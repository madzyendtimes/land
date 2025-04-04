extends Node

class_name stats

var bonus:={
	"health":0,
	"stanima":0,
	"power":0,
	"speed":0,
	"stanimaRate":0,
	"stanimaRecharge":0,
	"rizz":0,
	"smarts":0,
	"toughness":0,
	"karma":0
}

var maximum:={
	"health":3,
	"stanima":600,
	"power":1,
	"speed":1,
	"stanimaRate":1,
	"stanimaRecharge":1,
	"rizz":0,
	"smarts":0,
	"toughness":0,
	"karma":0
}
var actual:={
	"health":3,
	"stanima":600,
	"power":1,
	"speed":1,
	"stanimaRate":1,
	"stanimaRecharge":1,
	"rizz":0,
	"smarts":0,
	"toughness":0,
	"karma":0
}
	
var health: int :
	get:
		return actual.health+bonus.health
	set(val):
		var last=actual.health

		setStat("health",val)		
		if val!=last:
			if Flags.tne!=null:				
				Flags.tne.addEvent("update","health",true,{"params":[val]})
	
var stanima: int :
	get:
		return actual.stanima+bonus.stanima

	set(val):
		var laststanima=actual.stanima
		setStat("stanima",val)
		if laststanima!=val:
			if Flags.tne!=null:			
				Flags.tne.addEvent("update","stanima",true,{"params":[val]})
var stanimaRecharge: int :
	get:
		return actual.stanimaRecharge+bonus.stanimaRecharge

	set(val):
		setStat("stanimaRecharge",val)			


var power: int :
	get:
		return actual.power+bonus.power
	set(val):
		setStat("power",val)			

var speed: int :
	get:
		return actual.speed+bonus.speed
	set(val):
		setStat("speed",val)			
		
var stanimaRate: int :
	get:
		return actual.stanimaRate+bonus.stanimaRate
	set(val):
		setStat("stanimaRate",val)			
		
var rizz: int :
	get:
		return actual.rizz+bonus.rizz
	set(val):
		setStat("rizz",val)					
var smarts: int :
	get:
		return actual.smarts+bonus.smarts
	set(val):
		setStat("smarts",val)					
var toughness: int :
	get:
		return actual.toughness+bonus.toughness
	set(val):
		setStat("toughness",val)		
var karma: int :
	get:
		return actual.karma+bonus.karma
	set(val):
		setStat("karma",val)		

		
var maxHealth:int:
	get:
		return maximum.health
	set(val):
		maximum.health=val
		if Flags.tne!=null:
			Flags.tne.addEvent("max","health",true,{"params":[val]})
		
var maxStanima:int:
	get:
		return maximum.stanima
	set(val):
		maximum.stanima=val
		if Flags.tne!=null:
			Flags.tne.addEvent("max","stanima",true,{"params":[val]})

var maxStanimaRecharge:int:
	get:
		return maximum.stanimaRecharge
	set(val):
		maximum.stanimaRecharge=val



var maxSpeed:int:
	get:
		return maximum.speed
	set(val):
		maximum.speed=val

var maxPower:int:
	get:
		return maximum.power
	set(val):
		maximum.power=val
		
var maxStanimaRate:int:
	get:
		return maximum.stanimaRate
	set(val):
		maximum.stanimaRate=val

var maxRizz:int:
	get:
		return maximum.rizz
	set(val):
		maximum.rizz=val
		
var maxSmarts:int:
	get:
		return maximum.smarts
	set(val):
		maximum.smarts=val

var maxToughness:int:
	get:
		return maximum.toughness
	set(val):
		maximum.toughness=val
var maxKarma:int:
	get:
		return maximum.karma
	set(val):
		maximum.karma=val




var bonusHealth:int:
	get:
		return bonus.health
	set(val):
		bonus.health=val

		
var bonusStanima:int:
	get:
		return bonus.stanima
	set(val):
		bonus.stanima=val

var bonusSpeed:int:
	get:
		return bonus.speed
	set(val):
		bonus.speed=val

var bonusPower:int:
	get:
		return bonus.power
	set(val):
		bonus.power=val

var bonusStanimaRate:int:
	get:
		return bonus.stanimaRate
	set(val):
		bonus.stanimaRate=val

var bonusStanimaRecharge:int:
	get:
		return bonus.stanimaRecharge
	set(val):
		bonus.stanimaRecharge=val

var bonusRizz:int:
	get:
		return bonus.rizz
	set(val):
		bonus.rizz=val
var bonusSmarts:int:
	get:
		return bonus.smarts
	set(val):
		bonus.smarts=val
var bonusToughness:int:
	get:
		return bonus.toughness
	set(val):
		bonus.toughness=val
var bonusKarma:int:
	get:
		return bonus.karma
	set(val):
		bonus.karma=val






func resetBonus():
	var key="stanima"
	print("reset",key)
	bonus[key]=0

func setStat(key,val):
		var diff=0
	#	if key!="stanima":
	#		print(key,val,actual[key],bonus[key])
	#	else:
	#		actual.stanima=val
	#		return
			
		if val<actual[key]:
			
			diff=actual[key]-val
	#		print("diff:",diff)
			var tdiff=bonus[key]-diff
	#		print("tdiff:",tdiff)
			bonus[key]=max(0,bonus[key]-diff)
	#		print("bonus:",bonus[key])
			diff=tdiff
		#print("diff:",diff)
		else:
			diff=val-actual[key]
		actual[key]=min(actual[key]+diff,maximum[key])
	#	if key!="stanima":
	#		print(actual[key])
			
