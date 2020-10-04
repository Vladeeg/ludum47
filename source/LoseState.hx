package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flixel.FlxState;

class LoseState extends FlxState
{
	var typeText:FlxTypeText;

	override function create()
	{
		typeText = new FlxTypeText(15, 10, FlxG.width - 30, "You died...\nRestart? [Y/N]", 16, true);

		typeText.delay = 0.05;
		typeText.eraseDelay = 0.2;
		typeText.showCursor = false;
		typeText.cursorBlinkSpeed = 1.0;
		typeText.autoErase = true;
		typeText.waitTime = 2.0;
		typeText.setTypingVariation(0.75, true);
		typeText.color = FlxColor.WHITE;
		typeText.skipKeys = ["SPACE"];

		add(typeText);
        typeText.start(0.02);
        StateFactory.resetState();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([Y]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new Level(1));
			});
		}
		else if (FlxG.keys.anyJustPressed([N]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new MainMenuState());
			});
		}
		super.update(elapsed);
	}
}
