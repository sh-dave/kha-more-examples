package ;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Key;
import kha.System;
import kha.Video;
import kha.Window;
import kha.WindowOptions;

class MainDisplay extends SampleDisplayTarget {
	var font : Font;

	override function setup() {
		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
	}

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
		g.drawRect(100, 100, 512, 512, 10);
	}
}

class SubDisplay extends SampleDisplayTarget {
	var font : Font;

	override function setup() {
		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
	}

	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0xff, 0x00, 0xff), 0.0, 0);
		trace('SubDisplay renderG4');
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		trace('SubDisplay renderG2');

		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('i\'m the sub display', 8, 8);

		g.color = Color.White;
		g.drawRect(100, 100, 512, 512, 10);
	}
}

class ButtonDisplay extends SampleDisplayTarget {
	var font : Font;

	override function setup() {
		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
	}

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
		g.drawRect(100, 100, 512, 512, 10);
	}
}

class Main {
	public static function main() {
		trace('main');

		Assets.loadEverything(assets_loadedHandler);
	}

	static function assets_loadedHandler() {
		var mainWindowOptions = new WindowOptions('system_settings_playground | main', 683, 384)
			.setMode(Windowed)
			.setPosition(Center, Fixed(0))
			.setTargetDisplay(Main)
			;

		var subWindowOptions = new WindowOptions('system_settings_playground | sub1', 683, 384)
			.setMode(Windowed)
			.setPosition(Center, Fixed(450)) // TODO (DK) make relative to targetDisplay, not TargetDisplay.Main
			.setTargetDisplay(Custom(1))
			;

		var buttonWindowOptions = new WindowOptions('system_settings_playground | buttons', 683, 192)
			.setMode(Windowed)
			.setPosition(Center, Fixed(900)) // TODO (DK) make relative to targetDisplay, not TargetDisplay.Main
			.setTargetDisplay(Custom(1))
			;

		System.initEx(
			[mainWindowOptions, subWindowOptions, buttonWindowOptions],
			window_initializedHandler,
			system_initializedHandler
		);
	}

	// TODO (DK) crappy logic for now, use diffrent callbacks for each window?
	static function window_initializedHandler( id : Int ) {
		trace('window_initializedHandler');

		if (m == null) {
			m = new MainDisplay(id);
		} else if (s == null) {
			s = new SubDisplay(id);
		} else {
			b = new ButtonDisplay(id);
		}
	}

	static function system_initializedHandler() {
		trace('system_initializedHandler');
	}

	static var m : MainDisplay;
	static var s : SubDisplay;
	static var b : ButtonDisplay;
}
