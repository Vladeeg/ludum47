package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var healths:Array<FlxSprite>;

	public function new()
	{
		super();

		healths = new Array<FlxSprite>();
		addHealths();
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHud()
	{
		for (_ in healths)
		{
			remove(healths.pop());
		}
		addHealths();
	}

	private function addHealths()
	{
		for (i in 0...StateFactory.getState().playerHealth)
		{
			var hpSprite = new FlxSprite(5 + (i * 10), 5);
			hpSprite.loadGraphic("assets/images/health.png", false, 8, 8);
			healths.push(hpSprite);
			add(hpSprite);
		}
	}
}
