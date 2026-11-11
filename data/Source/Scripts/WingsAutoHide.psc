Scriptname WingsAutoHide extends ReferenceAlias
{Wings - MCM 1.1.0: puts the wings away when not in use. Once Animated Wings Ultimate's
wings have been out of use for a few seconds (not flying in WingFlight, not jumping, not swimming), this casts AWU's own
free wing toggle (Wings, 0xA5C) to put them away; AWU remembers the pair. The next Jump press casts it again, so the
wings are back before the second, in-air Jump that WingFlight needs to take off. Only wings this script hid come back
on their own; wings put away with AWU's toggle key or power stay away. Settings: the MCM "Wings" (WingsMCM).
WingFlight's state is its behaviour-graph flag Wingflight_IsFlying (injected by its BehaviorDataInjector file).}

bool hiddenByUs = false
float groundSeconds = 0.0
float Property TickSeconds = 1.0 AutoReadOnly

Event OnInit()
	Start()
EndEvent

Event OnPlayerLoadGame()
	Start()
EndEvent

Function Start()
	groundSeconds = 0.0
	If hiddenByUs
		RegisterForControl("Jump")
	EndIf
	RegisterForSingleUpdate(TickSeconds)
EndFunction

Keyword Function Presence()
	Return Game.GetFormFromFile(0x000800, "Animated Wings Ultimate.esp") as Keyword
EndFunction

Spell Function ToggleSpell()
	Return Game.GetFormFromFile(0x000A5C, "Animated Wings Ultimate.esp") as Spell
EndFunction

Event OnUpdate()
	WingsMCM mcm = GetOwningQuest() as WingsMCM
	Actor player = GetReference() as Actor
	Keyword presence = Presence()
	If !mcm || !player || !presence
		RegisterForSingleUpdate(10.0)
		Return
	EndIf
	If mcm.AutoHide && player.HasMagicEffectWithKeyword(presence)
		bool inUse = player.GetAnimationVariableBool("Wingflight_IsFlying") || player.GetAnimationVariableBool("bInJumpState") || player.IsSwimming() || player.IsOnMount()
		If inUse
			groundSeconds = 0.0
		Else
			groundSeconds += TickSeconds
			If groundSeconds >= mcm.HideDelay
				Hide(player)
			EndIf
		EndIf
	Else
		groundSeconds = 0.0
	EndIf
	RegisterForSingleUpdate(TickSeconds)
EndEvent

Function Hide(Actor player)
	Spell toggle = ToggleSpell()
	If toggle
		toggle.Cast(player, player)
		hiddenByUs = true
		groundSeconds = 0.0
		RegisterForControl("Jump")
	EndIf
EndFunction

Event OnControlDown(string control)
	If control != "Jump" || !hiddenByUs
		Return
	EndIf
	Actor player = GetReference() as Actor
	Keyword presence = Presence()
	Spell toggle = ToggleSpell()
	hiddenByUs = false
	UnregisterForControl("Jump")
	groundSeconds = 0.0
	If player && presence && toggle && !player.HasMagicEffectWithKeyword(presence)
		toggle.Cast(player, player)
	EndIf
EndEvent
