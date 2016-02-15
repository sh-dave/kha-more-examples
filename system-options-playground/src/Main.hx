package ;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Image;
import kha.Key;
import kha.System;
import kha.Video;
import kha.Window;
import kha.WindowOptions;

class BasicDisplay extends SampleDisplayTarget {
	var font : Font;
	var char : Image;
	var startX : Float;

	override function setup() {
		super.setup();

		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
		char = Assets.images.character;
		startX = Math.random() * 512;
	}
}

class MainDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0xff, 0x00, 0x00, 0xff), 0.0, 0);
		trace('MainDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		trace('MainDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('i\'m the main display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 384 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, startX, 64);
	}
}

class SubDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0xff, 0x00, 0xff), 0.0, 0);
		trace('SubDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		trace('SubDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.Black;
		g.drawString('i\'m the sub display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 384 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, startX, 64);
	}
}

class ButtonDisplay extends BasicDisplay {
	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0x00, 0xff, 0xff), 0.0, 0);
		trace('ButtonDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		trace('ButtonDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('i\'m the button display', 8, 8);

		g.color = Color.White;
		g.drawRect(64, 64, 683 - 128, 192 - 128, 10);

		g.color = Color.White;
		g.drawImage(char, startX, 64);
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
		System.init('single window', 800, 600, function() {
			m = new MainDisplay(0);

			Assets.loadEverything(function() {
				m.setup();
			});
		});
	}

	static function setup_multipleWindows() {
		var mainWindowOptions = new WindowOptions('main', 683, 384)
			.setMode(Windowed)
			.setPosition(Fixed(128), Fixed(128))
			.setTargetDisplay(Main)
			;

		var subWindowOptions = new WindowOptions('sub1', 683, 384)
			.setMode(Windowed)
			.setPosition(Fixed(128), Fixed(128)) // TODO (DK) make relative to targetDisplay, not TargetDisplay.Main
			.setTargetDisplay(Custom(2))
			;

		var buttonWindowOptions = new WindowOptions('buttons', 683, 192)
			.setMode(Windowed)
			.setPosition(Center, Fixed(128)) // TODO (DK) make relative to targetDisplay, not TargetDisplay.Main
			.setTargetDisplay(Custom(1))
			;

		System.initEx(
			'system settings playground',
			[mainWindowOptions, subWindowOptions, buttonWindowOptions],
			function window_initializedHandler( id : Int ) {
				// TODO (DK) crappy logic for now, use diffrent callbacks for each window?
				trace('window_initializedHandler');

				if (m == null) {
					m = new MainDisplay(id);// , mainWindowOptions.rendererOptions);
				} else if (s == null) {
					s = new SubDisplay(id);// , subWindowOptions.rendererOptions);
				} else {
					b = new ButtonDisplay(id);// , buttonWindowOptions.rendererOptions);
				}
			},
			function system_initializedHandler() {
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
