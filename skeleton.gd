extends CharacterBody2D

@export var is_attacking = false
var activate = false
const PATROL_SPEED = 100.0
const CHASE_SPEED = 200.0
const ATTACK_RANGE = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $detection_box
@onready var sprite: AnimatedSprite2D = $movible/skeletonSprite
@onready var attack_timer: Timer = $AttackTimer
@onready var patrol_timer: Timer = $PatrolTimer

var direction: int = 1  # 1 = derecha, -1 = izquierda
var player: CharacterBody2D = null
var can_attack: bool = true
var idle_time: float = 0

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	
	attack_timer.start(randf_range(2, 5))  # Inicia con tiempo aleatorio
	patrol_timer.start(3)  # Cambia de dirección cada 3 segundos

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity.x = 0  # 🔥 Cuando ataca o usa escudo, se queda quieto 🔥
	else:
		if activate and player:
			# Perseguir al jugador
			if player.is_on_floor():
				direction = sign(player.global_position.x - global_position.x)
				velocity.x = direction * CHASE_SPEED

				# 🔥 Atacar de inmediato si está en rango 🔥
				if global_position.distance_to(player.global_position) < ATTACK_RANGE and can_attack:
					_attack()
			else:
				activate = false  # Deja de perseguir si el jugador está en el aire

		else:
			# Patrullar de izquierda a derecha
			velocity.x = direction * PATROL_SPEED
			idle_time += delta

			# Cambia a animación idle después de caminar un rato
			if idle_time > 3:
				velocity.x = 0
				animation_player.play("idle_skeleton_animation")
				await get_tree().create_timer(2).timeout  # Espera 2 segundos en idle
				idle_time = 0  # Reiniciar contador

	_flip_sprite(direction)
	move_and_slide()

	# Animaciones de caminar, pero solo si no está atacando
	if velocity.x != 0 and not is_attacking:
		animation_player.play("walk_skeleton_animation")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("golem_damage"):  
		player = body
		activate = true
		idle_time = 0  # Resetear idle

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		activate = false
		player = null
		animation_player.play("idle_skeleton_animation")  # Volver a idle

func _flip_sprite(move_dir: int) -> void:
	sprite.flip_h = move_dir < 0  # Si va a la izquierda, voltea el sprite

func _on_attack_timer_timeout() -> void:
	if not activate and not is_attacking:  # Solo si no está persiguiendo y no está en medio de un ataque
		var rng = RandomNumberGenerator.new()
		var number = rng.randi_range(1, 2)  # 1 = escudo, 2 = ataque

		if number == 1:
			_activate_shield()
		else:
			_attack()

	attack_timer.start(randf_range(2, 5))  # Reinicia con tiempo aleatorio

func _activate_shield() -> void:
	is_attacking = true
	velocity.x = 0  # 🔥 Se queda quieto al activar escudo 🔥
	animation_player.play("shield_skeleton_animation")
	await animation_player.animation_finished
	is_attacking = false

func _attack() -> void:
	is_attacking = true
	velocity.x = 0  # 🔥 Se queda quieto al atacar 🔥
	animation_player.play("attack_skeleton_animation")
	await animation_player.animation_finished
	is_attacking = false

func _on_patrol_timer_timeout() -> void:
	if not activate and not is_attacking:  # Solo cambia de dirección si no está persiguiendo ni atacando
		direction *= -1
	patrol_timer.start(3)  # Reinicia el timer
