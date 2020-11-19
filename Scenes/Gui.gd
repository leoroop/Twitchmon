extends Node2D


onready var pauseMenu = $CanvasLayer/PauseMenu

func _process(delta):
	
	if Input.is_key_pressed(KEY_ESCAPE):
		pauseMenu.visible = not pauseMenu.visible
