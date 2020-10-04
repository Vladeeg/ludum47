package player;

import flixel.math.FlxVector;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	public var SPEED = 200;
	var fsm:FlxFSM<Player>;

	public var weapon:FlxSprite;
	public var attacking:Bool;

	public var MAX_INVINCIBLE_SECS = 0.15;
	public var invincibleSecs:Float;

	public var armored:Bool;
	public var cooldown:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic("assets/images/player.png", true, 32, 32);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setSize(20, 20);
		offset.set(6, 12);
		animation.add("lr", [6, 7, 6, 8], 10, false);
		animation.add("u", [3, 4, 3, 5], 10, false);
		animation.add("d", [0, 1, 0, 2], 10, false);
		animation.add("hurt", [9, 10, 11], 10, false);
		animation.add("die", [9, 10, 11], 10, false);
		animation.add("dead", [6]);

		drag.x = drag.y = 1600;

		fsm = new FlxFSM<Player>(this);
		fsm.transitions.add(General, Attack, Conditions.attack)
			.add(Attack, General, Conditions.attackFinished)
			.add(General, Dying, Conditions.dead)
			.add(Attack, Dying, Conditions.dead)
			.add(Dying, Dead, Conditions.attackFinished)
			.start(General);

		weapon = new FlxSprite(x, y);
		weapon.loadGraphic("assets/images/slash.png", true, 32, 32);
		weapon.animation.add("lr", [6, 7, 8], 12, false);
		weapon.setFacingFlip(FlxObject.LEFT, true, false);
		weapon.setFacingFlip(FlxObject.RIGHT, false, false);
		weapon.setFacingFlip(FlxObject.UP, false, true);
		weapon.setFacingFlip(FlxObject.DOWN, false, false);
		weapon.setSize(10, 32);

		health = StateFactory.getState().playerHealth;
		attacking = false;
		weapon.visible = false;
		weapon.alive = StateFactory.getState().gotSword;
	}

	override function update(elapsed:Float)
	{
		updateMovement();

		if (invincibleSecs > 0)
		{
			invincibleSecs -= elapsed;
		}
		if (cooldown > 0)
		{
			cooldown -= elapsed;
		}
		fsm.update(elapsed);
		weapon.update(elapsed);
		super.update(elapsed);
	}

	public function takeDamage(damage:Float, hurtPoint:FlxPoint)
	{
		if (alive && invincibleSecs <= 0)
		{
			health -= damage;
			StateFactory.getState().playerHealth -= Std.int(damage);
			animation.play("hurt");
			invincibleSecs = MAX_INVINCIBLE_SECS;
			var a = new FlxVector();
			a.addPoint(getMidpoint());
			a.subtractPoint(hurtPoint);
			velocity.set(SPEED * 3, 0);
			velocity.rotate(FlxPoint.weak(), a.degrees);
		}
	}

	private function updateMovement()
	{
		var newAngle:Float = 0;
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (alive && invincibleSecs <= 0)
		{
			if (up || down || left || right)
			{
				if (up)
				{
					newAngle = -90;
					if (left)
						newAngle -= 45;
					else if (right)
						newAngle += 45;
					facing = FlxObject.UP;
				}
				else if (down)
				{
					newAngle = 90;
					if (left)
						newAngle += 45;
					else if (right)
						newAngle -= 45;
					facing = FlxObject.DOWN;
				}
				else if (left)
				{
					newAngle = 180;
					facing = FlxObject.LEFT;
				}
				else if (right)
				{
					newAngle = 0;
					facing = FlxObject.RIGHT;
				}

				// determine our velocity based on angle and speed
				velocity.set(SPEED, 0);
				velocity.rotate(FlxPoint.weak(0, 0), newAngle);
			}
			// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}

		weapon.facing = facing;

		switch (facing)
		{
			case FlxObject.UP:
				weapon.setPosition(this.x - offset.x, this.y - height);
				weapon.angle = -90;
				weapon.setSize(32, 16);
				weapon.offset.set();
			case FlxObject.DOWN:
				weapon.setPosition(this.x - offset.x, this.y + 2 * height - offset.y);
				weapon.angle = 90;
				weapon.setSize(32, 16);
				weapon.offset.set(0, 16);
			case FlxObject.LEFT:
				weapon.setPosition(this.x - width - offset.x, this.y - offset.y);
				weapon.angle = 0;
				weapon.setSize(16, 32);
				weapon.offset.set();
			case FlxObject.RIGHT:
				weapon.setPosition(this.x + 2 * width - offset.x, this.y - offset.y);
				weapon.angle = 0;
				weapon.setSize(16, 32);
				weapon.offset.set(16);
		}
	}
}

class Conditions
{
	public static function attack(owner:Player)
	{
		return (owner.alive && owner.invincibleSecs <= 0) &&
			owner.cooldown <= 0 &&
			owner.weapon.alive &&
			FlxG.keys.anyJustPressed([X]);
	}

	public static function attackFinished(owner:Player)
	{
		return owner.weapon.animation.finished;
	}

	public static function dead(owner:Player) {
		return owner.health <= 0;
	}
}

class General extends FlxFSMState<Player> {}

class Attack extends FlxFSMState<Player>
{
	override function enter(owner:Player, fsm:FlxFSM<Player>)
	{
		owner.attacking = true;
		owner.weapon.visible = true;
		owner.weapon.animation.play("lr");
	}

	override function exit(owner:Player)
	{
		owner.attacking = false;
		owner.weapon.visible = false;
		owner.cooldown = 0.33;
	}
}

class Dying extends FlxFSMState<Player>
{
	override function enter(owner:Player, fsm:FlxFSM<Player>)
	{
		owner.animation.play("die");
	}
}

class Dead extends FlxFSMState<Player>
{
	override function enter(owner:Player, fsm:FlxFSM<Player>)
	{
		owner.animation.play("dead");
		owner.alive = false;
	}
}
