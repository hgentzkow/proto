############################################
# Font Picker ##############################
# February, 2023 ###########################
############################################

# Set cursor type (look up all others!!!)
document.body.style.cursor = "pointer"
# disable hints
Framer.Extras.Hints.disable()


############################################
# LOCAL CLASSES - Collapse each with fold
############################################
# SWITCH CLASS
class Switch extends Layer
	constructor: (options = {}) ->
		super(options)
		@backgroundColor = null
		@enabled = options.enabled ? true
		@fillColor = options.fillColor ? "#FF7600"
		@height = options.height ? 31
		@width = options.width ? 51

		@bg = new Layer
			parent: @
			width: @width
			height: @height
			backgroundColor: @fillColor
			borderColor: @fillColor
			borderWidth: 2
			borderRadius: (@height / 2)

		@thumb = new Layer
			parent: @
			width: @height - 4
			height: @height - 4
			backgroundColor: "#FFF"
			borderRadius: @height / 2
			shadowY: 2
			shadowBlur: 4
			shadowColor: "rgba(0,0,0,0.35)"	
			x: 2
			y: 2

		@enable @enabled

		@on Events.Tap, @toggle

	enable: (isOn = true) =>
		@enabled = isOn
		if @enabled
			@thumb.animate
				maxX: @bg.width - 2
				options: 
					time: 0.1
			@bg.animate
				backgroundColor: @fillColor
				borderColor: @fillColor
				options:
					time: 0.1
		else
			@thumb.animate
				x: 2
				options:
					time: 0.1
			@bg.animate
				backgroundColor: "#FFF"
				borderColor: "#E5E5EA"
				options:
					time: 0.1

	toggle: () =>
		@enable(!@enabled)
		

############################################
# GREENSOCK TWEEN CLASSES
############################################

# TweenLite = require "gsap/TweenLite"
TweenMax = require "gsap/TweenMax"
Expo = require "gsap/easing/EasePack"
# TimelineLite = require "gsap/TimelineLite"
# TimelineMax = require "gsap/TimelineMax"


############################################
# PARSE FONT LIST JSON INTO OBJECTS & SORTING
############################################

fontListData = JSON.parse Utils.domLoadDataSync "files/fontList.json"
fontListArray = []
sortAlpha = true
topListText = ""
pickerMaxHeight = 500

# stuff objects into array 
createFontListArray = () ->
	# clear text string of fonts
	topListText = ""

	for i in [0...fontListData.fonts.length]

		# generate text string of fonts in their order
		topListText = topListText + ((i + 1) + ". " + fontListData.fonts[i].name) + "\n"

		fontListArray.push {
			"name": fontListData.fonts[i].name
			"size": fontListData.fonts[i].size
			"yOffset": fontListData.fonts[i].yOffset
			"xOffset": fontListData.fonts[i].xOffset
			"kerning": fontListData.fonts[i].kerning
			"show": fontListData.fonts[i].show
		}
	if sortAlpha
		fontListArray.sort(sortFontsAlpha)

# sort array alphabetically 
sortFontsAlpha = (a, b) ->
	optA = a.name.toUpperCase()
	optB = b.name.toUpperCase()

	comparison = 0
	if optA > optB
		comparison = 1
	else if optA < optB
		comparison = -1
	return comparison # return comparison * -1 // to invert z - a


############################################
# ADD FIGMA BG
############################################

Figma = new Layer
	width: 1280
	height: 910
	image: "images/FigmaApp.png"
	x: 0
	y: 0
	opacity: 1
	clip: true


############################################
# CANVAS TEXT & BOUNDS
############################################

# create canvas text layer
canvasNode = new TextLayer
	fontFamily: Utils.loadWebFont "Caveat"
	fontSize: 30
	x: 350	
	y: 250
	# width: 400
	text: 'The way to get started \nis to quit talking \nand begin doing.'
	color: "black"
	superLayer: Figma
canvasNode.autoHeight = yes
canvasNode.autoWidth = yes

# create bounding box elements
canvasNodeBounds = new Layer
	x: canvasNode.x
	y: canvasNode.y
	width: canvasNode.width
	height: canvasNode.height
	backgroundColor: null
	superLayer: Figma

canvasNodeBoundsBox = new Layer
	superLayer: canvasNodeBounds
	x: -6
	y: -4
	backgroundColor: null
	borderWidth: 1
	borderColor: "#4497F7"

