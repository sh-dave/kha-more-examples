package ;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.graphics4.CompareMode;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.StencilAction;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Key;
import kha.math.FastMatrix4;
import kha.Shaders;
import kha.System;

class Mesh {
	public var vb : VertexBuffer;
	public var ib : IndexBuffer;

	public function new( vertices : Array<Float>, vertexSize : Int, vertexStructure : VertexStructure, indices : Array<Int> ) {
		this.vb = new VertexBuffer(Std.int(vertices.length / vertexSize), vertexStructure, Usage.StaticUsage);

		var vbdata = vb.lock();
			for (i in 0 ... vbdata.length) {
				vbdata.set(i, vertices[i]);
			}
		vb.unlock();

		this.ib = new IndexBuffer(indices.length, Usage.StaticUsage);

		var ibdata = ib.lock();
			for (i in 0 ... ibdata.length) {
				ibdata[i] = indices[i];
			}
		ib.unlock();
	}
}

class StencilTrianglesExample extends SampleApplication {
	var whiteQuad : Mesh;
	var rgbQuad : Mesh;

	var stencilModeIndex = 0;
	var stencilMode : CompareMode;

	var font : Font;

	override function setup() {
		this.stencilMode =  CompareMode.createByIndex(0);
		this.font = Assets.fonts.LiberationSans_Regular;

		var structure = new VertexStructure();
		structure.add('vertexPosition', VertexData.Float3);
		structure.add('vertexColor', VertexData.Float4);

		this.whiteQuad = new Mesh(
			[
				-0.75,	-0.75,	0.5,	1, 1, 1, 1,
				0.75, 	-0.75,	0.5,	1, 1, 1, 1,
				0,		0.75,	0.5,	1, 1, 1, 1,
			],
			7,
			structure,
			[ 0,  1,  2 ]
		);

		this.rgbQuad = new Mesh(
			[
				-0.75,	0.75,	0.5,	1, 0, 0, 1,
				0,		-0.75,	0.5,	0, 1, 0, 1,
				0.75, 	0.75,	0.5,	0, 0, 1, 1,
			],
			7,
			structure,
			[ 0,  1,  2 ]
		);

		this.pipeline = new PipelineState();
		pipeline.vertexShader = Shaders.painter_colored_vert;
		pipeline.fragmentShader = Shaders.painter_colored_frag;
		pipeline.inputLayout = [structure];
		pipeline.stencilReferenceValue = 1;
		pipeline.stencilReadMask = 1;
		pipeline.stencilWriteMask = 1;
		pipeline.compile();

		// (DK) TODO
		//	-pipeline should be ready after .compile(), but it crashes on android -.-
		//	-so we set it in renderG4() and get the id then
		//		=> figure out whats wrong on android/opengles

		//this.mvpId = pipeline.getConstantLocation('projectionMatrix');
	}

	override function renderG4( g : kha.graphics4.Graphics ) {
		g.setPipeline(pipeline);

		g.clear(Color.fromBytes(0x00, 0x80, 0x80, 0xff), 0.0, 0);

		if (mvpId == null) {
			this.mvpId = pipeline.getConstantLocation('projectionMatrix');
		}

		var mvp = FastMatrix4.identity();
		mvp.multmat(projection);
		mvp.multmat(view);
		mvp.multmat(model);
		g.setMatrix(mvpId, mvp);

// white quad, always drawn
		pipeline.stencilMode = CompareMode.Always;
		pipeline.stencilFail = StencilAction.Replace;
		pipeline.stencilBothPass = StencilAction.Replace;
		pipeline.stencilDepthFail = StencilAction.Replace;
		g.setPipeline(pipeline);

		g.setVertexBuffer(whiteQuad.vb);
		g.setIndexBuffer(whiteQuad.ib);
		g.drawIndexedVertices(0, 3);

// rgb quad, stencil masked
		pipeline.stencilMode = stencilMode;
		pipeline.stencilFail = StencilAction.Keep;
		pipeline.stencilBothPass = StencilAction.Keep;
		pipeline.stencilDepthFail = StencilAction.Keep;
		g.setPipeline(pipeline);

		g.setVertexBuffer(rgbQuad.vb);
		g.setIndexBuffer(rgbQuad.ib);
		g.drawIndexedVertices(0, 3);
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		g.font = font;
		g.fontSize = 16;
		g.drawString('"q" / click|touch left side: switch CompareMode (current = "${stencilMode}")', 8, 8);
		g.drawString('"r" / click|touch right side: switch RenderMode (current = ${renderMode})', 8, 24);
	}

	// TODO (DK)
	//	-on android we get a touch + mouse handler callback, so leave it be for now
	override function touch_endHandler( index : Int, x : Int, y : Int ) {
		//if (x < System.pixelWidth / 2) {
			//changeCompareMode();
		//} else {
			//changeRenderMode();
		//}
	}

	override function mouse_downHandler( button : Int, x : Int, y : Int ) {
		if (x < System.pixelWidth / 2) {
			changeCompareMode();
		} else {
			changeRenderMode();
		}
	}

	override function keyboard_downHandler( key : Key, value : String ) {
		switch (key) {
			case CHAR: {
				switch (value) {
					case 'q': changeCompareMode();
					case 'r': changeRenderMode();
				}
			}
			default: return;
		}
	}

	function changeCompareMode() {
		if (++stencilModeIndex >= 7) {
			stencilModeIndex = 0;
		}

		stencilMode = CompareMode.createByIndex(stencilModeIndex);
	}
}

class Main {
	public static function main() {
		System.init('stencil_triangles', 512, 512, system_initializedHandler);
	}

	static function system_initializedHandler() {
		new StencilTrianglesExample();
	}
}
