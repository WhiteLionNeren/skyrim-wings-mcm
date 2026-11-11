# Wings - MCM

**Work in progress: not ready for general use yet.** This mod has only been tried in a single short game session so far.
Expect bugs, and keep a save from before you install it. Bug reports are welcome.

A small MCM for [Animated Wings Ultimate](https://www.nexusmods.com/skyrimspecialedition/mods/34571) (AWU) when you fly
with [WingFlight](https://www.nexusmods.com/skyrimspecialedition/mods/194587). Get the wings without crafting their tomes
at a forge, and have them put away automatically when you aren't using them.

## What it does

The MCM is called **Wings**:

- **Know Rite of Wings (your wings):** adds or removes AWU's Rite of Wings spell, normally learned from a tome you craft at a
  forge. Casting it opens AWU's wing menu, where you pick a pair.
- **Know Endowment of Wings (NPC wings):** adds or removes the spell that gives wings to the NPC you cast it on.
- **Summoning / dispelling wings costs ingredients:** AWU's own two settings, here for convenience (they're also in AWU's
  MCM).
- **Put wings away when not in use** (on by default) and **...after on the ground for** (4 s by default, 1-30 s): once
  you've been on the ground that long (not flying, jumping, swimming or riding), it uses AWU's own free wing toggle to put
  them away; AWU remembers the pair. Your next **Jump** brings them back, so jumping again in the air takes off as usual.
  Wings you put away yourself (with AWU's toggle key or power) stay away.

## Requirements

- [SKSE64](https://skse.silverlock.org/)
- [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
- [Animated Wings Ultimate](https://www.nexusmods.com/skyrimspecialedition/mods/34571), the **"No Flying Mod Integration"**
  file (1.3.0 tested).
- [WingFlight](https://www.nexusmods.com/skyrimspecialedition/mods/194587) for flying (0.4.1 tested). Without it the menu
  still works, but auto-hide can't tell that you're flying.

## Installation

Install the archive with your mod manager (Mod Organizer 2, Vortex), or copy its contents into your game's `Data` folder.
Then enable `Wings - MCM.esp`.

## Compatibility

- **Game 1.6.1170.** Only tried briefly so far (see the note at the top).
- `Wings - MCM.esp` is a light plugin (ESL) that only needs Skyrim.esm. It adds one quest for the MCM and changes no
  vanilla records. You can add it to an existing save; the MCM appears after a few seconds.
- Load order doesn't matter: the mod finds Animated Wings Ultimate while the game runs. If AWU isn't installed, the MCM
  page says so.

## Credits and permissions

By WhiteLionNeren and Claude (Anthropic).

Works with [Animated Wings Ultimate](https://www.nexusmods.com/skyrimspecialedition/mods/34571) by Anton and Delta 6 and
[WingFlight](https://www.nexusmods.com/skyrimspecialedition/mods/194587) by RoVerehr. Requires
[SKSE64](https://skse.silverlock.org/) by the SKSE team and [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
by the SkyUI team. None of their files are included.

Source code: https://github.com/WhiteLionNeren/skyrim-wings-mcm (public domain, Unlicense). You may reupload, modify,
translate or include this mod in a collection without asking.

<!-- end of the Nexus description: everything below is GitHub only -->

## Building from source

- **Plugin:** `./build.sh "PATH/TO/Skyrim Special Edition/Data"` runs `plugin/build.cs`, a one-file
  [Mutagen](https://github.com/Mutagen-Modding/Mutagen) script (needs the .NET 10 SDK; `dotnet run` fetches Mutagen),
  and writes `data/Wings - MCM.esp`. Only `Skyrim.esm` is read.
- **Scripts:** compile `data/Source/Scripts/*.psc` with the Creation Kit's Papyrus compiler. The imports need the vanilla
  script sources (shipped with the Creation Kit) and SkyUI's `SKI_ConfigBase`, `SKI_QuestBase` and `SKI_ConfigManager`
  sources (from the SkyUI SDK, or decompiled from SkyUI's BSA); those are other authors' files and aren't included here.
  For example, from the game folder:

  ```
  "Papyrus Compiler\PapyrusCompiler.exe" "<repo>\data\Source\Scripts" -all -f="TESV_Papyrus_Flags.flg"
      -i="<repo>\data\Source\Scripts;<SkyUI SDK sources>;Data\Source\Scripts" -o="<repo>\data\Scripts"
  ```

The `.pex` files in `data/Scripts/` were compiled from these sources. The release zip holds the contents of `data/`.

## Technical details

- The plugin has one start-game-enabled quest with the MCM script (`WingsMCM`, extends `SKI_ConfigBase`) and a forced
  "Player" alias running SkyUI's `SKI_PlayerLoadGameAlias` and `WingsAutoHide`.
- AWU's forms are read with `Game.GetFormFromFile` from `Animated Wings Ultimate.esp`: Rite of Wings 0xA58, Endowment of
  Wings 0xA54, the free wing toggle 0xA5C, and the two ingredient-cost globals 0x863 / 0x864.
- WingFlight's flight state is read from its behaviour-graph variable `Wingflight_IsFlying`.

## License

Public domain ([Unlicense](LICENSE)). Animated Wings Ultimate, WingFlight and SkyUI belong to their authors; none of their
files are included.
