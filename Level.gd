extends Node2D
signal hit
signal pukehit
signal begout
signal timeout
var treeScene:PackedScene=load("res://tree.tscn")
var enemyScene:PackedScene=load("res://groundling.tscn")
var rockScene:PackedScene=load("res://rock.tscn")
var trashScene:PackedScene=load("res://interact.tscn")
var warpScene:PackedScene=load("res://warp.tscn")
var tvScene:PackedScene=load("res://tv.tscn")
var missleScene:PackedScene=load("res://missle.tscn")
var pukeScene:PackedScene=load("res://puke.tscn")
var expanderScene:PackedScene=load("res://expander.tscn")
var tallmScene:PackedScene=load("res://monster_tall.tscn")
var welcomeScene:PackedScene=load("res://welcome_center.tscn")
var assetsScene:PackedScene=load("res://assets.tscn")
var enterScene:PackedScene=load("res://enterable.tscn")
var flavorScene:PackedScene=load("res://flavornpc.tscn")
var flyerScene:PackedScene=load("res://flyer.tscn")
var multiScene:PackedScene=load("res://multistage.tscn")
var gemScene:PackedScene=load("res://gemmonster.tscn")
var graveScene:PackedScene=load("res://gravestone.tscn")
var specialnpcScene:PackedScene=load("res://specialnpc.tscn")
var bulletScene:PackedScene=load("res://bullet.tscn")
var needleScene:PackedScene=load("res://needle.tscn")
var bossScene:PackedScene=load("res://braino.tscn")
var lowshader=preload("res://low.gdshader")
var plaugeScene:PackedScene=load("res://plaugetester.tscn")
var gasScene:PackedScene=load("res://vampiregas.tscn")
var sawScene:PackedScene=load("res://saw.tscn")
var knifeScene:PackedScene=load("res://knifulator.tscn")
var ufoScene:PackedScene=load("res://ufo.tscn")
var laserScene:PackedScene=load("res://laser.tscn")
var starScene:PackedScene=load("res://stars.tscn")
var liltripScene:PackedScene=load("res://liltrip.tscn")
var grassScene:PackedScene=load("res://grass.tscn")
var wallScene:PackedScene=load("res://wall.tscn")
var wrestplayercontrol=false
var canJump:=true
var baseSpeed=Flags.megaStats.speed
var speed=baseSpeed
var currSpeed=speed
var gy:=0
var gx:=0
var oldmod
var questDistributed:=false
var statScene
var types=[{"name":"trees/tree","num":5},{"name":"trees/buildings/sky","num":4}]
var stanimaAction:=false
var warpS
var missle
var dangerZone
var canrandom=true
var newsave=false
var bossZone=0
var jumps=0
var basey=423
var ascent=300
var height=0
var countheight=0
var inascent=false
var indescent=false
var treeholderResetY=0
var treeholder2ResetY=0
var jumpheight=0
var jumpups=0
var phantomposition=0
var injumpup=false

var eplus=0
var pplus=0
var pposmax=300
var eposmax=400
var eposy=0




