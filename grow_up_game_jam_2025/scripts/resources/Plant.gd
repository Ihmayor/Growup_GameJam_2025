class_name Plant extends Resource

@export_enum("Lettuce", "Eggplant", "Pepper", "Potato", "Tomato", "Cucumber") var name: String
@export var base_stat : int 
@export var first_image: Texture2D 
@export_enum("Lettuce", "Eggplant", "Pepper", "Potato", "Tomato", "Cucumber") var compatible_matchup: String
@export_enum("Lettuce", "Eggplant", "Pepper", "Potato", "Tomato", "Cucumber") var incompatible_matchup: Array[String]
