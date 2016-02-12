#stencil triangles - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/stencil-triangles)
- display 2 triangles with different stencil operations for the rgb one

#system options playground - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/system-options-playground)
- ideas for improvements to kha.System.init
- prototype implementation for multiple window
- requires: https://github.com/sh-dave/Kha - system-options-playground branch
- requires: https://github.com/sh-dave/Kore - system-options-playground branch

### old interface is still supported (single window ...)
```haxe
kha.System.init('hello world', 800, 600, ...);
```

### new interface
- window mode (Windowed, BorderlessWindow, Fullscreen) - 
- target display (Main, Custom(N)) - monitor selection
- window position (Center, Fixed(N)) - positioning the window
- ... more to come

```haxe
var mainWindowOptions = new WindowOptions('system_settings_playground | main', 683, 384)
	.setMode(Windowed)
	.setPosition(Center, Fixed(0))
	.setTargetDisplay(Main)
	;

var subWindowOptions = new WindowOptions('system_settings_playground | sub1', 683, 384)
	.setMode(Windowed)
	.setPosition(Center, Fixed(450))
	.setTargetDisplay(Custom(1))
	;

var buttonWindowOptions = new WindowOptions('system_settings_playground | buttons', 683, 192)
	.setMode(Windowed)
	.setPosition(Center, Fixed(900))
	.setTargetDisplay(Custom(1))
	;

System.initEx(
	[mainWindowOptions, subWindowOptions, buttonWindowOptions],
	window_initializedHandler,
	system_initializedHandler
);
```

### os progress
- [ ] windows - wip
- [ ] linux - wip
- others not planned

#### graphics progress
- [ ] opengl2 - wip
- others not planned
