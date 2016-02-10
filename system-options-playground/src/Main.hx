package ;

import kha.Assets;
import kha.Color;
import kha.Font;
import kha.Key;
import kha.System;
import kha.SystemOptions;
import kha.Video;

class SystemSettingsExample extends SampleApplication {
	var video : Video;
	var videoIsPlaying = false;

	var font : Font;

	override function setup() {
		var a = Assets;
		font = a.fonts.LiberationSans_Regular;
	}

	override function renderG4( g : kha.graphics4.Graphics ) {
		g.clear(Color.fromBytes(0x00, 0x80, 0x80, 0xff), 0.0, 0);
	}

	override function renderG2( g : kha.graphics2.Graphics ) {
		g.font = font;
		g.fontSize = 16;
		g.color = Color.White;
		g.drawString('"space" / click|touch left side: do nothing!', 8, 8);
	}

	override function mouse_downHandler( button : Int, x : Int, y : Int ) {
	}

	override function keyboard_downHandler( key : Key, value : String ) {
		switch (key) {
			case CHAR: {
				switch (value) {
					case ' ': {
					}
				}
			}
			default: return;
		}
	}
}

class Main {
	static inline var width = 1920;
	static inline var height = 1200;

	public static function main() {
		var options = new SystemOptions('system_settings_playground', width, height)
			.setWindowMode(Windowed)
			.setWindowPosition(Fixed(128), Fixed(128))
			.setWindowFlags(true, false, true)
			;

		System.initEx(options, system_initializedHandler);
		//System.init('system_settings_playground', 2366, 768, system_initializedHandler);
	}

	static function system_initializedHandler() {
		new SystemSettingsExample(width, height);
	}
}
