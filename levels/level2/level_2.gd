extends Node2D
var platscene:PackedScene=load("res://levels/level2/platform.tscn")
var playerscene:PackedScene=load("res://levels/level2/l_2_player.tscn")
var enemyscene:PackedScene=load("res://levels/level2/enemy.tscn")
var shscene:PackedScene=load("res://levels/level2/safehouse.tscn")
var backscene:PackedScene=load("res://levels/level2/level_2_back.tscn")
var forescene:PackedScene=load("res://levels/level2/level_2_fore.tscn")
var wallscene:PackedScene=load("res://levels/level2/level_2_wall.tscn")
var bfscene:PackedScene=load("res://levels/level2/level_2_big_fore.tscn")
var ypos=300
var player
var dir=1
var isground=true

func playgame():
	pass
func _ready() -> void:
	Flags.mode="level"
	Flags.playerStats.health=Flags.playerStats.maxHealth
	Flags.playerStats.stanima=Flags.playerStats.maxStanima
	var count=0
	var sfloc=Flags.rng.randi_range(50,400)
	for i in range(0,500):
		count+=1
		var b=backscene.instantiate()
		b.position.x=i*(100+Flags.rng.randi_range(0,50))
		b.position.y=150
		b.z_index=-20
		$playarea/back.add_child(b)
		var r=platscene.instantiate()
		r.position.x=count*150+Flags.rng.randi_range(-80,80)
		if Flags.rng.randi_range(0,100)>90:
			count+=4
		if Flags.rng.randi_range(0,100)>85:
			r.position.y=ypos-150
		else:
			r.position.y=clamp(ypos+randi_range(-35,35),-200,200)
			ypos=r.position.y
		r.z_index=-1
		r.position.y+=300
		$playarea/platforms.add_child(r)
		if i==sfloc:
			var sh=shscene.instantiate()
			sh.position.x=r.position.x+25
			sh.position.y=r.position.y-200
			$playarea/platforms.add_child(sh)		
		var enemy=enemyscene.instantiate()
		enemy.position.x=i*100
		enemy.isground=true
		enemy.modulate=Color(Flags.rng.randf_range(0,1),Flags.rng.randf_range(0,1),Flags.rng.randf_range(0,1))
		enemy.position.y=600

		$playarea/enemies.add_child(enemy)
		var range=1.4
		var minrange=.75
		if enemy.ename=="f2" || enemy.ename=="f1":
			#print(enemy.ename)
			minrange=1.0
			range=1.0
		enemy.scale.y=Flags.rng.randf_range(minrange,range)
		enemy.scale.x=Flags.rng.randf_range(minrange,range)
		#enemy.scale.y=rng.randf_range(.75,1.4)
		#enemy.scale.x=rng.randf_range(.75,1.4)
		enemy.z_index=enemy.scale.y
		if i%10==0:
			var d=wallscene.instantiate()
			d.position.x=r.position.x-Flags.rng.randi_range(-25,25)
			d.position.y=550
			d.z_index=-2
			$playarea/back.add_child(d)
		if Flags.rng.randi_range(0,100)>70:
			var f=forescene.instantiate()
			f.position.x=(count*150)+Flags.rng.randi_range(-100,500)
			f.position.y=525
			f.z_index=8
			$playarea/fore.add_child(f)
			
		if Flags.rng.randi_range(0,1000)>995:
			var f=bfscene.instantiate()
			f.position.x=(count*150)+Flags.rng.randi_range(-100,500)
			f.position.y=490
			f.z_index=9
			$playarea/fore.add_child(f)
		
		
		
	player=playerscene.instantiate()
	player.position.x=300
	player.position.y=320
	add_child(player)
	
	
	
	
func doEffect(effect):
	if Flags.mode!="level":
		Flags.tne.dotime(self,[doEffect.bind(effect)],.5,"retryEvent",true,"level")
		return
	var sEff=effect.name
	var aSel = sEff.split("|")
	if aSel.size()>1:
		sEff=aSel[Flags.rng.randi_range(0,aSel.size()-1)]		
	#print(sEff)
	match sEff:
		"addgems":
			var g=Flags.rng.randi_range(1,5)+Flags.playerStats.rizz
			Flags.megaStats.gems+=g
			$player.stat("+","gem",g)
			Flags.save()
			Flags.play("gemget")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var canplay=false
	if Input.is_action_pressed("left"):
		canplay=true
		player.left()
		$playarea.position.x+=Flags.dir*(Flags.playerStats.speed+3)

	if Input.is_action_pressed("right"):
		canplay=true
		player.right()
		$playarea.position.x+=Flags.dir*(Flags.playerStats.speed+3)


	if Input.is_action_pressed("jump"):
		player.jump()
	if Input.is_action_just_released("jump"):
		player.unjump()
	if Input.is_action_pressed("run"):
		if !player.exhaust:		
			Flags.playerStats.bonusSpeed=3
			Flags.playerStats.stanima-=Flags.playerStats.stanimaRate
			if Flags.playerStats.stanima<1:
				Flags.playerStats.bonusSpeed=0
				player.exhausted()		
	else:
		if Flags.playerStats.stanima<Flags.playerStats.maxStanima:
			Flags.playerStats.stanima+=Flags.playerStats.stanimaRate
			if (Flags.playerStats.stanima>=Flags.playerStats.maxStanima)&&player.exhaust:
				player.unexhausted()
	if Input.is_action_just_released("run"):
		Flags.playerStats.bonusSpeed=0
	if Input.is_action_pressed("down"):
		player.crouch()
	if Input.is_action_just_released("down"):
		player.uncrouch()
	if Input.is_action_just_pressed("fight"):
		player.fight()
#	if canplay:
		#player.position.x+=player.dir*Flags.playerStats.speed

	movealong()
	#follow()
			
func movealong():
	var ppos=Flags.dir*Flags.playerStats.speed
	#position.x=-1*player.position.x+500
	#position.x=Flags.dir*Flags.playerStats.speed
	$playarea.position.y=-1*(player.position.y-200)*.5
	#print(player.position.x)
	$playarea/platforms.position.x=ppos
	$playarea/enemies.position.x=ppos*.75
	$playarea/fore.position.x=ppos*.25
	$playarea/back.position.x=ppos*.05
	Flags.playerposition=player.position.x
	Flags.playerpositiony=player.position.y

	
func follow():

	var count=0
	for i in Flags.followers:
		var px=1
		var py=1
		count+=1
		var test=(i.position.x-$playarea.position.x+(player.position.x))
		var testy=(i.position.y+$playarea.position.y+(player.position.y))
		#if count==1:
			#print(test)
			#print(i.position.x,"-",player.position.x," : ",player.position.x+$playarea.position.x-i.position.x)
		if (test>20):
			px=-1
			py=1
		elif test<-20:
			px=1
			py=-1
		else:
			if !i.injump():
				i.stop()
			return
		i.unstopped()
		i.setdir(px)
		i.setydir(py)
	pass
