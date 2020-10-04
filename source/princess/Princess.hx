package princess;

import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;

class Princess extends FlxSprite
{
	var brain:FlxFSM<Princess>;

	public function new(?x:Float, ?y:Float, playerSpeed:Float, ?dead:Bool = false)
	{
		super(x, y);

		loadGraphic("assets/images/princess.png", true, 32, 32);
		animation.add("stay", [0]);
		animation.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 12, false);
		animation.add("dead", [15]);

        health = 1;
		brain = new FlxFSM<Princess>(this);
        brain.transitions.add(Idle, Dying, Conditions.dead)
            .add(Dying, Dead, Conditions.animationFinished);
			
		if (dead)
		{
			animation.play("dead");
			alive = false;
			brain.transitions.start(Dead);
		} else {
			brain.transitions.start(Idle);
		}

        maxVelocity.x = maxVelocity.y = playerSpeed * 0.4;
		drag.x = drag.y = maxVelocity.x * 2;

    }

    override function update(elapsed:Float) {
        brain.update(elapsed);
        super.update(elapsed);
    }
    
	public function takeDamage(damage:Float)
	{
        health -= damage;
        alive = false;
	}
}

class Conditions
{
	public static function dead(owner:Princess)
	{
		return owner.health <= 0;
	}

	public static function animationFinished(owner:Princess)
	{
		return owner.animation.finished;
	}
}

class Idle extends FlxFSMState<Princess>
{
	override function enter(owner:Princess, fsm:FlxFSM<Princess>)
	{
		owner.animation.play("stay");
    }
    
    override function update(elapsed:Float, owner:Princess, fsm:FlxFSM<Princess>) {
        owner.animation.play("stay");
    }
}

class Dying extends FlxFSMState<Princess>
{
	override function enter(owner:Princess, fsm:FlxFSM<Princess>)
	{
		owner.animation.play("die");
	}
}

class Dead extends FlxFSMState<Princess>
{
	override function enter(owner:Princess, fsm:FlxFSM<Princess>)
	{
		// owner.kill();
		owner.animation.play("dead");
	}
}
