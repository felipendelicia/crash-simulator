extends Node2D

var mass = 1.0
var velocity = Vector2.ZERO
var initial_position = Vector2.ZERO
var friction = 0.0

export var other_circle: NodePath

var is_simulation_running = false

# Límites de la pantalla
var screen_bounds = Rect2()

func _ready():
    initial_position = position
    # Obtener los límites de la pantalla
    screen_bounds = Rect2(Vector2.ZERO, get_viewport().size)

func start_simulation(mass_value, velocity_value, friction_value):
    mass = mass_value
    velocity = -velocity_value  # Invertir la dirección de la velocidad
    friction = friction_value
    is_simulation_running = true

func stop_simulation():
    is_simulation_running = false
    position = initial_position

func _physics_process(delta):
    if is_simulation_running:
        # Actualizar la posición
        position += velocity * delta

        # Aplicar fricción
        velocity = velocity * (1.0 - friction * delta)

        # Verificar colisiones con las paredes
        check_wall_collisions()

        # Manejar colisiones con el otro círculo
        handle_circle_collision()

func check_wall_collisions():
    var radius = get_node("CollisionShape2D").shape.radius

    # Colisión con la pared izquierda
    if position.x - radius < screen_bounds.position.x:
        position.x = screen_bounds.position.x + radius
        velocity.x = -velocity.x

    # Colisión con la pared derecha
    if position.x + radius > screen_bounds.position.x + screen_bounds.size.x:
        position.x = screen_bounds.position.x + screen_bounds.size.x - radius
        velocity.x = -velocity.x

    # Colisión con la pared superior
    if position.y - radius < screen_bounds.position.y:
        position.y = screen_bounds.position.y + radius
        velocity.y = -velocity.y

    # Colisión con la pared inferior
    if position.y + radius > screen_bounds.position.y + screen_bounds.size.y:
        position.y = screen_bounds.position.y + screen_bounds.size.y - radius
        velocity.y = -velocity.y

func handle_circle_collision():
    var other_circle_node = get_node(other_circle)
    var distance = position.distance_to(other_circle_node.position)
    var combined_radius = get_node("CollisionShape2D").shape.radius + other_circle_node.get_node("CollisionShape2D").shape.radius

    if distance < combined_radius:
        # Calcular la nueva velocidad después del choque elástico
        var other_mass = other_circle_node.mass
        var other_velocity = other_circle_node.velocity

        var new_velocity = ((mass - other_mass) / (mass + other_mass)) * velocity + ((2 * other_mass) / (mass + other_mass)) * other_velocity
        var new_other_velocity = ((2 * mass) / (mass + other_mass)) * velocity + ((other_mass - mass) / (mass + other_mass)) * other_velocity

        # Aplicar la fricción
        velocity = new_velocity * (1 - friction)
        other_circle_node.velocity = new_other_velocity * (1 - friction)
