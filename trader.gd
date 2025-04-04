extends Node2D
var choice:=6
var lastchoice:=6
var choices:=[
	{"price":99,"effect":"winner","instock":true,"text":"pay to win","implemented":true},
	{"price":10,"effect":"carryinventory","instock":true,"text":"limited will & testament","implemented":true},
	{"price":8,"effect":"addstrength","instock":Flags.megaStats.power<(Flags.megaStats.capPower+1),"text":"muscle memory","implemented":true},
	{"price":8,"effect":"addhealth","instock":Flags.megaStats.health<(Flags.megaStats.capHealth+1),"text":"well fed","implemented":true},
	{"price":8,"effect":"addspeed","instock":Flags.megaStats.speed<(Flags.megaStats.capSpeed+1),"text":"adhd","implemented":true},
	{"price":5,"effect":"moneybags","instock":Flags.megaStats.credit!=true,"text":"unlimited credit","implemented":true},
	{"price":8,"effect":"addstanima","instock":Flags.megaStats.stanima<(Flags.megaStats.capStanima+1),"text":"coffee iv","implemented":true},
	{"price":8,"effect":"addrizz","instock":Flags.megaStats.rizz<(Flags.megaStats.capRizz+1),"text":"mouthwash","implemented":true},
	{"price":8,"effect":"addtoughness","instock":Flags.megaStats.toughness<(Flags.megaStats.capToughness+1),"text":"bullied as a child","implemented":true},
	{"price":8,"effect":"addsmarts","instock":Flags.megaStats.smarts<(Flags.megaStats.capSmarts+1),"text":"a skeptic's guide to logic","implemented":true},
	{"price":999,"effect":"nocap","instock":Flags.megaStats.capPower<1000,"text":"no cap","implemented":true},
	{"price":15,"effect":"slowspeed","instock":Flags.megaStats.speed>1,"text":"adhd meds","implemented":true},
	{"price":35,"effect":"spinattack","instock":!Flags.megaStats.spinattack,"text":"somersault assault","implemented":true},
	{"price":8,"effect":"dizzyresist","instock":Flags.megaStats.dizres>.01,"text":"drama meme","implemented":true},
	{"price":35,"effect":"doublejump","instock":Flags.megaStats.extraJump<Flags.megaStats.capExtraJump,"text":"extra air friction","implemented":true},
	{"price":45,"effect":"deathgifts","instock":!Flags.megaStats.deathgifts,"text":"death gifts","implemented":true},
	{"price":99,"effect":"fistshot","instock":!Flags.megaStats.attackmode.gun,"text":"hand cannon","implemented":true},
	{"price":99,"effect":"liltrip","instock":!Flags.megaStats.liltrip,"text":"adoption papers","implemented":true},
	{"price":45,"effect":"levelselect","instock":true,"text":"flat circle dissector","implemented":false},
	{"price":85,"effect":"transmute","instock":!Flags.megaStats.transmute,"text":"philosopher's rock","implemented":true},
	{"price":85,"effect":"homebase","instock":true,"text":"mortage","implemented":false},
	{"price":1,"effect":"vapor","instock":true,"text":"vapor ware","implemented":false},
	]
var stock:=[]
var home=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	$CanvasLayer/music.volume_db=Flags.options.music
#	$CanvasLayer/purchase.volume_db=Flags.options.fx
#	$CanvasLayer/invalid.volume_db=Flags.options.fx
	$CanvasLayer.visible=false
#uncomment to test locally
	#Flags.load() 
	#start(self)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Flags.mode!="trader":
		return
	
	$CanvasLayer/playergems.text=str(Flags.megaStats.gems)
	if Input.is_action_just_pressed("up"):
		select(-1)
	if Input.is_action_just_pressed("down"):
		select(1)
	if Input.is_action_just_pressed("jump"):
		purchase()
	if Input.is_action_just_pressed("fight")||Input.is_action_just_pressed("reset"):
		exit()


func getstock():
	var c=choices[Flags.rng.randi_range(0,choices.size()-1)]
	for i in stock:
		if i.text==c.text:
			c=getstock()
	return c
	
	
func start(returnlevel):
#	Flags.megaStats.gems=200
	Flags.mode="trader"
	choice=6
	lastchoice=6
	$CanvasLayer.visible=true
	home=returnlevel
	Flags.play("gemmusic","music")
#	$CanvasLayer/music.play()

	for i in range(1,7):
		var item=getstock()
		stock.append(item)
		var canva="CanvasLayer/choices/choice"+str(i)
		get_node(canva).text=str(stock[i-1].price)+"        "+stock[i-1].text
		if stock[i-1].instock==false:
			get_node(canva).set("theme_override_colors/font_color",Color.RED)
			get_node("CanvasLayer/Soldout"+str(i)).visible=true
		else:
			get_node("CanvasLayer/Soldout"+str(i)).visible=false
		if stock[i-1].implemented==false:
			get_node(canva).set("theme_override_colors/font_color",Color.RED)
			get_node("CanvasLayer/Coming"+str(i)).visible=true
		else:
			get_node("CanvasLayer/Coming"+str(i)).visible=false		
	select(0)
			
