############################################
# Font Picker ##############################
# February, 2023 ###########################
############################################

# Set cursor type (look up all others!!!)
document.body.style.cursor = "pointer"
# disable hints
Framer.Extras.Hints.disable()



# Layer::createChildrenRefs
#   Creates convenience refs on targetd layers from the design tab so that we don't have to use Layer::childrenWithName.
#   Pass recursive=true to do this for all descendant layers while maintaining hierarchy.
Layer::createChildrenRefs = (recursive=false) ->
	
	for layer in @children
		
		# Get layer name for the key
		key = layer.name
		
		# Set reference
		@[key] = layer
		
		# Should we also do this for current layer's children?
		if recursive and layer.children.length > 0
			layer.createChildrenRefs(recursive)






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
		@height = 20
		@width = 30

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
	# topListText = ""

	for i in [0...fontListData.fonts.length]

		# generate text string of fonts in their order
		# topListText = topListText + ((i + 1) + ". " + fontListData.fonts[i].name) + "\n" # X345

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
	
Canvas = new Layer
	x: 0
	y: 0
	width: 1280
	height: 910
	backgroundColor: "red"
	opacity: 0
	superLayer: Figma

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


previewFontSetMenuY = 7
selectedFontSetMenuY = 7

############################################
# CREATE PICKER & ALL IT'S LAYERS
############################################

pickerOpen = false
pickerDragged = false
selectedFontMenuName = "Top Design fonts"
showPicker = (bool) ->
	if bool
		pickerOpen = true
		Picker.x = 823
		Picker.y = 302
		# Scroll to currently selected font in list after opening
		if fontListLayerHolder != ""
			for child, i in fontListLayerHolder.subLayers
				if child.name == selectedFont
					scrollToSelectedFont(child)
		FontSetMenuName.text = selectedFontMenuName


	else
		pickerOpen = false
		Picker.x = -1000
		Picker.y = -1000
		entryButton.backgroundColor = "white"
		pickerDragged = false
		fontSetMenu.y = -1000
		FontSetMenuName.text = selectedFontMenuName


		# print "close picker - selectedFontSetMenuY= " + selectedFontSetMenuY # MENU DISCREPENCY BUG
		# print "close picker - previewFontSetMenuY= " + previewFontSetMenuY # MENU DISCREPENCY BUG
		if previewFontSetMenuY != selectedFontSetMenuY
			previewFontSetMenuY = selectedFontSetMenuY
			# print "close picker changed - previewFontSetMenuY= " + previewFontSetMenuY # MENU DISCREPENCY BUG
			

		# SHOULD THE PICKER SHOW THE LIST THE CURRENT SELECTED FONT IS IN EVEN IF YOU
		# PREVIEWED A DIFFERENT SET PRIOR TO CLOSING PICKER (not selecting)?
		# THIS IS A DESIGN DECISION!
		# IF YOU KEEP THIS< ALSO REMEMBER TO RESET THE FONT SET MENU
		if previewedFontSet != selectedFontSet
			switchFontList(selectedFontSet)



Picker = new Layer
	index: 1
	x:-1000
	y:-1000
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
	
# /* offset-x | offset-y | blur-radius | spread-radius | color */
# must specify px for values other than color - e.g. 2px
# can add multiple by puting comma separated sets inside quotes
# Picker.style["box-shadow"] = elevation400menuPanelShadow
Picker.style["box-shadow"] = elevation400menuPanelShadow

# Enable dragging on the picker
Picker.draggable.enabled = true
Picker.draggable.momentum = false
Picker.on Events.Drag, (e) ->
	pickerDragged = true
	# Picker.style["box-shadow"] = elevation400menuPanelShadow
	Picker.borderColor = "#E6E6E6"
	Picker.bringToFront()
	fontSetMenu.y = -1000

Header = new Layer
	width: 216
	height: 40
	superLayer: Picker
	image: "images/Header.png"
	x: 0
	y: 0
	opacity: 1

CloseX = new Layer
	x: 180
	y: 5
	width: 32
	height: 32
	superLayer: Header
	image: "images/X.png"
	opacity: 1

Search = new Layer
	width: 216
	height: 42
	superLayer: Picker
	image: "images/Search.png"
	x: 0
	y: 40
	opacity: 1

