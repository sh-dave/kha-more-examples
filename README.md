#stencil triangles
- display 2 triangles with different stencil operations for the rgb one
- [screenshots](https://github.com/sh-dave/kha-more-examples/wiki/stencil-triangles)

#system options playground
- ideas for improvements to kha.System.init
```haxe
kha.System.init('hello world', 800, 600, ...);
```
```haxe
var options = new SystemOptions('system_settings_playground', width, height)
    .setWindowMode(BorderlessWindow)
    //.setWindowMode(Fullscreen)
    .setWindowPosition(Fixed(128), Center)
    .setTargetDisplay(Custom(1))
    //.setTargetDisplay(Main)
    .setWindowFlags(true, false, true)
    .setFramebufferOptions(new RendererOptions(DepthStencilFormat.DepthAutoStencilAuto))
    ;

System.initEx(options, system_initializedHandler);
```
