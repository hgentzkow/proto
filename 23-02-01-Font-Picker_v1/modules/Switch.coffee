class exports.Switch extends Layer
	constructor: (options = {}) ->
		super(options)
		@backgroundColor = null
		@enabled = options.enabled ? true
		@fillColor = options.fillColor ? "#FF7600"
		@height = 31
		@width = 51

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
		


		