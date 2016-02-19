package ;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Image;
import kha.Key;
import kha.System;
import kha.Video;
import kha.WindowOptions;

class BasicDisplay extends SampleDisplayTarget {
	var font : Font;
	var char : Image;
	var charX : Float;
	var charY : Float;

	override function setup() {
		super.setup();

		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
		char = Assets.images.character;
		charX = Math.random() * windowOptions.width - char.width;
		charY = Math.random() * windowOptions.height - char.height;
	}

	override function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) {
		charX = x;
		charY = y;
	}
}

class MainDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0xff, 0x00, 0x00, 0xff), 0.0, 0);
		//trace('MainDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		//trace('MainDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('i\'m the main display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 384 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, charX, charY);
	}

	override function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) {
		super.mouse_moveHandler(x, y, mx, my);
		trace('MainDisplay.mouse_moveHandler ${x} ${y} ${mx} ${my}');
	}
}

class SubDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0xff, 0x00, 0xff), 0.0, 0);
		//trace('SubDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		//trace('SubDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.Black;
		g.drawString('i\'m the sub display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 384 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, charX, charY);
	}

	override function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) {
		super.mouse_moveHandler(x, y, mx, my);
		trace('SubDisplay.mouse_moveHandler ${x} ${y} ${mx} ${my}');
	}
}

class ButtonDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0x00, 0xff, 0xff), 0.0, 0);
		//trace('ButtonDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		//trace('ButtonDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('i\'m the button display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 192 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, charX, charY);
	}

	override function mouse_moveHandler( x : Int, y : Int, mx : Int, my : Int ) {
		super.mouse_moveHandler(x, y, mx, my);
		trace('ButtonDisplay.mouse_moveHandler ${x} ${y} ${mx} ${my}');
	}
}

// (DK) Setup has to be called after Assets.loadEverything()
class Main {
	public static function main() {
		trace('main');

		//setup_singleWindow();
		setup_multipleWindows();
	}

	static function setup_singleWindow() {
		var options = { title : 'single window', width : 683, height : 384 };

		System.init({title : options.title, width : options.width, height : options.height}, function() {
			m = new MainDisplay(0, options);

			Assets.loadEverything(function() {
				m.setup();
			});
		});
	}

	static function setup_multipleWindows() {
		var mainWindowOptions = { title : ' | main', width : 683, height : 384, mode : Window, x : Fixed(128), y : Fixed(128) };
		var subWindowOptions = { title : ' | sub1', width : 683, height : 384, mode : BorderlessWindow, x : Fixed(128), y : Fixed(128), targetDisplay : ById(2) };
		var buttonWindowOptions = { title : ' | buttons', width : 683, height : 192, y : Fixed(768), targetDisplay : ById(1) };

		System.initEx(
			'system settings playground',
			[mainWindowOptions, subWindowOptions, buttonWindowOptions],
			function( id : Int ) {
				// TODO (DK) crappy logic for now, use diffrent callbacks for each window?
				trace('window_initializedHandler');

				if (m == null) {
					m = new MainDisplay(id, mainWindowOptions);
				} else if (s == null) {
					s = new SubDisplay(id, subWindowOptions);
				} else {
					b = new ButtonDisplay(id, buttonWindowOptions);
				}
			},
			function() {
				trace('system_initializedHandler');

				Assets.loadEverything(function() {
					trace('assets_loadedHandler');

					if (m != null) {
						m.setup();
					}

					if (s != null) {
						s.setup();
					}

					if (b != null) {
						b.setup();
					}
				});
			}
		);
	}

	static var m : MainDisplay;
	static var s : SubDisplay;
	static var b : ButtonDisplay;
}
