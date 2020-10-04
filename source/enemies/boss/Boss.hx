package enemies.boss;

import enemies.states.Idle;
import enemies.states.Chasing;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Boss extends Enemy
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/boss.png", true, 128, 128);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setSize(100, 100);
		offset.set(14, 0);
		animation.add("walk", [0, 1, 2], 8, false);
		animation.add("stay", [0, 1, 2], 8, false);
		animation.add("die", [3, 4, 5], 8, false);
		animation.add("hurt", [3, 4, 5], 8, false);
		animation.add("dead", [4]);
		animation.add("startAttack", [6, 7], 10, false);
		animation.add("attack", [8, 9], 10, false);

		SPEED = 140;
		drag.x = drag.y = 1600;

		playerPosition = FlxPoint.get();
		seesPlayer = false;

		health = 5;
		strong = true;

		invincibleSecs = 0;

		brain.transitions.add(Chasing, StartAttack, Conditions.attacking)
			.add(StartAttack, Attacking, enemies.states.Conditions.animationFinished)
			.add(Attacking, Chasing, enemies.states.Conditions.animationFinished);
	}
}

class Conditions {
	public static function attacking(owner:Enemy) {
		return owner.attacking;
	}
}

class StartAttack extends FlxFSMState<Enemy> {
	override function enter(owner:Enemy, fsm:FlxFSM<Enemy>) {
		owner.animation.play("startAttack");
	}
}


class Attacking extends FlxFSMState<Enemy> {
	override function enter(owner:Enemy, fsm:FlxFSM<Enemy>) {
		owner.dealsDamage = true;
		owner.animation.play("attack");
	}

	override function exit(owner:Enemy) {
		owner.attacking = false;
		owner.dealsDamage = false;
		owner.cooldown = 0.25;
	}
}