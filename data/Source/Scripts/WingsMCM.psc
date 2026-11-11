Scriptname WingsMCM extends SKI_ConfigBase
{MCM "Wings": teaches or removes Animated Wings Ultimate's two wing spells without crafting their
tomes at a forge, and switches AWU's ingredient cost for summoning/dispelling wings. AWU is looked up at runtime
(Game.GetFormFromFile), so it is not a master; the page says so when it isn't loaded.}

bool Property AutoHide = true Auto
float Property HideDelay = 4.0 Auto

int oRite
int oEndow
int oIngredients
int oDispelIngredients
int oAutoHide
int oHideDelay

Spell Function AWUSpell(int formId)
	Return Game.GetFormFromFile(formId, "Animated Wings Ultimate.esp") as Spell
EndFunction

GlobalVariable Function AWUGlobal(int formId)
	Return Game.GetFormFromFile(formId, "Animated Wings Ultimate.esp") as GlobalVariable
EndFunction

Event OnConfigInit()
	ModName = "Wings"
	Pages = new string[1]
	Pages[0] = "Wings"
EndEvent

Event OnPageReset(string a_page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)
	Actor player = Game.GetPlayer()
	Spell rite = AWUSpell(0x000A58)
	Spell endow = AWUSpell(0x000A54)
	AddHeaderOption("Animated Wings Ultimate", 0)
	If !rite || !endow
		AddTextOption("Animated Wings Ultimate.esp is not loaded", "", OPTION_FLAG_DISABLED)
		Return
	EndIf
	oRite = AddToggleOption("Know Rite of Wings (your wings)", player.HasSpell(rite), 0)
	oEndow = AddToggleOption("Know Endowment of Wings (NPC wings)", player.HasSpell(endow), 0)
	oIngredients = AddToggleOption("Summoning wings costs ingredients", AWUGlobal(0x000863).GetValueInt() != 0, 0)
	oDispelIngredients = AddToggleOption("Dispelling wings costs ingredients", AWUGlobal(0x000864).GetValueInt() != 0, 0)
	oAutoHide = AddToggleOption("Put wings away when not in use", AutoHide, 0)
	int delayFlags = 0
	If !AutoHide
		delayFlags = OPTION_FLAG_DISABLED
	EndIf
	oHideDelay = AddSliderOption("...after on the ground for", HideDelay, "{0} s", delayFlags)
	AddEmptyOption()
	AddTextOption("Cast Rite of Wings to pick a pair.", "", OPTION_FLAG_DISABLED)
	AddTextOption("More wing options: MCM > Animated Wings Ultimate.", "", OPTION_FLAG_DISABLED)

	SetCursorPosition(1)
	AddHeaderOption("WingFlight", 0)
	AddTextOption("Take off", "Jump, then jump in the air", OPTION_FLAG_DISABLED)
	AddTextOption("Other flight keys: WingFlight's settings.", "", OPTION_FLAG_DISABLED)
	AddTextOption("Land before saving.", "", OPTION_FLAG_DISABLED)
EndEvent

Event OnOptionSelect(int a_option)
	Actor player = Game.GetPlayer()
	If a_option == oRite || a_option == oEndow
		Spell s = AWUSpell(0x000A58)
		If a_option == oEndow
			s = AWUSpell(0x000A54)
		EndIf
		If player.HasSpell(s)
			player.RemoveSpell(s)
		Else
			player.AddSpell(s, false)
		EndIf
		SetToggleOptionValue(a_option, player.HasSpell(s), false)
	ElseIf a_option == oAutoHide
		AutoHide = !AutoHide
		SetToggleOptionValue(a_option, AutoHide, false)
		If AutoHide
			SetOptionFlags(oHideDelay, 0, false)
		Else
			SetOptionFlags(oHideDelay, OPTION_FLAG_DISABLED, false)
		EndIf
	ElseIf a_option == oIngredients || a_option == oDispelIngredients
		GlobalVariable g = AWUGlobal(0x000863)
		If a_option == oDispelIngredients
			g = AWUGlobal(0x000864)
		EndIf
		g.SetValueInt((g.GetValueInt() == 0) as int)
		SetToggleOptionValue(a_option, g.GetValueInt() != 0, false)
	EndIf
EndEvent

Event OnOptionSliderOpen(int a_option)
	If a_option == oHideDelay
		SetSliderDialogStartValue(HideDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(1.0, 30.0)
		SetSliderDialogInterval(1.0)
	EndIf
EndEvent

Event OnOptionSliderAccept(int a_option, float a_value)
	If a_option == oHideDelay
		HideDelay = a_value
		SetSliderOptionValue(a_option, a_value, "{0} s", false)
	EndIf
EndEvent

Event OnOptionHighlight(int a_option)
	If a_option == oRite
		SetInfoText("Adds or removes AWU's Rite of Wings spell (normally learned from a tome crafted at a forge). Casting it opens AWU's wing menu.")
	ElseIf a_option == oEndow
		SetInfoText("Adds or removes Endowment of Wings: gives wings to the NPC you cast it on.")
	ElseIf a_option == oAutoHide
		SetInfoText("Puts AWU's wings away once you have been on the ground (not flying, jumping, swimming or riding) for a few seconds. Your next jump brings them back, so jump again in the air to take off as usual. Wings you put away yourself stay away.")
	ElseIf a_option == oHideDelay
		SetInfoText("How long the wings stay out after you land before they are put away.")
	ElseIf a_option == oIngredients
		SetInfoText("AWU's own setting (also in its MCM): summoning wings with Rite of Wings uses up ingredients.")
	ElseIf a_option == oDispelIngredients
		SetInfoText("AWU's own setting (also in its MCM): dispelling wings uses up ingredients.")
	EndIf
EndEvent
