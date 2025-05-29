extends DisplayTemplate
class_name TypeTemplate

export (Array) var effective_against : Array = []
export (Array) var weak_against : Array = []
# Due to cyclic references, damage types are loaded by path instead of resource.
# This is only important if you are creating dialogue from the editor.
# Make sure this box is unticked once you are finished. Kinda sucks, but oh well =/
export (bool) var types_as_resource : bool = false
