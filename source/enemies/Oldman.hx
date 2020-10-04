package enemies;

class Oldman extends Enemy {
    public function new(x:Int, y:Int, ?dead:Bool = false) {
        super(x, y);

        SPEED = 0;
        health = 1;
        loadGraphic("assets/images/oldman.png", true, 32, 32);
		animation.add("stay", [0], 12, false);
		animation.add("walk", [0], 6, false);
		animation.add("die", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 12, false);
		animation.add("hurt", [3, 4]);
        animation.add("dead", [12]);
		animation.add("speaking", [0, 1, 2], 12, true);
        
        if (dead) {
            animation.play("dead");
            kill();
        }
    }

    override function kill() {
        super.kill();
        StateFactory.getState().oldmanDead = true;
    }
}