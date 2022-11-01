GymMode
================================================================================

Beginner-friendly Northstar server mod, where your maximum HP adjusts at every kill and death.

If a match has only beginners or average players in it,
most players will float around 70-130 HP.
If a veteran player joins the match, others get more HP after deaths,
while the veteran player can end up with very low HP.
This means the beginners can still practice the game,
while the veteran player has to practice better movement to avoid dying,
and better aim to kill the high-HP enemies.

This also works as a soft anti-cheat against aimbotters,
since cheaters tend to have bad movement and thus can't survive well with low HP.

Default settings
--------------------------------------------------------------------------------

  * You start from 100 HP
  * A kill reduces your maximum HP by 10 points
  * A death (non-suicide) increases your maximum HP by 10 points
  * Minimum HP is 10, and maximum HP is 200
  * Kraber and Charge Rifle deal 120 damage

See [mod.json](./mod.json) for tuning.
