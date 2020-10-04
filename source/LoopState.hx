package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flixel.FlxState;

class LoopState extends FlxState
{
	var youveWon:FlxTypeText;
	var challengesText:FlxText;
	var tooltip:FlxText;
	var canContinue:Bool;

	override function create()
	{
		youveWon = new FlxTypeText(15, 10, FlxG.width - 30, "You've won...\nOr are you?..", 16, true);

		youveWon.delay = 0.05;
		youveWon.eraseDelay = 0.2;
		youveWon.showCursor = false;
		youveWon.cursorBlinkSpeed = 1.0;
		youveWon.autoErase = true;
		youveWon.waitTime = 2.0;
		youveWon.setTypingVariation(0.75, true);
		youveWon.color = FlxColor.WHITE;
		youveWon.skipKeys = ["SPACE"];

		add(youveWon);

		tooltip = new FlxText();
		tooltip.text = "Press SPACE to continue";
		tooltip.visible = false;
		tooltip.screenCenter();
		tooltip.y = FlxG.height - tooltip.height - 10;
		add(tooltip);

		challengesText = new FlxText(15, youveWon.y + youveWon.height * 2 + 5, FlxG.width - 30);
		challengesText.text = "Nasty deals done:";
		if (StateFactory.getState().fairyDead) {
			challengesText.text += "\n- Fairy is dead.";
		}
		if (StateFactory.getState().oldmanDead)
		{
			challengesText.text += "\n- Old man is dead.";
		}
		if (StateFactory.getState().princessDead)
		{
			challengesText.text += "\n- Princess is dead.";
		}
		challengesText.visible = false;
		add(challengesText);

		youveWon.start(null, false, false, null, function() {
			if (StateFactory.getState().nastyDealsDone() > 0) {
				challengesText.visible = true;
			}
			canContinue = true;
			tooltip.visible = true;
		});
		
		StateFactory.getState().run += 1;
		StateFactory.getState().gotSword = false;
		StateFactory.getState().tutorialListened = false;
		StateFactory.getState().swordTutorialListened = false;
		StateFactory.getState().princessSaveText = false;
		StateFactory.getState().playerHealth = 3;

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (canContinue && FlxG.keys.anyJustPressed([SPACE]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
			{
				FlxG.switchState(new Level(1));
			});
		}
		super.update(elapsed);
	}
}
