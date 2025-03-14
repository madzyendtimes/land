extends Area2D
var eq=load("res://event_q.gd")
var et
var dir=-1
var rng=RandomNumberGenerator.new()
var speed=1
var isground=false
var currentground=800
var fall
var following=false
var friendly=false
var stopped=false
var ename
var kind="enemy"
var injump=false
var jumpcount=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ename="e"+str(rng.randi_range(1,6))
	if Flags.rng.randi_range(0,100)>65:
		friendly=true
		ename="f"+str(rng.randi_range(1,2))
		kind="friendly"
	$AnimatedSprite2D.animation=ename
	speed=rng.randi_range(1,4)
	et=Flags.tne
	
	changedir()

func jump():
	if injump:
		return
	injump=true
	jumpcount=20
	

func stop():
	stopped=true
func unstopped():
	stopped=false

func setdir(d):
	stopped=false
	dir=d
	$AnimatedSprite2D.flip_h=dir>0

func changedir():
	if rng.randi_range(0,100)>75 && !following:
		setdir(dir*-1)
		
	if !following:
		et.dotime(self,[changedir],rng.randf_range(.5,3.0),"changedir"+str(get_instance_id()))


func makefriend(sp):
	if !following:
		Flags.followers.append(self)
		$Label.text="friend " +str(Flags.followers.size())
		speed=max((sp-.5)-((Flags.followers.size())/4),.5)
		following=true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		print(global_position.y,Flags.playerpositiony)
		if global_position.y-10>Flags.playerpositiony:
			jump()
		var temppos=global_position.x-Flags.playerposition
		if temppos<-20:
			setdir(1)
		elif temppos>20:
			setdir(-1)
		else:
			stopped=true
	if injump:
		jumpcount-=1
		if jumpcount<1:
			injump=false
			return
		position.y+=5		
	if !stopped:
		position.x+=speed*dir
	if !isground && !$efeet.has_overlapping_areas()&& !injump:
		position.y+=5
		if position.y>600:
			position.y=600
			isground=true


func _on_area_entered(area: Area2D) -> void:
	
	if (area.name.contains("player"))&&(!following) && friendly:
		Flags.followers.append(self)
		$Label.text="friend " +str(Flags.followers.size())
		speed=max((area.speed-.5)-((Flags.followers.size())/4),.5)
		following=true
		pass
	
	if !isground:
		position.y=area.position.y
	pass # Replace with function body.
