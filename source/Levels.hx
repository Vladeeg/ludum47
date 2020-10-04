package;

import flixel.FlxState;

class Levels
{
	public static function get(n:Int, playerX: Float, playerY: Float):FlxState
	{
		return new Level(n, playerX, playerY);
	}
}
