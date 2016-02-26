package;

import haxe.Http;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.System;

using tink.CoreApi;

class RemoteLoader {
    public static function load( url : String ) : Surprise<String, String> {
		return Future.async(function( handler : Outcome<String, String> -> Void ) {
			var http = new Http(url);
			http.onData = function( data : String ) {
				trace(data);
				handler(Success(data));
			}
			http.onError = function( error : String ) {
				trace(error);
				handler(Failure(error));
			}
			http.request();
		});
    }
}

class LocalLoader {
	public static function load( url : String ) : Surprise<String, String> {
		return Future.async(function( handler : Outcome<String, String> -> Void ) {
			var assets = Assets;
			var data : String = Reflect.field(assets.blobs, url);
			handler(Success(data));
		});
	}
}

class ImageBuilder {
	public static function convertPng( o : Outcome<String, String> ) : Surprise<Image, String> {
		return Future.async(function( handler : Outcome<Image, String> -> Void ) {
			switch (o) {
				case Success(data): {
					var bytes = Bytes.ofString(data);
					var reader = new format.png.Reader(new BytesInput(bytes));
					var pngData = reader.read();
					var header = format.png.Tools.getHeader(pngData);

					var tempImg = Image.create(header.width, header.height);
					var pngbytes = format.png.Tools.extract32(pngData);

					var imagebytes = tempImg.lock();
					imagebytes.blit(0, pngbytes, 0, pngbytes.length);
						//for (y in 0 ... tempImg.height) for (x in 0 ... tempImg.width) {
							//imagebytes.set(y * Std.int(header.width) * 4 + x * 4 + 0, pngbytes.get(y * Std.int(header.width) * 4 + x * 4 + 0));
							//imagebytes.set(y * Std.int(header.width) * 4 + x * 4 + 1, pngbytes.get(y * Std.int(header.width) * 4 + x * 4 + 1));
							//imagebytes.set(y * Std.int(header.width) * 4 + x * 4 + 2, pngbytes.get(y * Std.int(header.width) * 4 + x * 4 + 2));
							//imagebytes.set(y * Std.int(header.width) * 4 + x * 4 + 3, pngbytes.get(y * Std.int(header.width) * 4 + x * 4 + 3));
						//}
					tempImg.unlock();
					handler(Success(tempImg));
				}
				case Failure(error): trace(error);
			}
		});
	}

	public static function convertBmp( o : Outcome<String, String> ) : Surprise<Image, String> {
		return Future.async(function( handler : Outcome<Image, String> -> Void ) {
			switch (o) {
				case Success(data): {
					var bytes = Bytes.ofString(data);
					var reader = new format.bmp.Reader(new BytesInput(bytes));
					var bmpData = reader.read();
					var bgraData = format.bmp.Tools.extractBGRA(bmpData);

					var tempImg = Image.create(bmpData.header.width, bmpData.header.height);
					trace('bmpData w/h ${bmpData.header.width}x${bmpData.header.height} / tempImg w/h ${tempImg.width}x${tempImg.height} / tempImg rw/rw ${tempImg.realWidth}x${tempImg.realHeight}');
					trace('bgraData length ${bgraData.length}');

					var imagebytes : Bytes = tempImg.lock();
						// (DK) only works for equal sizes
						//imagebytes.blit(0, bgraData, 0, bgraData.length);

						//for (i in 0...imagebytes.length) {
							//imagebytes.set(i, pngbytes.get(i));
						//}

						for (y in 0 ... bmpData.header.height) {
							for (x in 0 ... bmpData.header.width) {
								imagebytes.set(y * Std.int(bmpData.header.width) * 4 + x * 4 + 0, bgraData.get(y * Std.int(bmpData.header.width) * 4 + x * 4 + 0));
								imagebytes.set(y * Std.int(bmpData.header.width) * 4 + x * 4 + 1, bgraData.get(y * Std.int(bmpData.header.width) * 4 + x * 4 + 1));
								imagebytes.set(y * Std.int(bmpData.header.width) * 4 + x * 4 + 2, bgraData.get(y * Std.int(bmpData.header.width) * 4 + x * 4 + 2));
								imagebytes.set(y * Std.int(bmpData.header.width) * 4 + x * 4 + 3, bgraData.get(y * Std.int(bmpData.header.width) * 4 + x * 4 + 3));
							}
						}
					tempImg.unlock();

					handler(Success(tempImg));
				}
				case Failure(error): trace(error);
			}
		});
	}
}

class RemoteAssetLoading extends SampleApplication {
    var remoteImage : Image;

	override function setup() {
		// TODO (DK) windows requires hxssl library for https stuff
		//RemoteLoader.load('https://github.com/sh-dave/kha-more-examples/raw/gh-pages/stencil-triangles/images/always.png')
		//RemoteLoader.load('http://sudoestegames.com/play/ball.png')
		//RemoteLoader.load('http://icons.iconarchive.com/icons/martin-berube/sport/128/Baseball-icon.png')

		//LocalLoader.load('ball_png_blob') // broken
		//LocalLoader.load('ball_2_png_blob') // broken
		//LocalLoader.load('ball_3_png_blob') // broken
		//LocalLoader.load('baseball_icon_png_blob') // ok
		LocalLoader.load('Glow_Ball_icon_120_png_blob') // ok with changes in ogl2/textureimpl
		//LocalLoader.load('gimp_ball_pot_png_blob') // ok
			//.flatMap(ImageBuilder.convertPng)

//		LocalLoader.load('baseball_icon_128_bmp_blob') //
		//LocalLoader.load('grid_5_png_blob') //

			.flatMap(ImageBuilder.convertPng)
			.handle(function( o : Outcome<Image, String> /*image : Image*/ ) {
				switch (o) {
					case Success(image): remoteImage = image;
					case Failure(error): trace(error);
				}
			});
    }

	override function renderG2( g : kha.graphics2.Graphics ) {
        g.begin(true, remoteImage != null ? Color.White : Color.Magenta);
			if (remoteImage != null) {
				g.drawImage(remoteImage, (bb.width - remoteImage.width) / 2, (bb.height - remoteImage.height) / 2);
			}
        g.end();
    }
}

class Main {
	static inline var width = 512;
	static inline var height = 512;

	public static function main() {
		System.init({ title : 'remote asset loading', width : width, height : height}, system_initializedHandler);
	}

	static function system_initializedHandler() {
		//SampleApplication.bbScale = 0.25;
		new RemoteAssetLoading(width, height);
	}
}
