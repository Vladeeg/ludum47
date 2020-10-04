package;

import flixel.FlxSprite;

class Sword extends FlxSprite {
    public function new(?x:Float = 0, ?y:Float = 0) {
        super(x, y);
        loadGraphic("assets/images/sword.png");
    }
}