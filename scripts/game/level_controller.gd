extends Node2D
class_name LevelController

@export_file("*.tscn") var next_level_scene := ""
@export var escape_duration := 30.0
@export var collectible_bonus_seconds := 1.25
@export_file("*.tscn") var fallback_scene := "res://scenes/game/victory_screen.tscn"

var _phase := "explore"
var _time_left := 0.0
var _collected := 0
var _total_collectibles := 0
var _score := 0

@onready var player: Node = get_node_or_null("Player")
@onready var pillar: Node = get_node_or_null("PillarJohn")
@onready var exit_area: Area2D = get_node_or_null("ExitArea")
@onready var shortcut_block: Node = get_node_or_null("EscapeShortcutBlock")
@onready var objective_label: Label = get_node_or_null("HudLayer/ObjectiveLabel")
@onready var timer_label: Label = get_node_or_null("HudLayer/TimerLabel")
@onready var collect_label: Label = get_node_or_null("HudLayer/CollectLabel")

func _ready() -> void:
	if pillar != null and pillar.has_signal("pillar_destroyed"):
		pillar.connect("pillar_destroyed", Callable(self, "_on_pillar_destroyed"))

	if exit_area != null:
		exit_area.body_entered.connect(_on_exit_area_body_entered)

	_connect_collectibles()
	_update_hud_labels()
	_set_explore_text()

func _process(delta: float) -> void:
	if _phase != "escape":
		return

	_time_left -= delta
	if _time_left <= 0.0:
		_time_left = 0.0
		_update_hud_labels()
		_on_escape_failed()
		return

	_update_hud_labels()

func _connect_collectibles() -> void:
	_total_collectibles = 0
	for collectible in get_tree().get_nodes_in_group("collectible_topping"):
		if not is_ancestor_of(collectible):
			continue

		_total_collectibles += 1
		if collectible.has_signal("collected"):
			collectible.connect("collected", Callable(self, "_on_collectible_collected"))

func _on_collectible_collected(points: int) -> void:
	_collected += 1
	_score += points
	_update_hud_labels()

func _on_pillar_destroyed() -> void:
	if _phase == "escape":
		return

	_phase = "escape"
	_time_left = escape_duration + float(_collected) * collectible_bonus_seconds

	if shortcut_block != null and is_instance_valid(shortcut_block):
		shortcut_block.queue_free()

	_set_escape_text()
	_update_hud_labels()

func _on_exit_area_body_entered(body: Node) -> void:
	if _phase != "escape":
		return

	if body == null:
		return

	if not body.is_in_group("player"):
		return

	_complete_level()

func _complete_level() -> void:
	if objective_label:
		objective_label.text = "Fase concluida!"

	var target_scene := fallback_scene
	if next_level_scene.strip_edges() != "" and ResourceLoader.exists(next_level_scene):
		target_scene = next_level_scene

	call_deferred("_deferred_change_scene", target_scene)

func _on_escape_failed() -> void:
	if objective_label:
		objective_label.text = "Tempo esgotado! Reiniciando..."

	call_deferred("_deferred_reload_scene")

func _deferred_change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func _deferred_reload_scene() -> void:
	get_tree().reload_current_scene()

func _set_explore_text() -> void:
	if objective_label:
		objective_label.text = "Objetivo: destrua o Pillar John"

func _set_escape_text() -> void:
	if objective_label:
		objective_label.text = "PIZZA TIME! Volte para a entrada!"

func _update_hud_labels() -> void:
	if timer_label:
		if _phase == "escape":
			timer_label.text = "Tempo: %.1f" % _time_left
		else:
			timer_label.text = "Tempo: --"

	if collect_label:
		collect_label.text = "Coletaveis: %d/%d | Score: %d" % [_collected, _total_collectibles, _score]
