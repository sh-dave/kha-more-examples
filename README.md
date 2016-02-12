#stencil triangles - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/stencil-triangles)
- display 2 triangles with different stencil operations for the rgb one

#system options playground - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/system-options-playground)
- ideas for improvements to kha.System.init
- prototype implementation for multiple window
- requires: https://github.com/sh-dave/Kha - system-options-playground branch
- requires: https://github.com/sh-dave/Kore - system-options-playground branch

```haxe
kha.System.init('hello world', 800, 600, ...);
```
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
