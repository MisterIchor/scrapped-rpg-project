extends DisplayTemplate
class_name WorldTemplate

# This template shouldn't be created manually and instead be made using the world creation tool.

export (Array) var tiles : Array = []
export (TileSet) var tile_set : TileSet = null
export (Array) var landmarks : Array = []
export (Dictionary) var encounters : Dictionary = {
	encounters = [],
	quests = [],
	campaign = []
}
