###
	# USING STATUSBARLAYER

	# Require the module
	StatusBarLayer = require "StatusBarLayer"

	myStatusBar = new StatusBarLayer
		# iOS version
		version: <number> (10 || 11)

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
		myStatusBar.endCall()

		# Check visibility and call status
		print myStatusBar.hidden
		print myStatusBar.onCall
###

defaults =
	style: "light"
	powered: false
	carrier: "Carrier"
	foregroundColor: ""
	backgroundColor: ""
	time: ""
	percent: 100
	showPercentage: true
	wifi: true
	signal: true
	ipod: false
	hide: false
	autoHide: true
	onCall: false
	vibrant: false
	version: 10

# iOS 11 unfilled signal bar is 25%
# iOS 11 battery stroke is 35%

class StatusBarLayer extends Layer
	fontWeight = 400
	timeFontWeight = 500

	batteryGreen = "#4cd964"
	onCallColor = "#4cd964"

	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)


		isiPhonePlus = () ->
			if _.includes(Framer.Device.deviceType, "plus")
				return true
			else
				return false

		super @options

		getTopMargin = () =>
			switch isiPhonePlus()
				when true then return 6
				else return 4

		getOnCallMargin = () =>
			switch isiPhonePlus()
				when true then return 35
				else return 38

		getBatteryMargin = () =>
			switch isiPhonePlus()
				when true then return 16.5
				else return 5.5


		statusBarHeight = 20
		topMargin = getTopMargin()
		onCallMargin = topMargin + getOnCallMargin()
		carrierMargin = 3
		signalMargin = 6.5
		carrierMargin = 4.5
		wifiMargin = if isiPhonePlus() == true then 8 else 2
		powerMargin = 5.5
		percentageMargin = 2.5
		alarmMargin = 6.5
		locationMargin = 6
		ipodMargin = 6
		baseFontSize = 13
		onCallFontSize = 13.5
		letterSpacing = if isiPhonePlus() == true then 2 else 0
		onCallLetterSpacing = 0
		onCallWordSpacing = 0

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

		signalSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 34 16'><circle cx='2.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='9.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='16.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='23.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='30.75' cy='2.75' r='2.5' stroke='#{@options.foregroundColor}' stroke-width='0.5' fill-opacity='0' class='stroked' /></svg>"
		signal_iOS11_SVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 67 32'><circle cx='5.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='19.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='33.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='47.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><path d='M61.5,1A4.5,4.5,0,1,1,57,5.5,4.51,4.51,0,0,1,61.5,1m0-1A5.5,5.5,0,1,0,67,5.5,5.5,5.5,0,0,0,61.5,0Z' fill='#{@options.foregroundColor}' /></svg>"
		wifiSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 36'><path d='M 8.085 13.63 L 11.995 18 L 15.905 13.63 C 13.752 11.454 10.238 11.454 8.085 13.63 Z M 4.085 9.16 L 6.085 11.39 C 9.376 8.192 14.614 8.192 17.905 11.39 L 19.905 9.16 C 15.479 4.943 8.521 4.943 4.095 9.16 Z M 11.995 0 C 7.576 0.001 3.322 1.681 0.095 4.7 L 2.095 6.93 C 7.659 1.691 16.341 1.691 21.905 6.93 L 23.905 4.7 C 20.676 1.678 16.418 -0.002 11.995 0 Z' fill='#{@options.foregroundColor}' /></svg>"
		batterySVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 49 32'><rect x='0.5' y='0.5'  width='44' height='18' rx='3' ry='3' stroke='#{@options.foregroundColor}' fill-opacity='0' class='stroked' /><rect x='2' y='2' width='#{getBatteryLevel(41)}' height='15' rx='1.5' ry='1.5' fill='#{batteryColor}' id='batteryFill' /><path d='M46,6v7a3.28,3.28,0,0,0,3-3.5A3.28,3.28,0,0,0,46,6Z' fill='#{@options.foregroundColor}'/></svg>"
		battery_iOS11_SVG = ""
		battery3xSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 73 29'><path d='M62,0H5A5,5,0,0,0,0,5V24a5,5,0,0,0,5,5H62a5,5,0,0,0,5-5V5A5,5,0,0,0,62,0Zm4,24a4,4,0,0,1-4,4H5a4,4,0,0,1-4-4V5A4,4,0,0,1,5,1H62a4,4,0,0,1,4,4Z' fill='#{@options.foregroundColor}' /><rect x='2' y='2' width='#{getBatteryLevel(63)}' height='25' rx='3' ry='3' fill='#{batteryColor}' id='batteryFill' /><path d='M69,10.06v9.89A4.82,4.82,0,0,0,73,15,4.82,4.82,0,0,0,69,10.06Z' fill='#{@options.foregroundColor}' /></svg>"
		battery3x_iOS11_SVG = ""
		powerSVG = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 6 17'><polygon points='6 3.75 3.43 3.75 4.5 0 0.5 5.25 2.98 5.25 1.5 9.5 6 3.75' fill='#{@options.foregroundColor}' /></svg>"

		onCallBlock = new Layer
			parent: @
			name: "onCallBlock"
			height: statusBarHeight

		@.onCallBlock = onCallBlock

		onCallMessage = new TextLayer
			parent: @
			name: "onCallMessage"
			padding:
				top: onCallMargin
			text: ""
			fontSize: onCallFontSize
			fontWeight: fontWeight
			textAlign: "center"
			color: "white"
			letterSpacing: onCallLetterSpacing
			wordSpacing: onCallWordSpacing

		@.onCallMessage = onCallMessage

		carrier = new TextLayer
			parent: @
			name: "carrier"
			padding:
				top: getTopMargin()
			text: @options.carrier
			fontSize: baseFontSize
			fontWeight: fontWeight
			letterSpacing: letterSpacing

		@.carrier = carrier

		signal = new Layer
			parent: @
			name: "signal"
			width: 34
			height: 6
			y: Align.center
			html: if @options.version < 11 then signalSVG else signal_iOS11_SVG

		@.signal = signal

		wifi = new Layer
			parent: @
			name: "wifi"
			y: Align.center
			width: 13
			height: 9
			html: wifiSVG

		@.wifi = wifi

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

		time = new TextLayer
			parent: @
			name: "time"
			width: @.width
			padding:
				top: getTopMargin()
			text: getTime()
			fontSize: baseFontSize
			fontWeight: timeFontWeight
			textAlign: "center"
			letterSpacing: letterSpacing

		@.time = time

		power = new Layer
			parent: @
			name: "power"
			y: Align.center
			width: 5.5
			height: 9.5
			html: powerSVG

		@.power = power

		battery = new Layer
			parent: @
			name: "battery"
			y: Align.center
			width: 24.5
			height: 10
			html: if isiPhonePlus() == true then battery3xSVG else batterySVG

		@.battery = battery

		percentage = new TextLayer
			parent: @
			name: "percentage"
			padding:
				top: getTopMargin()
			text: @options.percent + "%"
			fontSize: baseFontSize
			fontWeight: fontWeight
			textAlign: "right"
			letterSpacing: letterSpacing

		@.percentage = percentage

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
			wifi.x = carrier.x + carrier.width + wifiMargin
			# Center current time and on-call
			time.width = Screen.width
			onCallBlock.width = Screen.width
			onCallMessage.width = Screen.width
			# Right-side items
			if @options.powered == true
				power.x = Align.right(-powerMargin)
			else
				power.x = Screen.width
			battery.x = power.x - battery.width - getBatteryMargin()
			if @options.showPercentage == false
				percentageMargin = 0
				percentage.text = ""
			else
				percentage.text = @options.percent + "%"
			percentage.maxX = battery.x - percentageMargin

		getTime()
		@layout()

		foregroundItems = [percentage, power, time, wifi, signal, carrier, battery]

		selectForegroundColor = () =>
			if @options.foregroundColor == ""
				if @options.style == "dark"
					return "white"
				else
					return "black"
			else
				return @options.foregroundColor

		colorForeground = (color = "") =>
			if color == "" then color = selectForegroundColor()
			for layer in foregroundItems
				layer.color = color
				layerSVG = layer.querySelectorAll('path, circle, rect, polygon')
				strokedSVG = layer.querySelectorAll('.stroked')
				for SVG in layerSVG
					SVG.setAttribute('fill', color)
				for SVG in strokedSVG
					SVG.setAttribute('stroke', color)
					SVG.setAttribute('fill-opacity', '0')

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
			else
				for SVG in batteryFillSVG
					SVG.style.WebkitTransition = 'all 0.25s';
					SVG.setAttribute('fill', selectForegroundColor())

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
			colorForeground()
			colorBattery()

		@applyStyle()

		@startCall = (message = "Touch to return to call 0:30", color = onCallColor) =>
			@options.onCall = true
			colorForeground("white")
			colorBattery()
			onCallBlock.animate
				properties:
					backgroundColor: color
					opacity: 1
					height: statusBarHeight * 2
				time:
					0.25
			onCallBlock.onAnimationEnd =>
				if @options.onCall == true
					onCallMessage.text = message

		@endCall = () =>
			@options.onCall = false
			onCallMessage.text = ""
			onCallBlock.animate
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
