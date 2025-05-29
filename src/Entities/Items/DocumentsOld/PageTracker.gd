tool
extends Node

export (int) var number_of_pages : int = 0 setget set_number_of_pages
var page : PackedScene = preload("Page.tscn")

signal pages_changed(number_of_pages)


func set_number_of_pages(new_number : int) -> void:
	number_of_pages = new_number
	emit_signal("pages_changed", new_number)
