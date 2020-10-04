package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Portal extends FlxSprite
{
	public var to:Int;
	public var playerX:Float;
	public var playerY:Float;

	public function new(x:Int = 0, y:Int = 0, to:Int, playerX:Float, playerY:Float)
	{
		super(x, y);
		this.to = to;
		this.playerX = playerX;
		this.playerY = playerY;
		makeGraphic(16, 16, FlxColor.TRANSPARENT);
	}
}
