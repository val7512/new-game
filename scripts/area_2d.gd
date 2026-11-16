extends Area2D

const SPEED = 100.0
var direction = -1.0
var is_dead = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not is_dead:
		position.x += direction * SPEED * delta

func _on_timer_timeout() -> void:
	if not is_dead:
		direction *= -1
		animated_sprite.flip_h = (direction == 1.0)

func _on_body_entered(body: Node2D) -> void:
	if is_dead:
		return

	if body.name == "Player" or body.name == "player":
		if body.velocity.y > 0 and body.global_position.y < global_position.y:
			is_dead = true
			body.velocity.y = -300.0
			queue_free()
		else:
			
			is_dead = true
			body.set_physics_process(false) 
			body.animated_sprite_2d.play("dying")
			await get_tree().create_timer(1.0).timeout 
			get_tree().call_deferred("reload_current_scene")
