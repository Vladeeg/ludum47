package enemies;

import enemies.states.Dead;
import enemies.states.Dying;
import enemies.states.Conditions;
import enemies.states.Chasing;
import enemies.states.Idle;
import flixel.addons.util.FlxFSM;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Enemy extends FlxSprite
{
	public var SPEED:Float;
	public var playerPosition:FlxPoint;
	public var seesPlayer:Bool;
	public var MAX_INVINCIBLE_SECS = 0.5;
	public var invincibleSecs:Float;

	var brain:FlxFSM<Enemy>;

	public var attacking:Bool;
	public var cooldown:Float;
	public var idleTimer:Float = 0;
	public var dealsDamage:Bool;
	public var strong:Bool = false;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		brain = new FlxFSM<Enemy>(this);
		brain.transitions.add(Idle, Chasing, Conditions.seesPlayer)
			.add(Chasing, Idle, Conditions.notSeesPlayer)
			.add(Chasing, Dying, Conditions.dead)
			.add(Idle, Dying, Conditions.dead)
			.add(Dying, Dead, Conditions.animationFinished)
			.start(Idle);
	}

	public function takeDamage(damage:Float, hurtPoint:FlxPoint)
	{
		if (alive && invincibleSecs <= 0)
		{
			health -= damage;
			animation.play("hurt");
			invincibleSecs = MAX_INVINCIBLE_SECS;
			var a = new FlxVector();
			a.addPoint(getMidpoint());
			a.subtractPoint(hurtPoint);
			velocity.set(SPEED * 3, 0);
			velocity.rotate(FlxPoint.weak(), a.degrees);
		}
	}

	override function kill()
	{
		this.alive = false;
	}

	public function tryAttack()
	{
		if (alive && invincibleSecs <= 0 && cooldown <= 0)
		{
			attacking = true;
		}
	}

	function updateMovement()
	{
		if ((velocity.x != 0 || velocity.y != 0))
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (invincibleSecs > 0)
		{
			invincibleSecs -= elapsed;
		}
		if (cooldown > 0)
		{
			cooldown -= elapsed;
		}
		updateMovement();
		brain.update(elapsed);
		super.update(elapsed);
	}
}
