###
	# USING STATUSBARLAYER
	
	# Require the module
	StatusBarLayer = require "StatusBarLayer"
	
	myStatusBar = new StatusBarLayer
		# Text
		carrier: <string>
		time: <string> # if not set, will use local time
		percent: <number>
		
		# Show or hide status items
		signal: <boolean>
		wifi: <boolean>
		powered: <boolean>
		showPercentage: <boolean>
		ipod: <boolean> # also affects signal and carrier
		
		# Colors
		style: <string> ("light" || "dark")
		foregroundColor: <string> (hex or rgba)
		backgroundColor: <string> (hex or rgba)
		vibrant: <boolean>
		
		# Behavior
		hide: <boolean> # initial visibility
		autoHide: <boolean> # hide in landscape where device-appropriate
		
		# Set @1x, @2x or @3x -- usually unnecessary
		scaleFactor: <number> (1 || 2 || 3)
		
		# Simulate call
		myStatusBar.startCall(message, color) # <string>, <string> (hex or rgba)
		myStatusBar.stopCall()
		
		# Check visibility and call status
		print myStatusBar.hidden
		print myStatusBar.onCall
###

class StatusBarLayer extends Layer
	fontWeight = 400
	timeFontWeight = 500
	
	batteryGreen = "#4cd964"
	onCallColor = "#4cd964"

	constructor: (@options={}) ->
		@options.style ?= "light"
		@options.powered ?= false
		@options.carrier ?= "Carrier"
		@options.foregroundColor ?= ""
		@options.backgroundColor ?= ""
		@options.time ?= ""
		@options.percent ?= 100
		@options.showPercentage ?= true
		@options.wifi ?= true
		@options.signal ?= true
		@options.ipod ?= false
		@options.hide ?= false
		@options.autoHide ?= true
		@options.onCall ?= false
		@options.vibrant ?= false
		@options.scaleFactor ?= if _.includes(Framer.Device.deviceType, "plus") then 3 else 2
		
		@options.scaleFactor = @options.scaleFactor / 2
		super @options
		
		getTopMargin = () =>
			switch @options.scaleFactor
				when 1.5 then return 17
				when 0.5 then return -4
				else return 6
				
		getSVGFactor = () =>
			switch @options.scaleFactor
				when 1.5 then return 6
				when 0.5 then return 5
				else return 2
				
		statusBarHeight = 40 * @options.scaleFactor
		topMargin = getTopMargin()
		onCallMargin = topMargin + (39 * @options.scaleFactor)
		signalMargin = 13 * @options.scaleFactor
		carrierMargin = 9 * @options.scaleFactor
		wifiMargin = 12 * @options.scaleFactor
		powerMargin = 11 * @options.scaleFactor
		batteryMargin = 5 * @options.scaleFactor
		percentageMargin = 6 * @options.scaleFactor
		alarmMargin = 13 * @options.scaleFactor
		locationMargin = 12 * @options.scaleFactor
		ipodMargin = 12 * @options.scaleFactor
		
		@.height = statusBarHeight
		
		if @options.ipod == true
			@options.carrier = "iPod"
			@options.signal = false

		if @options.powered == true
			batteryColor = batteryGreen
		else
			batteryColor = @options.foregroundColor
		
		getBatteryLevel = (defaultBatteryWidth) =>
			percentageWidth = @options.percent / 100 * defaultBatteryWidth
			return percentageWidth

		signalSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 67 #{11 * getSVGFactor()}'><circle cx='5.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='19.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='33.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='47.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><path d='M61.5,1A4.5,4.5,0,1,1,57,5.5,4.51,4.51,0,0,1,61.5,1m0-1A5.5,5.5,0,1,0,67,5.5,5.5,5.5,0,0,0,61.5,0Z' fill='#{@options.foregroundColor}' /></svg>"	
		wifiSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 25 #{18 * getSVGFactor()}'><path d='M8.59,13.63,12.5,18l3.91-4.37a5.5,5.5,0,0,0-7.82,0Zm-4-4.47,2,2.23a8.48,8.48,0,0,1,11.82,0l2-2.23a11.46,11.46,0,0,0-15.81,0ZM12.5,0A17.42,17.42,0,0,0,.6,4.7l2,2.23a14.45,14.45,0,0,1,19.81,0l2-2.23A17.42,17.42,0,0,0,12.5,0Z' fill='#{@options.foregroundColor}' /></svg>"
		batterySVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 49 #{19 * getSVGFactor()}'><path d='M41.5,0H3.5A3.5,3.5,0,0,0,0,3.5v12A3.5,3.5,0,0,0,3.5,19h38A3.5,3.5,0,0,0,45,15.5V3.5A3.5,3.5,0,0,0,41.5,0ZM44,15.5A2.5,2.5,0,0,1,41.5,18H3.5A2.5,2.5,0,0,1,1,15.5V3.5A2.5,2.5,0,0,1,3.5,1h38A2.5,2.5,0,0,1,44,3.5Z' fill='#{@options.foregroundColor}' /><rect x='2' y='2' width='#{getBatteryLevel(41)}' height='15' rx='1.5' ry='1.5' fill='#{batteryColor}' id='batteryFill' /><path d='M46,6v7a3.28,3.28,0,0,0,3-3.5A3.28,3.28,0,0,0,46,6Z' fill='#{@options.foregroundColor}'/></svg>"
		batterySVG3x = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 73 #{29 * getSVGFactor()}'><path d='M62,0H5A5,5,0,0,0,0,5V24a5,5,0,0,0,5,5H62a5,5,0,0,0,5-5V5A5,5,0,0,0,62,0Zm4,24a4,4,0,0,1-4,4H5a4,4,0,0,1-4-4V5A4,4,0,0,1,5,1H62a4,4,0,0,1,4,4Z' fill='#{@options.foregroundColor}' /><rect x='2' y='2' width='#{getBatteryLevel(63)}' height='25' rx='3' ry='3' fill='#{batteryColor}' id='batteryFill' /><path d='M69,10.06v9.89A4.82,4.82,0,0,0,73,15,4.82,4.82,0,0,0,69,10.06Z' fill='#{@options.foregroundColor}' /></svg>"
		powerSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 11 #{19 * getSVGFactor()}'><polygon points='11 7.5 5.86 7.5 8 0 0 10.5 4.96 10.5 2 19 11 7.5' fill='#{@options.foregroundColor}' /></svg>"
		
		onCall = new Layer
			parent: @
			name: "onCall"
			height: statusBarHeight
			
		onCallMessage = new Layer
			parent: @
			name: "onCallMessage"
			y: onCallMargin
			height: statusBarHeight
			html: ""
			style: 
				"font-family" : "-apple-system, Helvetica, Arial, sans-serif"
				"font-size" : "#{18 * @options.scaleFactor}pt"
				"font-weight" : "#{fontWeight}"
				"text-align" : "center"

		carrier = new Layer
			parent: @
			name: "carrier"
			y: getTopMargin()
			height: statusBarHeight
			html: @options.carrier
			width: Utils.textsize + 0
			style: 
				"font-family" : "-apple-system, Helvetica, Arial, sans-serif"
				"font-size" : "#{18 * @options.scaleFactor}pt"
				"font-weight" : "#{fontWeight}"

		signal = new Layer
			parent: @
			name: "signal"
			width: 67 * @options.scaleFactor
			height: 11 * @options.scaleFactor
			y: Align.center
			html: signalSVG

		wifi = new Layer
			parent: @
			name: "wifi"
			y: Align.center
			width: 25 * @options.scaleFactor
			height: 18 * @options.scaleFactor
			html: wifiSVG

		getTime = () =>
			today = new Date
			day = today.getDay()
			hour = today.getHours()
			minute = today.getMinutes()
			second = today.getSeconds()
			suffix = if hour >= 12 then ' PM' else ' AM'
			hour = if hour > 12 then hour - 12 else hour
			minute = if minute < 10 then "0" + minute else minute
			if @options.time == ""
				return hour + ':' + minute + suffix
			else
				return @options.time

		time = new Layer
			parent: @
			name: "time"
			y: topMargin
			height: statusBarHeight
			html: getTime()
			style: 
				"font-family" : "-apple-system, Helvetica, Arial, sans-serif"
				"font-size" : "#{18 * @options.scaleFactor}pt"
				"font-weight" : "#{timeFontWeight}"
				"text-align" : "center"

		power = new Layer
			parent: @
			name: "power"
			y: Align.center
			width: 11 * @options.scaleFactor
			height: 19 * @options.scaleFactor
			html: powerSVG

		battery = new Layer
			parent: @
			name: "battery"
			y: Align.center
			width: 49 * @options.scaleFactor
			height: 19 * @options.scaleFactor
			html: if @options.scaleFactor == 1 then batterySVG else batterySVG3x

		percentage = new Layer
			parent: @
			name: "percentage"
			y: topMargin
			height: statusBarHeight
			html: @options.percent + "%"
			width: Utils.textsize + 0
			style: 
				"font-family" : "-apple-system, Helvetica, Arial, sans-serif"
				"font-size" : "#{18 * @options.scaleFactor}pt"
				"font-weight" : "#{fontWeight}"
				"text-align" : "right"
			
		for layer in @.subLayers
			layer.backgroundColor = "clear"

		@hide = () =>
			@options.hide = true
			@.animate
				properties:
					y: 0 - statusBarHeight
				time:
					0.25

		@show = () =>
			@options.hide = false
			@.animate
				properties:
					y: 0
				time:
					0.25

		@layout = () =>
			@.width = Screen.width
			if @options.hide == true
				@hide()
			if Framer.Device.orientation > 0 && (Screen.width == 2208 || Screen.width == 1334 || Screen.width == 1136)
				# Device is landscape iPhone
				if @options.autoHide == true
					@hide()
			else
				@show()
			# Left-side items
			if @options.carrier == ""
				carrierMargin = 0
			else
				carrierMargin = 9 * @options.scaleFactor
			if @options.signal == true
				signal.visible = true
				signal.x = signalMargin
				carrier.x = signal.x + signal.width + carrierMargin
			else
				signal.visible = false
				carrier.x = ipodMargin
			if @options.wifi == true
				wifi.visible = true
			else
				wifi.visible = false
			wifi.x = carrier.x + carrier._element.children[0].offsetWidth + wifiMargin
			# Center current time and on-call
			time.width = Screen.width
			onCall.width = Screen.width
			onCallMessage.width = Screen.width
			# Right-side items
			if @options.powered == true
				power.x = Align.right(-powerMargin)
			else
				power.x = Screen.width
				batteryMargin = if @options.scaleFactor == 1 then 10 else 16.5
			battery.x = power.x - battery.width - batteryMargin
			if @options.showPercentage == false
				percentageMargin = 0
				percentage.html = ""
			else
				percentageMargin = 6 * @options.scaleFactor
				percentage.html = @options.percent + "%"
			percentage.x = battery.x - percentage._element.children[0].offsetWidth - percentageMargin

		getTime()
		@layout()

		foregroundItems = [percentage, power, time, wifi, signal, carrier, battery]

		colorForeground = (color = @options.foregroundColor) =>
			if color == ""
				if @options.style == "dark"
					color = "white"
				else
					color = "black"
			for layer in foregroundItems
				layer.color = color
				layerSVG = layer.querySelectorAll('path, circle, rect, polygon')
				for SVG in layerSVG
					SVG.setAttribute('fill', color)

		colorBattery = () =>
			batteryFillSVG = layer.querySelectorAll('#batteryFill')
			if @options.onCall == true
				for SVG in batteryFillSVG
					SVG.style.WebkitTransition = 'all 0.25s';
					SVG.setAttribute('fill', "white")
			else if @options.powered == true
				for SVG in batteryFillSVG
					SVG.style.WebkitTransition = 'all 0.25s';
					SVG.setAttribute('fill', batteryGreen)
			else if @options.style == "dark"
				for SVG in batteryFillSVG
					SVG.style.WebkitTransition = 'all 0.25s';
					SVG.setAttribute('fill', "white")
			else
				for SVG in batteryFillSVG
					SVG.style.WebkitTransition = 'all 0.25s';
					SVG.setAttribute('fill', "black")

		styleBar = (style, backgroundColor = "") =>
			if backgroundColor == ""
				@.style =
					"-webkit-backdrop-filter": "blur(60px)"
				if style == "dark"
					@.backgroundColor = "rgba(0, 0, 0, 0.5)"
				else
					@.backgroundColor = "rgba(255, 255, 255, 0.5)"
			else
				@.backgroundColor = backgroundColor
			if @options.vibrant == true
				barColor = new Color(backgroundColor).alpha(.5)
				@.backgroundColor = barColor
				@.style =
					"-webkit-backdrop-filter": "blur(60px)"
					
						
		@applyStyle = (style = @options.style, foregroundColor = @options.foregroundColor, backgroundColor = @options.backgroundColor) =>
			if style == "light" && foregroundColor == ""
				foregroundColor = "black"
			if style == "dark" && foregroundColor == ""
				foregroundColor = "white"
			styleBar(style, backgroundColor)
			colorForeground(foregroundColor)
			colorBattery()
			
		@applyStyle()

		@startCall = (message = "Touch to return to call 0:30", color = onCallColor) =>
			@options.onCall = true
			colorForeground("white")
			colorBattery()
			onCall.animate
				properties:
					backgroundColor: color
					opacity: 1
					height: statusBarHeight * 2
				time:
					0.25
			onCall.onAnimationEnd =>
				if @options.onCall == true
					onCallMessage.html = message

		@stopCall = () =>
			@options.onCall = false
			onCallMessage.html = ""
			onCall.animate
				properties:
					opacity: 0
					height: statusBarHeight
				time:
					0.25
			@applyStyle()

		updateOrientation = (device) =>
		# Setup value to be either Framer.Device.orientation if type is "Framer"
		# Or window.orientation if device is on mobile
			value = if device is "Framer" then Framer.Device.orientation else window.orientation
			# Condition to match iOS
			# In Framer, rotating to landscape makes it a negative rotation, not positive
			# To be consistent, automatically making it set value correctly
			if value < 0 && device is "Framer"
				value = Math.abs(value)
			# Switch to check the value
			rotation = switch
				when value is 0
					deviceRotation = "Portrait"
				when value is 180
					deviceRotation = "Portrait (Upside-Down)"
				when value is -90
					deviceRotation = "Landscape (Clockwise)"
				when value is 90
					deviceRotation = "Landscape (Counterclockwise)" 
			# Set deviceOrientation as deviceRotation	
			deviceOrientation = deviceRotation
			@layout()
		# Check whether the device is mobile or not (versus Framer)
		if Utils.isMobile()
			# Set type
			device = "mobile"
			# Add event listener on orientation change
			window.addEventListener "orientationchange", -> 
				# Send event handling to function along with device type
				updateOrientation(device)
		else
			# Listen for orientation changes on the device view
			Framer.Device.on "change:orientation", ->
				# Set type
				device = "Framer"
				# Send event handling to function with device type
				updateOrientation(device)

	@define 'hidden', get: () -> @options.hide
	@define 'onCall', get: () -> @options.onCall

module.exports = StatusBarLayer