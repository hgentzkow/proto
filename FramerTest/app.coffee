
FABmidX = Screen.midX


FAB.states.add
	idle:
		width: 64
		height: 64
		borderRadius: 32
		x: Screen.midX - 32
		y: 667
		shadowY: 20
	listening:
		width: Screen.width
		height: 300
		maxY: Screen.height
		x: 0
		borderRadius: 20
		midX: Screen.midX
		shadowY: -2

isOpen = false

FAB.onTap (event, layer) ->
	if !isOpen
		FAB.animate("listening")
		isOpen = !isOpen
	else
		FAB.animate("idle")
		isOpen = !isOpen




FAB1.states.add
	idle:
		width: 164
		height: 164
		borderRadius: 150
		x: Screen.midX - 32
		y: 300
		shadowY: 20
	listening:
		width: Screen.width
		height: 300
		minY: 0
		x: 0
		borderRadius: 0
		midX: Screen.midX
		shadowY: 2

isOpen2 = false

FAB1.onTap (event, layer) ->
	if !isOpen2
		FAB1.animate("listening")
		isOpen2 = !isOpen2
	else
		FAB1.animate("idle")
		isOpen2 = !isOpen2

layerA = new Layer
    width: 100, height: 80
    x: 120, y: 300

layerA.backgroundColor = "red"
layerA.borderRadius = 5
layerA.opacity = 0.8
# layerA.parent = __layer_0__
FAB1.bringToFront()
print FAB1.parent
print layerA.parent