func _ready():
	
	Flags.mode="level"
	$Camera2D.make_current()
	if Flags.options.randomizeDistribution:
		Flags.percentageMap.shuffle()
	Flags.playerStats.maxHealth=Flags.playerStats.maxHealth
	Flags.playerStats.maxStanima=Flags.playerStats.maxStanima
	
	Flags.play("mainmusic","music")
	Flags.titlescreen="gameover"
	$trader.visible=false	
	Flags.reset()
	baseSpeed=Flags.megaStats.speed
	speed=baseSpeed
	$treeholder.position.y=-100

	treeholderResetY=$treeholder.position.y
	$treeholder2.position.y=-250
	treeholder2ResetY=$treeholder2.position.y
	for i in range(0,600):
		var ypos=0
		var nType=0
		if i>200:
			nType=Flags.rng.randi_range(0,3)
		
		var ts=get_bg_texture(nType)
		ts.position=Vector2(min(i+(i*.6189),i*3)*75,400)
		var star=starScene.instantiate()
		star.staticstar()
		star.z_index=-5
		star.position.x=min(i+(i*.6189),i*3)*75+Flags.rng.randi_range(0,600)
		$stars.add_child(star)
		$ground.position.y=530
		for j in range(0,10):
			var yposy=Flags.rng.randf_range(.5,3.5)
			var grass=grassScene.instantiate()
			grass.position.x=min(i+(i*.6189),i*3)*75+Flags.rng.randi_range(0,600)
			grass.position.y+=200-(200*yposy)
			grass.flip_h=Flags.rng.randi_range(0,1)>0
			grass.modulate=Color(Flags.rng.randf_range(0.0,1.0),Flags.rng.randf_range(0.0,1.0),Flags.rng.randf_range(0.0,1.0))
			grass.scale=Vector2(Flags.rng.randf_range(.5,3.5),yposy)
			if yposy<1.5:
				$background.add_child(grass)
				grass.z_index=$player.z_index-1
			else:
				$ground.add_child(grass)
		$background.position.y=270
			
		ts.flip_h=Flags.rng.randi_range(0,1)>0
		var yscale=randf_range(.3,1)
		if nType==1:
			yscale=.54
			ypos=Flags.rng.randi_range(75,100)
		ts.scale=Vector2(Flags.rng.randf_range(.5,1),yscale)
		ts.modulate=Color(Flags.rng.randf_range(0.0,1.0),Flags.rng.randf_range(0.0,1.0),Flags.rng.randf_range(0.0,1.0))
		applyshaders(ts)

		if yscale<.55:
			$treeholder.add_child(ts)
			ts.position.y-=ypos
			ts.position.y+=-85-(85*yscale)			
		else: 
			if yscale<.85 && nType==0:
				$treeholder2.add_child(ts)
				ts.position.y+=-60-(-60*yscale)
			else:
				ts.position.y+=75-(75*yscale)
				$treeholder3.add_child(ts)
	$treeholder3.position.y+=75
	var welcome=welcomeScene.instantiate()
	$locationfront.add_child(welcome)
	welcome.position=Vector2(min(301+(301*.6189),301*3)*100,400)
	bossZone=welcome.position.x-4000
	dangerZone={"less":4114,"more":welcome.position.x-3000}
	statScene=$stats
	oldmod = $player.modulate
	warpS=warpScene.instantiate()
	warpS.position.y=570
	warpS.position.x=Flags.warploc;
	$interactive.add_child(warpS)
	warpS.play()
	if newsave:
		Flags.save()
	$player.position.y=basey
	Flags.env=[]
	Flags.addEnv([[$treeholder,.5],[$treeholder2,.7],[$background,.85],[$treeholder3,1.5],[$ground,1],[$stars,.1],[$locationback,1],[$interactive,1],[$npcs,1],[$locationfront,1],[$enemy,1],[$rocks,1],[$pets,1]])
	phantomposition=$player.position.y
	#if Flags.amode.size()>0:
	$player.chooseweapon()
	

	
	#uncomment to test gemna
	#speed=1
	#warpto(34000)
	#this sets off the spawntimer testing before removing old static enemyGeneraator
	dospawns()
	for i in Flags.megaStats.inventory:
		Flags.playerInventory.append(i)
	
	var testliltrip=false
	if testliltrip || Flags.megaStats.liltrip:
		var pet=liltripScene.instantiate()
		pet.position.y=basey+100
		$pets.add_child(pet)
	
		
	#Flags.addToInventory(1,4) #give user a begging board
	
func applyshaders(ts):
	if Flags.options.graphics=="low":
		ts.material=ShaderMaterial.new()		
		ts.material.shader=lowshader	

func horrorend():
	Flags.horror=false
func dohorror():
#	var timer=get_tree().create_timer(rng.randf_range(0.5,2)).timeout
	#this timer is now defunct considering dotime, will test before uncomment
	Flags.horror=true
	$random.position.y=-1500
	Flags.play("scary")
	var tween=get_tree().create_tween()
	tween.tween_property($random,"modulate",Color(1,1,1,0),.5)
	tween.tween_callback(horrorflash)
	
	Flags.tne.dotime(self,[horrorend],5.0,"horrorend",true,"level")


func horrorflash():

	$random.position.y=0
	var tween=get_tree().create_tween()
	tween.tween_property($random,"modulate",Color(1,1,1,1),.5)		

func triggerhorror():
	Flags.tne.dotime(self,[dohorror],Flags.rng.randf_range(0.5,5.0),"horror",true,"level")
	

func setShaderParam(parm,val):
	$Camera2D/CanvasLayer/colorect.material.set_shader_parameter(parm,val)



func dopuke():
	Flags.pukestate=true
	if !$player/AnimatedSprite2D.is_playing():
		$player/AnimatedSprite2D.play()
	renderPuke()

func randpuke():	
	Flags.tne.dotime(self,[dopuke],Flags.rng.randf_range(0.1,2.0),"dopuke",true,"level")	
	if Flags.radiation==true:
		Flags.tne.dotime(self,[randpuke],Flags.rng.randf_range(0.5,2.0),"randpuke",true,"level")	