SearchCursor = new Layer 
	width: 1.5
	height: 13
	backgroundColor: "black"
	x: 37
	y: 14.5
	superLayer: Search

TweenMax.to(SearchCursor, 1, {opacity: 0, repeat:-1})

FontSets = new Layer
	width: 216
	height: 38
	superLayer: Picker
	backgroundColor: "white"
	x: 0
	y: 82
	opacity: 1

FontSetMenuName = new TextLayer
	text: "Top Design fonts"
	x: 16
	y: 14
	fontSize: 10
	fontFamily: Utils.loadWebFont "Inter"
	fontWeight: 500
	color: "black"
	superLayer: FontSets

FontSetsMenuChevron = new Layer
	width: 8
	height: 5.5
	superLayer: FontSets
	image: "images/MenuChevron.png"
	x: 100
	y: 18
	opacity: 0.3

FontSetMenuHover = new Layer 
	width: 200
	height: 30
	x: 8
	y: 4
	borderColor: "#E3E3E3"
	borderWidth: 1
	borderRadius: 2
	backgroundColor: null
	superLayer: FontSets
	opacity: 0


FontSetLine = new Layer
	width: 216
	height: 1
	backgroundColor: "#E6E6E6"
	superLayer: FontSets
	y: 37


FontSets.on Events.MouseOver, (e) ->
	FontSetMenuHover.opacity = 1
	FontSetsMenuChevron.opacity = 1
	FontSetsMenuChevron.x = FontSetMenuHover.maxX - 16

FontSets.on Events.MouseOut, (e) ->
	FontSetMenuHover.opacity = 0
	FontSetsMenuChevron.opacity = 0.3
	alignnChevron()

FontSets.on Events.Tap, (e) ->
	fontSetMenu.x = Picker.x + 8
	fontSetMenu.y = Picker.y + 90 - previewFontSetMenuY
	# print "fontSets Open - previewFontSetMenuY = " + previewFontSetMenuY # MENU DISCREPENCY BUG

alignnChevron = () ->
	FontSetsMenuChevron.x = FontSetMenuName.width + 20


# Font list scroll
Fonts = new ScrollComponent
	width: 216
	height: Picker.height - Header.height - Search.height - FontSets.height
	superLayer: Picker
	x: 0
	y: FontSets.maxY
	clip: true
	mouseWheelEnabled: true





# ScrollChevronDown = new Layer
# 	width: 216
# 	height: 12
# 	superLayer: Picker
# 	image: "images/ScrollChevron.png"
# 	x: 0
# 	maxY: Picker.height
# 	opacity: 1

# ScrollChevronUp = new Layer
# 	width: 216
# 	height: 12
# 	superLayer: Picker
# 	image: "images/ScrollChevron.png"
# 	rotation: 180
# 	x: 0
# 	minY: Fonts.y
# 	opacity: 0


# ############################################
# # SHOW FONT LIST  * NOT NEEDED! * X345
# ############################################

# # show fonts in normal order
# toplist = new TextLayer
# 	x: 10
# 	y: 430
# 	fontSize: 12
# 	color: "#999"
# 	padding:
# 		top: 10
# 		left: 10
# 		right: 10


############################################
# BUILD FONT LIST
############################################

# trim last char off string
trimString = (str) ->
	return str.substr(0, (str.length - 1))

# Font list vars
fontItemWidth = 216
fontItemHeight = 28 # changed when testing fontlist16.json
fontItemBG = "#FFF"
fontItemHoverBG = "#F5F5F5"
fontItemTextColor = "black"
fontListTopPadding = 8 						# bumps whole list down from search
fontItemTextIndent = 38 					# default row left padding
fontItemTextOffset = 3 #5 						# default yOffset value for moving up/dn
fontItemCheckPadding = 14 					# left padding for check mark
fontItemTruncation = fontItemWidth - 76		# width to truncate too + little extra for the "..."
fontHover = true
hoverDelay = 0

