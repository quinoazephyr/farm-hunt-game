class_name PlayerCharacter
extends CharacterWithBag

signal quest_accepted(quest : QuestBase)
signal quest_completed(quest : QuestBase)

const _TEMP_SPEED = 5.0
const _ANIMATION_NAME_IDLE = "Idle"
const _ANIMATION_NAME_RUN = "Run"
const _ANIMATION_NAME_JUMP = "Jump"
const _ANIMATION_NAME_FALL = "Fall"

@export_node_path("CameraPlayer") var _camera_player_path

var _quests : PlayerQuests

@onready var _camera_player = get_node(_camera_player_path)
@onready var _camera_pivot = $CameraPivot
@onready var _root_node = get_tree().root # todo: i don't like it

func _ready() -> void:
	super._ready()
	
	_quests = PlayerQuests.new()
	_quests.quest_accepted.connect(_emit_quest_accepted)
	_quests.quest_completed.connect(_emit_quest_completed)
	
	_camera_player.set_target(_camera_pivot)
	
	_animation_player = $Mesh/fox/AnimationPlayer
	_leg_ray_length = 1.1

func _process(delta):
	super._process(delta)
	
	_process_animations()

func take_quest(quest : QuestBase) -> void:
	_quests.accept_quest(quest, _root_node)
	
func _process_movement(velocity) -> void:
	_movement_velocity = _camera_player.camera_forward * velocity.y \
			+ _camera_player.camera_right * velocity.x
	_movement_velocity *= _TEMP_SPEED # todo: change to raycast floor

func _emit_quest_accepted(quest : QuestBase) -> void:
	quest_accepted.emit(quest)

func _emit_quest_completed(quest : QuestBase) -> void:
	quest_completed.emit(quest)

func _process_animations() -> void:
	if _movement_velocity.length_squared() > 0:
		_play_animation(_ANIMATION_NAME_RUN)
	else:
		_play_animation(_ANIMATION_NAME_IDLE)