# create corner boxes
cornerBox1 = canvasNodeBoundsBox.copy()
cornerBox2 = canvasNodeBoundsBox.copy()
cornerBox3 = canvasNodeBoundsBox.copy()
cornerBox4 = canvasNodeBoundsBox.copy()

canvasBoundsDimensions = new TextLayer
	# fontFamily: Utils.loadWebFont "Inter"
	fontSize: 11
	fontWeight: 500
	text: 'dim'
	color: "black"
	superLayer: canvasNodeBounds
	color: "white"
	backgroundColor: "#4497F7"
	borderRadius: 2
	padding:
		top: 3
		left: 6
		bottom: 2
		right: 6

showBounds = () ->
	canvasNodeBounds.opacity = 1

# update bounding box to canvas test node size
updateBounds = () ->
	# turn off bounds, then back on in 2 seconds NEED GSAP TO CANCEL
	canvasNodeBounds.opacity = 0
	TweenLite.killDelayedCallsTo(showBounds);
	TweenLite.delayedCall(2, showBounds);
	# update bounding box border
	canvasNodeBounds.height = canvasNode.height + 10 # are these redundant? or parent for hiding only?
	canvasNodeBounds.width = canvasNode.width + 10
	canvasNodeBoundsBox.width = canvasNodeBounds.width
	canvasNodeBoundsBox.height = canvasNodeBounds.height # can you use , and put these 4 into 2?
	# update dimensions
	canvasBoundsDimensions.midX = canvasNodeBoundsBox.midX
	canvasBoundsDimensions.y = canvasNodeBoundsBox.height 
	canvasBoundsDimensions.text = canvasNodeBoundsBox.width + " x " + canvasNodeBoundsBox.height
	# update corner boxes
	for i in [1..4]
		l = eval("cornerBox" + i)
		l.superLayer = canvasNodeBounds
		l.backgroundColor = "white"
		l.width = 8
		l.height = 8
		stag = 0 
		switch i
			when 1
				l.midX = canvasNodeBoundsBox.minX
				l.midY = canvasNodeBoundsBox.minY
			when 2
				l.midX = canvasNodeBoundsBox.maxX
				l.midY = canvasNodeBoundsBox.minY
			when 3
				l.midX = canvasNodeBoundsBox.minX
				l.midY = canvasNodeBoundsBox.maxY
			when 4
				l.midX = canvasNodeBoundsBox.maxX
				l.midY = canvasNodeBoundsBox.maxY

updateBounds()


# bounds boxes = 4x4 white bg 1px blue inner and centered on corners of bounds
# dimensions 3px padding sides of font (16px high - text field) - Inter 11 medium white on blue bg 2px corner radius, 6px below bounds centered


############################################
# CREATE PICKER & ALL IT'S LAYERS
############################################

Picker = new Layer
	index: 1
	x:823
	y:302
	width: 216
	height: pickerMaxHeight
	backgroundColor: "#FFF"
	clip: true
	superLayer: Figma
	borderWidth: 1
	borderColor: "#E6E6E6"

# shadow details from UI2
elevation400menuPanelShadow = 
	"0 10px 16px rgba(0,0,0,0.12), 
	0 2px 5px rgba(0,0,0,0.15), 
	0 0px 0.5px rgba(0,0,0,0.12)"

	# "0px 0px 0.5px 0px rgba(255, 255, 255, 0.30) inset, 
    # 0px 0.5px 0px 0px rgba(255, 255, 255, 0.10) inset,
    # 0px 1px 3px rgba(0, 0, 0, 0.40),
    # 0px 0px 0.5px rgba(0, 0, 0, 0.50)"
	
# /* offset-x | offset-y | blur-radius | spread-radius | color */
# must specify px for values other than color - e.g. 2px
# can add multiple by puting comma separated sets inside quotes
# Picker.style["box-shadow"] = elevation400menuPanelShadow
Picker.style["box-shadow"] = null

# Enable dragging on the picker
Picker.draggable.enabled = true
Picker.draggable.momentum = false
Picker.on Events.Drag, (e) ->
	# print Picker.x + ", " + Picker.y
	Picker.style["box-shadow"] = elevation400menuPanelShadow
	Picker.borderColor = "#E6E6E6"

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
	mouseWheelEnabled: true

ScrollChevronDown = new Layer
	width: 216
	height: 12
	superLayer: Picker
	image: "images/ScrollChevron.png"
	x: 0
	maxY: Picker.height
	opacity: 1