func radiationend():
	Flags.radiation=false
	if get_tree()!=null:
		var tween=get_tree().create_tween()
		tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/brightness",1.0,1.0)
		tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/contrast",1.0,1.0)
		tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/saturation",1.0,1.0)


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
		"changeweather":
			Flags.play("weathermachine")
			changeweather()
		"spendingspree":
			Flags.credit=true
			Flags.play("purchase")
		"radiation":
			Flags.radiation=true;
			randpuke()
			var radtime=Flags.rng.randi_range(1,10)
			var tween=get_tree().create_tween()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/brightness",8.0,1.5).from_current()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/contrast",5.0,1.0).from_current()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/saturation",6.0,1.0).from_current()
			tween.tween_callback(radiationend)
			Flags.play("alarm")
		"horror":
			triggerhorror()

		"exitenterable":
			exit()
		"puke":
			dopuke()
		"getgems":
			var g=Flags.rng.randi_range(1,5)+Flags.playerStats.rizz
			Flags.megaStats.gems+=g
			$player.stat("+","gem",g)
			Flags.save()
			Flags.play("gemget")


		"restorehp":
			var h=1
			Flags.playerStats.health=min(Flags.playerStats.health+1,Flags.playerStats.maxHealth)
			$player.stat("+","health",h)
		"that":
			Flags.hat="that"
			$player/AnimatedSprite2D.animation=$player/AnimatedSprite2D.animation+Flags.hat
			Flags.mesmerized=false
			$player.walkani()
			Flags.tne.dotime(self,[warnhat],27.0,"warnhat",true,"level")
			
		"controlled":
			var resistChance=Flags.playerStats.smarts*10
			if Flags.rng.randi_range(0,100)>resistChance:
				Flags.controlled=true
				$player.walkani()
			else:
				$player.resisted()
		"mesmerized":
			var resistChance=Flags.playerStats.smarts*10
			if Flags.rng.randi_range(0,100)>resistChance:
				Flags.mesmerized=true
				$player.walkani()
				Flags.play("hypno")
			else:
				$player.resisted()
		"resisted":
			$player.resisted()		
		"normal":
			Flags.mesmerized=false
			Flags.controlled=false
			$player.walkani()
		"kick":
			missle=missleScene.instantiate()
			$interactive.add_child(missle)
			missle.position.x=($interactive.position.x*-1)+550
			missle.position.y=550
			missle.dir=Flags.dir
			missle.hit.connect(missleHit)
			Flags.play("lilthud")
			
		"warp":
			var loc=Flags.warploc
			Flags.warploc=-1*$interactive.position.x
			warpS.position.x=Flags.warploc+550
			var wi=warpScene.instantiate()
			wi.position.x=loc+550
			wi.position.y=550
			$interactive.add_child(wi)
			wi.setanimation("inactive")
			var tween = get_tree().create_tween()
			tween.tween_property($player, "modulate", Color(1,1,1,0), .5)
			tween.tween_callback(warpCB.bind(loc))
			Flags.play("warp")
		"beg":
			Flags.hat="beg"
			$player/AnimatedSprite2D.animation=$player/AnimatedSprite2D.animation+Flags.hat
			
			Flags.tne.dotime(self,[warnbeg],27.0,"warnbeg",true,"level")
				
		"stanima":
			Flags.playerStats.bonusStanima=Flags.playerStats.maxStanima
			Flags.playerStats.stanima=Flags.playerStats.maxStanima
			
			Flags.tne.dotime(self,[returnBonus.bind("stanima")],10.0,"returnstanimabonus",true,"level")

		"quest":
			pass
		"hit":
			$player.hit()
		"win":
			dowin()
		"gun":
			Flags.fightmode="gun"
		"shot":
			var bullet=bulletScene.instantiate()
			var bposy=Flags.rng.randi_range(-50,50)
			bullet.position.y=$player.position.y+bposy
			
			$enemy.add_child(bullet)	
			bullet.position.x=(($enemy.position.x)*-1)+300
			bullet.start()
			Flags.play("gunshot")
		"needle":
			var needy=needleScene.instantiate()
			$enemy.add_child(needy)
			var pos=effect.param.pos
			needy.global_position.x=effect.param.pos-75
			needy.position.y=400+Flags.rng.randi_range(-20,20)
			needy.start()
		"bosskill":
			Flags.play("mainmusic","music")
			var g=Flags.rng.randi_range(50,100)+(Flags.playerStats.rizz*10)
			Flags.megaStats.gems+=g
			$player.stat("+","gem",g)
			Flags.save()
		"gas":
			var gas=gasScene.instantiate()
			$enemy.add_child(gas)
			gas.position.y=400+Flags.rng.randi_range(-50,50)
			gas.position.x=((effect.param.pos))+Flags.rng.randi_range(-100,100)
		"shrinkgas":
			$player.scale.y=maxf($player.scale.y-.05,.10)
			$player.scale.x=maxf($player.scale.x-.05,.10)
		"laser":
			var laser=laserScene.instantiate()
			if effect.param.user:
				add_child(laser)
			else:
				$enemy.add_child(laser)
			laser.position=effect.param.pos
			laser.start(effect.param.rot)
			Flags.play("lasersound")
		"vehicle":
			if wrestplayercontrol:
				return
			$player.position.y=effect.param.pos.y
			Flags.dir=effect.param.dir			
			moveDir(effect.param.speed,true,Flags.dir,true)
		"spacetime":
			wrestplayercontrol=true
			for i in range(0,100):				
				Flags.tne.addEvent("flyup","level",false)
			Flags.tne.addEvent("inspace","level",true)
			
		"outufo":
			Flags.vehicle.rotation=1.27
			#Flags.vehicle.position.y=600
			$Camera2D.make_current()
			Flags.mode="level"
			for i in range(0,100):				
				Flags.tne.addEvent("flydown","level",false)
			Flags.tne.addEvent("outspace","level",true)
		
		"flyup":
			flyup()
		"flydown":
			flydown()
		"inspace":
			inspaceattack()	
		"inventoryAcquired":	
			$player.inventoryAcquired(effect.param.item)
		"deadEnemy":
			Flags.deathgifts()
			Flags.recordKill(effect.param.type)
		"killedby":
			Flags.recordDeath(effect.param)
		"wallon":
			basey=240*effect.param.scale
		"walloff":
			basey=420
			if !injumpup:
				jumpdown()
		"weatheroff":
			weatheroff()



