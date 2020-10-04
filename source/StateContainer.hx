package;

class StateContainer
{
	public var oldmanDead:Bool;
	public var fairyDead:Bool;
	public var princessDead:Bool;
	public var gotSword:Bool;
	public var playerHealth:Int;
	public var run:Int;
	public var swordTutorialListened:Bool;
	public var tutorialListened:Bool;
	public var toldAboutLoop:Bool;
	public var princessSaveText:Bool;
	public var failure:Bool;

	public function new()
	{
		oldmanDead = false;
		fairyDead = false;
		princessDead = false;
		gotSword = false;
		playerHealth = 3;
		run = 0;
		swordTutorialListened = false;
		tutorialListened = false;
		toldAboutLoop = false;
		princessSaveText = false;
		failure = false;
	}

	public function nastyDealsDone() {
		var ret = 0;
		if (fairyDead) {
			++ret;
		}
		if (oldmanDead) {
			++ret;
		}
		if (princessDead)
		{
			++ret;
		}
		return ret;
	}
}
