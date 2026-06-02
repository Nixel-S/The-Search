extends Node

# ============================================================
#  DualGrid.gd
#  Adjunta este script al Node padre que contiene ambos TileMapLayer.
#
#  Estructura de escena:
#    Node2D  <-- este nodo tiene el script
#    ├── TileMapLayer  (nombre: "Logic")   - tile size 32x32, lo pintas a mano
#    └── TileMapLayer  (nombre: "Visual")  - tile size 16x16, se genera solo
#
#  El TileMapLayer Visual debe tener su posición en (-16, -16)
#  para el offset del dual grid.
# ============================================================

@export var logic_layer: TileMapLayer
@export var visual_layer: TileMapLayer

# Source ID de tu tileset visual (normalmente 0, cámbialo si es distinto)
@export var visual_source_id: int = 0

# ============================================================
#  MAPEO: bitmask (4 bits) → coordenada del tile en tu .png
#
#  Bitmask:  bit3=TL  bit2=TR  bit1=BL  bit0=BR
#            TL TR
#            BL BR
#
#  Basado en el tileset estándar del Dual Grid (jess::codes)
#  que encaja con tu imagen 4x4.
#
#  Clave  = TL<<3 | TR<<2 | BL<<1 | BR<<0
#  Valor  = Vector2i(columna, fila) en el atlas
# ============================================================
const BITMASK_TO_TILE: Dictionary = {
	0b0000: Vector2i(0, 0),  # vacío — no se pinta (tile de relleno/nada)
	0b0001: Vector2i(1, 0),  # solo BR
	0b0010: Vector2i(3, 0),  # solo BL
	0b0011: Vector2i(2, 0),  # BL + BR  (borde top)
	0b0100: Vector2i(0, 1),  # solo TR
	0b0101: Vector2i(0, 2),  # TR + BR  (borde left)
	0b0110: Vector2i(3, 3),  # TR + BL  (diagonal /)
	0b0111: Vector2i(0, 3),  # TR + BL + BR
	0b1000: Vector2i(3, 1),  # solo TL
	0b1001: Vector2i(2, 3),  # TL + BR  (diagonal \)
	0b1010: Vector2i(3, 2),  # TL + BL  (borde right)
	0b1011: Vector2i(2, 2),  # TL + BL + BR — esquina interior TR
	0b1100: Vector2i(1, 1),  # TL + TR  (borde bottom)
	0b1101: Vector2i(1, 2),  # TL + TR + BR — esquina interior BL
	0b1110: Vector2i(1, 3),  # TL + TR + BL — esquina interior BR
	0b1111: Vector2i(2, 1),  # lleno
}

# ============================================================
func _ready() -> void:
	# Conecta la señal del layer lógico para regenerar al pintar
	if logic_layer:
		logic_layer.changed.connect(_on_logic_changed)
	update_visual()


func _on_logic_changed() -> void:
	update_visual()


# ============================================================
#  Regenera todo el TileMapLayer visual leyendo el lógico
# ============================================================
func update_visual() -> void:
	if not logic_layer or not visual_layer:
		push_error("DualGrid: faltan referencias a logic_layer o visual_layer")
		return

	visual_layer.clear()

	var logic_cells: Array = logic_layer.get_used_cells()
	if logic_cells.is_empty():
		return

	# Construimos un set para lookup rápido O(1)
	var logic_set: Dictionary = {}
	for cell in logic_cells:
		logic_set[cell] = true

	# Las celdas visuales son las esquinas compartidas entre celdas lógicas.
	# Cada celda visual (vx, vy) cubre las 4 celdas lógicas:
	#   TL=(vx-1, vy-1)  TR=(vx, vy-1)
	#   BL=(vx-1, vy  )  BR=(vx, vy  )
	var visual_set: Dictionary = {}
	for cell in logic_cells:
		# Una celda lógica contribuye a 4 esquinas visuales
		for offset in [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]:
			visual_set[cell + offset] = true

	for vcell in visual_set:
		var vx: int = vcell.x
		var vy: int = vcell.y

		var tl: int = 1 if logic_set.has(Vector2i(vx - 1, vy - 1)) else 0
		var tr: int = 1 if logic_set.has(Vector2i(vx,     vy - 1)) else 0
		var bl: int = 1 if logic_set.has(Vector2i(vx - 1, vy    )) else 0
		var br: int = 1 if logic_set.has(Vector2i(vx,     vy    )) else 0

		var bitmask: int = (tl << 3) | (tr << 2) | (bl << 1) | br

		if bitmask == 0:
			continue  # celda completamente vacía, no pintar

		var atlas_coord: Vector2i = BITMASK_TO_TILE.get(bitmask, Vector2i(0, 0))
		visual_layer.set_cell(vcell, visual_source_id, atlas_coord)


# ============================================================
#  API pública: pinta una celda lógica y regenera el visual
# ============================================================
func set_logic_cell(cell: Vector2i, erase: bool = false) -> void:
	if erase:
		logic_layer.erase_cell(cell)
	else:
		logic_layer.set_cell(cell, visual_source_id, Vector2i(0, 0))
	update_visual()


func fill_rect_logic(rect: Rect2i) -> void:
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			logic_layer.set_cell(Vector2i(x, y), visual_source_id, Vector2i(0, 0))
	update_visual()
