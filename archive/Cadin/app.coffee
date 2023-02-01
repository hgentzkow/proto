Base = new Layer
	index: 1
	x:0
	y:0
	width: window.innerWidth
	height: window.innerHeight
	backgroundColor: "#FFF"

cadin = new Layer
	image: "images/cadin.png"
	width: 200
	height: 200
	x: 85
	y: 100
	parent: Base

spin = new Animation(cadin, {
    rotation: 360
    options: {curve: Bezier(0.25, 0.1, 0.25, 1), repeat: 5, delay: 2, time: 1}
})
spin.start()

message = new TextLayer
	fontFamily: Utils.loadWebFont "Permanent Marker"
	x: 46
	y: 300
	text: "I'm back baby!!!"
	color: "black"
	parent: Base

flash = new Animation(message, {
    opacity: 0
    options: {curve: Bezier(0.25, 0.1, 0.25, 1), repeat: 5, delay: 1, time: 1}
})
flash.start()