func outspace():
		wrestplayercontrol=false
		Flags.vehicle.reparent($enemy)
		Flags.vehicle.position.y=600
		$player.scale.x=.75
		$player.scale.y=.75
		Flags.special=""
		Flags.play("mainmusic","music")

		$player.position.y=650
		Flags.wasufo=true	

func inspaceattack():
			$spacetime.make_current()
			Flags.mode="spacetime"
			Flags.play("spacemusic","music")
			$spaceattack.start($player.position.x)
	
		
			
func flyup():
	moveDir(1,false,1,false,"y")
	
func flydown():
	moveDir(1,false,-1,false,"y")

func exit(isdead=false):
	$Camera2D.make_current()			
	Flags.paused=false
	Flags.mode="level"
	var tween=get_tree().create_tween()
	tween.parallel().tween_property($player,"scale",Flags.playerscale,.5)
	tween.parallel().tween_property($player,"position",Flags.playerposition,.5)
	if isdead:
		$player.kill()
		return
	$player/AnimatedSprite2D.play()
	Flags.play("mainmusic","music")
	$player.walkani()


func returnBonus(skey):
	Flags.playerStats.bonusStanima=0

func warnbeg():
	$player.warn()
	
	Flags.tne.dotime(self,[returnbeg],3.0,"returnbeg",true,"level")

func warnhat():
	$player.warn()

	
	Flags.tne.dotime(self,[returnhat],3.0,"returnhat",true,"level")
	
func returnhat():
	$player.unwarn()
	if Flags.hat=="that":
		Flags.hat=""
		$player.walkani()

func returnbeg():
	$player.unwarn()
	if Flags.hat=="beg":
		Flags.hat=""
		$player.walkani()


func missleHit(body):
	body.hit()


func renderPuke():

	var puke=pukeScene.instantiate()
	puke.position.x=($interactive.position.x*-1)+550+(200*(Flags.dir*-1))
	puke.position.y=550
	$interactive.add_child(puke)
	puke.pukehit.connect(pukeHit)

	
func pukeHit(body):
	body.hit()
	
func warpCB(loc):

	warpto(loc)
	var tween = get_tree().create_tween()
	tween.tween_property($player, "modulate", oldmod, .5)



func dorandaction():
	var randaction=Flags.rng.randi_range(0,4)
	if randaction==0:
		Flags.dir=-1
		moveDir(Flags.rng.randi_range(1,75),true,Flags.dir,true)
	if randaction==1:
		Flags.dir=1
		moveDir(Flags.rng.randi_range(1,75),true,Flags.dir,true)		
	if randaction==2&& canJump==true:
		canJump=false
		Flags.inFight=true
		$player.fight()
		var tween = get_tree().create_tween()
		oldmod = $player.modulate
		tween.tween_property($player, "modulate", oldmod, .65)
		tween.tween_callback(stop_fight)
	if randaction==3 && canJump==true:
		canJump=false
		currSpeed=speed
		speed+=5
		var tween = get_tree().create_tween()
		gy=basey
		gx=$player.position.x
		Flags.play("jump")
		tween.tween_property($player, "position", Vector2(gx,gy-ascent), .5)
		tween.tween_callback(reset_player)
	if randaction==4 && canJump==true:
		$player.search()
	canrandom=false	
	
	Flags.tne.dotime(self,[rando],Flags.rng.randi_range(1.0,4.0),"rando",true,"level")	


func rando():
	canrandom=true

func _process(delta):
	
	if Input.is_action_just_pressed("reset"):
		if Flags.mode=="statsScreen":
			$stats.contract()
		#elif Flags.mode=="level":
		else:
			$stats.expand()
			$stats.clear()
			var count:=0
			for i in Flags.playerInventory:
				count+=1
				$stats.addInventory(i,count)
	
	
	if Flags.mode!="level":
		return
	
	if Flags.paused==true:
		return
		

	if Flags.controlled==true && canrandom==true:
		dorandaction()		
	

	var ce=Flags.tne.consumeEvent("level")
	if ce != null:
		doEffect(ce)

	if Flags.special!="":
		return

	if Input.is_action_just_released("down"):
		Flags.inCrouch=false
		$player.uncrouch()
		$player.walkani()
	
	if Input.is_action_just_released("run"):
		stopRun()


		
	if stanimaAction==true:
		var rate=Flags.playerStats.stanimaRate
		if Flags.weather=="sun":
			rate=5
		Flags.playerStats.stanima-=rate
	#	$stanimabar.value=Flags.playerStats.stanima

	if Flags.playerStats.stanima<1:
		stanimaAction=false
		Flags.exhausted=true
		$player.walkani()
		speed=1
	if stanimaAction==false:
		
		Flags.playerStats.stanima=min(Flags.playerStats.stanima+Flags.playerStats.stanimaRecharge,Flags.playerStats.maxStanima)
	#	if Flags.playerStats.stanima!=Flags.playerStats.maxStanima:
	#		$stanimabar.value=Flags.playerStats.stanima
		if Flags.exhausted==true && Flags.playerStats.stanima>(Flags.playerStats.maxStanima/2):
			speed=currSpeed
			Flags.exhausted=false
			$player.walkani()	
					
	var ani:=false
	if Flags.playerDead==true:
		if Input.is_action_just_pressed("reset"):
			stop_fight()
		return
	
	if Input.is_action_pressed("down") && canJump:
		if !Flags.inCrouch:
			Flags.inCrouch=true
			$player.crouch()
	
	if Input.is_action_pressed("right"):
		Flags.dir=-1
		moveDir(1,true,Flags.dir,true)
		ani=true
	if Input.is_action_pressed("left"):
		Flags.dir=1
		moveDir(1,true,Flags.dir,true)		
		ani=true

	if Flags.pukestate==true:
		ani=true
	if !ani && (Flags.inFight==false && Flags.playerSearch==false):		
		$player/AnimatedSprite2D.pause()
	else:
		if !$player/AnimatedSprite2D.is_playing():
			$player/AnimatedSprite2D.play()

	if Flags.mesmerized==true:
		stopRun()
		return

		