currentFont = "" # stupid hack because passing parameter in TweenLite.delay was always sendin 1 font.  FIGURE OUT WHY???
showFontRender = (fontItem) ->
	TweenLite.killDelayedCallsTo(showFontRender);
	canvasNode.fontFamily = Utils.loadWebFont currentFont
	updateBounds()


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
			fontSize: font.size - 2
			superLayer: fontItem
			x: fontItemTextIndent + font.xOffset
			y: fontItemTextOffset + font.yOffset
			text: font.name
			color: fontItemTextColor
			letterSpacing: font.kerning
			name: "fontItemText"

		check = new Layer
			superLayer: fontItem
			image: "images/Check28.png"
			width: 16
			height: 28
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

		# create references for all child layers to have easy access later (like in the Tap event below)
		fontItem.createChildrenRefs()  # custom function at the top

		# add events
		do (fontItem) ->
			fontItem.on Events.MouseOver, (e) ->
				if this.name != selectedFont
					fontItem.backgroundColor = fontItemHoverBG
				if fontHover
					# call to showFontRender - but hacky way to pass parameter
					currentFont = fontItem.name
					TweenLite.delayedCall(hoverDelay, showFontRender, ["fontItem", "foo"]);
			fontItem.on Events.MouseOut, (e) ->
				if this.name != selectedFont
					fontItem.backgroundColor = fontItemBG
			fontItem.on Events.Tap, (e) ->
				canvasNode.fontFamily = Utils.loadWebFont fontItem.name
				updateBounds()
				selectFont(this, this.parent)
				if !pickerDragged
					showPicker(false)
		
		if fontItem.name == selectedFont
			setFontSelected(fontItem)
			scrollToSelectedFont(fontItem)


		
	# change size of picker to meet shorter lists - DO WE WANT THIS???  MAKE TWEAKER???
	# make shorter
	# if Picker.height > (Header.height + Search.height + fontListLayer.height)
	# 	Picker.height = Header.height + Search.height + fontListLayer.height
	# 	Fonts.height = Picker.height - Header.height - Search.height
		# ScrollChevronDown.opacity = 0
		# ScrollChevronUp.opacity = 0
	# make default size
	# else if fontListLayer.height > Picker.height - Header.height - Search.height
	# 	Picker.height = pickerMaxHeight
	# 	Fonts.height = Picker.height - Header.height - Search.height
		# ScrollChevronDown.opacity = 1
		# ScrollChevronUp.opacity = 0






############################################
# FONT SELECTOR
############################################

selectedFont = "Inter" # QUICK N DIRTY hack to keep state of currently selected font
selectedFontSet = "fontList" 
previewedFontSet = "fontList"
fontListLayerHolder = "" # to capture the fontListLayer layer for use in showPicker()

selectFont = (fontItem, fontListLayer) ->
	selectedFont = fontItem.name
	selectedFontSet = previewedFontSet
	for child, i in fontListLayer.subLayers
		deselectFont(child)
	setFontSelected(fontItem)

	entryText.font = fontItem.fontItemText.fontFamily
	entryText.text = fontItem.name
	fontListLayerHolder = fontListLayer

	# for resetting menu position if you close when not on the list that has the sected font.  
	# PART OF THE SHOWPICKER DESIGN DECISION!
	selectedFontSetMenuY = previewFontSetMenuY
	# print "selectFont - previewFontSetMenuY= " + previewFontSetMenuY # MENU DISCREPENCY BUG
	selectedFontMenuName = FontSetMenuName.text







deselectFont = (fontItem) ->
	fontItem.checkMark.opacity = 0
	fontItem.backgroundColor = fontItemBG

setFontSelected = (fontItem) ->
	fontItem.checkMark.opacity = 1
	fontItem.backgroundColor = "#E5F4FF"

scrollToSelectedFont = (fontItem) ->
	Fonts.scrollY = fontItem.y - fontListTopPadding


# ********************************************************

# HACKY FONT LIST SWITCHER FOR TESTING
############################################

switchFontList = (list) ->
	fontListData = JSON.parse Utils.domLoadDataSync "files/" + list + ".json"
	Fonts.content.children[0].destroy()
	fontListArray = []
	previewedFontSet = list
	generateFontList()



# fontChange = new Layer
# 	x: 10
# 	y: 10

# fontChange.on Events.Tap, (e) ->
# 	switchFontList("Sans_GoogleTop10_fontList.json")

# fontChange2 = new Layer
# 	x: 240
# 	y: 10

