package fairy;

import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;

class Fairy extends FlxSprite
{
	var brain:FlxFSM<Fairy>;

	public function new(?x:Float, ?y:Float, playerSpeed:Float)
	{
		super(x, y);

		loadGraphic("assets/images/fairy.png", true, 16, 16);
		animation.add("walk", [0, 1], 6, false);
		animation.add("speaking", [0, 1], 6, false);
		animation.add("stay", [0, 1], 6, false);
		animation.add("die", [2, 3, 4, 5], 6, false);

        health = 1;
		brain = new FlxFSM<Fairy>(this);
        brain.transitions.add(Idle, Dying, Conditions.dead)
            .add(Dying, Dead, Conditions.animationFinished)
            .start(Idle);

        maxVelocity.x = maxVelocity.y = playerSpeed * 0.66;
        drag.x = drag.y = maxVelocity.x * 2;
    }

    override function update(elapsed:Float) {
        brain.update(elapsed);
        super.update(elapsed);
    }
    
	public function takeDamage(damage:Float, hurtPoint:FlxPoint)
	{
        health -= damage;
        var a = new FlxVector();
        a.addPoint(getMidpoint());
        a.subtractPoint(hurtPoint);
        alive = false;
        velocity.set(600, 0);
        velocity.rotate(FlxPoint.weak(), a.degrees);
	}
}

class Conditions
{
	public static function dead(owner:Fairy)
	{
		return owner.health <= 0;
	}

	public static function animationFinished(owner:Fairy)
	{
		return owner.animation.finished;
	}
}

class Idle extends FlxFSMState<Fairy>
{
	override function enter(owner:Fairy, fsm:FlxFSM<Fairy>)
	{
		owner.animation.play("walk");
    }
    
    override function update(elapsed:Float, owner:Fairy, fsm:FlxFSM<Fairy>) {
        owner.animation.play("walk");
    }
}

class Dying extends FlxFSMState<Fairy>
{
	override function enter(owner:Fairy, fsm:FlxFSM<Fairy>)
	{
		owner.animation.play("die");
	}
}

class Dead extends FlxFSMState<Fairy>
{
	override function enter(owner:Fairy, fsm:FlxFSM<Fairy>)
	{
		owner.kill();
	}
}
