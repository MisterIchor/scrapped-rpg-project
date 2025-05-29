extends ColorRect

const NAME_CANCELLED : int = 0
const NAME_CONFIRMED : int = 1

onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
onready var line_edit: LineEdit = $ConfirmationDialog/LineEdit

var treeitem : TreeItem

signal done(status)


func _ready() -> void:
	confirmation_dialog.connect("confirmed", self, "_on_ConfirmationDialog_confirmed")
	confirmation_dialog.connect("popup_hide", self, "hide")
	connect("visibility_changed", self, "_on_visibility_changed")



func _on_ConfirmationDialog_confirmed() -> void:
	if not line_edit.text.empty():
		treeitem.set_text(0, line_edit.text)
		emit_signal("done", NAME_CONFIRMED)
	else:
		emit_signal("done", NAME_CANCELLED)


func _on_visibility_changed() -> void:
	if visible:
		confirmation_dialog.popup()
