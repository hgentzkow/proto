############################################
# Outline Mode Information Banner and Visual Bell
# Feb 2, 2023
############################################

# Require input module
{InputLayer} = require "input"

document.body.style.cursor = "auto"

oCnt = 0
shiftTrue = false
outlineMode = false

bellTimeShort = 3
bellTimeLong = 10

############################################
# Core
############################################

Base = new Layer
	width: 1920
	height: 1080
	backgroundColor: "#F0F0F0"
	borderRadius: 0
	clip: true

App = new Layer
    width: 1407
    height: 871
    image: "images/AppShadow.png"

Instructions = new Layer
    width: 210
    height: 152
    image: "images/Instructions.png"
    x: 74
    y: 226
    superLayer: App

Reset = new Layer
    width: 57
    height: 32
    image: "images/Button.png"
    x: 74
    y: 384
    superLayer: App

Progress = new Layer
    x: 73
    y: 288
    backgroundColor: "white"
    width: 10
    height: 0
    opacity: 0.75
    superLayer: App

Banner = new Layer
    width: 813
    height: 40
    image: "images/InfoBanner.png"
    x: 297 
    y: 124
    superLayer: App
    opacity: 0

VisBell = new Layer
    width: 271
    height: 68
    image: "images/VisBell.png"
    x: 584
    y: 737
    superLayer: App
    opacity: 0

Banner.on Events.Tap, (e) ->
    if Banner.opacity = 1
        Banner.opacity = 0
        Progress.height = 16

switchModes = (e) ->

    if !outlineMode && shiftTrue && e.which == 79
        # print "OUTLINE MODE ON"
        App.image = "images/AppOutlineShadow.png"
        outlineMode = true
        if oCnt == 0
            Utils.delay 0.1, ->
                Banner.animate
                    opacity: 1
                    options:
                        time: 0.2
        else if oCnt < 5
            toggleBell(bellTimeLong)
        else
            toggleBell(bellTimeShort)
        oCnt++
    else
        if oCnt < 5
            Progress.height = 16 * oCnt
        App.image = "images/AppShadow.png"
        outlineMode = false
        Banner.opacity = 0
        bellOff()


toggleBell = (t) ->
    VisBell.animate
            opacity: 1
            options:
                time: 0.2
    Utils.delay t, ->
        bellOff()

bellOff = () ->
    VisBell.animate
        opacity: 0
        options:
            time: 0.2

reset = () =>
    oCnt = 0
    Progress.height = 0
    outlineMode = false
    App.image = "images/AppShadow.png"
    VisBell.opacity = 0

Reset.on Events.Tap, (e) ->
    reset()

# Keyboard methods	
document.onkeydown = (e) ->

    # Shift down
    if e.which == 16
        shiftTrue = true
        # print "SHIFT"
								
document.onkeypress = (e) ->
	
    switchModes(e)

					
document.onkeyup = (e) ->

    # print String.fromCharCode(e.which) + " " + e.which

    # Shift up	
    if e.which == 16
        shiftTrue = false