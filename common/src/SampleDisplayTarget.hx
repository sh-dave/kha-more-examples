package ;

import kha.Assets;
import kha.DepthStencilFormat;
import kha.Framebuffer;
import kha.graphics4.ConstantLocation;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureFormat;
import kha.Image;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;
import kha.Key;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.Scaler;
import kha.System;
import kha.WindowOptions;
import kha.WindowOptions.RendererOptions;

enum RenderMode {
	Backbuffer;
	Framebuffer;
}

class SampleDisplayTarget {
	var pipeline : PipelineState;
	var mvpId : ConstantLocation;

	var model = FastMatrix4.identity();
	var view = FastMatrix4.lookAt(new FastVector3(0, 0, 1), new FastVector3(0, 0, 0), new FastVector3(0, 1, 0));
	//var projection = FastMatrix4.orthogonalProjection( -1.0, 1.0, -1.0, 1.0, 0.0, 100.0);
	var projection = FastMatrix4.perspectiveProjection(45.0, 4.0 / 3.0, 0.1, 100.0);

	var bb : Image;
	var renderMode = Backbuffer;
	//var renderMode = Framebuffer;

	var windowId : Int;
	var windowOptions : WindowOptions;

	public function new( windowId : Int, windowOptions : WindowOptions ) {
		this.windowId = windowId;
		this.windowOptions = windowOptions;
	}

	public function setup() {
		bb = Image.createRenderTarget(
			windowOptions.width,
			windowOptions.height,
			windowOptions.rendererOptions != null ? windowOptions.rendererOptions.textureFormat : TextureFormat.RGBA32,
			windowOptions.rendererOptions != null ? windowOptions.rendererOptions.depthStencilFormat : DepthStencilFormat.DepthAutoStencilAuto,
			0, // TODO (DK) samplesPerPixel
			windowId
		);

		System.notifyOnRender(windowId, render);

		//if (Keyboard.get() != null) {
			//Keyboard.get().notify(keyboard_downHandler, keyboard_upHandler);
		//}
//
		if (Mouse.get() != null) {
			Mouse.get().notifyWindowed(windowId, mouse_downHandler, mouse_upHandler, mouse_moveHandler, mouse_wheelHandler);
		}
//
		//if (Surface.get() != null) {
			//Surface.get().notify(touch_startHandler, touch_endHandler, touch_moveHandler);
		//}
	}

	function render( fb : Framebuffer ) {
		switch (renderMode) {
			case Framebuffer: renderFB(fb);
			case Backbuffer: renderBB(fb);
		}
	}

	function renderImpl( g4 : kha.graphics4.Graphics, g2 : kha.graphics2.Graphics ) {
		//trace('renderImpl enter');

		//trace('renderImpl g4 begin');
		g4.begin();
			renderG4(g4);
		g4.end();
		//trace('renderImpl g4 end');

		//trace('renderImpl g2 begin');
		g2.begin(false);
			renderG2(g2);
		g2.end();
		//trace('renderImpl g2 end');

		//trace('renderImpl exit');
	}

	function renderBB( fb : Framebuffer ) {
		//trace('renderBB enter');
		renderImpl(bb.g4, bb.g2);

		//trace('renderBB fb.g2.begin()');
		fb.g2.begin();
			//trace('renderBB scale');
			Scaler.scale(bb, fb, System.screenRotation);
		fb.g2.end();
		//trace('renderBB fb.g2.end()');

		//trace('renderBB exit');
	}

	function renderFB( fb : Framebuffer ) {
		//trace('renderFB enter');
		renderImpl(fb.g4, fb.g2);
		//trace('renderFB exit');
	}

	public function changeRenderMode() {
		renderMode = renderMode == Framebuffer ? Backbuffer : Framebuffer;
	}

	function keyboard_downHandler( key : Key, id : String ) {}
	function keyboard_upHandler( key : Key, id : String ) {}

	function mouse_downHandler( button : Int, x : Int, y : Int ) { }
	function mouse_upHandler( button : Int, x : Int, y : Int ) { }
	function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) { }
	function mouse_wheelHandler( delta : Int ) { }

	function touch_startHandler( index : Int, x : Int, y : Int ) { }
	function touch_endHandler( index : Int, x : Int, y : Int ) { }
	function touch_moveHandler( index : Int, x : Int, y : Int ) { }

	function renderG4( g : kha.graphics4.Graphics ) {}
	function renderG2( g : kha.graphics2.Graphics ) {}
}
