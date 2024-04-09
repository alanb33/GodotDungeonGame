class_name PlayerActionController
extends Node2D

signal action_request(action: ActionTypes.Action)

func _input(event):
	if event.is_action_pressed("action_close"):
		action_request.emit(ActionTypes.Action.ACTION_CLOSE)
	if event.is_action_pressed("action_open"):
		action_request.emit(ActionTypes.Action.ACTION_OPEN_ALL)