# fontChange2.on Events.Tap, (e) ->
# 	switchFontList("fontList.json")

# ********************************************************
# UI Entry Button + Events

entryButton = new Layer
	x: 1047
	y: 345
	width: 224
	height: 32
	borderRadius: 2
	backgroundColor: "white"
	opacity: 1
	superLayer: Figma



entryText = new TextLayer
	text: "Inter"
	parent: entryButton
	x: 10
	y: 6
	color: "black"
	fontSize: 15
	fontFamily: Utils.loadWebFont "Inter"

entryButton.on Events.MouseOver, (e) ->
	this.backgroundColor = "#F5F5F5"

entryButton.on Events.MouseOut, (e) ->
	if !pickerOpen
		this.backgroundColor = "white"

entryButton.on Events.Tap, (e) ->
	if !pickerOpen
		showPicker(true)
	else
		showPicker(false)


# ********************************************************
# Close Picker when you click the canvas or UI

Canvas.on Events.Tap, (e) ->
	if pickerOpen
		showPicker(false)



# ********************************************************
# Close Picker when X is clicked

CloseX.on Events.Tap, (e) ->
	showPicker(false)





# ********************************************************
# Menu

fontSetMenu = new Layer
	x: -1000
	y: -1000
	backgroundColor: "#1E1E1E"
	borderRadius: 2


fontSetMenu.style["box-shadow"] = elevation400menuPanelShadow

fontSetMenuArray = [
	{ "set": "Top Design fonts", "file": "fontList" },
	{ "set": "Web fonts", "file": "Figma_GoogleTop10_fontList" },
	{ "set": "Variable fonts", "file": "Sans_GoogleTop10_fontList" },
	{ "set": "Local fonts", "file": "Serif_GoogleTop10_fontList" },
	{ "set": "div", "file": "div" },
	{ "set": "All fonts", "file": "Mono_GoogleTop10_fontList" }
]


fontSetMenuHeightTracker = 7


for item, index in fontSetMenuArray

	if item.set != "div"
		menuItem = new Layer
			width: 200
			height: 22
			superLayer: fontSetMenu
			x: 0
			y: fontSetMenuHeightTracker
			backgroundColor: null
			name: item.file
			file: item.file
		
		menuText = new TextLayer
			text: item.set
			x: 32
			y: 4
			fontSize: 11
			fontFamily: Utils.loadWebFont "Inter"
			color: "white"
			superLayer: menuItem
		
		fontSetMenuHeightTracker = menuItem.maxY
		
		do (menuItem, item) ->
				menuItem.on Events.MouseOver, (e) ->
					this.backgroundColor = "#0D99FF"
				menuItem.on Events.MouseOut, (e) ->
					this.backgroundColor = null
				menuItem.on Events.Tap, (e) ->
					switchFontList(menuItem.name)
					FontSetMenuName.text = item.set
					previewFontSetMenuY = this.y
					# print "menuItem click - previewFontSetMenuY = " + previewFontSetMenuY # MENU DISCREPENCY BUG
					fontSetMenu.y = -1000
					alignnChevron()

	else
		divider = new Layer
			width: 200
			height: 16
			superLayer: fontSetMenu
			x: 0
			y: fontSetMenuHeightTracker
			backgroundColor: null
		
		line = new Layer
			width: 200
			height: 1
			backgroundColor: "#383838"
			superLayer: divider
			y: 8
		
		fontSetMenuHeightTracker = fontSetMenuHeightTracker + 16

fontSetMenu.height = fontSetMenuHeightTracker + 7





############################################
# FONT LIST CHEVRONS & EVENTS
############################################

# detect when youre at the top or bottom of list to hide specific chevrons
# Fonts.onScroll ->
# 	if Fonts.content.y == -(Fonts.content.height - Fonts.height)
# 		print "bottom"
# 		ScrollChevronDown.opacity = 0
# 	else if Fonts.content.y == 0
# 		print "top"
# 		ScrollChevronUp.opacity = 0
# 	else
# 		ScrollChevronUp.opacity = 1
# 		ScrollChevronDown.opacity = 1

# # events for mouse over chevrons
# ScrollChevronUp.on Events.MouseOver, (e) ->
# 	Fonts.scrollY = 0