#	if Input.is_action_just_pressed("fight")&& (canJump==true && !Flags.inFight:
	if Input.is_action_just_pressed("fight"):
		Flags.inCrouch=false
		Flags.playerHits=Flags.playerStats.power		
		Flags.inFight=true
		$player.fight()
		var tween = get_tree().create_tween()
		oldmod = $player.modulate
		tween.tween_property($player, "modulate", oldmod, .65)
		tween.tween_callback(stop_fight)

	if Input.is_action_just_pressed("jump") && canJump==true:
			jumps+=1
			inascent=true
			Flags.inCrouch=false
			canJump=jumps<Flags.megaStats.extraJump
			Flags.inJump=true
			currSpeed=speed
			speed+=5
#			var tween = get_tree().create_tween()
			gy=$player.position.y
			gx=$player.position.x
			Flags.play("jump")
			phantomposition=$player.position.y
			jump(gy-ascent)
#			tween.tween_property($player, "position", Vector2(gx,gy-ascent), .5)
#			tween.tween_callback(reset_player)	
			
	#if Input.is_action_just_pressed("jump") && canJump==true:				
		#jumps+=1
		#inascent=true
		#Flags.inCrouch=false
		#canJump=jumps<Flags.megaStats.extraJump
		#Flags.inJump=true
		#currSpeed=speed
		#speed+=5
		#var tween = get_tree().create_tween()
		#gy=$player.position.y
		#gx=$player.position.x
		#$player/jump.play()
		#tween.tween_property($player, "position", Vector2(gx,gy-ascent), .5)
		#tween.tween_callback(reset_player)
		

	if Input.is_action_just_pressed("search") && canJump==true:
		Flags.inCrouch=false
		if Flags.interactablenpc!=null:
			interact()
			return
		$player.search()

	if Input.is_action_just_pressed("run") && canJump==true && Flags.exhausted==false && Flags.weather!="snow":
		speed=baseSpeed+4		
		stanimaAction=true

	if Input.is_action_just_pressed("enter") && Flags.entered.ready==true:
		Flags.inCrouch=false
		if Flags.entered.building.allreadyentered==false:
			$player.enter()
			Flags.entered.active=true
			Flags.paused=true
			Flags.entered.building.allreadyentered=true
			
			Flags.conveniance.oldloc=$locationback.position.x
			ani=true
			var tween=get_tree().create_tween()
			tween.parallel().tween_property($player,"scale",Vector2(0.4,0.4),1.5)
			tween.parallel().tween_property($player,"position",Vector2($player.position.x,350),1.5)
			tween.tween_callback(entered)		
	

	

	if Flags.pukestate==true:
		$player/AnimatedSprite2D.play()

func jump(howhigh):
	
	jumpheight=howhigh
	jumpup()
	doenvup()


func doenvup():
	for i in Flags.env:
		i.scene.position.y+=10*i.speed
	Flags.tne.dotime(self,[doenvup],.01,"doenvup",true,"level")

func doenvdown():
	Flags.tne.killTimer("doenvup","level")
	var count=0
	for i in Flags.env:
		if i.scene.position.y>i.y:
			i.scene.position.y-=7*i.speed
			count+=1
		else:
			i.scene.position.y=i.y
	if count>0:
		Flags.tne.dotime(self,[doenvdown],.01,"doenvdown",true,"level")
		
		
func newjumpstart():
	pplus=-1
	eplus=0
	pposmax=basey-200
	eposmax=100
	eposy=0
	newjumpup()
	
func envup():
	return
	
func newjumpup():
	$player.position.y+=pplus
	if $player.position.y>pposmax:
		pplus=0
		eplus=1
		eposy+=eplus
		if eposy>eposmax:
			eplus=-1
			newjumpdown()
			pplus=0
			return
	newjumpup()
	
func newjumpdown():
	var ebasey
	eposy+=eplus
	if eposy<=ebasey:
		eplus=0
		pplus=-1
		$player.position.y+=pplus
		if $player.position.y<=basey:
			pplus=0
			newstopjump()		
	newjumpdown()
	
