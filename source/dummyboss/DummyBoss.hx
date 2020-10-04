package dummyboss;

import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;

class DummyBoss extends FlxSprite
{
	var brain:FlxFSM<DummyBoss>;

	public function new(?x:Float, ?y:Float, playerSpeed:Float)
	{
		super(x, y);

		loadGraphic("assets/images/boss.png", true, 128, 128);
		animation.add("speaking", [3, 4, 5], 12, true);
		animation.add("stay", [4], 6, false);
	}

	override function update(elapsed:Float)
	{
		// brain.update(elapsed);
		super.update(elapsed);
	}
}
