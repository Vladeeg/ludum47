package enemies.states;

import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;

class Dead extends FlxFSMState<Enemy>
{
	override function enter(owner:Enemy, fsm:FlxFSM<Enemy>)
	{
		owner.animation.play("dead");
		// owner.kill();
	}
}