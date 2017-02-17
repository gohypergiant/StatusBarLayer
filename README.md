# StatusBarLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

### Installation

#### Manual Installation

Copy / save the `StatusBarLayer.coffee` file into your project's `modules` folder.

### Adding It To Your Project

In your Framer project add the following:

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
	autoHide: <boolean> # hide in landscape where relevant
	
	# Set @1x, @2x or @3x -- usually unnecessary
	scaleFactor: <number> (1 || 2 || 3)
```
	
#### Simulate call
```coffeescript
myStatusBar.startCall(message, color) # <string>, <string> (hex or rgba)
myStatusBar.stopCall()
```
		
#### Check visibility and call status
```coffeescript
print myStatusBar.hidden
print myStatusBar.onCall
```