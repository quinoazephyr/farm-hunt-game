class_name TestActionPrint
extends ActionBase

@export_multiline var _string_to_print : String

func fire(root : Node) -> void:
	print(_string_to_print)
