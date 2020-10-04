package;

import flixel.addons.text.FlxTypeText;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Dialog extends FlxSubState {
    var fsm:FlxFSM<Dialog>;
    public var background:FlxSprite;
    public var phrases:Array<Phrase>;
    public var currentIndex:Int;
    public var displayedText:FlxTypeText;
    public var finished:Bool;
	
    public function new(phrases:Array<Phrase>, ?closeCallback:() -> Void) {
        super();

		background = new FlxSprite().makeGraphic(FlxG.width, 80, FlxColor.WHITE);
		background.stamp(new FlxSprite().makeGraphic(FlxG.width, Std.int(background.height - 1), FlxColor.BLACK), 0, 1);
        background.screenCenter();
        background.y = FlxG.height - background.height;
        add(background);

        this.phrases = phrases;
        currentIndex = 0;
        displayedText = new FlxTypeText(
            background.x + 100,
            background.y + 20,
            Std.int(background.width - 150),
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

        this.closeCallback = closeCallback;
        finished = false;
        
        fsm = new FlxFSM<Dialog>(this);
        fsm.transitions.add(Speaking, Spoke, Conditions.phraseFinished)
            .add(Spoke, ChangePhrase, Conditions.next)
            .add(ChangePhrase, Speaking, Conditions.true_)
            .add(Spoke, Close, Conditions.ended)
            .start(Speaking);
    }

    override function update(elapsed:Float) {
        fsm.update(elapsed);
        super.update(elapsed);
    }
}

class Conditions {
    public static function phraseFinished(owner:Dialog) {
        return owner.finished;
    }

    public static function next(owner:Dialog) {
		return FlxG.keys.anyJustPressed([SPACE]) && !_ended(owner);
    }

    public static function true_(owner:Dialog) {
        return true;
    }

    public static function ended(owner:Dialog) {
		return FlxG.keys.anyJustPressed([SPACE]) && _ended(owner);
    }

    private static function _ended(owner:Dialog) {
		return owner.currentIndex == owner.phrases.length - 1;
    }
}

class Speaking extends FlxFSMState<Dialog> {
    override function enter(owner:Dialog, fsm:FlxFSM<Dialog>) {
        var sp = owner.phrases[owner.currentIndex].speaker;
        sp.x = (owner.displayedText.y - sp.width) / 2 - 20;
        sp.y = owner.displayedText.y;
        sp.animation.play("speaking", true);
        owner.add(sp);
		owner.displayedText.start(null, false, false, null, function() {
            owner.finished = true;
            sp.animation.play("stay");
        });
    }
}

class Spoke extends FlxFSMState<Dialog> {}

class ChangePhrase extends FlxFSMState<Dialog> {
    override function enter(owner:Dialog, fsm:FlxFSM<Dialog>) {
		owner.remove(owner.phrases[owner.currentIndex].speaker);
        owner.finished = false;
        owner.currentIndex++;
        var p = owner.phrases[owner.currentIndex];
		owner.displayedText.resetText(p.text);
    }
}

class Close extends FlxFSMState<Dialog> {
    override function enter(owner:Dialog, fsm:FlxFSM<Dialog>) {
        owner.close();
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
