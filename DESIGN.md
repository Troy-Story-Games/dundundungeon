# Dun Dun Dungeon!

"Dun Dun Dungeon" will be the Troy Story Games submission for the 2022 Godot Wild game jam #45. Due May 22nd, 2022 at 4PM EST.

This is a **draf document**. All points are subject to change. This initial version represents the rantings of only one (half) of the developers.

# Overview

Dun Dun Dungeon will be a Virtual Reality rogue-like dungeon crawler with procedurally generated dungeon layouts composed of a series of pre-made rooms and hallways connected by doors to travel between them.

The core mechanics will be: movement and combat (both melee and ranged).

# Gameplay

The player will always start the game in the same room; the "starting room". 

## Starting room

The room will consist of:

* A door that the player will walk through to begin a run (locked until at least 1 weapon selected).
* A dummy enemy that can be used for practice (won't attack back). If the enemy is killed it will respawn.
* A table of weapons to choose from
* A menu screen with settings and a quit button that will immediately exit the game
* A menu screen directly next to the other with the current control layout based on the settings

The player will be able to pick up to 2 weapons (1 minimum) from the starting room to use on their run.

### Settings Menu

The settings menu will be the default menu in the starting room. Settings will be:

* Movement type
* Weapon hold or toggle (hold grip or toggle with grip)

### Controls Menu

This menu will display the 3D models of the quest controllers with arrows and text boxes off each button saying what they do. This will update based on the settings.

### Default controls

* Left controller grip, materialize left weapon (unless magic)
* Right controller grip, materialize right weapon (unless magic)
* Left thumb stick - glide or teleport movement
* Right thumb stick - 45/90 degree rotation or dash movement?
* Triggers - weapon specific
    * Magic - requires both controllers, hold triggeres with hands close together to charge magic. Once fully charges, use trigger on the magic hand to fire.
    * Sword - Trigger does nothing
    * Bow and arrow - In the hand holding the arrow, grab the arrow by pulling trigger over either shoulder, draw the bow, release trigger to fire

## Weapons

The following weapons will be available (all starting at level 1)

* Sword
* Shield
* Bow and arrows (counts as 1 weapon)
* Magic

Picking up the weapon in VR selects it for the run. The player can select at most 2 and as few as 1 weapon for their run in any combination from the list above.

Equiping the weapon will involve holding the grip button on the controller. While holding grip, the weapon will materialize. When the player lets go of the grip, the weapon will dissappear, allowing them to use their hands in VR to pick things up and whatnot. NOTE: There will need to be a setting to change it from "hold grip" to "toggle" so that people who don't love holding down the grip button can be happy.

### Sword

Basic melee weapon. Swing it around and hit enemies with it

### Shield

Basic defensive weapon. Hold it up to block light attacks or reduce the damage taken from heavy attacks

### Bow and arrows

Basic ranged weapon. Arrows are infinite. They can be pulled from either shoulder. Hold arrow tip in a torch for flaming arrow.

### Magic

The hand that selects the magic will become magical. Magic will be a ranged weapon that deals splash damage/effects around where it lands for an amount of time. The magic attack will have a charge up time that requires both hands (e.g. you can't block with the shield while charging magic). When magic is fully charged, it remains that way until fired.

Examples: Burn, slow, freeze.

## Advancing

### Gold

During a run, the player will encounter enemies. Enemies will drop gold. Gold can be used to buy items/bufs that apply for just one run. Additionally, gold will be in some chests hidden throughout the map in certain rooms.

### Experience

Experience will be tied to the number of rooms cleared in a run (1 experience per room). The player will be able to spend experience on upgrading the weapon's levels to increase the damage they deal. THe higher the level the weapon, the more experience required to unlock it...thus requiring more rooms be cleared or more runs be completed. So it should just scale like that.

## Rooms

There will be a few different room types:

1. Starting room - you always spawn here after dying and when starting the game
2. Regular room (60% of rooms) - 2 to 4 enemies (probably build 2 or 3 different layouts for variety)
3. Hard room (20% of rooms) - 4 to 6 enemies with 25% more health. This room will have a chest with gold in it. Chest will unlock when all enemies are killed.
4. Maze room (15% of rooms) - Series of hallways with a hidden chest and 2 to 4 enemies hiding around corners
5. Bonus room (5% of rooms) - A room where gold can be spent on health or one-time bufs.

percentages are how often they will generate. Bonus rooms cannot generate back-to-back.

## Enemies

3 types of enemies (for initial version, 4 listed)

1. Fast sword enemy
2. Slow sword and shield
3. Archers
4. (not in initial version) Mages

### Fast Sword Enemy

* Holds only a sword.
* Is slightly faster than the player.
* Attack is light: Fully blocked by shield.

### Slow Sword and Shield

* Holds sword and shield.
* Blocks attacks until staggered.
* Can only be hurt when staggered or right before they attack (which causes a stagger) 
* Stagger time depends on damage dealt
* Attack is heavy: Partially blocked by shield.

### Archers

* Attempts to move away from player.
* Fires arrows.
* Arrows can be blocked by shield or doged
* Staggers easily

## Constraints

Here are some constraints we should stick to in order to avoid taking on more than we can handle.

* No bosses - It's gonna be hard enough to do a procedurally generated infinite dungeon. If we add a boss room, then we have to have some "level 2" with different looking dungeon rooms...that's too much. Also this will allow us to make more enemy types and not worry about complicated boss AI with fancy special attacks and behavior
* The "magic" option for this initial version should just be **one type of simple magic** that does generic splash damage. No slow/burn/freeze...just explode with some splash damage and be done.
* No hands - Colored spheres for hands should be good enough for this version. Figuring out how to make hands that move around seems like a waste of time, especially given the art style and assets we picked don't have detailed human hands.
* Procedural generation should be linear - Each room will have the entrance and the exit, not multiple exits. Eventually it'd be cool the have multiple exits.
* Quest-only for now - Don't bother with other headsets
