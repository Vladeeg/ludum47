package enemies.states;

class Conditions
{
	public static function seesPlayer(owner:Enemy):Bool
	{
		return owner.seesPlayer;
	}

	public static function notSeesPlayer(owner:Enemy):Bool
	{
		return !seesPlayer(owner);
	}

	public static function dead(owner:Enemy):Bool
	{
		return owner.health <= 0;
	}

	public static function animationFinished(owner:Enemy):Bool
	{
		return owner.animation.finished;
	}
}
