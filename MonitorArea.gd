extends "res://ClickableArea.gd"

func onClick():
	if get_parent().get_parent().viewingMonitor == false:
		get_parent().get_parent().switchView()
