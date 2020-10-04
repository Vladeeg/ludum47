package;

import enemies.Enemy;
import player.Player;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.util.FlxColor;
import flixel.FlxG;

class Utils
{
	public static function touchPortal(player:Player, portal:Portal)
	{
		if (player.alive && player.exists && portal.alive && portal.exists)
		{
			player.active = false;
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				switchToLevel(portal);
			});
		}
	}

	public static function switchToLevel(portal:Portal)
	{
		FlxG.switchState(Levels.get(portal.to, portal.playerX, portal.playerY));
	}

	public static function addPortal(portals:FlxTypedGroup<Portal>, entity:EntityData)
	{
		portals.add(new Portal(entity.x, entity.y, entity.values.to, entity.values.playerX, entity.values.playerY));
	}

	public static function addEnemy(enemies:FlxTypedGroup<Enemy>, entity:EntityData)
	{
        
    }
    
    public static function addNpc(npcs:FlxTypedGroup<Enemy>, entity:EntityData) {
        
    }
}
