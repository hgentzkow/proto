# npm install http-server -g
# http-server . -p 8080
# http://localhost:8080/


# Import the class
TestModule = require "TestModule"
myGhost = new TestModule

myGhost.enable()


############################################
# Springs
############################################

excessiveSpring = "spring(200,15, -3)"
gentleSpring = "spring(40,5, 0)"
swingSpring = "spring(120,15, 0)"
smoothSpring = "spring(100,20, 0)"
slowSpring = "spring(100,15, -3)"
snapSpring = "spring(200, 20, 0)"
tightSpring = "spring(300, 25, 0)"
straightSpring = "spring(500, 40, 0)"
superSlowSpring = "spring(30,20,0)"
minimalOverBoundSpring = "spring(300, 40, 0)"

Framer.Defaults.Animation.curve = minimalOverBoundSpring
 #"ease-in-out"
#Framer.Defaults.Animation.curve ="ease-in-out"
Framer.Defaults.Animation.time = 0.05


############################################
# Core
############################################

# Base = new Layer
# 	width: 1920
# 	height: 1080
# 	backgroundColor: "#F0F0F0"
# 	# image: "images/Start.png"
# 	borderRadius: 0
# 	clip: true


# Dark = new Layer
# 	superLayer: Base
# 	width: 1920
# 	height: 1080
# 	backgroundColor: "#000"
# 	image: "images/Dark.png"
# 	borderRadius: 0
# 	opacity: 0

# Dark.states.add
# 	rest: {opacity: 0}
# 	deck: {opacity: 1}


# Dark_Overlay = new Layer
# 	x: 0
# 	y: 0
# 	width: 1920
# 	height: 1080
# 	backgroundColor: "rgba(0,0,0,0.8)"
# 	superLayer: Base
# 	opacity: 0

# Dark_Overlay.states.add
# 	hidden: {opacity: 0,}
# 	shown: {opacity: 1, animationOptions: {curve: superSlowSpring}}


# Slides = new Layer
# 	width: 10803/2
# 	height: 1969/2
# 	image: "images/Deck.png"
# 	superLayer: Base
# 	scale: 1

# Slides.center()

# Slides.originX = 0
# Slides.originY = 0.5


# Slides.states.add
# 	rest: {scale: 0.3, x: 128, y: 48}
# 	deck: {scale: 0.9, x: 128, y: 72}
# 	deck2: {scale: 0.9, x: 128 - 1600, y: 72}


# Base.opacity = 0
# Slides.states.switch "rest"

# Utils.delay 1, ->
# 	Base.opacity = 1

# Dock = new Layer
# 	width: 1714/2
# 	height: 221/2
# 	superLayer: Base
# 	image: "images/Dock.png"
# 	x: 548 - 17
# 	y: 976 - 7
# 	opacity: 0

# Dock.states.add
# 	rest: {opacity: 0, y: Dock.y, scale: 1, brightness: 100}
# 	deck: {opacity: 1, y: Dock.y, scale: 1, brightness: 100}
# 	deckDown: {opacity: 1, brightness: 20, animationOptions: {curve: superSlowSpring}}


# Base.on Events.Click, ->
# 	if Slides.states.current.name != "deck" and Slides.states.current.name != "deck2"
# 		Slides.states.switch "deck"
# 		Dock.states.switch "deck"
# 		Dark.states.switch "deck"

# 		Utils.delay 0.2, ->
# 			Dark_Overlay.states.switch "shown"
# 			Dock.states.switch "deckDown"
# 	else
# 		Slides.states.switch "rest"
# 		Dock.states.switch "rest"
# 		Dark.states.switch "rest"
# 		Dark_Overlay.states.switch "hidden"



# Slides.on Events.Click, (e) ->
# 	#print Slides.states.current.name 
# 	if Slides.states.current.name == "deck" or Slides.states.current.name == "deck2"

# 		if Slides.states.current.name == "deck"
# 			Slides.states.switch "deck2"
# 			Dark_Overlay.states.switch "shown"
# 			Dock.states.switch "deckDown"
# 		else
# 			Slides.states.switch "deck"
# 			Dark_Overlay.states.switch "shown"
# 			Dock.states.switch "deckDown"

# 	e.stopPropagation()

