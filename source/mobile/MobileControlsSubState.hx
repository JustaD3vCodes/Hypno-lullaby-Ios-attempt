package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import mobile.flixel.FlxButton;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
import openfl.utils.Assets;

class MobileControlsSubState extends FlxSubState
{
	final controlsItems:Array<String> = ['Pad-Right', 'Pad-Left', 'Pad-Custom', 'Pad-Duo', 'Hitbox', 'HitboxAlt', 'Keyboard'];

	var grpControlsItems:FlxText;
	var virtualPad:FlxVirtualPad;
	var hitbox:FlxHitbox;
	var upPozition:FlxText;
	var downPozition:FlxText;
	var leftPozition:FlxText;
	var rightPozition:FlxText;
	var bPozition:FlxText;
	var funitext:FlxText;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var curSelected:Int = 0;
	var buttonBinded:Bool = false;
	var bindButton:FlxButton;
	var resetButton:FlxButton;
	public static var bPosX:Float;
	public static var bPosY:Float;

	override function create()
	{
		if (FlxG.save.data.bPosX != null && FlxG.save.data.bPosY != null)
		{
			bPosX = FlxG.save.data.bPosX;
			bPosY = FlxG.save.data.bPosY;
		}

		for (i in 0...controlsItems.length)
			if (controlsItems[i] == MobileControls.mode)
				curSelected = i;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height,
			FlxColor.fromHSB(FlxG.random.int(0, 359), FlxG.random.float(0, 0.8), FlxG.random.float(0.3, 1)));
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		var exitButton:FlxButton = new FlxButton(FlxG.width - 200, 50, 'Exit', function()
		{
			FlxG.save.data.bPosX = bPosX;
			FlxG.save.data.bPosY = bPosY;
			FlxG.save.flush();

			MobileControls.mode = controlsItems[Math.floor(curSelected)];

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
				MobileControls.customVirtualPad = virtualPad;

			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		});
		exitButton.setGraphicSize(Std.int(exitButton.width) * 3);
		exitButton.label.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, CENTER, true);
		exitButton.color = FlxColor.YELLOW;
		add(exitButton);

		resetButton = new FlxButton(exitButton.x, exitButton.y + 100, 'Reset', function()
		{
			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom' && resetButton.visible) // being sure about something
			{
				MobileControls.customVirtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				reloadMobileControls('Pad-Custom');
			}
		});
		resetButton.setGraphicSize(Std.int(resetButton.width) * 3);
		resetButton.label.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, CENTER, true);
		resetButton.color = FlxColor.RED;
		resetButton.visible = false;
		add(resetButton);

		virtualPad = new FlxVirtualPad(NONE, NONE);
		virtualPad.visible = false;
		add(virtualPad);

		if (FlxG.save.data.bPosX != null && FlxG.save.data.bPosY != null)
		{
			virtualPad.buttonB.x = bPosX;
			virtualPad.buttonB.y = bPosY;
		}

		hitbox = new FlxHitbox(false);

		hitbox.visible = false;
		add(hitbox);

		funitext = new FlxText(0, 50, 0, 'No Android Controls!', 42);
		funitext.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		funitext.borderSize = 3;
		funitext.borderQuality = 1;
		funitext.screenCenter();
		funitext.visible = false;
		add(funitext);

		grpControlsItems = new FlxText(0, 100, 0, '', 42);
		grpControlsItems.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		grpControlsItems.borderSize = 3;
		grpControlsItems.borderQuality = 1;
		grpControlsItems.screenCenter(X);
		add(grpControlsItems);

		leftArrow = new FlxSprite(grpControlsItems.x - 60, grpControlsItems.y - 25);
		leftArrow.frames = FlxAtlasFrames.fromSparrow(Assets.getBitmapData('assets/mobile/menu/arrows.png'), Assets.getText('assets/mobile/menu/arrows.xml'));
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(grpControlsItems.x + grpControlsItems.width + 10, grpControlsItems.y - 25);
		rightArrow.frames = FlxAtlasFrames.fromSparrow(Assets.getBitmapData('assets/mobile/menu/arrows.png'), Assets.getText('assets/mobile/menu/arrows.xml'));
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.play('idle');
		add(rightArrow);

		bPozition = new FlxText(10, FlxG.height - 4, 0, '', 21);
		bPozition.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		bPozition.borderSize = 3;
		bPozition.borderQuality = 1;
		add(rightPozition);

		rightPozition = new FlxText(10, FlxG.height - 24, 0, '', 21);
		rightPozition.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		rightPozition.borderSize = 3;
		rightPozition.borderQuality = 1;
		add(rightPozition);

		leftPozition = new FlxText(10, FlxG.height - 44, 0, '', 21);
		leftPozition.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		leftPozition.borderSize = 3;
		leftPozition.borderQuality = 1;
		add(leftPozition);

		downPozition = new FlxText(10, FlxG.height - 64, 0, '', 21);
		downPozition.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		downPozition.borderSize = 3;
		downPozition.borderQuality = 1;
		add(downPozition);

		upPozition = new FlxText(10, FlxG.height - 84, 0, '', 21);
		upPozition.setFormat(Assets.getFont('assets/mobile/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		upPozition.borderSize = 3;
		upPozition.borderQuality = 1;
		add(upPozition);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		grpControlsItems.text = controlsItems[curSelected].toUpperCase();
		grpControlsItems.screenCenter(X);
		leftArrow.x = grpControlsItems.x - 60;
		rightArrow.x = grpControlsItems.x + grpControlsItems.width + 10;

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(leftArrow) && touch.justPressed)
				changeSelection(-1);
			else if (touch.overlaps(rightArrow) && touch.justPressed)
				changeSelection(1);

			if (buttonBinded)
			{
				if (touch.justReleased)
				{
					bindButton = null;
					buttonBinded = false;
				}
				else
					moveButton(touch, bindButton);
			}
			else
			{

				if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
				{
					if (virtualPad.buttonUp.justPressed)
						moveButton(touch, virtualPad.buttonUp);
					if (virtualPad.buttonDown.justPressed)
						moveButton(touch, virtualPad.buttonDown);
					if (virtualPad.buttonRight.justPressed)
						moveButton(touch, virtualPad.buttonRight);

					if (virtualPad.buttonLeft.justPressed)
						moveButton(touch, virtualPad.buttonLeft);
				}

				if (virtualPad.buttonB.justPressed)
					moveButton(touch, virtualPad.buttonB);
			}
		}

		if (virtualPad != null)
		{
			if (virtualPad.buttonB != null)
				rightPozition.text = 'BUTTON B X:' + virtualPad.buttonB.x + ' Y:' + virtualPad.buttonB.y;
		
			if (virtualPad.buttonUp != null)
				upPozition.text = 'BUTTON UP X:' + virtualPad.buttonUp.x + ' Y:' + virtualPad.buttonUp.y;

			if (virtualPad.buttonDown != null)
				downPozition.text = 'BUTTON DOWN X:' + virtualPad.buttonDown.x + ' Y:' + virtualPad.buttonDown.y;

			if (virtualPad.buttonLeft != null)
				leftPozition.text = 'BUTTON LEFT X:' + virtualPad.buttonLeft.x + ' Y:' + virtualPad.buttonLeft.y;

			if (virtualPad.buttonRight != null)
				rightPozition.text = 'BUTTON RIGHT X:' + virtualPad.buttonRight.x + ' Y:' + virtualPad.buttonRight.y;
			
			bPosX = virtualPad.buttonB.x;
			bPosY = virtualPad.buttonB.y;
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = controlsItems.length - 1;

		if (curSelected >= controlsItems.length)
			curSelected = 0;

		var daChoice:String = controlsItems[Math.floor(curSelected)];

		reloadMobileControls(daChoice);

		funitext.visible = daChoice == 'Keyboard';
		resetButton.visible = daChoice == 'Pad-Custom';
		upPozition.visible = daChoice == 'Pad-Custom';
		downPozition.visible = daChoice == 'Pad-Custom';
		leftPozition.visible = daChoice == 'Pad-Custom';
		rightPozition.visible = daChoice == 'Pad-Custom';
	}

	function moveButton(touch:FlxTouch, button:FlxButton):Void
	{
		bindButton = button;
		bindButton.x = touch.x - Std.int(bindButton.width / 2);
		bindButton.y = touch.y - Std.int(bindButton.height / 2);
		buttonBinded = true;
	}

	function reloadMobileControls(daChoice:String):Void
	{
		switch (daChoice)
		{
			case 'Pad-Right':
				hitbox.visible = false;
				remove(virtualPad);
				virtualPad = new FlxVirtualPad(RIGHT_FULL, B);
				add(virtualPad);
			case 'Pad-Left':
				hitbox.visible = false;
				remove(virtualPad);
				virtualPad = new FlxVirtualPad(LEFT_FULL, B);
				add(virtualPad);
			case 'Pad-Custom':
				hitbox.visible = false;
				remove(virtualPad);
				virtualPad = MobileControls.customVirtualPad;
				add(virtualPad);
			case 'Pad-Duo':
				hitbox.visible = false;
				remove(virtualPad);
				virtualPad = new FlxVirtualPad(BOTH_FULL, B);
				add(virtualPad);
			case 'Hitbox':
				hitbox = new FlxHitbox(false);
				hitbox.visible = true;
				remove(virtualPad);
				virtualPad = new FlxVirtualPad(NONE, B);
				add(virtualPad);
			case 'HitboxAlt':
				hitbox = new FlxHitbox(true);
				hitbox.visible = true;
			case 'Keyboard':
				hitbox.visible = false;
				virtualPad.visible = false;
		}
	}
}
