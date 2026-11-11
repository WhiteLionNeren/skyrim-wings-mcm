#:package Mutagen.Bethesda.Skyrim@0.54.4
// Builds "Wings - MCM.esp" (ESL, master Skyrim.esm only): 0x800 WingsMCMQuest, start game enabled, script WingsMCM (SkyUI
// MCM) + forced "Player" alias with SKI_PlayerLoadGameAlias and WingsAutoHide (1.1.0). Usage: dotnet run build.cs -- SKYRIM_DATA_DIR OUT.esp
using Mutagen.Bethesda;
using Mutagen.Bethesda.Plugins;
using Mutagen.Bethesda.Skyrim;

using var skyrim = SkyrimMod.CreateFromBinaryOverlay(new ModPath(Path.Combine(args[0], "Skyrim.esm")), SkyrimRelease.SkyrimSE);
var playerRef = new FormKey(skyrim.ModKey, 0x000014);
var mod = new SkyrimMod(ModKey.FromFileName(Path.GetFileName(args[1])), SkyrimRelease.SkyrimSE);
mod.ModHeader.Flags |= SkyrimModHeader.HeaderFlag.Small;
mod.ModHeader.Author = "WhiteLionNeren & Claude";
mod.ModHeader.Description = "MCM to learn Animated Wings Ultimate's wing spells without crafting their tomes.";
var q = mod.Quests.AddNew("WingsMCMQuest");
q.Flags = Quest.Flag.StartGameEnabled;
q.Priority = 50;
q.NextAliasID = 1;
q.Aliases.Add(new QuestAlias { ID = 0, Name = "Player", Type = QuestAlias.TypeEnum.Reference, ForcedReference = new FormLinkNullable<IPlacedGetter>(playerRef) });
var vm = new QuestAdapter();
vm.Scripts.Add(new ScriptEntry { Name = "WingsMCM" });
var fa = new QuestFragmentAlias { Property = new ScriptObjectProperty { Name = "", Object = new FormLink<ISkyrimMajorRecordGetter>(q.FormKey), Alias = 0 } };
fa.Scripts.Add(new ScriptEntry { Name = "SKI_PlayerLoadGameAlias" });
fa.Scripts.Add(new ScriptEntry { Name = "WingsAutoHide" });  // 1.1.0: puts the wings away when not in use
vm.Aliases.Add(fa);
q.VirtualMachineAdapter = vm;
mod.WriteToBinary(args[1]);
Console.WriteLine($"{args[1]}: {q.FormKey}");
