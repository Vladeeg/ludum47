package enemies.slime;

import flixel.math.FlxPoint;
import flixel.FlxObject;

class Slime extends Enemy
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/slime.png", true, 32, 32);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setSize(20, 20);
		offset.set(6, 12);
		animation.add("walk", [0, 1, 2], 12, false);
		animation.add("stay", [0]);
		animation.add("die", [3, 4, 5], 6, false);
		animation.add("hurt", [3]);
		animation.add("dead", [5]);

		SPEED = 100;
		drag.x = drag.y = 1600;

		playerPosition = FlxPoint.get();
		seesPlayer = false;

		health = 1;

		invincibleSecs = 0;
		dealsDamage = true;
	}
}
