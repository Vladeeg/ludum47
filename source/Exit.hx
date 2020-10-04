package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite
{
	public var to:Int;
	public var playerX:Float;
	public var playerY:Float;

	public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.TRANSPARENT);
	}
}
