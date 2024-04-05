class_name PlayerActionController
extends Node2D

signal action_request(action: ActionTypes.Action)

func handle_actions():
	if Input.is_action_just_pressed("action_close"):
		action_request.emit(ActionTypes.Action.ACTION_CLOSE)
