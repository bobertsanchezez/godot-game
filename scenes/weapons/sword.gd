extends Weapon2
class_name Sword

enum State {IDLE, SWING_1, SWING_2, SWING_3}

var _state : State = State.IDLE
var _swing_1_end := 4
var _swing_2_end := 5
var _swing_3_end := 7
var _finished_animation := false
var _should_transition_state := false
var _animation_timed_out := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attack(element : Player.Element):
	if _state == State.IDLE: 
		_state = State.SWING_1
	elif _finished_animation:
		# Go to next swing. If on final swing, do first swing again
		_state += 1 if _state != State.SWING_3 else 2 
		_state %= 4
		_finished_animation = false
		_animation_timed_out = false
		$AttackTimer.stop()
	else: _should_transition_state = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_state()
	_select_animation()
	_select_hitbox()

# Updates state
func _update_state():
	if not _finished_animation:
		match _state: 
			State.SWING_1: 
				if frame == _swing_1_end: 
					_pause_attack()
			State.SWING_2:
				if frame == _swing_2_end:
					_pause_attack()
			State.SWING_3:
				if frame == _swing_3_end:
					_pause_attack()
	if _finished_animation and _should_transition_state:
		# Go to next swing. If on final swing, do first swing again
		_state += 1 if _state != State.SWING_3 else 2 
		_state %= 4
		_finished_animation = false
		_should_transition_state = false
		$AttackTimer.stop()
	elif _finished_animation and _animation_timed_out: 
		_state = State.IDLE
		_finished_animation = false
		_animation_timed_out = false

func _pause_attack():
	pause()
	_finished_animation = true
	# start timer, after which attack pose resets to idle
	$AttackTimer.start(0.25)

# Sets animation based on state.
func _select_animation():
	if !_finished_animation: play() 
	match _state:
		State.IDLE: animation = "idle"
		State.SWING_1: animation = "swing_1"
		State.SWING_2: animation = "swing_2"
		State.SWING_3: animation = "swing_3"

func _select_hitbox():
	pass # Replace with hitbox code for swings.

func _on_attack_timer_timeout():
	_animation_timed_out = true