func newstopjump():
	return
		
func ensurebase():
	var s=0
	jumps=-1
	
	
func jumpup():
	injumpup=true
	jumpups+=1
	inascent=true
	var jumpmax=100
	if Flags.weather=="snow":
		jumpmax=150
	$player.position.y=max(jumpmax,$player.position.y-20)
	phantomposition-=20
	if phantomposition<(jumpheight*jumps):
		jumps-=1
		if jumps<1:
			jumpdown()
			injumpup=false
			doenvdown()
			inascent=false
			Flags.tne.killTimer("jumpup","level")
			return
	Flags.tne.dotime(self,[jumpup],.01,"jumpup",true,"level")

func jumpdown():
	injumpup=false
	Flags.tne.killTimer("jumpup","level")
	jumpups=max(jumpups-1,0)
	indescent=true
	phantomposition+=20
	$player.position.y=min($player.position.y+20,basey)
	if phantomposition>basey:
		$player.position.y=basey
		Flags.tne.killTimer("jumpdown","level")
		stopjump()
		return
	Flags.tne.dotime(self,[jumpdown],.01,"jumpdown",true,"level")
	
	
func finishenvdescent():
	#potential kill
		return

	
func unconfused():
	Flags.confused=false


func interact():
	Flags.paused=true
	Flags.mode=Flags.interactablenpc.mode
	doMode()

func doMode():
	match Flags.mode:
		"trader":
			$trader.visible=true
#			Flags.stopthemusic()
			$trader.start(self)
		"jobboard":
#			Flags.stopthemusic()
			$joboard.start(self)
	
	
func intreturn():
	Flags.play("mainmusic","music")
	
	
func entered():
	weatheroff()
	speed=1
#	Flags.stopthemusic()
	Flags.entered.building.start(self)
	Flags.entered.building.close()

func stopRun():
		if Flags.exhausted==false && canJump==true:
			speed=currSpeed
		else:
			currSpeed=baseSpeed
		$player.walkani()
		stanimaAction=false

func moveDir(base,flip,dir,offS,pos="x"):
	if Flags.confused:
		dir*=-1
	var gospeed=speed
	if Flags.weather=="snow":
		gospeed=max(1,speed/2)
	Flags.l=$locationback.position[pos]
	$stars.position[pos]+=dir*(base-.9)*gospeed
	$treeholder.position[pos]+=dir*base*gospeed 
	$background.position[pos]+=dir*(base+0.25)*gospeed
	$treeholder2.position[pos]+=dir*(base+0.5)*gospeed 
	$ground.position[pos]+=dir*(base+1)*gospeed
	$treeholder3.position[pos]+=dir*(base+1.5)*gospeed
	$rocks.position[pos]+=dir*(base+0.60)*gospeed
	$npcs.position[pos]+=dir*(base+0.45)*gospeed
	$interactive.position[pos]+=dir*(base+0.45)*gospeed
	$enemy.position[pos]+=dir*(base+0.5)*gospeed
	$locationback.position[pos]+=dir*(base+0.6)*gospeed
	$locationfront.position[pos]+=dir*(base+0.6)*gospeed
	if Flags.petmove:
		$pets.position[pos]+=dir*(base+1)*gospeed
	if flip:
		$player.flip(dir==1)
		
			#$player/CollisionShape2D.flip_h=(dir==1)
	if dir!=1:
		$player.dooffset(false)
		#$player/AnimatedSprite2D.offset=Vector2(0,0)
		#$player/CollisionShape2D.offset=Vector2(0,0)
	else:
		if offS==true:
			$player.dooffset(true)
			

func warpto(base,sped=speed,axis="x"):
		base*=-1
		$treeholder.position[axis]=base 
		$stars.position[axis]+=(base-.9)*speed
		$background.position[axis]+=(base+0.25)*speed
		$treeholder2.position[axis]=(base+0.5)*speed 
		$treeholder3.position[axis]=(base+1.5)*speed
		$ground.position[axis]+=(base+1)*speed
		$rocks.position[axis]=(base+0.60)*speed
		$npcs.position[axis]=(base+0.45)*speed
		$interactive.position[axis]=(base+0.45)*speed
		$enemy.position[axis]=(base+0.5)*speed
		$locationback.position[axis]=(base+0.6)*speed
		$locationfront.position[axis]=(base+0.6)*speed
		$player/AnimatedSprite2D.offset=Vector2(0,0)
		
		#$pets.position[axis]=(base+1)*speed


func resety(axis="y"):
	
		$treeholder.position[axis]=treeholderResetY 
		$stars.position[axis]=0
		$treeholder2.position[axis]=treeholder2ResetY
		$ground.position[axis]=0
		$background.position[axis]=0
		$treeholder3.position[axis]=0
		$rocks.position[axis]=0
		$npcs.position[axis]=0
		$interactive.position[axis]=0
		$enemy.position[axis]=0
		$locationback.position[axis]=0
		$locationfront.position[axis]=0
		$pets.position[axis]=0
#		$player/AnimatedSprite2D.offset=Vector2(0,0)


