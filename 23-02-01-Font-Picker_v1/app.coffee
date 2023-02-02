# TweenLite = require "gsap/TweenLite"
TweenMax = require "gsap/TweenMax"
Expo = require "gsap/easing/EasePack"
# TimelineLite = require "gsap/TimelineLite"
TimelineMax = require "gsap/TimelineMax"
Canvas.backgroundColor = "#F0F0F0"


############################################
# Canvas text
############################################

canvasNode = new TextLayer
	fontFamily: Utils.loadWebFont "Alfa Slab One"
	fontSize: 30
	x: 600	
	y: 250
	width: 400
	text: "“The way to get started is to quit talking and begin doing.” "
	color: "black"

canvasNode.autoHeight = yes




############################################
# Picker Core
############################################


Picker = new Layer
	index: 1
	x:300
	y:100
	width: 216
	height: 500
	backgroundColor: "#FFF"
	clip: true

# shadow details from UI2
elevation400menuPanelShadow = 
	"0 10px 16px rgba(0,0,0,0.12), 
	0 2px 5px rgba(0,0,0,0.15), 
	0 0px 0.5px rgba(0,0,0,0.12)"
	
# /* offset-x | offset-y | blur-radius | spread-radius | color */
# must specify px for values other than color - e.g. 2px
# can add multiple by puting comma separated sets inside quotes
Picker.style["box-shadow"] = elevation400menuPanelShadow

# Enable dragging on the picker
Picker.draggable.enabled = true
Picker.draggable.momentum = false

Header = new Layer
	width: 216
	height: 40
	superLayer: Picker
	image: "images/Header.png"
	x: 0
	y: 0
	opacity: 1

Search = new Layer
	width: 216
	height: 42
	superLayer: Picker
	image: "images/Search.png"
	x: 0
	y: 40
	opacity: 1

Fonts = new ScrollComponent
	width: 216
	height: Picker.height - Header.height - Search.height
	superLayer: Picker
	x: 0
	y: Search.maxY
	clip: true
	backgroundColor: "white"


# scroll = new ScrollComponent
#     width: 100
#     height: 100
# Create a new ScrollComponent 
# scroll = new ScrollComponent
# 	parent: Picker
#     width: 212
#     height: Picker.height - Header.height - Search.height
# 	x: 0
# 	y: Header.height + Search.height


# wrap Fonts ScrollComponent
# scroll = ScrollComponent.wrap(Fonts)
# scroll.scrollHorizontal = false
# scroll.scrollVertical = true


############################################
# Build font list
############################################

# generate previews in code / would be nice to move to external json
# can also change to key value pairs instead of position [0]
fontNames = [
	["Georama", 18, 0], 
	["Alfa Slab One", 17, 0], 
	["Righteous", 18, 0], 
	["Abril Fatface", 18, 0], 
	["Gentium Book Plus", 18, 0], 
	["Shadows Into Light Two", 18, 0], 
	["Alegreya Sans SC", 18, 0], 
	["Alumni Sans Inline One", 22, -2],
	["Georama", 18, 0], 
	["Alfa Slab One", 17, 0], 
	["Righteous", 18, 0], 
	["Abril Fatface", 18, 0], 
	["Gentium Book Plus", 18, 0], 
	["Shadows Into Light Two", 18, 0], 
	["Alegreya Sans SC", 18, 0], 
	["Alumni Sans Inline One", 22, -2]
	]

fontList = []

# trim last char off string
trimString = (str) ->
	return str.substr(0, (str.length - 1))


# ADD SCROLLVIEW for fontItems and figure out scroll - EASIER SAID THEN DONE!

for font, index in fontNames
	layerName = font[0]
	yOffset = font[2]
	fontItem = new Layer
		width: 216
		height: 32
		superLayer: Fonts.content
		x: 0
		y: 8 + (index * 32)
		backgroundColor: "#FFF"
		name: layerName

	textLayer = new TextLayer
		fontFamily: Utils.loadWebFont font[0]
		fontSize: font[1]
		superLayer: fontItem
		x: 38
		y: 5 + yOffset
		text: font[0]
		color: "black"
		name: font[0] + "text"
		# textOverflow: "ellipsis" - doesnt work!

	# check for truncation
	# print index + " - " + textLayer.width
	if textLayer.width > 140
		while textLayer.width > 140
			textLayer.text = trimString(textLayer.text)
		textLayer.text = textLayer.text + "..."

	check = new Layer
		superLayer: fontItem
		image: "images/Check.png"
		width: 16
		height: 32
		x: 14
		y: 0
		opacity: 1
		name: "checkMark"
	
	fontList.push fontItem

	do (fontItem) ->
		fontItem.on Events.MouseOver, (e) ->
			fontItem.backgroundColor = "#F5F5F5"
			canvasNode.fontFamily = Utils.loadWebFont fontItem.name
		fontItem.on Events.MouseOut, (e) ->
			fontItem.backgroundColor = "#FFF"
		fontItem.on Events.Tap, (e) ->
			canvasNode.fontFamily = Utils.loadWebFont fontItem.name
			
# FOR HOVER - look into TweenMax class for delay variable and kill if change before delay
layer = new Layer
	size: 100
	y: 0
	borderRadius: 16

printSomething = ->
	print "foo"

foo = new TimelineMax({paused:true, onComplete: printSomething})
foo.to(layer, 1, {maxX: "+=200", scale: 0.5, ease: Quad.easeIn})
foo.to(layer, 1, {maxY:Screen.height, scale: 1, ease: Quad.easeOut})
foo.to(layer, 1, {x:0, ease: Quad.easeIn})
foo.to(layer, 1, {y:0, ease: Quad.easeOut})
# foo.pause()

TweenMax.to(layer, 1, {y: 300, paused: true})
foo.timeScale(1).play()
# toggler.onTap (event, layer) ->
# 	foo.timeScale(1).play() #3x speed thanks to timeScale

# reverser.onTap (event, layer) ->
# 	foo.reverse()

# seeker.onTap (event, layer) ->
# 	foo.seek(1.5).play()
	
# killer.onTap (event, layer) ->
# 	foo.kill({scale:true})
document.body.style.cursor = "pointer"