# Base.on Events.MouseMove, ->
# 	if Slides.states.current.name == "deck"
# 		if Dark_Overlay.states.current.name == "shown"
# 			Dark_Overlay.states.switch "hidden"
# 			Dock.states.switch "deck"
# 			Utils.delay 1, ->
# 				if Slides.states.current.name == "deck"
# 					Dark_Overlay.states.switch "shown"
# 					Dock.states.switch "deckDown"

# Slides.center()





############################################
# Desktop Defaults
############################################

# Set the cursor correctly
document.body.style.cursor = "default"
Framer.Device.deviceType = "fullscreen"
Framer.Extras.Hints.disable()

# Set a background layer with a color
Background = new Layer
	index: 1
	x:0
	y:0
	width: window.innerWidth
	height: window.innerHeight
	backgroundColor: "#000"
    
# "Base" is the layer you should add everything to. 
Base = new Layer
	index: 1
	x:0
	y:0
	width: window.innerWidth
	height: window.innerHeight
	backgroundColor: "#F0F0F0"
	superLayer: Background
	clip: true

# If you use the design tab, just create a layer target called “Base”, 
# and apply these properties instead.

# Base.superLayer = Background
# Base.clip = true
# Base.index = 1

    
# Automatically Resize Background, and scale "Base"--
# This way your whole prototype is always visible, no matter the size of the window
# resizeBackground = () ->
# 	Base.center()
# 	Background.width = window.innerWidth
# 	Background.height = window.innerHeight
# 	scaleWidth = Math.min(1, window.innerWidth / Base.width)
# 	scaleHeight = Math.min(1, window.innerHeight / Base.height)
# 	Base.scale = Math.min(scaleWidth, scaleHeight)
            
# resizeBackground()
# window.addEventListener("resize", resizeBackground, false);

# You can also use this with a FlowComponent, if you prefer to 
# visualize independent artboards in the design tab
#
# flow = new FlowComponent
# flow.superLayer = Base
# flow.showNext(LayerName)




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
	superLayer: Base
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

FontRowArial = new Layer
	width: 216
	height: 32
	superLayer: Picker
	image: "images/Font18_Arial.png"
	x: 0
	y: 82
	opacity: 1
	

FontRowArial.on Events.MouseOver, (e) ->
	FontRowArial.backgroundColor = "#F5F5F5"

FontRowArial.on Events.MouseOut, (e) ->
	FontRowArial.backgroundColor = null


fontImages = ["Font18_Arial", "Font18_Bar", "Font18_DM", "Font18_Fira", "Font18_IBM", "Font18_Inter", "Font18_Jost", "Font18_Lato", "Font18_Mon"]

# for (i = 0, len = ref.length; i < len; i++) {
#     student = ref[i];
#     console.log(student);
#   }

# add images for font rows
addFonts = () ->
	for font, index in fontImages
		font = new Layer
			width: 216
			height: 32
			superLayer: Picker
			image: "images/" + font + ".png"
			x: 0
			y: 82 + 32 * index
		do (font) ->
			font.on Events.MouseOver, (e) ->
				font.backgroundColor = "#F5F5F5"
			font.on Events.MouseOut, (e) ->
				font.backgroundColor = null
		

addFonts()


# use a variable to set the font family
# interSemiBold = Utils.loadWebFont "Inter", 700



printLayer = (layer) ->
	print layer.name


# generate previews in code
fontNames = [["Georama", 18], ["Alfa Slab One", 17], ["Righteous", 18], ["Abril Fatface", 18], ["Overpass", 18]]
fontList = []

for font, index in fontNames
	layerName = font[0]
	layerName = new Layer
		width: 216
		height: 32
		superLayer: Base
		x:12
		y:12 + (index * 32)
		backgroundColor: "#FFF"
		name: layerName

	textLayer = font[0] + "text"
	textLayer= new TextLayer
		fontFamily: Utils.loadWebFont font[0]
		fontSize: font[1]
		superLayer: layerName
		x:38
		y:5
		text: font[0]
		color: "black"

	check = new Layer
		superLayer: layerName
		image: "images/Check.png"
		width: 16
		height: 24
		x: 10
		y: 4
		opacity: 0
		name: "checkMark"
	
	fontList.push layerName

	do (layerName) ->
		layerName.on Events.MouseOver, (e) ->
			layerName.backgroundColor = "#F5F5F5"
		layerName.on Events.MouseOut, (e) ->
			layerName.backgroundColor = "#FFF"
		layerName.on Events.Tap, (e) ->
			printLayer(layerName)