ScrollChevronUp = new Layer
	width: 216
	height: 12
	superLayer: Picker
	image: "images/ScrollChevron.png"
	rotation: 180
	x: 0
	minY: Fonts.y
	opacity: 0


############################################
# SHOW FONT LIST  * NOT NEEDED! *
############################################

# show fonts in normal order
toplist = new TextLayer
	x: 10
	y: 430
	fontSize: 12
	color: "#999"
	padding:
		top: 10
		left: 10
		right: 10


############################################
# BUILD FONT LIST
############################################

# trim last char off string
trimString = (str) ->
	return str.substr(0, (str.length - 1))

# Font list vars
fontItemWidth = 216
fontItemHeight = 32
fontItemBG = "#FFF"
fontItemHoverBG = "#F5F5F5"
fontItemTextColor = "black"
fontListTopPadding = 8 						# bumps whole list down from search
fontItemTextIndent = 38 					# default row left padding
fontItemTextOffset = 5 						# default yOffset value for moving up/dn
fontItemCheckPadding = 14 					# left padding for check mark
fontItemTruncation = fontItemWidth - 76		# width to truncate too + little extra for the "..."
fontHover = true
hoverDelay = 0

currentFont = "" # stupid hack because passing parameter in TweenLite.delay was always sendin 1 font.  FIGURE OUT WHY???
showFontRender = (fontItem) ->
	TweenLite.killDelayedCallsTo(showFontRender);
	canvasNode.fontFamily = Utils.loadWebFont currentFont
	updateBounds()


# Create font row layers from fontListArray
createFontList = () ->

	fontListLayer = new Layer
		backgroundColor: null
		width: fontItemWidth
		height: fontListArray.length * fontItemHeight + (fontListTopPadding * 2)
		superLayer: Fonts.content

	for font, index in fontListArray

		fontItem = new Layer
			width: fontItemWidth
			height: fontItemHeight
			superLayer: fontListLayer 
			x: 0
			y: fontListTopPadding + (index * fontItemHeight)
			backgroundColor: fontItemBG
			name: font.name

		textLayer = new TextLayer
			fontFamily: Utils.loadWebFont font.name
			fontSize: font.size
			superLayer: fontItem
			x: fontItemTextIndent + font.xOffset
			y: fontItemTextOffset + font.yOffset
			text: font.name
			color: fontItemTextColor
			letterSpacing: font.kerning

		check = new Layer
			superLayer: fontItem
			image: "images/Check.png"
			width: 16
			height: 32
			x: fontItemCheckPadding
			y: 0
			opacity: 0
			name: "checkMark"

		# check for truncation if text.width is larger than 140 (fontItemTruncation)
		if textLayer.width > fontItemTruncation
			origString = textLayer.text

			while textLayer.width > fontItemTruncation
				textLayer.text = trimString(textLayer.text)
			
			if (textLayer.text.length + 1) == origString.length
				textLayer.text = origString

			if textLayer.text.substr((textLayer.text.length - 1), (textLayer.text.length - 1)) == " "
				textLayer.text = trimString(textLayer.text)

			textLayer.text = textLayer.text + "..."

		# add events
		do (fontItem) ->
			fontItem.on Events.MouseOver, (e) ->
				fontItem.backgroundColor = fontItemHoverBG
				if fontHover
					# call to showFontRender - but hacky way to pass parameter
					currentFont = fontItem.name
					TweenLite.delayedCall(hoverDelay, showFontRender, ["fontItem", "foo"]);
			fontItem.on Events.MouseOut, (e) ->
				fontItem.backgroundColor = fontItemBG
			fontItem.on Events.Tap, (e) ->
				canvasNode.fontFamily = Utils.loadWebFont fontItem.name
				updateBounds()
		
	# change size of picker to meet shorter lists
	# make shorter
	if Picker.height > (Header.height + Search.height + fontListLayer.height)
		Picker.height = Header.height + Search.height + fontListLayer.height
		Fonts.height = Picker.height - Header.height - Search.height
		ScrollChevronDown.opacity = 0
		ScrollChevronUp.opacity = 0
	# make default size
	else if fontListLayer.height > Picker.height - Header.height - Search.height
		Picker.height = pickerMaxHeight
		Fonts.height = Picker.height - Header.height - Search.height
		ScrollChevronDown.opacity = 1
		ScrollChevronUp.opacity = 0


############################################
# FONT LIST CHEVRONS & EVENTS
############################################

