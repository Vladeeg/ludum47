package dummyprincess;

import flixel.FlxSprite;

class DummyPrincess extends FlxSprite
{
	public function new(?x:Float, ?y:Float, playerSpeed:Float)
	{
		super(x, y);

		loadGraphic("assets/images/princess.png", true, 32, 32);
		animation.add("speaking", [1], 12, true);
		animation.add("stay", [1], 6, false);
	}
}
