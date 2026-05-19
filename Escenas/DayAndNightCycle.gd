extends CanvasModulate
class_name DayAndNightCycle

signal ChangeDayTime(dayTime: DAY_STATE)

@onready var animation_player = $AnimationPlayer
var dayTime : DAY_STATE = DAY_STATE.NOON

enum DAY_STATE{NOON, EVENING}

func _ready() -> void:
	animation_player.play("day_cycle")
	add_to_group("dayAndNightCycle")
	
func _proccess(_delta: float) -> void:
	var animationPos = animation_player.current_animation_position
	var animationLength = animation_player.current_animation_length / 2
	
	if animationPos > animationLength && dayTime != DAY_STATE.EVENING:
		dayTime = DAY_STATE.EVENING
		ChangeDayTime.emit(dayTime)
		
	elif animationPos < animationLength && dayTime != DAY_STATE.NOON:
		dayTime = DAY_STATE.NOON
		ChangeDayTime.emit(dayTime)
		