# ScrollChevronDown.on Events.MouseOver, (e) ->
# 	Fonts.scrollY = Fonts.content.height - Fonts.height

# scroll.scrollY = 250
# try ^ as a way to tween to y position with tween max?
# remember to add a onComplete to hide the chevron when you hit the end


############################################
# GENERATE FONT LIST FUNCTION 
############################################

generateFontList = () ->
	createFontListArray()
	createFontList()
	# toplist.text = topListText # X345





############################################
# FONT LIST SWITCHER - X345
############################################

# switchFontList = (list) ->
# 	fontListData = JSON.parse Utils.domLoadDataSync "files/" + list
# 	Fonts.content.children[0].destroy()
# 	fontListArray = []
# 	generateFontList()


# fontSetArray = [ 
# 	{ "set": "Figma Mix 30", "file": "fontList" },
# 	{ "set": "Figma Top 10 Fonts", "file": "Figma_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Sans", "file": "Sans_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Serif", "file": "Serif_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Mono", "file": "Mono_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Hand", "file": "Hand_GoogleTop10_fontList" } 
# ]

# for item, index in fontSetArray
# 	fontSetButton = new Layer
# 		id: index
# 		width: 140
# 		height: 20
# 		x: 10
# 		y: 310 + (index * 20)
# 		backgroundColor: "white"
# 		name: item.file

# 	textLayer = new TextLayer
# 		fontFamily: Utils.loadWebFont "Inter"
# 		fontSize: 12
# 		fontStyle: "bold"
# 		superLayer: fontSetButton
# 		x: 10
# 		y: 2
# 		text: item.set
# 		color: "999"
	
# 	do (fontSetButton) ->
# 		fontSetButton.on Events.MouseOver, (e) ->
# 			fontSetButton.backgroundColor = "#ccc"
# 		fontSetButton.on Events.MouseOut, (e) ->
# 			fontSetButton.backgroundColor = "#fff"
# 		fontSetButton.on Events.Tap, (e) ->
# 			#switchFontList(item.file + ".json") # not working - LOOK INTO?
# 			# print item.file + ".json"
# 			# print fontSetButton.name
# 			switchFontList(fontSetButton.name + ".json")


############################################
# INIT
############################################

generateFontList() 
updateBounds()




############################################
# TWEAKER FUNCTIONS
############################################

hoverSwitch = new Switch
	x: 16
	y: 245
	fillColor: "#4497F7"
hoverSwitch.on Events.Tap, (e) ->
	if hoverSwitch.enabled
		fontHover = true
		hoverDelayslider.opacity = 1
		hoverDelayTimeLabel.opacity = 1
	else
		fontHover = false
		hoverDelayslider.opacity = 0.3
		hoverDelayTimeLabel.opacity = 0.3
	# fontHover = !fontHover

hoverOptionLabel = new TextLayer
	text: "Canvas Hover Preview (w/delay)"
	x: 16
	y: 225
	fontSize: 11
	fontWeight: "bold"
	fontFamily: Utils.loadWebFont "Inter"
	color: "black"


#*********************************
# Hover Slider

round = (number, nearest) ->
    Math.round(number / nearest) * nearest

# Create a SliderComponent  
hoverDelayslider = new SliderComponent
	width: 100
	x: 68
	y: 250

hoverDelayslider.knobSize = 16
hoverDelayslider.fill.backgroundColor = "#4497F7"
hoverDelayslider.on "change:value", ->
	val = round(this.value, 0.1)
	val = "#{val}"
	hoverDelayTimeLabel.text = val.substr(0, 3) + "s"
	hoverDelay = val

hoverDelayTimeLabel = new TextLayer
	text: "0s"
	x: 180
	y: 249
	fontSize: 11
	fontWeight: "bold"
	fontFamily: Utils.loadWebFont "Inter"
	color: "black"

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



# fontSetArray = [ 
# 	{ "set": "Figma Mix 30", "file": "fontList" },
# 	{ "set": "Figma Top 10 Fonts", "file": "Figma_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Sans", "file": "Sans_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Serif", "file": "Serif_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Mono", "file": "Mono_GoogleTop10_fontList" },
# 	{ "set": "Google Top 10 Hand", "file": "Hand_GoogleTop10_fontList" } 
# ]