# detect when youre at the top or bottom of list to hide specific chevrons
Fonts.onScroll ->
	if Fonts.content.y == -(Fonts.content.height - Fonts.height)
		print "bottom"
		ScrollChevronDown.opacity = 0
	else if Fonts.content.y == 0
		print "top"
		ScrollChevronUp.opacity = 0
	else
		ScrollChevronUp.opacity = 1
		ScrollChevronDown.opacity = 1

# events for mouse over chevrons
ScrollChevronUp.on Events.MouseOver, (e) ->
	Fonts.scrollY = 0

ScrollChevronDown.on Events.MouseOver, (e) ->
	Fonts.scrollY = Fonts.content.height - Fonts.height

# scroll.scrollY = 250
# try ^ as a way to tween to y position with tween max?
# remember to add a onComplete to hide the chevron when you hit the end


############################################
# GENERATE FONT LIST FUNCTION
############################################

generateFontList = () ->
	createFontListArray()
	createFontList()
	toplist.text = topListText


############################################
# TWEAKER FUNCTIONS
############################################

foo = new Switch
	x: 16
	y: 230
	height: 20
	width: 30
	fillColor: "#4497F7"
foo.on Events.Tap, (e) ->
	print foo.enabled
	if foo.enabled
		fontHover = true
		slider.opacity = 1
	else
		fontHover = false
		slider.opacity = 0.3
	# fontHover = !fontHover


############################################
# FONT LIST SWITCHER
############################################

switchFontList = (list) ->
	fontListData = JSON.parse Utils.domLoadDataSync "files/" + list
	Fonts.content.children[0].destroy()
	fontListArray = []
	generateFontList()


fontSetArray = [ 
	{ "set": "Figma Mix 30", "file": "fontList" },
	{ "set": "Figma Top 10 Fonts", "file": "Figma_GoogleTop10_fontList" },
	{ "set": "Google Top 10 Sans", "file": "Sans_GoogleTop10_fontList" },
	{ "set": "Google Top 10 Serif", "file": "Serif_GoogleTop10_fontList" },
	{ "set": "Google Top 10 Mono", "file": "Mono_GoogleTop10_fontList" },
	{ "set": "Google Top 10 Hand", "file": "Hand_GoogleTop10_fontList" } 
]

for item, index in fontSetArray
	fontSetButton = new Layer
		id: index
		width: 140
		height: 20
		x: 10
		y: 310 + (index * 20)
		backgroundColor: "white"
		name: item.file

	textLayer = new TextLayer
		fontFamily: Utils.loadWebFont "Inter"
		fontSize: 12
		fontStyle: "bold"
		superLayer: fontSetButton
		x: 10
		y: 2
		text: item.set
		color: "999"
	
	do (fontSetButton) ->
		fontSetButton.on Events.MouseOver, (e) ->
			fontSetButton.backgroundColor = "#ccc"
		fontSetButton.on Events.MouseOut, (e) ->
			fontSetButton.backgroundColor = "#fff"
		fontSetButton.on Events.Tap, (e) ->
			#switchFontList(item.file + ".json") # not working - LOOK INTO?
			# print item.file + ".json"
			# print fontSetButton.name
			switchFontList(fontSetButton.name + ".json")


############################################
# INIT
############################################

generateFontList()
updateBounds()


round = (number, nearest) ->
    Math.round(number / nearest) * nearest

# Create a SliderComponent  
slider = new SliderComponent
	width: 100
slider.x = 24
slider.y = 260
slider.knobSize = 16
slider.fill.backgroundColor = "#4497F7"
slider.on "change:value", ->
	val = round(this.value, 0.1)
	foo = "#{val}"
	print foo.substr(0, 3)
	hoverDelay = val

# SWITCH OPTIONS:
# Hover on/off
# Hover delay/debounce
# Alpha/Popularity sort
# Filter categories?

# TODO
# Add Sort by options - Alpha / Popularity - then get rid of text pop list
# Create Events instead of binding
# Add regions for folding
# Put in Figma app as BG
# 



# THIS IS A SECTION FOR EMITTING
# layer = new Layer
# layer2 = new Layer

# customEventName = "something"
# customEventName2 = "something bigger"

# layer.on customEventName, (argument, layer) ->
#     print "Custom event", argument, layer, customEventName

# layer2.on customEventName2, (argument, layer) ->
#     print "Custom event", argument, layer, customEventName2



# layer.emit customEventName, "down"

# layer.emit customEventName, "up"

# layer2.emit customEventName2, "up"