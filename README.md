# StatusBarLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

<a href="https://open.framermodules.com/statusbarlayer"><img alt="Install with Framer Modules" src="https://www.framermodules.com/assets/badge@2x.png" width='160' height='40' /></a>

The StatusBarLayer module allows you to instantly generate an accurate status bar for your iPhone and iPad app prototypes. Appearance and status items are customizable, and the module will mimic iOS orientation-switch behavior according to device type. Events that affect the status bar, such as calls, may also be simulated.

<img src="https://user-images.githubusercontent.com/935/28138062-118c3a22-6715-11e7-81a7-1ef1c9cf81ef.gif" width="500" style="display: block; margin: auto" alt="StatusBarLayer preview" />

### Installation

#### NPM Installation

```javascript
$ cd /your/framer/project
$ npm i @blackpixel/framer-statusbarlayer
```

#### Manual installation

Copy or save the `StatusBarLayer.coffee` file into your project's `modules` folder.

### Adding It to Your Project

In your Framer project, add the following:

```coffeescript
# If you manually installed
StatusBarLayer = require "StatusBarLayer"
# else
StatusBarLayer = require "@blackpixel/framer-statusbarlayer"
```

### API

#### `new StatusBarLayer`

Instantiates a new instance of StatusBarLayer.

#### Available options

```coffeescript
myStatusBar = new StatusBarLayer
	# iOS version
	version: <number> (10 || 11)
	
	# Text
	carrier: <string>
	time: <string> # if not set, will use local time
	hours24: <boolean> # 12-hours format by default, ignored if time is set 
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

### Example project
[Download](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/bpxl-labs/StatusBarLayer/tree/master/example.framer) the example to try it for yourself.

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
