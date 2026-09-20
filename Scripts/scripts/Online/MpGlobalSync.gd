extends Node2D

@export var Pid_Array: Array:
	get:
		return GlobalVar.Pid_Array
	set(val):
		GlobalVar.Pid_Array = val

@export var ActivePlayer: int:
	get:
		return GlobalVar.ActivePlayer
	set(val):
		GlobalVar.ActivePlayer = val
