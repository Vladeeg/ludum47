package win;

import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class WinState extends FlxState {
    var fsm:FlxFSM<WinState>;
    public var background:FlxSprite;
    public var phrases:Array<Phrase>;
    public var currentIndex:Int;
    public var displayedText:FlxTypeText;
    public var finished:Bool;
	
    override public function create() {
        
        FlxG.camera.bgColor = FlxColor.BLACK;
		background = new FlxSprite();
		background.loadGraphic("assets/images/ending.png", true, 320, 224);
		background.animation.add("0", [0]);
		background.animation.add("1", [1]);
		background.animation.add("2", [2]);
		background.animation.add("3", [3]);
		background.animation.add("4", [4]);
        background.animation.add("5", [5]);
        background.animation.play("0");
        add(background);
        
		var dummySpeaker = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		phrases = [
            new Phrase(dummySpeaker, "And so the hero managed to break the loop and leave the dungeon."),
			new Phrase(dummySpeaker, "But he felt guilty: all he was fighting for was destroyed with his own hands."),
			new Phrase(dummySpeaker, "An innocent princess was killed."),
			new Phrase(dummySpeaker, "A wise old man who gave him the weapon to fight against evil is dead."),
			new Phrase(dummySpeaker, "Even the little fairy is dead now."),
			new Phrase(dummySpeaker, "Isn't it making him villain itself?..")
		];
        
        currentIndex = 0;
        displayedText = new FlxTypeText(
            background.x + 75,
            background.y + 20,
            Std.int(FlxG.width - 150),
            phrases[0].text
        );
		displayedText.delay = 0.05;
		displayedText.eraseDelay = 0.2;
		displayedText.showCursor = false;
		displayedText.cursorBlinkSpeed = 1.0;
		displayedText.autoErase = true;
		displayedText.waitTime = 2.0;
		displayedText.setTypingVariation(0.75, true);
		displayedText.color = FlxColor.WHITE;
		displayedText.skipKeys = ["SPACE"];
        add(displayedText);

        finished = false;
        
        fsm = new FlxFSM<WinState>(this);
        fsm.transitions.add(Speaking, Spoke, Conditions.phraseFinished)
            .add(Spoke, ChangePhrase, Conditions.next)
            .add(ChangePhrase, Speaking, Conditions.true_)
            .add(Spoke, Close, Conditions.ended)
            .start(Speaking);

		super.create();
    }

    override function update(elapsed:Float) {
        fsm.update(elapsed);
        super.update(elapsed);
    }
}

class Conditions {
    public static function phraseFinished(owner:WinState) {
        return owner.finished;
    }

    public static function next(owner:WinState) {
		return FlxG.keys.anyJustPressed([SPACE]) && !_ended(owner);
    }

    public static function true_(owner:WinState) {
        return true;
    }

    public static function ended(owner:WinState) {
		return FlxG.keys.anyJustPressed([SPACE]) && _ended(owner);
    }

    private static function _ended(owner:WinState) {
		return owner.currentIndex == owner.phrases.length - 1;
    }
}

class Speaking extends FlxFSMState<WinState> {
    override function enter(owner:WinState, fsm:FlxFSM<WinState>) {
        // var sp = owner.phrases[owner.currentIndex].speaker;
        // sp.x = (owner.displayedText.y - sp.width) / 2 - 20;
        // sp.y = owner.displayedText.y;
        // sp.animation.play("speaking", true);
        // owner.add(sp);
		// FlxG.camera.fade(FlxColor.BLACK, 0.33, true);// function()
		// {
            // FlxG.camera.alpha
            owner.displayedText.start(null, false, false, null, function() {
                owner.finished = true;
                // sp.animation.play("stay");
            });
        // });
    }
}

class Spoke extends FlxFSMState<WinState> {}

class ChangePhrase extends FlxFSMState<WinState> {
    override function enter(owner:WinState, fsm:FlxFSM<WinState>) {
        // FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
			owner.remove(owner.phrases[owner.currentIndex].speaker);
            owner.finished = false;
			owner.currentIndex++;
			owner.background.animation.play(Std.string(owner.currentIndex));
			var p = owner.phrases[owner.currentIndex];
			owner.displayedText.resetText(p.text);
            // FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
        // });
    }
}

class Close extends FlxFSMState<WinState> {
    override function enter(owner:WinState, fsm:FlxFSM<WinState>) {
        // owner.close();
        FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
            FlxG.switchState(new MainMenuState());
        });
    }
}

class Phrase {
    public var speaker:FlxSprite;
    public var text:String;

    public function new(speaker:FlxSprite, text:String) {
        this.speaker = speaker;
        this.text = text;
    }
}
