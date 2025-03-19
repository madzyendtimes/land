extends Node2D
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
var ydirection=1
var canjump=true
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

	if injump || !canjump:
		return
	canjump=false
#	ydirection=-1
	injump=true
	jumpcount=90
	

func stop():
	stopped=true
func unstopped():
	stopped=false

func injumptest():
	return injump

func setydir(ydir):
	ydirection=ydir	
	
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
	#print("friended from enemy")
	if !following:
		Flags.followers.append(self)
		$Label.text="friend " +str(Flags.followers.size())
		speed=max((sp-.5)-((Flags.followers.size())/4),.5)
		following=true
	#	print("following is now true")

func allowjump():
	canjump=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if following:
		if global_position.y-50>Flags.playerpositiony:
			jump()
		var temppos=global_position.x-Flags.playerposition
		if temppos<-20:
			setdir(1)

		elif temppos>20:
			setdir(-1)
		else:
			stopped=true
		
#		
#		if temposy<-20:
#			setydir(1)
#
#		elif temposy>20:
#			setydir(-1)
#		else:
#			stopped=true
	if injump:
		jumpcount-=1
		if jumpcount<1:
			injump=false
			isground=false
			canjump=false
			Flags.tne.dotime(self,[allowjump],Flags.rng.randf_range(1.5,3.0),str(get_instance_id())+"canjump",true)
		else:
			position.y-=9		
	if !stopped:
		position.x+=speed*dir
	if !isground && !$efeet.has_overlapping_areas()&& !injump:
		var validcollision=true	
		for i in $efeet.get_overlapping_areas():
			if i.name.contains("player"):
				validcollision=false
				break
		if !validcollision:
			return
		position.y+=9
		if position.y>800:
			position.y=800
			isground=true




func _on_ebody_area_entered(area: Area2D) -> void:

	if (area.name.contains("pbody"))&&(!following) && friendly:
		Flags.followers.append(self)
		$Label.text="friend " +str(Flags.followers.size())
		speed=max(((Flags.playerStats.speed*3)-Flags.rng.randf_range(.25,.75))-(Flags.followers.size()/4),2.0)
		following=true
		pass
	

	


func _on_efeet_area_entered(area: Area2D) -> void:
	if !isground:
		position.y=area.position.y-165
	pass # Replace with function body.
