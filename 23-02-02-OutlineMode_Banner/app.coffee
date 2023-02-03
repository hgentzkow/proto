############################################
# Outline Mode Information Banner and Visual Bell
# Feb 2, 2023
############################################

# TweenLite = require "gsap/TweenLite"
TweenMax = require "gsap/TweenMax"
Expo = require "gsap/easing/EasePack"
# TimelineLite = require "gsap/TimelineLite"
# TimelineMax = require "gsap/TimelineMax"

document.body.style.cursor = "auto"

oCnt = 0
shiftTrue = false
outlineMode = false

bellTimeShort = 3
bellTimeLong = 6
bellYshift = 3

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

AppOutlineLoad = new Layer
    x: -2000
    image: "images/AppOutlineShadow.png"

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

VisBellLong = new Layer
    width: 271
    height: 68
    image: "images/VisBellLong.png"
    midX: App.midX
    y: 737
    superLayer: App
    opacity: 0

VisBellShort = new Layer
    width: 163
    height: 68
    image: "images/VisBellShort.png"
    midX: App.midX
    y: 737
    superLayer: App
    opacity: 0

VisBellOff = new Layer
    width: 163
    height: 68
    image: "images/VisBellOff.png"
    midX: App.midX
    y: 737
    superLayer: App
    opacity: 0

Shortcuts = new Layer
    width: 1297
    height: 239
    image: "images/Shortcuts.png"
    midX: App.midX
    y: 558
    opacity: 0


Shortcuts.on Events.Tap, (e) ->
    Shortcuts.opacity = 0

# 1008-1072 / 1078-1094
Banner.on Events.Tap, (e) ->
    if e.x > 1008 && e.x < 1072 && Banner.opacity != 0
        #shortcuts
        Shortcuts.opacity = 1
        Banner.opacity = 0
    else if e.x > 1078 && e.x < 1094 && Banner.opacity != 0
        #close
        Banner.opacity = 0
        Progress.height = 16 


switchModes = (e) ->

    if !outlineMode
        # print "OUTLINE MODE ON"
        App.image = "images/AppOutlineShadow.png"
        outlineMode = true
        if oCnt == 0
            TweenMax.to(Banner, 0.2, { opacity: 1, delay: 0.1 })
        else if oCnt < 4
            longBell()
        else
            shortBell()
        oCnt++
    else
        App.image = "images/AppShadow.png"
        outlineMode = false
        if oCnt == 1
            Banner.opacity = 0
        if oCnt < 5
            VisBellLong.opacity = 0
            Progress.height = 16 * oCnt
            TweenMax.killAll(true, true, true, true)
            bellsOff()
        else
            VisBellShort.opacity = 0
            TweenMax.killAll(true, true, true, true)
            bellsOff()
        

longBell = () ->
    if VisBellOff.opacity > 0
        VisBellOff.opacity = 0
        VisBellOff.y = 737
        t = 0
    else
        t = 0.2
    TweenMax.to(VisBellLong, t, { opacity: 1, y: 732 })
    TweenMax.to(VisBellLong, 0.3, { delay: bellTimeLong, opacity: 0, y: 737 })

shortBell = () ->
    if VisBellOff.opacity > 0
        VisBellOff.opacity = 0
        VisBellOff.y = 737
        t = 0
    else
        t = 0.2
    TweenMax.to(VisBellShort, t, { opacity: 1, y: 732 })
    TweenMax.to(VisBellShort, 0.3, { delay: bellTimeShort, opacity: 0, y: 737 })

bellsOff = () ->
    TweenMax.to(VisBellOff, 0, { opacity: 1, y: 732 })
    TweenMax.to(VisBellOff, 0.3, { delay: 3, opacity: 0, y: 737 })

reset = () =>
    oCnt = 0
    Progress.height = 0
    outlineMode = false
    App.image = "images/AppShadow.png"
    VisBellLong.opacity = 0

Reset.on Events.Tap, (e) ->
    reset()


# Keyboard events	
document.onkeydown = (e) ->
    # Shift down
    if e.which == 16
        shiftTrue = true
        # print "SHIFT"
								
document.onkeypress = (e) ->
    if shiftTrue && e.which == 79
        switchModes(e)

document.onkeyup = (e) ->
    # print String.fromCharCode(e.which) + " " + e.which
    # Shift up	
    if e.which == 16
        shiftTrue = false


