class_name QuestBase
extends Resource

signal started
signal finished

enum State {
	PENDING, # not started yet
	IN_PROGRESS, # shown to the player and started
	FINISHED, # finished
}

@export var _id : int = -1
@export var _title : String
@export_multiline var _description : String
@export var _goals : Array[QuestGoalBase]
@export_category("Actions")
@export var _actions_on_start : Array[ActionBase]
@export var _actions_on_finish : Array[ActionBase]

var id:
	get:
		return _id
var title:
	get:
		return _title
var description:
	get:
		return _description
var state:
	get:
		return _state
var goals:
	get:
		return _goals

var _state : State
var _goals_completed : int = 0

func _init() -> void:
	_state = State.PENDING

func start(root_node : Node) -> void:
	_state = State.IN_PROGRESS
	for goal in _goals:
		goal.start(root_node)
		goal.completed.connect(_on_goal_completed)
	_fire_actions(root_node, _actions_on_start)
	finished.connect(_fire_actions.bind(root_node, _actions_on_finish))
	
	started.emit()
	_try_finish_quest()

func force_finish() -> void:
	finished.emit()

func _fire_actions(root_node : Node, actions : Array[ActionBase]) -> void:
	for action in actions:
		action.fire(root_node)

func _on_goal_completed() -> void:
	_goals_completed += 1
	_try_finish_quest()

func _try_finish_quest():
	if _goals_completed == _goals.size():
		finished.emit()
