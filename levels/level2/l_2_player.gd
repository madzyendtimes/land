extends Node2D
var freefall=true
var ground=600
var fallspeed=8
var dir=1
var jumpaction=1
var jumpcount=40
var injump=false
var upspeed=15
var canmove=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func left():
	
	canmove=true
	Flags.dir=1
	$AnimatedSprite2D.flip_h=true
	$pfeet/CollisionShape2D.position.x=+25
	

func right():
		canmove=true
		Flags.dir=-1
		$AnimatedSprite2D.flip_h=false
		$pfeet/CollisionShape2D.position.x=-25

func unjump():
	injump=false
	
func jump():
	if jumpaction>0:
		jumpaction-=1
		jumpcount=40
		injump=true
		upspeed=Flags.playerStats.speed+10
	else:
		jumpcount-=1
		if jumpcount>0:
			position.y-=upspeed
		else:
			injump=false

func setpos(ypos):
	#if !freefall:
	var pos=600
	var pareas=$pfeet.get_overlapping_areas()
	for i in pareas:
		if (i.position.y/1.69)-5<pos:
			pos=(i.position.y/1.69)-5
	if pareas.size()>0:
		position.y=pos
		ground=pos-200
		#position.y=ypos-225
		#ground=ypos-225



	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($pfeet.has_overlapping_areas(), " ", position.y)
	if position.y<600 && !$pfeet.has_overlapping_areas() && !injump:
		position.y+=fallspeed
		freefall=true
#		if $pfeet.has_overlapping_areas():
#			position.y-=fallspeed/2
	else:
		if !injump:
			setpos(0)
			jumpaction=1
		freefall=false 
	Flags.playerpositiony=position.y

func _on_pbody_area_entered(area: Area2D) -> void:
	if area.kind=="friendly":
		area.makefriend(5)
	pass # Replace with function body.