func stop_fight():
		#Flags.playerHits=Flags.playerStats.power
		$player.revert()
		$player.modulate=oldmod;
		canJump=true
		Flags.inFight=false
		Flags.playerDead=false
		stopRun()

func stopjump():
	indescent=false
	inascent=false
	jumps=0
	speed=Flags.playerStats.speed
	currSpeed=speed
	height=0
	countheight=0
	indescent=false
	#finishenvdescent()
	
	Flags.inJump=false
	canJump=true
	Flags.inCrouch=false
	if Flags.spinned:
		Flags.spinned=false
		if Flags.megaStats.dizres>0.0:
			Flags.confused=true
			$player.confused()
			Flags.tne.dotime(self,[unconfused],Flags.megaStats.dizres,"unconfuse",true,"level")





			
func reset_player():
	indescent=true
	inascent=false
	canJump=false
	jumps-=1
	#Flags.inJump=false
	#speed=currSpeed
	if get_tree()!=null&&jumps<1:
		var tween = get_tree().create_tween()
		tween.tween_property($player, "position", Vector2(gx,basey), .5)
		tween.tween_callback(reset_flags)

func reset_flags():
	jumps=0
	##print($player.position.y)
	if $player.position.y==basey:
		speed=Flags.playerStats.speed
		currSpeed=speed
	Flags.inJump=false
	canJump=true
	Flags.inCrouch=false
	if Flags.spinned:
		Flags.spinned=false
		if Flags.megaStats.dizres>0.0:
			Flags.confused=true
			$player.confused()
			Flags.tne.dotime(self,[unconfused],Flags.megaStats.dizres,"unconfuse",true,"level")


func get_bg_texture(type):
	if type>types.size()-1:

		type=0
	var s:="t" 
	if type==1: s="s"
	var name=types[type].name
	var numvariant=types[type].num

	var treenum=Flags.rng.randi_range(1,numvariant)
	var ts=assetsScene.instantiate()
	ts.animation=s+str(treenum)
	return ts




func createchoice(holder,scn,pos,brandflip,setani,ypos,deploycheck,fromleft):
		var spwn=scn.instantiate()

		if brandflip:
			spwn.get_child(1).flip_h=!Flags.rng.randi_range(0,1)>0
		if setani>1:
			spwn.choose()
		if ypos!=0:
			spwn.position.y=ypos
		if deploycheck && !spwn.candeploy:
			return
		if spwn==null:
			return
		if fromleft:
			var bleft=randbool()
			if bleft:
				spwn.position.x=((holder.position.x)*-1)-pos
				spwn.polarity(bleft)			
			else:
				spwn.position.x=((holder.position.x)*-1)+pos		
		else:
			spwn.position.x=((holder.position.x)*-1)+pos		
		holder.add_child(spwn)	
		

var spawnulator:=[

]

func fightweather():
	
	for i in $npcs.get_children():
		if "who" in i:
			if i.who=="win3":
				i.position.x=($npcs.position.x*-1)+1300
				Flags.play("gunshot","fx")
				$weather.changeweather()
				if Flags.weather!="":
					Flags.tne.dotime(self,[fightweather],1.5,"fightweather",true,"level")
				break




func randbool():
	return Flags.rng.randi_range(0,1)==1


func dochances(val):
	#trash
	if val<1:
		createchoice($interactive,trashScene,1400,false,1,0,false,false)
		return
	if val<2:
		#rock
		createchoice($rocks,rockScene,1400,true,3,0,false,false)
		return
	if val<3:
		#groundling
		createchoice($enemy,enemyScene,1400,false,1,500,false, true)
		return
	if val<4:
		#tv
		createchoice($interactive,tvScene,1400,false,1,0,false,false)
		return
	if val<5:
		#expander
		createchoice($enemy,expanderScene,1400,false,1,350,false,false)
		return
	if val<6:
		 #tall monster (diapertooth)
		createchoice($enemy,tallmScene,1400,false,1,450,false,true)
		return
	if val<7:
		 #minigame
		createchoice($locationback,enterScene,1400,false,1,196,false,false)
		return
	if val<8:
		 #weather effects
		$weather.changeweather()
		$weather.position.y=-800
		Flags.tne.dotime(self,[fightweather],1.0,"fightweather",true,"level")
		return	
	if val<9:
		#fair weather
		weatheroff()
		return
	if val<10:
		#flavor npcs
		createchoice($npcs,flavorScene,1400,false,3,0,true,false)
		if Flags.weather!="":
			Flags.tne.dotime(self,[fightweather],.5,"fightweather",true,"level")
		return
	if val<11:
		#flying enemy
		createchoice($enemy,flyerScene,1400,false,1,0,false,false)
		return
	if val<12:
		#multistage enemy
		createchoice($enemy,multiScene,1400,false,1,400,false,true)
		return
	if val<13:
		#gemmonster
		createchoice($enemy,gemScene,1400,false,1,400,false,true)
		return
	if val<14:
		#hoarde
		dohoarde()
		return
	if val<15:
		#gravestone
		createchoice($enemy,graveScene,1400,false,1,400,false,false)
		return
	if val<16:
		 #special npc
		createchoice($npcs,specialnpcScene,1400,false,2,400,true,false)
		return
	if val<17:
		#boss
		createchoice($enemy,bossScene,1400,false,1,300,false,false)
		return

	if val<18:
		 #plaugetester
		createchoice($enemy,plaugeScene,1400,false,1,400,false,true)
		return
	if val<19:
		#saw
		createchoice($enemy,sawScene,1400,false,1,300,false,false)
		return
	if val<20:
		#kinfulator
		createchoice($enemy,knifeScene,1400,false,1,375,false,false)
		return
	if val<21:
		#ufo
		createchoice($enemy,ufoScene,1400,false,1,20,false,false)
		return
	if val<22:
		#wall
		createchoice($interactive,wallScene,1400,false,1,20,false,false)
		return


		
	if val<23:
		#quest
		if questDistributed==false:
			var trash=trashScene.instantiate()
			trash.position.x=(($interactive.position.x)*-1)+1400
			trash.questItem=true
			questDistributed=true
			$interactive.add_child(trash)	
			return	

