package enemies.states;

import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;

class Dying extends FlxFSMState<Enemy>
{
	override function enter(owner:Enemy, fsm:FlxFSM<Enemy>)
	{
		owner.animation.play("die");
		owner.kill();
	}
}