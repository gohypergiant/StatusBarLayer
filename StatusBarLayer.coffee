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
	version: 11

# iOS 11 unfilled signal bar is 25%
# iOS 11 battery stroke is 35%

class StatusBarLayer extends Layer

	batteryGreen = "#4cd964"
	onCallColor = "#4cd964"

	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)

		super @options

		@.isHidden = @options.hide

		isiPhone = () ->
			if _.includes(Framer.Device.deviceType, "iphone")
				return true
			else
				return false

		isiPhonePlus = () ->
			if _.includes(Framer.Device.deviceType, "plus")
				return true
			else
				return false

		getBatteryMargin = () =>
			if @options.powered == false
				if isiPhonePlus() and @options.version > 10
					return 5
				else
					return 5.5
			else
				return 2.5

		getBatteryWidth = () =>
			if @options.version > 10 and isiPhonePlus()
				return 26
			else if @options.version > 10
				return 26.5
			else
				return 24.5

		getBatterySVG = () =>
			size = if isiPhonePlus() then "at3x" else "at2x"
			return svg["battery"]["v" + @options.version][size]

		getSignalSVG = () =>
			size = if isiPhonePlus() then "at3x" else "at2x"
			return svg["signal"]["v" + @options.version][size]

		getScreenWidth = () ->
			if _.includes(Framer.Device.deviceType, "apple")
				orientation = 0
				if Utils.isMobile()
					orientation = window.orientation
				else
					orientation = Math.abs(Framer.Device.orientation)
				if orientation == 0
					return Math.min(Screen.width, Screen.height)
				else
					return Math.max(Screen.width, Screen.height)
			else
				return Screen.width

		topMargin = 3
		onCallMargin = 18
		statusBarHeight = 20
		onCallMargin = topMargin + onCallMargin
		carrierMargin = 4.5
		signalMargin = if isiPhonePlus() then 6 else 6.5
		wifiMargin = 4
		powerMargin = 5.5
		percentageMargin = 2.5
		alarmMargin = 6.5
		locationMargin = 6
		ipodMargin = 6
		baseFontSize = 12
		onCallFontSize = 13.5
		letterSpacing = 0
		timeLetterSpacing = if isiPhonePlus() then 1 else 0
		onCallLetterSpacing = 0
		onCallWordSpacing = 0
		fontWeight = if isiPhonePlus() then 300 else 400
		timeFontWeight = 500

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
			percentageWidth = Math.round(percentageWidth)
			return percentageWidth

		appleSVGCSS = """
			.svgFit {
			  object-fit: contain;
			  width: 100%;
			  height: 100%;
			  max-width: 100%;
			  max-height: 100%;
			}
			"""

		canvasSVGCSS = """
			.svgFit {
			  object-fit: contain;
			  width: 100%;
			  max-width: 100%;
			  position: absolute;
			  top: 0;
			}
			"""
		svgCSS = if _.includes(Framer.Device.deviceType, "apple") then appleSVGCSS else canvasSVGCSS
		
		Utils.insertCSS(svgCSS)
		signal_v10_2x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 34 16'><circle cx='2.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='9.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='16.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='23.75' cy='2.75' r='2.75' fill='#{@options.foregroundColor}' /><circle cx='30.75' cy='2.75' r='2.5' stroke='#{@options.foregroundColor}' stroke-width='0.5' fill-opacity='0' class='stroked' /></svg>"
		signal_v11_2x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 33 33'><rect x='0' y='11' width='6' height='9' rx='2' fill='#{@options.foregroundColor}' /><rect x='9' y='8' width='6' height='12' rx='2' fill='#{@options.foregroundColor}' /><rect x='18' y='4' width='6' height='16' rx='2' fill='#{@options.foregroundColor}' /><rect x='27' y='0' width='6' height='20' rx='2' fill='#{@options.foregroundColor}' /></svg>"
		signal_v10_3x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 67 32'><circle cx='5.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='19.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='33.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><circle cx='47.5' cy='5.5' r='5.5' fill='#{@options.foregroundColor}' /><path d='M61.5,1A4.5,4.5,0,1,1,57,5.5,4.51,4.51,0,0,1,61.5,1m0-1A5.5,5.5,0,1,0,67,5.5,5.5,5.5,0,0,0,61.5,0Z' fill='#{@options.foregroundColor}' /></svg>"
		signal_v11_3x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 49.5 60'><rect x='0' y='17' width='9' height='13' rx='3' fill='#{@options.foregroundColor}' /><rect x='13' y='12' width='9' height='18' rx='3' fill='#{@options.foregroundColor}' /><rect x='26' y='6' width='9' height='24' rx='3' fill='#{@options.foregroundColor}' /><rect x='39' y='0' width='9' height='30' rx='3' fill='#{@options.foregroundColor}' /></svg>"
		wifiSVG = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 24 36'><path d='M 8.085 13.63 L 11.995 18 L 15.905 13.63 C 13.752 11.454 10.238 11.454 8.085 13.63 Z M 4.085 9.16 L 6.085 11.39 C 9.376 8.192 14.614 8.192 17.905 11.39 L 19.905 9.16 C 15.479 4.943 8.521 4.943 4.095 9.16 Z M 11.995 0 C 7.576 0.001 3.322 1.681 0.095 4.7 L 2.095 6.93 C 7.659 1.691 16.341 1.691 21.905 6.93 L 23.905 4.7 C 20.676 1.678 16.418 -0.002 11.995 0 Z' fill='#{@options.foregroundColor}' /></svg>"
		battery_v10_2x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 49 32'><rect x='0.5' y='0.5'  width='44' height='18' rx='3' ry='3' stroke='#{@options.foregroundColor}' fill-opacity='0' class='stroked' /><rect x='2' y='2' width='#{getBatteryLevel(41)}' height='15' rx='1.5' ry='1.5' fill='#{batteryColor}' id='batteryFill' /><path d='M46,6v7a3.28,3.28,0,0,0,3-3.5A3.28,3.28,0,0,0,46,6Z' fill='#{@options.foregroundColor}'/></svg>"
		battery_v11_2x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 53 32'><rect fill='#{batteryColor}' id='batteryFill' x='4' y='4' width='#{getBatteryLevel(40)}' height='15' rx='2' /><rect stroke='#{@options.foregroundColor}' fill-opacity='0' class='stroked' stroke-width='2' opacity='0.4' x='1' y='1' width='46' height='21' rx='5' /><path d='M50,7.25605856 C51.7477886,7.87381317 53,9.54067176 53,11.5 C53,13.4593282 51.7477886,15.1261868 50,15.7439414 L50,7.25605856 Z' fill='#{@options.foregroundColor}' opacity='0.4' /></svg>"
		battery_v10_3x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 73 42'><path d='M62,0H5A5,5,0,0,0,0,5V24a5,5,0,0,0,5,5H62a5,5,0,0,0,5-5V5A5,5,0,0,0,62,0Zm4,24a4,4,0,0,1-4,4H5a4,4,0,0,1-4-4V5A4,4,0,0,1,5,1H62a4,4,0,0,1,4,4Z' fill='#{@options.foregroundColor}' /><rect x='2' y='2' width='#{getBatteryLevel(63)}' height='25' rx='3' ry='3' fill='#{batteryColor}' id='batteryFill' /><path d='M69,10.06v9.89A4.82,4.82,0,0,0,73,15,4.82,4.82,0,0,0,69,10.06Z' fill='#{@options.foregroundColor}' /></svg>"
		battery_v11_3x = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 78 42'><rect fill='#{batteryColor}' id='batteryFill' x='6' y='6' width='#{getBatteryLevel(59)}' height='22' rx='3' /><rect stroke='#{@options.foregroundColor}' fill-opacity='0' class='stroked' stroke-width='3' opacity='0.4' x='1.5' y='1.5' width='68' height='31' rx='7.5' /><path d='M 74 10.674 C 76.365 11.797 78 14.208 78 17 C 78 19.792 76.365 22.203 74 23.326 L 74 10.674 Z' fill='#{@options.foregroundColor}' opacity='0.4'/></svg>"
		powerSVG = "<svg xmlns='http://www.w3.org/2000/svg' class='svgFit' viewBox='0 0 6 17'><polygon points='6 3.75 3.43 3.75 4.5 0 0.5 5.25 2.98 5.25 1.5 9.5 6 3.75' fill='#{@options.foregroundColor}' /></svg>"

		svg =
			battery:
				v10:
					at2x: battery_v10_2x
					at3x: battery_v10_3x
				v11:
					at2x: battery_v11_2x
					at3x: battery_v11_3x
			signal:
				v10:
					at2x: signal_v10_2x
					at3x: signal_v10_3x
				v11:
					at2x: signal_v11_2x
					at3x: signal_v11_3x
			wifi: wifiSVG
			power: powerSVG

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
				top: topMargin
			text: @options.carrier
			fontSize: baseFontSize
			fontWeight: fontWeight
			letterSpacing: letterSpacing

		@.carrier = carrier

		signal = new Layer
			parent: @
			name: "signal"
			width: if @options.version > 10 then 16.5 else 34
			height: if @options.version > 10 then 10 else 6
			y: Align.center
			html: getSignalSVG()

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
				top: topMargin
			text: getTime()
			fontSize: baseFontSize
			fontWeight: timeFontWeight
			textAlign: "center"
			letterSpacing: timeLetterSpacing

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
			width: getBatteryWidth()
			height: if @options.version > 10 then 11.5 else 9
			html: getBatterySVG()

		@.battery = battery

		percentage = new TextLayer
			parent: @
			name: "percentage"
			padding:
				top: topMargin
			text: @options.percent + "%"
			fontSize: baseFontSize
			fontWeight: fontWeight
			textAlign: "right"
			letterSpacing: letterSpacing

		@.percentage = percentage

		for layer in @.subLayers
			layer.backgroundColor = "clear"

		@hide = () =>
			@.isHidden = true
			@.animate
				properties:
					y: 0 - statusBarHeight
				time:
					0.25

		@show = () =>
			@.isHidden = false
			@.animate
				properties:
					y: 0
				time:
					0.25

		@layout = (orientation = 0) =>
			layoutWidth = getScreenWidth()
			@.width = layoutWidth
			if @options.hide == true
				@hide()
			else if @options.autoHide == true && orientation > 0 && isiPhone()
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
			time.width = layoutWidth
			onCallBlock.width = layoutWidth
			onCallMessage.width = layoutWidth
			# Right-side items
			if @options.powered == true
				power.x = Align.right(-powerMargin)
			else
				power.x = layoutWidth
			battery.x = power.x - battery.width - getBatteryMargin()
			if @options.showPercentage == false
				percentageMargin = 0
				percentage.text = ""
			else
				percentage.text = @options.percent + "%"
			percentage.maxX = battery.x - percentageMargin

		getTime()
		@layout()

		# end layout()

		selectForegroundColor = () =>
			if @options.foregroundColor == ""
				if @options.style == "dark"
					return "white"
				else
					return "black"
			else
				return @options.foregroundColor

		foregroundItems = [percentage, power, time, wifi, signal, carrier, battery]

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

		# Check whether the device is mobile or not (versus Framer)
		if Utils.isMobile()
			# Set type
			device = "mobile"
			# Add event listener on orientation change
			window.addEventListener "orientationchange", =>
				# Send event handling to function along with device type
				@layout(window.orientation)
		else
			# Listen for orientation changes on the device view
			Framer.Device.on "change:orientation", =>
				# Set type
				device = "Framer"
				# Send event handling to function with device type
				@layout(Math.abs(Framer.Device.orientation))

	@define 'hidden', get: () -> @.isHidden
	@define 'onCall', get: () -> @options.onCall

module.exports = StatusBarLayer
