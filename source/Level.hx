package;

import win.WinState;
import dummyplayer.DummyPlayer;
import dummyprincess.DummyPrincess;
import princess.Princess;
import dummyboss.DummyBoss;
import dummyoldman.DummyOldman;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import enemies.Oldman;
import flixel.util.FlxColor;
import enemies.boss.Boss;
import enemies.slime.Slime;
import flixel.math.FlxVelocity;
import fairy.Fairy;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import enemies.Enemy;
import player.Player;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class Level extends FlxState
{
	var playerX:Float;
	var playerY:Float;
	var number:Int;
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var portals:FlxTypedGroup<Portal>;
	var exits:FlxTypedGroup<Exit>;
	var enemies:FlxTypedGroup<Enemy>;
	var swords:FlxTypedGroup<Sword>;
	var fairy:Fairy;
	var hud:HUD;
	var boss:Boss;
	var oldman:Oldman;
	var princess:Princess;

	var oldmanSpoke:Bool;

	public function new(number:Int = 1, playerX:Float = -1, playerY:Float = -1)
	{
		this.playerX = playerX;
		this.playerY = playerY;
		this.number = number;
		super();
	}

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		var effectStrengthMod = StateFactory.getState().nastyDealsDone();
		var glitch = new FlxGlitchEffect(effectStrengthMod, 6);
		var rainbow = new FlxRainbowEffect(0.1 * effectStrengthMod, 0.1 * effectStrengthMod, effectStrengthMod);

		map = new FlxOgmo3Loader("assets/data/levels.ogmo", "assets/data/room-" + number + ".json");
		walls = map.loadTilemap("assets/images/tiles.png", "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		var mapCopy = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		for (i in 0...walls.widthInTiles) {
			for (j in 0...walls.heightInTiles) {
				mapCopy.stamp(walls.tileToSprite(i, j, -1), 16 * i, 16 * j);
			}
		}
		var effects = new FlxEffectSprite(mapCopy);
		effects.effects = [rainbow, glitch];
		add(effects);

		portals = new FlxTypedGroup<Portal>();
		exits = new FlxTypedGroup<Exit>();
		enemies = new FlxTypedGroup<Enemy>();
		swords = new FlxTypedGroup<Sword>();
		player = new Player();
		map.loadEntities(placeEntities, "entities");
		
		add(portals);
		add(exits);
		add(enemies);
		add(swords);
		add(player);
		
		if (!StateFactory.getState().fairyDead) {
			fairy = new Fairy(player.x - 10, player.y - 10, player.SPEED);
			add(fairy);
		}
		if (StateFactory.getState().gotSword)
		{
			add(player.weapon);
		}

		FlxG.camera.follow(player, TOPDOWN, 1);

		hud = new HUD();
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, portals, Utils.touchPortal);

		FlxG.collide(enemies, walls);
		FlxG.overlap(enemies, enemies, collideEnemies);

		FlxG.overlap(player, enemies, hurtPlayer);
		FlxG.overlap(enemies, player.weapon, hurtEnemy);
		enemies.forEachAlive(checkEnemyVision);
		enemies.forEachAlive(enemyAttack);

		FlxG.overlap(player, swords, getSword);
		FlxG.overlap(player, exits, triggerExit);
		
		if (fairy != null && fairy.alive && fairy.exists) {
			FlxG.overlap(player.weapon, fairy, killFairy);
			var v = new FlxVector();
			v.addPoint(player.getMidpoint());
			v.subtractPoint(fairy.getMidpoint());

			if (v.length > player.width * 1.5)
			{
				FlxVelocity.moveTowardsPoint(fairy, player.getMidpoint(), Std.int(player.SPEED * 0.66));
			}
		}

		if (princess != null && princess.alive && princess.exists)
		{
			FlxG.overlap(player.weapon, princess, killPrincess);
			var v = new FlxVector();
			v.addPoint(player.getMidpoint());
			v.subtractPoint(princess.getMidpoint());
			if (v.length > player.width * 1.5)
			{
				FlxVelocity.moveTowardsPoint(princess, player.getMidpoint(), Std.int(player.SPEED * 0.66));
			}
		}

		if (!player.alive) {
			FlxG.switchState(new LoseState());
		}

		if (princess != null && princess.alive)
		{
			// player.active = false;
			var s = StateFactory.getState();
			if (!s.princessSaveText)
			{
				s.princessSaveText = true;
				var phrases:Array<Dialog.Phrase> = [];
				var dummyPrincess = new DummyPrincess(0, 0, 0);
				phrases.push(new Dialog.Phrase(dummyPrincess, "Oh, a hero!"));
				phrases.push(new Dialog.Phrase(dummyPrincess, "You've came to save me?"));
				phrases.push(new Dialog.Phrase(dummyPrincess, "Let's get out of this scary place!"));

				if (phrases.length > 0)
				{
					openSubState(new Dialog(phrases));
				}
			}
		}

		if (number == 2) {
			if (oldman != null && oldman.alive && !oldmanSpoke) {
				oldmanSpoke = true;
				var phrases:Array<Dialog.Phrase> = [];
				var dummyOldman = new DummyOldman(0, 0, 0);
				if (!StateFactory.getState().gotSword)
				{
					phrases.push(new Dialog.Phrase(dummyOldman, "It's dangerous to go alone, take this!"));
				}
				if (StateFactory.getState().fairyDead)
				{
					phrases.push(new Dialog.Phrase(dummyOldman, "Where are your kind fairy helper?"));
				}
				if (phrases.length > 0)
				{
					openSubState(new Dialog(phrases));
				}
			}

			var s = StateFactory.getState();

			if (fairy != null && fairy.alive && StateFactory.getState().gotSword && !s.swordTutorialListened) {
				s.swordTutorialListened = true;
				var phrases:Array<Dialog.Phrase> = [];
				var dummyFairy = new Fairy(0, 0, 0);
				phrases.push(new Dialog.Phrase(dummyFairy, "You have a sword now!"));
				phrases.push(new Dialog.Phrase(dummyFairy, "Press [X] to attack!"));
				if (phrases.length > 0)
				{
					openSubState(new Dialog(phrases));
				}
			}
		}

		if (number == 1 && fairy != null && fairy.alive)
		{
			var s = StateFactory.getState();
			if (!s.tutorialListened) {
				s.tutorialListened = true;
				var phrases:Array<Dialog.Phrase> = [];
				var dummyFairy = new Fairy(0, 0, 0);

				if (s.run > 0 && s.nastyDealsDone() <= 0)
				{
					var dummyPlayer = new DummyPlayer(0, 0, 0);
					phrases.push(new Dialog.Phrase(dummyPlayer, "There should be a way to escape..."));
					phrases.push(new Dialog.Phrase(dummyPlayer, "Maybe I need to act a little... different?"));
				}
				phrases.push(new Dialog.Phrase(dummyFairy, "Hello, brave hero!\n\n(press [SPACE] to go to next phrase)"));
				phrases.push(new Dialog.Phrase(dummyFairy, "I'll be your little advisor!"));
				phrases.push(new Dialog.Phrase(dummyFairy, "You can use ARROW KEYS to move around."));
				phrases.push(new Dialog.Phrase(dummyFairy, "We've got our princess kidnapped, and so we need your help to rescue her!"));
				phrases.push(new Dialog.Phrase(dummyFairy, "Now go to the next room and listen to the old wiseacre!"));

				if (phrases.length > 0)
				{
					openSubState(new Dialog(phrases));
				}
			}
		}

		if (StateFactory.getState().nastyDealsDone() > 0 && !StateFactory.getState().failure) {
			StateFactory.getState().failure = true;
			var phrases:Array<Dialog.Phrase> = [];
			var dummyBoss = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.TRANSPARENT);
			var dummyPlayer = new DummyPlayer(0, 0, 0);

			phrases.push(new Dialog.Phrase(dummyBoss, "> Program failure..."));
			phrases.push(new Dialog.Phrase(dummyBoss, "> Time loop stability decreased!"));
			phrases.push(new Dialog.Phrase(dummyPlayer, "So I need to become..."));
			phrases.push(new Dialog.Phrase(dummyPlayer, "Evil?"));
			if (phrases.length > 0)
			{
				openSubState(new Dialog(phrases));
			}
		}
	}

	public function triggerExit(player, exit) {
		if (player.active) {
			player.active = false;
			var s = StateFactory.getState();
			if (s.nastyDealsDone() >= 3) {
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					FlxG.switchState(new WinState());
				});
			}
			else if (!s.toldAboutLoop)
			{
				s.toldAboutLoop = true;
				var phrases:Array<Dialog.Phrase> = [];
				var dummyBoss = new DummyBoss(0, 0, 0);
				phrases.push(new Dialog.Phrase(dummyBoss, "You've defeated me!"));
				phrases.push(new Dialog.Phrase(dummyBoss, "But don't rejoice too soon!"));
				phrases.push(new Dialog.Phrase(dummyBoss, "I've set up a time loop, so you'll never escape this dungeon!"));
				phrases.push(new Dialog.Phrase(dummyBoss, "Mu-ha-ha-ha!"));
				if (phrases.length > 0)
				{
					openSubState(new Dialog(phrases, function()
					{
						FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
						{
							FlxG.switchState(new LoopState());
						});
					}));
				}
			}
			else
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					FlxG.switchState(new LoopState());
				});
			}
		}
	}

	public function killFairy(weapon:FlxSprite, fairy:Fairy) {
		if (StateFactory.getState().run > 0 &&
			weapon.alive &&
			weapon.exists &&
			fairy.alive &&
			fairy.exists &&
			player.attacking)
		{
			fairy.takeDamage(1, player.getMidpoint());
			StateFactory.getState().fairyDead = true;
			fairy.velocity.x = fairy.velocity.y = 0;
		}
	}

	public function killPrincess(weapon:FlxSprite, princess:Princess)
	{
		if (StateFactory.getState().run > 0 &&
			weapon.alive &&
			weapon.exists &&
			princess.alive &&
			princess.exists &&
			player.attacking)
		{
			princess.takeDamage(1);
			StateFactory.getState().princessDead = true;
			// princ.velocity.x = fairy.velocity.y = 0;
		}
	}

	public function getSword(player:Player, sword:Sword) {
		if (player.alive && player.exists && sword.alive && sword.exists)
		{
			sword.kill();
			add(player.weapon);
			player.weapon.alive = true;
			StateFactory.getState().gotSword = true;
		}
	}

	public function collideEnemies(enemyL:Enemy, enemyR:Enemy) {
		if (enemyL.alive && enemyL.exists && enemyR.alive && enemyR.exists) {
			FlxObject.separate(enemyL, enemyR);
		}
	}

	public function hurtEnemy(enemy:Enemy, weapon:FlxSprite)
	{
		if (enemy.alive && enemy.exists && weapon.alive && weapon.exists && player.attacking)
		{
			if (enemy != oldman || StateFactory.getState().run > 0)
				enemy.takeDamage(1, player.getMidpoint());
		}
	}

	public function hurtPlayer(player:Player, enemy:Enemy)
	{
		if (enemy.alive && enemy.exists && player.alive && player.exists && enemy.dealsDamage)
		{
			player.takeDamage(1, enemy.getMidpoint());
			hud.updateHud();
			if (enemy.strong) {
				FlxG.camera.shake(0.01);
			}
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	function enemyAttack(enemy:Enemy) {
		var v = new FlxVector();
		v.addPoint(enemy.getMidpoint());
		v.subtractPoint(player.getMidpoint());

		if (v.length < enemy.width * 1.5) {
			enemy.tryAttack();
		}
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				if (playerX == -1 || playerY == -1)
					player.setPosition(entity.x + 6, entity.y + 12);
				else
					player.setPosition(playerX + 6, playerY + 12);
			case "portal":
				portals.add(new Portal(entity.x, entity.y, entity.values.to, entity.values.playerX, entity.values.playerY));
			case "enemy":
				switch (entity.values.type)
				{
					case "slime":
						enemies.add(new Slime(entity.x + 6, entity.y + 12));
					case "boss":
						boss = new Boss(entity.x + 14, entity.y);
						enemies.add(boss);
				}
			case "oldman":
				oldman = new Oldman(entity.x, entity.y, StateFactory.getState().oldmanDead);
				enemies.add(oldman);
				
				if (!StateFactory.getState().gotSword) {
					var sword = new Sword();
					sword.x = entity.x;
					sword.y = entity.y + sword.height * 0.5;
					swords.add(sword);
				}
			case "princess":
				princess = new Princess(entity.x, entity.y, player.SPEED, StateFactory.getState().princessDead);
				add(princess);
			case "exit":
				exits.add(new Exit(entity.x, entity.y));
		}
	}
}