print fontList
print fontList[3].name
foo = Base.childrenWithName("Alfa Slab One")
print(foo)

for child in fontList[3].subLayers
	print child
	child.opacity = 1



############################################
# Animate Clicks
############################################

window.tmpCursor = null

createTap = (e) ->
		x = e.clientX
		y = e.clientY
		radius= 2
		tap = new Layer 
				x: x - radius - 96
				y: y - radius - 96
				scale: 0.2
				borderRadius: 640
				originX: 0.5
				originY: 0.5
				backgroundColor: "rgba(31, 170, 237, 0.7)"
		return tap

showTapTarget = (e) ->
		x = e.offsetX
		y = e.offsetY
		tap = createTap e
		window.tmpCursor = tap
        
showTap = (e, parent) ->
		e.stopPropagation()
		if window.tmpCursor?
				window.tmpCursor.destroy()
		tap = createTap e
		tap.animate
				properties: {scale: 0.5, opacity: 0}
				curve: "spring(150,25, -3)"
		Utils.delay 1, ->
				tap.destroy()
                
#Base.on Events.TouchStart, showTapTarget
#Base.on Events.TouchEnd, showTap


############################################
# Show / Hide on Hover
# showOnHover someRandomLayerIHave
# showOnHover someRandomLayerIHave, whenIHoverOverThisLayer
# hideOnHover someRandomLayerIHave
# hideOnHover someRandomLayerIHave, whenIHoverOverThisLayer
############################################

showOnHover = (yourLayer, triggerLayer) ->
	if !(triggerLayer?)
		triggerLayer = yourLayer
	yourLayer.opacity = 0
        
	triggerLayer.on Events.MouseOver, -> 
		document.body.style.cursor = "pointer"
		yourLayer.animate
			properties: {opacity:1}
			curve: "spring(500, 40, 0)"
                        
	triggerLayer.on Events.MouseOut, -> 
		document.body.style.cursor = "auto"
		yourLayer.animate
			properties: {opacity:0}
			curve: "spring(500, 40, 0)"

showOnHoverDelayInstant = (yourLayer, triggerLayer, delay) ->
	if !(triggerLayer?)
		triggerLayer = yourLayer
	yourLayer.opacity = 0
        
	triggerLayer.on Events.MouseOver, -> 
		document.body.style.cursor = "pointer"
		Utils.delay delay, ->
			yourLayer.opacity = 1
                        
	triggerLayer.on Events.MouseOut, -> 
		document.body.style.cursor = "auto"
		yourLayer.opacity = 0
			
showOnHoverInstant = (yourLayer, triggerLayer) ->
	if !(triggerLayer?)
		triggerLayer = yourLayer
	yourLayer.opacity = 0
        
	triggerLayer.on Events.MouseOver, -> 
		yourLayer.opacity = 1
		document.body.style.cursor = "default"                  
	triggerLayer.on Events.MouseOut, -> 
		yourLayer.opacity = 0
		document.body.style.cursor = "default"

showOnMouseDown = (yourLayer, triggerLayer) ->
	if !(triggerLayer?)
		triggerLayer = yourLayer
	yourLayer.opacity = 0
        
	triggerLayer.on Events.MouseDown, -> 
		yourLayer.animate
			properties: {opacity:1}
			curve: "ease-in"
			time: 0.05
                        
	triggerLayer.on Events.MouseUp, -> 
		yourLayer.animate
			properties: {opacity:0}
			curve: "ease-in"
			time: 0.05
			
hideOnHover = (yourLayer, triggerLayer) ->
	if !(triggerLayer?)
		triggerLayer = yourLayer
	yourLayer.opacity = 1
    
	triggerLayer.on Events.MouseOver, -> 
		yourLayer.animate
			properties: {opacity:0}
			curve: "spring(500, 40, 0)"
                        
	triggerLayer.on Events.MouseOut, -> 
		yourLayer.animate
			properties: {opacity:1}
			curve: "spring(500, 40, 0)"

