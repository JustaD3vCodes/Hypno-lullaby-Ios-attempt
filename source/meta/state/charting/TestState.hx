package meta.state.charting;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import meta.MusicBeat.MusicBeatState;

class TestState extends MusicBeatState
{
	override public function create()
	{
		super.create();
		FlxG.mouse.useSystemCursor = false;
		FlxG.mouse.visible = true;

		generateBackground();

		var songMusic:FlxSound = new FlxSound().loadEmbedded(Paths.inst('isotope', false), false, true);
		FlxG.sound.list.add(songMusic);

		var visualiser:FlxGraphicsShader = new FlxGraphicsShader('', Paths.shader('visualizer'));
		var falseGraphic:FlxSprite = new FlxSprite().makeGraphic(1280, 720);
		falseGraphic.shader = visualiser;
		add(falseGraphic);
		// FlxG.camera.setFilters();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function generateBackground()
	{
		// var coolGrid = new FlxBackdrop(null, 1, 1, true, true, 1, 1);
		// coolGrid.loadGraphic(Paths.image('UI/forever/base/chart editor/grid'));
		// coolGrid.alpha = (32 / 255);
		// add(coolGrid);

		// gradient
		var coolGradient = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height,
			FlxColor.gradient(FlxColor.fromRGB(188, 158, 255, 200), FlxColor.fromRGB(80, 12, 108, 255), 16));
		coolGradient.alpha = (32 / 255);
		add(coolGradient);
	}
}
