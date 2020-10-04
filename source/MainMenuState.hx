package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class MainMenuState extends FlxState {
    override function create() {
        var txt = new FlxText();
        txt.text = "Press [SPACE] to play";
        txt.screenCenter();
        add(txt);
        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.anyJustPressed([SPACE])) {
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new Level(1));
			});
        }
        super.update(elapsed);
    }
}