var monsters=[
	{"scene":enemyScene,"height":500},
	{"scene":tallmScene,"height":450},
	{"scene":flyerScene,"height":0},
	{"scene":multiScene,"height":400},
	{"scene":gemScene,"height":400},
	{"scene":plaugeScene,"height":400}	
	]


func createrandommonster():
	var mob=Flags.rng.randi_range(0,monsters.size()-1)
	createchoice($enemy,monsters[mob].scene,1400,false,1,monsters[mob].height,false,true)



func dohoarde():
	for i in range(1,Flags.rng.randi_range(5,30)):
		
		Flags.tne.dotime(self,[createrandommonster],Flags.rng.randf_range(0.1,3.5),"hoarde",false,"level")
	Flags.play("warcry")
	
func dospawns():

	if Flags.mode!="level":
		#checkspawn in x seconds
		
		Flags.tne.dotime(self,[dospawns],3.0,"spawns",true,"level")
		return

	#print("bosszone ",bossZone," - current: ",$locationfront.position.x)
	if $locationfront.position.x<(bossZone*-1):
		
		createchoice($locationfront,bossScene,1400,false,1,300,false,false)
		Flags.tne.killTimer("spawns","level")
		return
		
		
		
	if (dangerZone.less*-1>$enemy.position.x):
		if (dangerZone.more*-1<$enemy.position.x):
			
			var upchoice=20

			if $interactive.position.x>-5000 && questDistributed==false:
				upchoice=21
			
			var chance=Flags.rng.randi_range(0,upchoice)
			var newchance=Flags.rng.randi_range(0,Flags.percentageAgg)
		#	print(newchance,Flags.percentageAgg)
			var agg=0
			var count=0
			for i in Flags.percentageMap:
				agg+=i
				if newchance<=agg:
					dochances(count)
					newchance=10000					
					break
				count+=1									
	
			var nextSpawn=Flags.rng.randf_range(2.5,5.0)
			
			Flags.tne.dotime(self,[dospawns],nextSpawn,"spawns",true,"level")
			
			return
			

	
	Flags.tne.dotime(self,[dospawns],3.0,"spawns",true,"level")

func changeweather():
	$weather.changeweatherforce()
	$weather.position.y=-800

func weatheroff():
	$weather.position.y=0
	Flags.weather=""
	
func _on_rock_body_entered(body):
	#$player.hit()
	pass

func _on_audio_stream_player_finished():
	#$AudioStreamPlayer.play()
	pass

func _on_missle_hit() -> void:
	pass # Replace with function body.


func _on_tutorial_body_entered(body: Node2D) -> void:
	weatheroff()
	$enemy/tv.settype("tv")
	speed=1
	warpto(-16250)

	if Flags.Levels.tutorial.instantiated==false:
		spawn()
		spawntrash(7680,1,1)
		Flags.Levels.tutorial.instantiated=true
	Flags.play("tutorial","music")

func backHome():
	Flags.Levels.tutorial.completed=true
	warpto(0)
	Flags.play("mainmusic","music")


func spawn():
	var trash=trashScene.instantiate()
	trash.position.x=(15050*-1)
	trash.setType("fridge")		
	trash.setItem(3,2)	
	$interactive.add_child(trash)	
	return

func dowin():
	Flags.titlescreen="win"
	$player.restart()

func spawntrash(xpos,t,v):
	var trash=trashScene.instantiate()
	trash.position.x=(xpos*-1)
	trash.setItem(t,v)	
	$interactive.add_child(trash)	
	return	

	
func spawnEnemyAt(ep):
	var enemy=enemyScene.instantiate()
	enemy.position.y=500
	enemy.position.x=(ep*-1)
	$enemy.add_child(enemy)
	return

func _on_pailface_body_entered(body: Node2D) -> void:
	spawnEnemyAt(12400)
	pass # Replace with function body.


func _on_exit_body_entered(body: Node2D) -> void:
	backHome()
	pass # Replace with function body.


func _on_backtostart_body_entered(body: Node2D) -> void:
	if body.name=="player":
		backHome()
	pass # Replace with function body.
