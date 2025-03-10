extends Node2D
var platscene:PackedScene=load("res://levels/level2/platform.tscn")
var playerscene:PackedScene=load("res://levels/level2/l_2_player.tscn")
var enemyscene:PackedScene=load("res://levels/level2/enemy.tscn")
var ypos=300
var player
var dir=1
var isground=true


func _ready() -> void:
	var count=0
	for i in range(0,500):
		count+=1
		var r=platscene.instantiate()
		r.position.x=count*150+Flags.rng.randi_range(-80,80)
		if Flags.rng.randi_range(0,100)>90:
			count+=4
		if Flags.rng.randi_range(0,100)>85:
			r.position.y=ypos-150
		else:
			r.position.y=clamp(ypos+randi_range(-35,35),-200,200)
			ypos=r.position.y
		
		r.position.y+=400
		$playarea/platforms.add_child(r)
		var enemy=enemyscene.instantiate()
		enemy.position.x=i*100
		enemy.isground=true
		enemy.modulate=Color(Flags.rng.randf_range(0,1),Flags.rng.randf_range(0,1),Flags.rng.randf_range(0,1))
		enemy.position.y=600

		$playarea/enemies.add_child(enemy)
		var range=1.4
		var minrange=.75
		if enemy.ename=="f2" || enemy.ename=="f1":
			print(enemy.ename)
			minrange=1.0
			range=1.0
		enemy.scale.y=Flags.rng.randf_range(minrange,range)
		enemy.scale.x=Flags.rng.randf_range(minrange,range)
		#enemy.scale.y=rng.randf_range(.75,1.4)
		#enemy.scale.x=rng.randf_range(.75,1.4)
		enemy.z_index=enemy.scale.y
		
	player=playerscene.instantiate()
	player.position.x=300
	player.position.y=320
	add_child(player)
	
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var canplay=false
	if Input.is_action_pressed("left"):
		player.left()
		$playarea.position.x+=Flags.dir*(Flags.playerStats.speed+3)

	if Input.is_action_pressed("right"):
		player.right()
		$playarea.position.x+=Flags.dir*(Flags.playerStats.speed+3)

	if Input.is_action_pressed("jump"):
		player.jump()
	if Input.is_action_just_released("jump"):
		player.unjump()

	movealong()
			
func movealong():
	#position.x=-1*player.position.x+500
	#position.x=Flags.dir*Flags.playerStats.speed
	$playarea.position.y=-1*(player.position.y-200)*.5
	$playarea/fore.position.x=-1*player.position.x+500*.25
	$playarea/back.position.x=(-1*player.position.x+500)*.05
	follow()
	
func follow():
	pass
