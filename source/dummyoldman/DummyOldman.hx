package dummyoldman;

import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;

class DummyOldman extends FlxSprite
{
	var brain:FlxFSM<DummyOldman>;

	public function new(?x:Float, ?y:Float, playerSpeed:Float)
	{
		super(x, y);

		loadGraphic("assets/images/oldman.png", true, 32, 32);
		animation.add("speaking", [0, 1, 2], 12, true);
		animation.add("stay", [0], 6, false);

        health = 1;

        maxVelocity.x = maxVelocity.y = playerSpeed * 0.66;
        drag.x = drag.y = maxVelocity.x * 2;
    }

    override function update(elapsed:Float) {
        // brain.update(elapsed);
        super.update(elapsed);
    }
}
