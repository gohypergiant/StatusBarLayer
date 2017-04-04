# StatusBarLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The StatusBarLayer module allows you to instantly generate an accurate status bar for your iPhone and iPad app prototypes. Appearance and status items are customizable, and the module will mimic iOS orientation-switch behavior according to device type. Events that affect the status bar, such as calls, may also be simulated.

<img src="https://cloud.githubusercontent.com/assets/935/23085407/44d08096-f52d-11e6-8d31-d9745537438b.gif" width="497" style="display: block; margin: auto" alt="StatusBarLayer preview" />

### Installation

#### Manual installation

Copy or save the `StatusBarLayer.coffee` file into your project's `modules` folder.

### Adding It to Your Project

In your Framer project, add the following:

```javascript
StatusBarLayer = require "StatusBarLayer"
```

### API

#### `new StatusBarLayer`

Instantiates a new instance of StatusBarLayer.

#### Available options

```coffeescript
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
```
	
#### Simulate call
```coffeescript
myStatusBar.startCall(message, color) # <string>, <string> (hex or rgba)
myStatusBar.endCall()
```

#### Show and hide
```coffeescript
myStatusBar.show()
myStatusBar.hide()
```
		
#### Check visibility and call status
```coffeescript
print myStatusBar.hidden
print myStatusBar.onCall
```

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
