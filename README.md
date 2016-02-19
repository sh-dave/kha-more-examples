#stencil triangles - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/stencil-triangles)
- display 2 triangles with different stencil operations for the rgb one

#system options playground - [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/system-options-playground)
- prototype implementation for multiple window
- requires: https://github.com/sh-dave/Kha - system-options-playground branch
- requires: https://github.com/sh-dave/Kore - system-options-playground branch
- requires: https://github.com/sh-dave/koremake - system-options-playground branch

### old interface is still supported (single window ...)
```haxe
kha.System.init('hello world', 800, 600, ...);
```

### new interface
- window mode (Window, BorderlessWindow, Fullscreen) - 
- target display (Primary, ById(N)) - monitor selection
- window position (Center, Fixed(N)) - positioning the window
- ... more to come

```haxe
var mainWindowOptions = { title : ' | main', width : 683, height : 384, mode : Window, x : Fixed(128), y : Fixed(128) };
var subWindowOptions = { title : ' | sub1', width : 683, height : 384, mode : BorderlessWindow, x : Fixed(128), y : Fixed(128), targetDisplay : ById(2) };
var buttonWindowOptions = { title : ' | buttons', width : 683, height : 192, y : Fixed(768), targetDisplay : ById(1) };

System.initEx(
	'system settings playground',
	[mainWindowOptions, subWindowOptions, buttonWindowOptions],
	window_initializedHandler,
	system_initializeHandler
);

```
### progress
- [x] win - basic implementation of multiple windows
- [x] win - setTargetDisplay
- [x] win - setPosition
- [ ] win - setWindowedFlag
- [x] win - mouse handling
- [ ] win - keyboard handling
- [ ] win - textureFormat flag for rendererOptions
- [ ] win - ...?

- [x] *nix - basic implementation of multiple windows
- [x] *nix - setTargetDisplay | wip
- [x] *nix - setPosition
- [ ] *nix - setWindowedFlag
- [x] *nix - mouse handling
- [ ] *nix - keyboard handling
- [ ] *nix - textureFormat flag for rendererOptions
- [ ] *nix - ...?
