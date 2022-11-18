package meta.state;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import lime.graphics.opengl.GL;
import meta.MusicBeat.MusicBeatState;
#if sys
import sys.io.File;
#end

class ShaderState extends MusicBeatState
{
	override public function create()
	{
		var centerText:FlxText = new FlxText().setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);
		centerText.text = 'throw me the file that got dumped\nin your fuckin root folder\nplease and thanks\n';
		centerText.screenCenter();
		add(centerText);

		#if sys
		File.saveContent(SUtil.getPath() + 'glsl.txt', Json.stringify({
			SHADING_LANGUAGE_VERSION: GL.SHADING_LANGUAGE_VERSION,
			CURRENT_PROGRAM: GL.CURRENT_PROGRAM,
			VERSION: GL.VERSION,
			FLOAT_VERSION: GL.version,
		}));
		#end
	}
}
