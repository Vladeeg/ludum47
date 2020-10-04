package enemies.states;

import flixel.math.FlxVelocity;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;

class Chasing extends FlxFSMState<Enemy>
{
	override public function update(elapsed:Float, owner:Enemy, fsm:FlxFSM<Enemy>):Void
	{
		if (owner.invincibleSecs <= 0) {
			FlxVelocity.moveTowardsPoint(owner, owner.playerPosition, Std.int(owner.SPEED));

			if (owner.alive)
			{
				if (owner.velocity.x != 0 || owner.velocity.y != 0)
				{
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