func purchase():
	if Flags.megaStats.gems>=stock[choice-1].price && stock[choice-1].instock==true&& stock[choice-1].implemented==true:
		Flags.megaStats.gems-=stock[choice-1].price
		var canva="CanvasLayer/choices/choice"+str(choice)
		stock[choice-1].instock=false
		get_node(canva).set("theme_override_colors/font_color",Color.RED)
		get_node("CanvasLayer/Soldout"+str(choice)).visible=true
		match stock[choice-1].effect:
			"addhealth":
				Flags.megaStats.health+=1
				Flags.playerStats.maxHealth=Flags.megaStats.health
				Flags.playerStats.health=Flags.megaStats.health

			"addstrength":
				Flags.megaStats.power+=1
				Flags.playerStats.maxPower=Flags.megaStats.power
				Flags.playerStats.power=Flags.megaStats.power

			"slowspeed":
				Flags.megaStats.speed-=1
				Flags.playerStats.maxSpeed=Flags.megaStats.speed
				Flags.playerStats.speed=Flags.megaStats.speed


			"addspeed":
				Flags.megaStats.speed+=1
				Flags.playerStats.maxSpeed=Flags.megaStats.speed
				Flags.playerStats.speed=Flags.megaStats.speed
				
			"addrizz":
				Flags.megaStats.rizz+=1
				Flags.playerStats.maxRizz=Flags.megaStats.rizz
				Flags.playerStats.rizz=Flags.megaStats.rizz
				
			"addsmarts":
				Flags.megaStats.smarts+=1
				Flags.playerStats.maxSmarts=Flags.megaStats.smarts
				Flags.playerStats.smarts=Flags.megaStats.smarts
								
			"addstanima":
				Flags.megaStats.stanima+=100
				Flags.playerStats.maxStanima=Flags.megaStats.stanima
				Flags.playerStats.stanima=Flags.megaStats.stanima
			"addtoughness":
				Flags.megaStats.toughness+=1
				Flags.playerStats.maxToughness=Flags.megaStats.toughness
				Flags.playerStats.toughness=Flags.megaStats.toughness				
			"moneybags":
				Flags.megaStats.credit=true
				Flags.credit=true
			"carryinventory":
				Flags.megaStats.inventorycapacity+=1
				
			"winner":
				Flags.tne.addEvent("win","level")
				#Flags.effect="win"
				
			"nocap":
				Flags.megaStats.capHealth=10000
				Flags.megaStats.capSpeed=10000
				Flags.megaStats.capPower=10000
				Flags.megaStats.capStanima=10000
				Flags.megaStats.capExtraJump=10000
				Flags.megaStats.capToughness=10000
				
			"spinattack":
				Flags.megaStats.spinattack=true
			"dizzyresist":
				Flags.megaStats.dizres=maxf(Flags.megaStats.dizres-.3,0.0)
			"doublejump":
				Flags.megaStats.extraJump=min(Flags.megaStats.extraJump+1,Flags.megaStats.capExtraJump)
			"deathgifts":
				Flags.megaStats.deathgifts=true
			"fistshot":
				Flags.megaStats.attackmode.gun=true
				Flags.fightmode="gun"
			"transmute":
				Flags.megaStats.transmute=true
			"carryinventory":
				Flags.megaStats.inventorycapacity+=1
			"liltrip":
				Flags.megaStats.liltrip=true

		$CanvasLayer/AnimatedSprite2D.animation="eat"
		Flags.save()
		#$CanvasLayer/purchase.play()
		Flags.play("purchase")
		Flags.tne.dotime(self,[backtonormal],3.6,"backtonormal")
	else:
		#$CanvasLayer/invalid.play()
		Flags.play("invalid")

func backtonormal():
	$CanvasLayer/AnimatedSprite2D.animation="default"

func exit():
	visible=false
	$CanvasLayer.visible=false
	Flags.mode="level"
	Flags.paused=false
	if Flags.interactablenpc!=null:
		Flags.interactablenpc.complete()
#	$CanvasLayer/music.stop()
	home.intreturn()
	pass

func select(dir):
	lastchoice=choice
	choice=clamp(choice+dir,1,6)
	var canva="CanvasLayer/choices/choice"+str(choice)
	var canvaold="CanvasLayer/choices/choice"+str(lastchoice)


	get_node(canvaold).get_theme_stylebox("normal").bg_color=Color.TRANSPARENT
	get_node(canva).get_theme_stylebox("normal").bg_color=Color.BLACK
	lastchoice=choice	
	
