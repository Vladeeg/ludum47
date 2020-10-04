package enemies.states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;

class Idle extends FlxFSMState<Enemy>
{
	var moveDirection:Float;

	override public function update(elapsed:Float, owner:Enemy, fsm:FlxFSM<Enemy>):Void
	{
		if (owner.invincibleSecs <= 0)
		{
			if (owner.idleTimer <= 0)
			{
				if (FlxG.random.bool(1))
				{
					moveDirection = -1;
					owner.velocity.x = owner.velocity.y = 0;
				}
				else
				{
					moveDirection = FlxG.random.int(0, 8) * 45;

					owner.velocity.set(owner.SPEED, 0);
					owner.velocity.rotate(FlxPoint.weak(), moveDirection);
				}
				owner.idleTimer = FlxG.random.int(1, 4);
			}
			else
				owner.idleTimer -= elapsed;

			if (owner.alive) {
				if (owner.velocity.x != 0 || owner.velocity.y != 0) {
					owner.animation.play("walk");
				}
				else
				{
					owner.animation.play("stay");
				}
			}
		}
	}
}