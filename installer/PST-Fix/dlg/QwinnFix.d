

// Qwinn's Original Fixes

// In the Fixpack readme, there was this:
// "Sometimes all Godsmen in the Foundry would ask you to leave and refuse to talk to you even if you had done nothing wrong. Caused by a bug in
// Thildon's dialog during the murder investigation quest."
// BUG DOCUMENTED BY:  Platter

// This fix confused me severely. See PFixpack.d for explanation of the history here. In Fixpack 1.0 and 2.0, I removed all 3 alarm sets to deal
// with the problem.  I am still removing all 3 alarm sets, but am now replacing them all with a single one which does the same job and has the
// added virtue of not setting both Alarm1 and Alarm2 at the same time. See 3.0 section regarding new Alarm Reset functionality.

// Fixpack 3.0:  Due to conversation with Colin (original designer of the Foundry) the original intent was to have Alarm1 reset to 0 by leaving
// the Foundry and coming back.  This makes sense and should work well.  Making the Foundry reset when you come back.  This fix done in v3.0 section.
ALTER_TRANS DTHILDON BEGIN 22 END BEGIN 0 END BEGIN "ACTION" ~~ END
ALTER_TRANS DTHILDON BEGIN 24 29 END BEGIN 1 END BEGIN "ACTION" ~~ END


// In the Fixpack readme, there was this:
// "If you attacked Hezobol in Carceri through dialog it would increment the global variable "Curst_Counter" when you chose the option "Attack him."
// and then again when you chose the next and only available option "Fight." It should have only been incremented once. This variable keeps track
// of how many things you have done in Carceri to lessen the chaos and weakens Trias the higher it gets."
// BUG DOCUMENTED BY:  Platter
//
// I'm fixing this in a different way. As it stands, you convince the slaver to stop just by saying "I'm here to stop you" as if you raised a good
// argument, after failing three easy stat checks, even though he'll attack you for saying the same thing in a different conversation branch.  No
// longer.  All "I'm here to stop you"'s lead to "Fight" now. "Attack him" immediately ends the conversation and begins battle. I strongly suspect
// that is what was originally intended, and that's why 'Attack' had it's own counter increment. You must actually pass one of the (easy) stat
// checks to settle things peacefully and get the 150,000xp reward now.
ALTER_TRANS DHEZOBOL BEGIN 1 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 2~ END
ALTER_TRANS DHEZOBOL BEGIN 1 END BEGIN 4 END BEGIN "EPILOGUE" ~EXIT~ END


// Mar would never give his reward if you go to Lower Ward after Aola banishes the demon from Moridor's box but before claiming that reward.
// Fixpack Beta tried and failed to fix this properly.
REPLACE_TRANS_TRIGGER DMAR BEGIN 2 END BEGIN 1 END ~Global("Demonbox", "Global",0)~ ~~
ADD_TRANS_TRIGGER DMAR 2 ~!Global("FedEx","GLOBAL",10)~ DO 6


// Additional fixes to Corvus's journal entries (SkardFix also did a couple)
ALTER_TRANS DHGCORV BEGIN 42 END BEGIN 0 1 END BEGIN "JOURNAL" ~~ END
ALTER_TRANS DHGCORV BEGIN 6  END BEGIN 1 END BEGIN "JOURNAL" ~#66534~ END
ALTER_TRANS DHGCORV BEGIN 18 END BEGIN 3 END BEGIN "JOURNAL" ~#36027~ END

// Could only tell Able Ponderthought you were a Godsman if you barely knew anything about them
REPLACE_TRANS_TRIGGER DABLE BEGIN 52 END BEGIN 0 END ~("Join_Godsmen", "GLOBAL", 1)~ ~("Join_Godsmen","GLOBAL",6)~

// In Able's dialogue, fixing the way the Know_Faction variable gets set and checked for, as it makes little sense as is.
// Also adding options to get to the faction menu after asking about the Fraternity of Order, if Know_Factions = 1.
REPLACE_TRIGGER_TEXT DABLE ~Global("Know_Factions", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT  DABLE ~SetGlobal("Know_Factions", "GLOBAL", 1)~ ~~
ADD_TRANS_ACTION DABLE BEGIN 43 END BEGIN 0 END ~SetGlobal("Know_Factions","GLOBAL",1)~
ADD_TRANS_TRIGGER DABLE 63 ~Global("Know_Factions","GLOBAL",1)~ DO 0
EXTEND_TOP DABLE 29 30 #1
  IF ~Global("Know_Factions","GLOBAL",1)~ THEN REPLY #31057 GOTO 50
 END

// Zombie 79 in the mortuary, the one that has the fanged circle inscription that lets you open the ancient copper earring... if you talked to
// him again after opening the earring and examined the fanged circle again, you'd get a conversation path and a journal entry indicating you
// didn't know what the circle was.
ADD_TRANS_TRIGGER DZM79 0 ~Global("Know_Copper_Earring_Secret","GLOBAL",0)~ DO 1


// Various bad transitions between DAETHEL, DTEGARIN and DMORTE's dialogues that were reversed
// and didn't make sense.
ALTER_TRANS DMORTE BEGIN 151 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DTEGARIN 12~ END
ALTER_TRANS DAETHEL BEGIN 10 END BEGIN 1 END BEGIN "EPILOGUE" ~EXTERN DMORTE 151~ END
ALTER_TRANS DTEGARIN BEGIN 18 END BEGIN 0 2 END BEGIN "EPILOGUE" ~EXTERN DMORTE 152~ END


// Epilogues to Annah's interjection when asking Ojo about her were reversed.
ALTER_TRANS DANNAH BEGIN 109 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DOJO 12~ END
ALTER_TRANS DANNAH BEGIN 109 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END


// A whole ton of bugs in Morte's Interactions with Yellow-Finger.  Alignment hits in
// Morte's file are wrong, and both dialogues fail to actually take the money you give
// Yellow Finger away from you.
REPLACE_TRANS_ACTION DMORTE BEGIN 188 END BEGIN 5 END
  ~IncrementGlobalOnce("Good_Yellow_1", "GLOBAL", "Good", "GLOBAL", 1)~ ~~
ADD_TRANS_ACTION DMORTE BEGIN 188 END BEGIN 6 END
  ~IncrementGlobalOnce("Good_Yellow_1","GLOBAL","Good","GLOBAL",1)~
ALTER_TRANS DMORTE BEGIN 188 END BEGIN 4 END BEGIN "REPLY" ~#18578~ END
ADD_TRANS_ACTION DMORTE BEGIN 188 END BEGIN 4 END
  ~IncrementGlobalOnce("Lawful_Yellow_1","GLOBAL","Law","GLOBAL",1)~
ADD_TRANS_ACTION DMORTE BEGIN 193 END BEGIN 0 END ~TakePartyGold(5)~
ADD_TRANS_ACTION DMORTE BEGIN 193 END BEGIN 1 END ~TakePartyGold(50)~
ADD_TRANS_ACTION DMORTE BEGIN 193 END BEGIN 2 END ~TakePartyGold(100)~
ADD_TRANS_ACTION DMORTE BEGIN 193 END BEGIN 3 END ~TakePartyGold(500)~
ADD_TRANS_ACTION DMORTE BEGIN 196 END BEGIN 0 END ~TakePartyGold(5)~
ADD_TRANS_ACTION DMORTE BEGIN 196 END BEGIN 1 END ~TakePartyGold(10)~
ADD_TRANS_ACTION DMORTE BEGIN 196 END BEGIN 2 END
 ~TakePartyGold(50)  IncrementGlobalOnce("Good_Yellow_2","GLOBAL","Good","GLOBAL",1)~
ADD_TRANS_ACTION DMORTE BEGIN 196 END BEGIN 3 END
 ~TakePartyGold(100) IncrementGlobalOnce("Good_Yellow_2","GLOBAL","Good","GLOBAL",1)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 16 END BEGIN 0 END ~TakePartyGold(1)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 16 END BEGIN 1 END ~TakePartyGold(5)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 16 END BEGIN 2 END ~TakePartyGold(50)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 16 END BEGIN 3 END ~TakePartyGold(100)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 16 END BEGIN 4 END ~TakePartyGold(500)~


// Bad item reference in Transcendent One dialogue that would fail to recognize if you had the Blade of Immortals
REPLACE_TRIGGER_TEXT DTRANS ~BladeIm2~ ~BladeIm~


// If Ilquix polymorphed into a Glazebru, and you'd ever talked to Ilquix in his human form, you wouldn't get the fuller description
// the first time you talked to him as a demon. Need to add a variable for this in the .tp2.
REPLACE_TRIGGER_TEXT DILQUIXT ~NumTimesTalkedTo (0)~ ~~
REPLACE_TRIGGER_TEXT DILQUIXT ~NumTimesTalkedToGT (0)~ ~~
ADD_STATE_TRIGGER DILQUIXT 0 ~Global("Ilquix_TalkedToAsDemon","AR0402",0)~ 1 2 3
ADD_STATE_TRIGGER DILQUIXT 4 ~Global("Ilquix_TalkedToAsDemon","AR0402",1)~ 6 7 8
ADD_TRANS_ACTION DILQUIXT BEGIN 0 1 2 3 END BEGIN END ~SetGlobal("Ilquix_TalkedToAsDemon","AR0402",1)~


// DCINDER.DLG
ALTER_TRANS DCINDER BEGIN 23 END BEGIN 1 END BEGIN "JOURNAL" ~~ END


// DDAKKON.DLG
// To complete Skard's "Journal entry for Dakkon translating severed arm tattoo fix"
ALTER_TRANS DDAKKON BEGIN 96 END BEGIN 2 END BEGIN "JOURNAL" ~#24274~ END


// DMORTE.DLG
// An additional occurance of the same error partially fixed in the Fixpack, where a conversation with Yellow-Fingers when Morte was present
// could lead to Sharegrave's dialogue, breaking his quest to find out where Pharod's bodies were coming from.
ALTER_TRANS DMORTE BEGIN 193 END BEGIN 4 END BEGIN "EPILOGUE" ~EXTERN DCOLYLFN 19~ END


// DR_BONE.DLG
// Missing journal entries.
ALTER_TRANS DR_BONE BEGIN 9 11 END BEGIN 0 END BEGIN "JOURNAL" ~#49653~ END


// Fix to DINCAR2, couldn't ask Paranoid Incarnation about the Iannis fire if you confessed it to Iannis
REPLACE_TRIGGER_TEXT DINCAR2 ~Global("Know_Iannis_Fire_Responsible", "GLOBAL", 1)~
                             ~GlobalGT("Know_Iannis_Fire_Responsible","GLOBAL",0)~


// Fixes to DGITH, variable had extra space in it that made you unable to remember learning about Achali-Drowning.  Also, if you said
// "Greetings" when you knew the Gith language, you'd be unable to understand his conversation with Dak'kon.
REPLACE_TRIGGER_TEXT DGITH ~Dictionary_Githzerai_ Achali~ ~Dictionary_Githzerai_Achali~
REPLACE_ACTION_TEXT DGITH ~Dictionary_Githzerai_ Achali~ ~Dictionary_Githzerai_Achali~
ALTER_TRANS DGITH BEGIN 50 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 55~ END


// Fix to DCOAX, "Thanks, Farewell" response led to asking more questions.
// Note that reply 1 doesn't exist until RestoPack extend_tops reply 0, so that has to come first.
ALTER_TRANS DCOAX BEGIN 25 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END


// Fix to DTRANS, variable setting "Crystal_Escape_ Answer" had a space in it.
// Transcendent One won't forget how you escaped the crystal if you tell him now.
// The space was in the wrong place in version 2.0.  Version 3.0 fixed.
REPLACE_ACTION_TEXT DTRANS ~Crystal_Escape _Answer~ ~Crystal_Escape_Answer~


// Craddock pays you twice for working for him and for delivering his message.
ALTER_TRANS DCRADDO BEGIN 17 18 19 END BEGIN 0 1 END BEGIN "ACTION" ~~ END


// Inappropriate and unavoidable morale decrease when Annah catches Drunk Harlot stealing
REPLACE_TRANS_ACTION DANNAH BEGIN 55 END BEGIN 0 END ~MoraleDec ("Annah", 1)~ ~~


// Incorrect trigger in one response when Ash-Mantle asks how you caught on to him.
REPLACE_TRANS_TRIGGER DASHMAN BEGIN 28 END BEGIN 1 END ~Global("Dustman_Pickpocket" , "GLOBAL" , 0)~ ~GlobalGT("Ash_Suspicious","GLOBAL",0)~


// Regarding the option to have Lenny switch your class to thief, the checks for it were on the wrong responses
// VERSION 2.0 adds the trigger to state 40 response 1 that I missed in the earlier run
REPLACE_TRIGGER_TEXT DLENNY ~!Class(Protagonist, Thief)~ ~~
ADD_TRANS_TRIGGER DLENNY 5 ~!Class(Protagonist,Thief)~ DO 2
ADD_TRANS_TRIGGER DLENNY 33 ~!Class(Protagonist,Thief)~ 34 38 40 DO 1


// Completely inexplicably, Jarym (he who wants to buy Moridor's gem) tries to
// "TakePartyItem("RochChrm")" while giving you your reward when you bring him a gem.
// He was probably supposed to give you one, but I'm just going to get rid of that bit
// altogether.
REPLACE_TRANS_ACTION DJARYM BEGIN 8 END BEGIN 0 END ~TakePartyItem("RochChrm")~ ~~


// Marta's Teeth Fix
// Making it so Marta gives you the Teeth of the Viper if you lie to her, as I believe was intended.  See QwinnFix.tph for explanation and more fixes.
REPLACE_TRANS_ACTION DMARTA BEGIN 26 END BEGIN 0 END ~GiveItemCreate("Teeth"~ ~GiveItemCreate("VTeeth"~


// Lenny gives you the starting thief stat boosts when changing you to thief class even when you've
// already received thief training.  You can still get his punch daggers by having him switch you
// to the thief class though.
REPLACE_TRANS_ACTION DLENNY BEGIN 27 END BEGIN 0 END ~SetGlobal("Thief_Training", "GLOBAL", 3)~ ~~
ADD_TRANS_ACTION DLENNY BEGIN 42 END BEGIN 0 END ~SetGlobal("Thief_Training","GLOBAL",3)~
ADD_TRANS_TRIGGER DLENNY 42 ~Global("Thief_Training","GLOBAL",0)~ DO 0
EXTEND_BOTTOM DLENNY 42 #1
  IF ~GlobalGT("Thief_Training","GLOBAL",0) HasItem("Zpunch",Myself)~ THEN REPLY #52392 GOTO 43
 END

// No matter what you do, the Drunk Harlot will start screaming and try to aggro the
// area on you if you talk to her for the first time with Annah in your party... even when
// you practically act as her lawyer, defending her vehemently against Annah's (accurate)
// accusations.  I really don't think this was the intent, the state that does that is
// just tacked on at the end of her file in an almost absent minded way.  It looks like it was
// something they meant to get back to later but never did.  The drunk harlot acts
// intelligently enough when Annah's not there that, if Annah -is- there, she should
// know enough to just thank her good fortune and get out of Dodge.
// Also, the dialogues have Annah doing the "GivePartyGold" option when you get your money back,
// which won't work when coming from her.  It has to be in the Drunk Harlot's dialogue, so something
// like this really is necessary.
// v4.1:  Implementing EscapeAreaRunning.
REPLACE_SAY DHARLOTD 26 @100 // ~The woman nods and runs away hurriedly.  You don't expect to see her again.~
REPLACE_TRANS_ACTION DHARLOTD BEGIN 26 END BEGIN 0 END
   ~Help ()~ ~GivePartyGold(100) SetGlobal("Remove_Drunk_Harlot","GLOBAL",1) EscapeAreaRunning()~
ALTER_TRANS DHARLOTD BEGIN 26 END BEGIN 0 END BEGIN "REPLY" ~#7596~ END
APPEND DHARLOTD
  IF ~~ THEN BEGIN DHARLOTD-NOMONEY
    SAY @100 // ~The woman nods and runs away hurriedly. You don't expect to see her again.~
    IF ~~ THEN REPLY #7596 /* ~Leave.~ */ DO ~Enemy() SetGlobal("Remove_Drunk_Harlot","GLOBAL",1) EscapeAreaRunning()~
       EXIT
  END
END
REPLACE_TRANS_ACTION DANNAH BEGIN 59 END BEGIN 0 END ~GivePartyGold (38)~ ~~
REPLACE_TRANS_ACTION DANNAH BEGIN 62 END BEGIN 0 END
~GivePartyGold (100)
CreatePartyGold(38)~ ~~
ALTER_TRANS DANNAH BEGIN 60 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DHARLOTD DHARLOTD-NOMONEY~ END

// Missing responses prevent you from asking Dak'kon to ask Fell details about the tattoos on your body when
// Dak'kon is translating for you.
EXTEND_TOP DDAKKON 102
  IF ~Global("Know_Dabus_Speak", "GLOBAL", 0)~ THEN REPLY #24893 /* ~"Can he tell me anything about them?"~ */ EXTERN ~DFELL~ 67
  IF ~Global("Know_Dabus_Speak", "GLOBAL", 1)
CheckStatLT (Protagonist, 15, INT)~ THEN REPLY #24894 /* ~"Can he tell me anything about them?"~ */ EXTERN ~DFELL~ 58
  IF ~Global("Know_Dabus_Speak", "GLOBAL", 1)
CheckStatGT (Protagonist, 14, INT)~ THEN REPLY #24895 /* ~"Can he tell me anything about them?"~ */ EXTERN ~DFELL~ 68
 END


// Any progress in Xander's quest to build the Dreambuilder would prevent you from telling Yves the story
// about it.  No longer.
REPLACE_TRIGGER_TEXT DYVES ~Global("Dream", "GLOBAL", 1)~ ~GlobalGT("Dream","GLOBAL",0)~


// Yvana will no longer communicate with and patch things up with Yves instantly, without ever leaving dialogue with you.
// Yvana now won't patch things up till you ask Yves about it.
// Version 3.0:  Bah, didn't work right originally.  Fixed.
ADD_TRANS_ACTION DYVES BEGIN 4 END BEGIN 4 END ~SetGlobal("Yvana","GLOBAL",3)~
REPLACE_TRIGGER_TEXT DYVES ~Global ("Yvana", "GLOBAL", 2)~ ~GlobalGT("Yvana","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DYVANA ~!Global ("Yvana", "GLOBAL", 2)~ ~GlobalLT("Yvana","GLOBAL",2)~
// REPLACE_TRIGGER_TEXT DYVANA ~Global ("Yvana", "GLOBAL", 2)~  ~GlobalGT("Yvana","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DYVANA ~Global ("Yvana", "GLOBAL", 2)~  ~Global("Yvana","GLOBAL",3)~

// Small logic fix to Justifier dialogue (Restoration Pack's version.
ADD_TRANS_TRIGGER DJUSTFER 41 ~False()~ DO 1

// Fhjull's dialogue doesn't register when he's run out of spells, due to a check for a spell he doesn't have.
REPLACE_TRIGGER_TEXT DFHJULL ~Global("Fhjull_Shield", "AR1101", 4)~ ~~


// ===================================== TRIAS DIALOGUE FIXES =============================================

// This response leads back to it's own state (i.e. makes him repeat himself).  Nulling it because I can't
// find an appropriate state to send it to, or an appropriate dialog in the dialog.tlk file either.  Either
// it wasn't implemented or I can't find it.  Too bad, I'd love to know how he intended to fly with burnt wings.
ADD_TRANS_TRIGGER DTRIAS 24 ~False()~ DO 2

// If you had Dak'kon in your party, Trias would completely ignore Grace the entire length of the conversation
// when you first talked to him, which means you'd never get to see a very interesting exchange between the two.
// You'd also get to see conversation paths you apparently shouldn't get when she's in the group, like asking him
// about paradise.
ADD_TRANS_TRIGGER DDAKKON 185 ~!NearbyDialog("DGrace")~ DO 0
EXTEND_BOTTOM DDAKKON 185 IF ~NearbyDialog("DGrace")~ THEN REPLY #54774 EXTERN ~DTRIAS~ 9 END

// You'd sometimes never get Trias's voiced self-introduction or the journal entry you're meant
// to get when you first meet him, depending on party makeup (such as, having Grace but not Morte).
APPEND DTRIAS
  IF ~~ THEN BEGIN NEWTRIAS-1
    SAY #61293
    IF ~~ THEN JOURNAL #54312 EXTERN DGRACE 176
  END
  IF ~~ THEN BEGIN NEWTRIAS-2
    SAY #61293
    IF ~~ THEN JOURNAL #54312 EXTERN DGRACE 177
  END
END
ALTER_TRANS DTRIAS BEGIN 0 END BEGIN 2 END BEGIN "EPILOGUE" ~GOTO NEWTRIAS-1~ END
ALTER_TRANS DTRIAS BEGIN 0 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO NEWTRIAS-2~ END

// Bad epilogue when asking Trias how he was betrayed, and his answer is to how he can be freed
ALTER_TRANS DTRIAS BEGIN 26 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 22~ END

// Grace doesn't warn you about killing Trias in several states
ADD_TRANS_TRIGGER DTRIAS 18 ~!NearbyDialog("DGrace")~ 118 DO 2
EXTEND_TOP DTRIAS 18 118 #3
  IF ~NearbyDialog("DGrace")~ THEN REPLY #61308 EXTERN ~DGRACE~ 181
 END
ADD_TRANS_TRIGGER DTRIAS 17 ~!NearbyDialog("DGrace")~ 118 DO 1
EXTEND_TOP DTRIAS 17 #2
  IF ~NearbyDialog("DGrace")~ THEN REPLY #54416 EXTERN ~DGRACE~ 181
 END

// Bad epilogue that also loses Grace's warning
ALTER_TRANS DTRIAS BEGIN 43 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 40~ END

// After defeating him, if you ask about the keeper first, you're locked out of asking him about
// the fortress.
EXTEND_TOP DTRIAS 104 IF ~~ THEN REPLY #54717 GOTO 58 END


// You wouldn't have the option to ask him several questions if you had Grace in your group, mostly
// about paradise but also several other questions.  You could ask him the -first- time you ever talked to
// him with Grace in your group, but only because of the previous bug regarding Dak'kon.

/* Commenting this out because it's not technically a fix... maybe the designers intended that, if
// Grace was in the group, you were somehow physically prevented from asking Trias about the Upper
// Planes.  *shrug*  Maybe make this a tweak.  Was originally going to put it in the Fixpack, it was
// a lot of work, that's why I'm commenting out rather than deleting.

EXTEND_TOP DTRIAS 34 35 45 52 #4 IF ~~ THEN REPLY #54380 GOTO 16 END
ADD_TRANS_TRIGGER DTRIAS 16 ~!NearbyDialog("DGrace")~ DO 0 1
EXTEND_TOP DTRIAS 16 #2
  IF ~NearbyDialog("DGrace")~ THEN REPLY #54410 GOTO 45
  IF ~NearbyDialog("DGrace")~ THEN REPLY #54411 GOTO 44
 END
ADD_TRANS_TRIGGER DTRIAS 29 ~!NearbyDialog("DGrace")~ 30 31 DO 2
EXTEND_TOP DTRIAS 29 30 31 #3 IF ~NearbyDialog("DGrace")~ THEN REPLY #54464 GOTO 45 END
ADD_TRANS_TRIGGER DTRIAS 23 ~!NearbyDialog("DGrace")~ DO 3
EXTEND_TOP DTRIAS 23 #4 IF ~NearbyDialog("DGrace")~ THEN REPLY #54438 GOTO 45 END
EXTEND_TOP DTRIAS 39 #2
  IF ~~ THEN REPLY #54407 GOTO 23
  IF ~~ THEN REPLY #54408 GOTO 24
END
ADD_TRANS_TRIGGER DTRIAS 24 ~!NearbyDialog("DGrace")~ DO 3
EXTEND_TOP DTRIAS 24 #4 IF ~NearbyDialog("DGrace")~ THEN REPLY #54444 GOTO 45 END
ADD_TRANS_TRIGGER DTRIAS 32 ~!NearbyDialog("DGrace")~ DO 1
EXTEND_TOP DTRIAS 32 #2 IF ~NearbyDialog("DGrace")~ THEN REPLY #54444 GOTO 45 END
*/

// =============================== CURST FIXES - GENERAL ===========================================


// Bad epilogue when asking Agril-Shanak "Who intercepted you?"
ALTER_TRANS DAGRIL BEGIN 14 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 11~ END

// Talking to Voorsha a 2nd time, having killed the gehreleth, acts as if you were given the quest
// to kill it whether you were or not.
ADD_TRANS_TRIGGER DVOORSHA 21 ~Global("Snuff_Ghrist","GLOBAL",3)~ DO 2
EXTEND_TOP DVOORSHA 21
  IF ~Global("Snuff_Ghrist","GLOBAL",0)~ THEN REPLY #57963 GOTO 2 END

// Various people in Curst-Carceri fail to remember that you've met them before.  This is because they
// use NumTimesTalkedTo and NumTimesTalkedToGT in their triggers to remember if you've talked to them
// before.  Problem is, that doesn't attach to the creature file, it attaches to the area.  So when Curst
// slides into Carceri, they forget having met you.  This requires several new variables.
// Version 4.0:  Adding Tek'elach to the list.
REPLACE_STATE_TRIGGER DCARETKR 0 ~Global("Current_Area","GLOBAL",900) Global("Know_Kyse","GLOBAL",0)~
REPLACE_STATE_TRIGGER DCARETKR 1 ~Global("Current_Area","GLOBAL",900) Global("Know_Kyse","GLOBAL",1)~
ADD_TRANS_ACTION DCARETKR BEGIN 0 END BEGIN 0 END ~SetGlobal("Know_Kyse","GLOBAL",1)~
ADD_TRANS_ACTION DCARETKR BEGIN 10 END BEGIN END ~SetGlobal("Know_Kyse","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DBERROG ~NumTimesTalkedTo(0)~ ~Global("Know_Berrog","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DBERROG ~NumTimesTalkedToGT(0)~ ~Global("Know_Berrog","GLOBAL",1)~
ADD_TRANS_ACTION DBERROG BEGIN 9 15 END BEGIN 0 END ~SetGlobal("Know_Berrog","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DEBB ~NumTimesTalkedTo(0)~ ~Global("Know_Ebb","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DEBB ~NumTimesTalkedToGT(0)~ ~Global("Know_Ebb","GLOBAL",1)~
ADD_TRANS_ACTION DEBB BEGIN 0 53 55 57 END BEGIN END ~SetGlobal("Know_Ebb","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DHERMIT ~NumTimesTalkedTo(0)~ ~Global("Know_Hermit","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DHERMIT ~NumTimesTalkedToGT(0)~ ~Global("Know_Hermit","GLOBAL",1)~
ADD_TRANS_ACTION DHERMIT BEGIN 0 8 9 10 END BEGIN END ~SetGlobal("Know_Hermit","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DTEK ~NumTimesTalkedTo(0)~ ~Global("Know_Tek","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DTEK ~NumTimesTalkedToGT(0)~ ~Global("Know_Tek","GLOBAL",1)~
ADD_TRANS_ACTION DTEK BEGIN 3 END BEGIN END ~SetGlobal("Know_Tek","GLOBAL",1)~


// Can keep asking Kiri why she's nervous, and potentially reset her quest, even when you know.
ADD_TRANS_TRIGGER DKIRI 10 ~Global("Know_Kiri","GLOBAL",0)~ DO 0

// One conversation path with the captain telling him about the plot wouldn't actually do anything.
ADD_TRANS_ACTION DCRSCAPT BEGIN 6 END BEGIN 0 END ~SetGlobal("Roberta_Betrayed","GLOBAL",1)~

// Can't tell guard or captain about Roberta/Carl assassination plot after Roberta tells you to give
// Kiri the go ahead.
REPLACE_TRIGGER_TEXT DCRSCAPT ~GlobalLT("Snuff_Carl", "GLOBAL", 3)~ ~GlobalLT("Snuff_Carl", "GLOBAL", 4)~
REPLACE_TRIGGER_TEXT DCRSTGRD ~GlobalLT("Snuff_Carl", "GLOBAL", 3)~ ~GlobalLT("Snuff_Carl", "GLOBAL", 4)~

// Turning her in should also set the Snuff_Carl variable to it's final state.
ADD_TRANS_ACTION DCRSCAPT BEGIN 6 END BEGIN 0 END ~SetGlobal("Snuff_Carl","GLOBAL",4)~
ADD_TRANS_ACTION DCRSCAPT BEGIN 3 4 END BEGIN 2 END ~SetGlobal("Snuff_Carl","GLOBAL",4)~
ADD_TRANS_ACTION DCRSTGRD BEGIN 8 END BEGIN 1 END ~SetGlobal("Snuff_Carl","GLOBAL",4)~
ADD_TRANS_ACTION DCRSTGRD BEGIN 9 END BEGIN 2 END ~SetGlobal("Snuff_Carl","GLOBAL",4)~




// ======================= CURST FIXES - BROTHERS MALOKO AND KITLA QUEST ============================

// Brothers Maloko and Kitla quest

// Kester's experience reward in the Kester/Crumplepunch legacy quest are wildly inconsistent with what was
// clearly intended from Crumplepunch and Kitla's dialogues (and even the last action in his own dialogue).
REPLACE_TRANS_ACTION DKESTER BEGIN 13 END BEGIN 0 1 END ~2000~ ~131250~
REPLACE_TRANS_ACTION DKESTER BEGIN 13 END BEGIN 2 END ~2000~ ~150000~

// If you never talked to Kitla before you did the Brothers' quest, you could get their
// reward, then take their legacies (which you are inexplicably allowed to keep) or kill them, and then
// get the reward a 2nd time from Kitla.  I believe this is because you weren't supposed to be
// able to get the Brothers' quest before Kitla gave it to you.  You could only do so via a single
// conversation path in Kester's dialogue missing a trigger.
ADD_TRANS_TRIGGER DKESTER 6 ~Global("Mediate","GLOBAL",1)~ DO 0

// The brothers accepted your final judgment without taking their legacies back from you?  Don't think so.
// This is -not- done if you tell them you're not giving them their legacies back.  That's handled below.
ADD_TRANS_TRIGGER DKESTER 14 ~PartyHasItem("KestLeg") PartyHasItem("CrumLeg")~ DO 2
ADD_TRANS_ACTION DKESTER BEGIN 14 END BEGIN 2 END ~TakePartyItem("KestLeg") TakePartyItem("CrumLeg")~
ADD_TRANS_TRIGGER DKESTER 13 ~PartyHasItem("KestLeg") PartyHasItem("CrumLeg")~ DO 0 1 2
ADD_TRANS_ACTION DKESTER BEGIN 13 END BEGIN 0 1 2 END ~TakePartyItem("KestLeg") TakePartyItem("CrumLeg")~
ADD_TRANS_TRIGGER DCRSSMTH 3 ~PartyHasItem("KestLeg") PartyHasItem("CrumLeg")~ DO 2
ADD_TRANS_ACTION DCRSSMTH BEGIN 3 END BEGIN 2 END ~TakePartyItem("KestLeg") TakePartyItem("CrumLeg")~
ADD_TRANS_TRIGGER DCRSSMTH 6 ~PartyHasItem("KestLeg") PartyHasItem("CrumLeg")~ DO 0 1 2
ADD_TRANS_ACTION DCRSSMTH BEGIN 6 END BEGIN 0 1 2 END ~TakePartyItem("KestLeg") TakePartyItem("CrumLeg")~

// Telling the brothers you're taking their legacies and giving them to someone else makes you unable to
// actually give them to Kitla.  Change value 9 of Mediate to mean "told them you're giving them to Kitla"
// and new value 10 means "gave them to Kitla".  Also, give the experience when you give them to Kitla, not
// before.
REPLACE_TRANS_ACTION DKESTER BEGIN 13 END BEGIN 3 END ~AddExperienceParty(2000)~ ~~
REPLACE_TRANS_ACTION DCRSSMTH BEGIN 6 END BEGIN 3 END ~AddExperienceParty(150000)~ ~~
REPLACE_TRIGGER_TEXT DKITLA
 ~GlobalLT("Mediate", "GLOBAL", 6)~
 ~!Global("Mediate","GLOBAL",6) !Global("Mediate","GLOBAL",7)
  !Global("Mediate","GLOBAL",8) !Global("Mediate","GLOBAL",10)~
REPLACE_TRANS_ACTION DKITLA BEGIN 11 END BEGIN 0 END ~SetGlobal("Mediate", "GLOBAL", 9)~
 ~SetGlobal("Mediate","GLOBAL",10)~
REPLACE_TRIGGER_TEXT DCRSSMTH ~Global("Mediate", "GLOBAL", 9)~ ~GlobalGT("Mediate","GLOBAL",8)~

// Get rid of options to not take legacies when agreeing to mediate.  It just causes problems for
// no good reason.
ADD_TRANS_TRIGGER DKESTER 7 ~False()~ 14 DO 1
ADD_TRANS_TRIGGER DCRSSMTH 10 ~False()~ DO 1

// If there -is- a way to get the quest without Kitla giving it to you - there shouldn't be - this will
// prevent her from giving it to you again.
ADD_STATE_TRIGGER DKITLA 4 ~Global("Mediate","GLOBAL",0)~

// =============================== CARCERI CART TRAP FIXES =========================================

// Telling Dak'kon to kill the Burgher ends abruptly, without him actually doing so.  Bad epilogues.

ALTER_TRANS DDAKKON BEGIN 186 END BEGIN 1 END BEGIN "EPILOGUE" ~EXTERN DBURGHER 3~ END
ALTER_TRANS DDAKKON BEGIN 188 END BEGIN 1 END BEGIN "EPILOGUE" ~EXTERN DBURGHER 14~ END


// The experience awards are very inconsistent.  It's completely random depending on conversation paths.
// This sorts it out and makes it consistent:

// Rescue Burgher, Berrog already dead = good hit, 125k xp, increase counter
// Rescue Berrog, Burgher already dead = good hit, 225k xp, increase counter
// Rescue Burgher, kill Berrog = evil hit, 125k xp, doesn't increase counter.
// Rescue Berrog, kill Burgher = good hit, 125k xp, increase counter.
// Rescue both = good hit, 225k xp, increase counter.

// Rescue Burgher, Berrog already dead
ALTER_TRANS DBURGHER BEGIN 5 END BEGIN 0 END BEGIN "ACTION"
~FadeToBlack()Wait(1)FadeFromBlack()
IncrementGlobalOnce("Good_Burgher_1","GLOBAL","Good","GLOBAL",1)IncrementGlobal("Curst_Counter","GLOBAL",1)AddexperienceParty(125000)SetGlobal("Cart_Trap","GLOBAL",2)~ END
ALTER_TRANS DBURGHER BEGIN 8 9 10 END BEGIN 0 END BEGIN "ACTION" ~~ END
ALTER_TRANS DBURGHER BEGIN 0 1 2 4 END BEGIN 3 END BEGIN "ACTION" ~~ END

// Rescue Berrog, Burgher already dead
ALTER_TRANS DBERROG BEGIN 13 END BEGIN 0 END BEGIN "ACTION"
~FadeToBlack()Wait(1)FadeFromBlack()
IncrementGlobalOnce("Good_Berrog_1","GLOBAL","Good","GLOBAL",1)IncrementGlobal("Curst_Counter","GLOBAL",1)AddexperienceParty(225000)SetGlobal("Cart_Trap","GLOBAL",1)~ END

// Rescue Burgher, kills Berrog
ALTER_TRANS DBURGHER BEGIN 18 END BEGIN 0 END BEGIN "ACTION"
~IncrementGlobalOnce("Evil_Burgher_3","GLOBAL","Good","GLOBAL",-3)
AddexperienceParty(125000)SetGlobal("Cart_Trap","GLOBAL",2)
GiveItem("SPWI803",Protagonist)EscapeArea()~ END
ALTER_TRANS DBURGHER BEGIN 25 END BEGIN 0 END BEGIN "ACTION" ~Kill("Berrog")FadeToBlack()Wait(1)FadeFromBlack()~ END
ALTER_TRANS DBERROG BEGIN 15 END BEGIN 2 END BEGIN "ACTION" ~Kill(Myself)FadeToBlack()Wait(1)FadeFromBlack()~ END
ALTER_TRANS DBERROG BEGIN 16 END BEGIN 1 END BEGIN "ACTION" ~Kill(Myself)FadeToBlack()Wait(1)FadeFromBlack()~ END
ALTER_TRANS DBERROG BEGIN 18 END BEGIN 0 END BEGIN "ACTION" ~Kill(Myself)FadeToBlack()Wait(1)FadeFromBlack()~ END

// Rescue Berrog, kills Burgher
ALTER_TRANS DBERROG BEGIN 18 END BEGIN 1 END BEGIN "ACTION"
~Kill("Burgher")FadeToBlack()Wait(1)FadeFromBlack()
IncrementGlobalOnce("Good_Berrog_1","GLOBAL","Good","GLOBAL",1)IncrementGlobal("Curst_Counter","GLOBAL",1)AddexperienceParty(125000)SetGlobal("Cart_Trap","GLOBAL",1)~ END

// Rescuing both
ALTER_TRANS DBURGHER BEGIN 26 END BEGIN 0 END BEGIN "ACTION"
~FadeToBlack()Wait(1)FadeFromBlack()
IncrementGlobalOnce("Good_Burgher_1","GLOBAL","Good","GLOBAL",1)IncrementGlobal("Curst_Counter","GLOBAL",1)
AddexperienceParty(225000)SetGlobal("Cart_Trap","GLOBAL",3)~ END
ALTER_TRANS DBURGHER BEGIN 23 25 END BEGIN 2 END BEGIN "ACTION" ~~ END
ALTER_TRANS DBERROG BEGIN 18 END BEGIN 2 END BEGIN "ACTION" ~~ END


// ==========================================================================================
//                            Iannis Has Worse Amnesia Than TNO

// Version 3.0:  Total rewrite of this fix.

// Could keep asking him what was wrong after you already knew, and he'd answer like he never told you.
// Those responses would also ignore everything else you'd ever told him.
ADD_TRANS_TRIGGER DIANNIS 1 ~Global("Know_Iannis_Fire","GLOBAL",0)~ DO 0 2
ADD_TRANS_ACTION DIANNIS BEGIN 57 END BEGIN 1 END ~SetGlobal("Know_Iannis_Fire","GLOBAL",1)SetGlobal("Know_Iannis_Deionarra_Death","GLOBAL",1)~

// Couple of checks about knowing that she died that don't actually do anything unless we reset epilogues.
ALTER_TRANS DIANNIS BEGIN 58 END BEGIN 1 4 END BEGIN "EPILOGUE" ~GOTO 60~ END

// Adding a response condition in case you are telling Iannis you spoke to Deionarra and he already knows she left with you,
// so we don't run through that whole conversation again.
ADD_TRANS_TRIGGER DIANNIS 97 ~Global("Deionarra_Fate_Quest","GLOBAL",0)~ DO 1
EXTEND_BOTTOM DIANNIS 97
  IF ~GlobalGT("Deionarra_Fate_Quest","GLOBAL",0)~ THEN REPLY #30496 GOTO 83
END

// Creating new variable Iannis_Know_Spirit - set it to 1 when he believes she's in the mortuary, 2 when you told her you talked to her.
ADD_TRANS_ACTION DIANNIS BEGIN 93 END BEGIN 0 END ~SetGlobal("Iannis_Know_Spirit","AR0607",1)~
ADD_TRANS_ACTION DIANNIS BEGIN 97 END BEGIN END ~SetGlobal("Iannis_Know_Spirit","AR0607",2)~

// Adding alternate destination for responses where you ask him about his daughter after you already know.
// If you already know he's her father and she died, go to state 63 instead of 62.
ALTER_TRANS DIANNIS BEGIN 39 END BEGIN 5 END BEGIN "EPILOGUE" ~GOTO 63~ END
ALTER_TRANS DIANNIS BEGIN 55 56 END BEGIN 3 4 END BEGIN "EPILOGUE" ~GOTO 63~ END
ALTER_TRANS DIANNIS BEGIN 60 END BEGIN 0 1 END BEGIN "EPILOGUE" ~GOTO 63~ END


// Need to add the Mortuary responses to state 63.
EXTEND_TOP DIANNIS 63 #1
  IF ~GlobalGT("Deionarra","GLOBAL",0)GlobalLT("Iannis_Know_Spirit","AR0607",1)~ THEN REPLY #30235 JOURNAL #30251 GOTO 86
  IF ~GlobalGT("Deionarra","GLOBAL",0)GlobalLT("Iannis_Know_Spirit","AR0607",2)~ THEN REPLY #30236 JOURNAL #30251 GOTO 87
END

// Now add our new check on Iannis_Know_Spirit to existing states, prevent telling him repeatedly that you saw her in the Mortuary.
ADD_TRANS_TRIGGER DIANNIS 61 ~GlobalLT("Iannis_Know_Spirit","AR0607",1)~ 62 DO 2
ADD_TRANS_TRIGGER DIANNIS 61 ~GlobalLT("Iannis_Know_Spirit","AR0607",2)~ 62 DO 3
ADD_TRANS_TRIGGER DIANNIS 87 ~GlobalLT("Iannis_Know_Spirit","AR0607",1)~ DO 0

// Dead transition in Vhailor's dialogue during confession that is activated by Expanded Deionarra's Truth mod.
ALTER_TRANS DVHAIL BEGIN 7 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DIANNIS 77~ END


// ==========================================================================================
//                            GivePartyGold/CreatePartyGold Fixes

// These creatures don't drop any real money despite having copious amounts to give you as quest rewards
// in their "pockets" and "robes".  Giving them their copper in QwinnFix.tph, and changing the
// dialog to deplete that copper when they give you your reward.
REPLACE_ACTION_TEXT DAMARYS  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DANIZIUS ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DAWAIT   ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DBAEN    ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DCOLSRGR ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DCRADDO  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DCRIER   ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DCRSOFF2 ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DCSTCPR3 ~CreatePartyGold~ ~GivePartyGold~ // Money given in UB Restored Curst Citizens
REPLACE_ACTION_TEXT DCSTCROG ~CreatePartyGold~ ~GivePartyGold~ // Money given in UB Restored Curst Citizens
REPLACE_ACTION_TEXT DECCO    ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DGHYSIS  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DGILTSP  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DJARYM   ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DJOLMI   ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DKRYS    ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DMALMANR ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DMAR     ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DMERTWYN ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DMORTAI  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DNOROCHJ ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DQUISHO  ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DUHIR    ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DWANGYAR ~CreatePartyGold~ ~GivePartyGold~
REPLACE_ACTION_TEXT DXANTHIA ~CreatePartyGold~ ~GivePartyGold~

// DDEVORE.DLG
// Devore goes elsewhere to get your gold reward, but then uses GivePartyGold (which he didn't
// have anyway, so you got nothing).  Should be CreatePartyGold.
REPLACE_ACTION_TEXT DDEVORE ~GivePartyGold~ ~CreatePartyGold~

// Old Coppereyes in most situations wasn't doing -either- GivePartyGold or CreatePartyGold - his
// dialog didn't even try to pay you.  See QwinnFix.tph for giving him his copper.
REPLACE_ACTION_TEXT DCOPPER ~CreatePartyGold(100)~ ~~
ADD_TRANS_ACTION DCOPPER BEGIN 2 8 9 END BEGIN 1 END ~GivePartyGold(100)~
ADD_TRANS_ACTION DCOPPER BEGIN 3 END BEGIN 0 1 2 4 END ~GivePartyGold(100)~

// Gave Fleece the extra 25 gold, so make him give you everything he has including what he stole
// (like DHARLOTD does).
REPLACE_ACTION_TEXT DFLEECE ~GivePartyGold (38)~ ~GivePartyGold(10000)~

// Fixing the Yellow Fingers "Give me all you've got" being 37 copper even if you just handed him 500
// and no matter how much he just pickpocketed off you (with you watching).
REPLACE_ACTION_TEXT DCOLYLFN ~CreatePartyGold(37)~ ~GivePartyGold(10000)~

// Emoric really does "create" his bigger reward, but gives his smaller reward, so need a more specific
// replace.
REPLACE_ACTION_TEXT DEMORIC  ~CreatePartyGold(50)~ ~GivePartyGold(50)~

// Gave the Harlot her 38 gold, so let her Give do the work.
REPLACE_TRANS_ACTION DHARLOTD BEGIN 18 END BEGIN 0 END ~CreatePartyGold(38)~ ~~

// DMOOCH.DLG
// Mooch is an odd situation.  She has no copper, but at least one GivePartyGold, which she may
// or may not have money for depending on if you gave her money to give to the barkeep... she
// also keeps that money even though she's supposed to give it to the barkeep right away.
// She can also be milked for bribe money several different times, with a lot of time and
// potentially spending money in between visits.  The best way to ensure the least bugs here is
// to have her only use CreatePartyGold and DestroyPartyGold.
// REPLACE_ACTION_TEXT DMOOCH ~GivePartyGold~ ~CreatePartyGold~
// REPLACE_ACTION_TEXT DMOOCH ~TakePartyGold~ ~DestroyPartyGold~
// EDIT: Version 3.0, redoing this. There's a possibility of killing Mooch via dialogue, and it's rather
// pointless if she doesn't drop any money. Since she's capable of giving you 75 copper, giving
// her 83. And correcting the fact that her second bribe, supposedly only 25 copper, is actually
// doubled up for a total of 100.
REPLACE_TRANS_ACTION DMOOCH BEGIN 20 END BEGIN 0 1 2 END ~CreatePartyGold(25)~ ~~
REPLACE_ACTION_TEXT DMOOCH ~CreatePartyGold~ ~GivePartyGold~




// ========================== INCREMENT GITHZERAI VARIABLE ==================================

// Totally redoing the "Increment Githzerai Variable" fixes from Restoration Pack.
// Too many bugs to simply fix.  Also applying a few fixes to bugs not caused by RestoPack.

// Also, as it stands in RestoPack the tattoo can be a little too difficult to get.  To get it, you
// have to get 5 points in the Githzerai variable.  That requires learning the Gith language
// (1 point), doing the entire circle of zerthimon with Dakkon (2 points), mercy-killing An'azi
// (1 point) and finding out about Vristigor and telling the Githzerai about it (1 point).  There's
// no other way to get a point, and since it's -very- easy to not find out about Vristigor
// (just having Dakkon with you all the time makes it impossible, and not knowingly walking into
// a trap does also) that makes it a little too close to requiring meta-gaming knowledge to get
// this tattoo, IMO.  Since the tattoo description explicitly mentions "knowing Zerthimon's teachings"
// as a condition, I'm upping the bonus you get for completing the circle to 3, and upping the
// Vristigor bonus to 2.

// Now you can get it by completing the Circle with Dakkon, PLUS either:
// 1)  Learning the language AND mercy-killing An'azi; or
// 2)  Warning about the attack on Vristigor

// You could of course do more.  This seems fair, as most Githzerai in game will
// consider you a friend for -just- mercy-killing An'azi.

// DANAZI - only incrementing when you kill her out of kindness, not out of spite as RP does
ADD_TRANS_ACTION DANAZI BEGIN 15 END BEGIN 0 END ~IncrementGlobal("Githzerai","GLOBAL",1)~

// DKIINA - implementing in different way so that you -always- get increment if you
// tell Kiina about the fortress attack (several instances were missed in RP), and
// -only- learn the Githzerai language, get the experience for it and increment the
// variable if you actually complete her language training (increment was missed in
// several instances of language learning by RP also).
ADD_TRANS_ACTION DKIINA BEGIN 8 END BEGIN 0 END
~SetGlobal("Vristigor","GLOBAL",2)
IncrementGlobal("Githzerai","GLOBAL",2)~
ADD_TRANS_ACTION DKIINA BEGIN 37 END BEGIN 0 1 END
~SetGlobal("Vristigor","GLOBAL",2)
IncrementGlobal("Githzerai","GLOBAL",2)~
ADD_TRANS_ACTION DKIINA BEGIN 18 56 END BEGIN 0 END
~SetGlobal("Know_Githzerai_Speak","GLOBAL",1)
GiveExperience(Protagonist,5000)
IncrementGlobal("Githzerai","GLOBAL",1)~
ALTER_TRANS DKIINA BEGIN 7 9 10 36 38 END BEGIN 0 END BEGIN "ACTION" ~~ END
ALTER_TRANS DKIINA BEGIN 60 END BEGIN 1 END BEGIN "ACTION" ~~ END
ALTER_TRANS DKIINA BEGIN 13 14 42 55 END BEGIN 2 END BEGIN "ACTION" ~~ END
ALTER_TRANS DKIINA BEGIN 41 52 61 END BEGIN 4 END BEGIN "ACTION" ~~ END
ALTER_TRANS DKIINA BEGIN 42 55 END BEGIN 5 END BEGIN "ACTION" ~~ END
ALTER_TRANS DKIINA BEGIN 41 52 END BEGIN 7 END BEGIN "ACTION" ~~ END

// DDAKKON - only incrementing when you kill her out of kindness, not out of spite as RP does
// Version 4.0 - removed add to state 131 0.
ADD_TRANS_ACTION DDAKKON BEGIN 130 END BEGIN 0 END ~IncrementGlobal("Githzerai","GLOBAL",1)~
ADD_TRANS_ACTION DDAKKON BEGIN 326 END BEGIN 0 END ~IncrementGlobal("Githzerai","GLOBAL",3)~
ADD_TRANS_ACTION DDAKKON BEGIN 342 END BEGIN 0 END ~IncrementGlobal("Githzerai","GLOBAL",1)~

// ============================= THIEF SKILL OVERFLOW BUG ===================================

// If you add to the thief skills using PermanentStatChange so that they go over 127, they wrap
// around to -128.  This thankfully does not happen due to increasing dexterity, so we only need
// to deal with it in dialogs where these boosts are given out.  Dealing with it by getting rid
// of the options to Bait the pickpockets, or to ask Annah for training.

// Do the same when teaching Annah.

ADD_TRANS_TRIGGER DHARLOTD 10 ~CheckStatLT(Protagonist,122,PICKPOCKET)~ 16 DO 3 4 5
ADD_TRANS_TRIGGER DFLEECE  10 ~CheckStatLT(Protagonist,122,PICKPOCKET)~ 15 DO 3 4 5
ADD_TRANS_TRIGGER DASHMAN  20 ~CheckStatLT(Protagonist,122,PICKPOCKET)~ 21 22 23 DO 3 4 5
ADD_TRANS_TRIGGER DCOLYLFN 41 ~CheckStatLT(Protagonist,126,PICKPOCKET)~ DO 2

ADD_TRANS_TRIGGER DANNAH 348 ~CheckStatLT(Protagonist,124,STEALTH)~ DO 0
ADD_TRANS_TRIGGER DANNAH 348 ~CheckStatLT(Protagonist,124,LOCKPICKING)~ DO 1
ADD_TRANS_TRIGGER DANNAH 348 ~CheckStatLT(Protagonist,124,TRAPS)~ DO 2
ADD_TRANS_TRIGGER DANNAH 348 ~CheckStatLT(Protagonist,124,PICKPOCKET)~ DO 3

ADD_TRANS_TRIGGER DANNAH 363 ~CheckStatLT("Annah",124,STEALTH)~ DO 0
ADD_TRANS_TRIGGER DANNAH 363 ~CheckStatLT("Annah",124,LOCKPICKING)~ DO 1
ADD_TRANS_TRIGGER DANNAH 363 ~CheckStatLT("Annah",124,PICKPOCKET)~ DO 2
ADD_TRANS_TRIGGER DANNAH 363 ~CheckStatLT("Annah",124,TRAPS)~ DO 3


// ================================= GRIS, BURT AND LOWDEN FIXES ====================================
// The dialogues of the three dead collectors in the Weeping Catacombs have many issues.  The game would
// think you had already talked to Burt from having talked to Lowden, and vice versa.  Talking to Annah
// about Gris would make Gris think you'd asked him about himself before.  Many triggers regarding
// knowing Gris was dead were misplaced, too.  Faction hits for telling Gris about Burt and Lowden were
// all off.  Just - lots of issues.
// This required adding Know_Burt, Know_Lowden, Know_Gris_Dead, Know_BLG_Grouped and Lawful_Gris_2 GLOBAL
// variables.  See the main .tp2 for the actual variable adds.

REPLACE_TRIGGER_TEXT DBURT ~Know_BLDead~ ~Know_Burt~
REPLACE_ACTION_TEXT  DBURT ~Know_BLDead~ ~Know_Burt~
REPLACE_TRIGGER_TEXT DLOWDEN ~Know_BLDead~ ~Know_Lowden~
REPLACE_ACTION_TEXT  DLOWDEN ~Know_BLDead~ ~Know_Lowden~

ADD_TRANS_ACTION DBURT   BEGIN 1 END BEGIN 0 END ~SetGlobal("Know_BLDead","GLOBAL",1)~
ADD_TRANS_ACTION DLOWDEN BEGIN 1 END BEGIN 0 END ~SetGlobal("Know_BLDead","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DBURT   ~Global("Know_Gris", "GLOBAL", 1)~ ~~
REPLACE_TRIGGER_TEXT DLOWDEN ~Global("Know_Gris", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT  DANNAH  ~SetGlobal("Know_Gris", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT  DGRIS   ~SetGlobal("Know_Gris", "GLOBAL", 1)~ ~~

ADD_TRANS_ACTION DBURT BEGIN 2 6 END BEGIN 0 END ~SetGlobal("Know_BLG_Grouped","GLOBAL",1)~
ADD_TRANS_TRIGGER DBURT 1 ~Global("Know_BLG_Grouped","GLOBAL",1)~ DO 2
ADD_TRANS_TRIGGER DLOWDEN 4 ~Global("Know_Gris_Dead","GLOBAL",1)~ DO 0

ADD_TRANS_ACTION DGRIS BEGIN 2 3 END BEGIN 5 6 END
  ~SetGlobal("Know_Gris","GLOBAL",1) SetGlobal("Know_Gris_Dead","GLOBAL",1)~
ADD_TRANS_ACTION DGRIS BEGIN 9 END BEGIN 6 7 END
  ~SetGlobal("Know_Gris","GLOBAL",1) SetGlobal("Know_Gris_Dead","GLOBAL",1)~
ADD_TRANS_ACTION DGRIS BEGIN 0 END BEGIN 0 END ~SetGlobal("Know_Gris_Dead","GLOBAL",1)~

REPLACE_ACTION_TEXT DGRIS ~IncrementGlobalOnce("Chaotic_Gris_1", "GLOBAL", "Law", "GLOBAL", -1)~ ~~
REPLACE_ACTION_TEXT DGRIS ~"Chaotic_Gris_2"~ ~"Chaotic_Gris_1"~
ADD_TRANS_ACTION DGRIS BEGIN 6 END BEGIN 1 2 3 4 END ~IncrementGlobalOnce("Chaotic_Gris_2","GLOBAL","Law","GLOBAL",-1)~
ADD_TRANS_ACTION DGRIS BEGIN 6 END BEGIN 0 5 END ~IncrementGlobalOnce("Lawful_Gris_2","GLOBAL","Law","GLOBAL",1)~

REPLACE_TRIGGER_TEXT DCHAD ~Global("Know_Gris", "GLOBAL", 1)~ ~Global("Know_Gris_Dead","GLOBAL",1)~


// ========================================== VERSION 2.0 ===============================================

// Fixing a number of quest-regressing bugs in Ingress's dialogue
ALTER_TRANS DINGRESS BEGIN 18 END BEGIN 1 END BEGIN "TRIGGER" ~Global("Ingress","GLOBAL",1)~ END
ALTER_TRANS DINGRESS BEGIN 18 END BEGIN 2 END BEGIN "TRIGGER" ~Global("Ingress","GLOBAL",2)~ END
ALTER_TRANS DINGRESS BEGIN 18 END BEGIN 3 END BEGIN "TRIGGER" ~Global("Ingress","GLOBAL",3)~ END
ALTER_TRANS DINGRESS BEGIN 18 END BEGIN 4 END BEGIN "TRIGGER" ~Global("Ingress","GLOBAL",4)~ END
ALTER_TRANS DINGRESS BEGIN 18 END BEGIN 5 END BEGIN "TRIGGER" ~Global("Ingress","GLOBAL",5)~ END

// Missing trigger in Creeden's dialogue for claiming you don't have enough gold to buy a ratsie.
ADD_TRANS_TRIGGER DCREED 5 ~PartyGoldLT(3)~ DO 6

// Could fail to get journal entry for fetching ink quest in Mebbeth's dialogue
ALTER_TRANS DMEBBETH BEGIN 79 END BEGIN 1 END BEGIN "JOURNAL" ~#23587~ END

// Reply in Githzerai Townsperson dialogue points to wrong string ref, making the answer not fit the question.
ALTER_TRANS DGITH BEGIN 27 END BEGIN 1 END BEGIN "REPLY" ~#8853~ END

// Add missing journal entries to Ei'vene's dialogue
ALTER_TRANS DEIVENE BEGIN 19 21 END BEGIN 0 END BEGIN "JOURNAL" ~#38205~ END

// Set new Siege_Tower_Portal variable when opening Siege Tower Portal in trigger dialogue
ADD_TRANS_ACTION DSTTRANS BEGIN 0 END BEGIN 0 END ~SetGlobal("Siege_Tower_Portal","AR0500",1)~

// Giltspur won't give you his quest anymore if it's become impossible to complete (Penn locked his door)
ADD_TRANS_TRIGGER DGILTSP 5 ~!Global("Penn_Out","GLOBAL",2)~ DO 5
ADD_TRANS_TRIGGER DGILTSP 6 ~!Global("Penn_Out","GLOBAL",2)~ 7 DO 3

// Experience loop available when infiltrating Sensates for the Anarchists
// Requires a new variable set up in Setup-PST-Fix.tp2.
// ADD_TRANS_ACTION DSPLINT BEGIN 26 END BEGIN 1 END ~SetGlobal("Infiltrated_Sensates","GLOBAL",1)~
// ADD_TRANS_TRIGGER DSPLINT 7 ~Global("Infiltrated_Sensates","GLOBAL",0)~ DO 0
// Fixing this properly in v4.0 by setting Join_Sensates to True

// Additional fixes to Crumplepunch's dialogue
REPLACE_TRANS_ACTION DCRSSMTH BEGIN 2 END BEGIN 1 END ~StartStore("Crumple1", Protagonist)~ ~~
REPLACE_TRANS_TRIGGER DCRSSMTH BEGIN 8 END BEGIN 1 END ~Global("Mediate", "GLOBAL", 2)~ ~Global("Mediate", "GLOBAL", 1)~
REPLACE_TRANS_TRIGGER DCRSSMTH BEGIN 8 END BEGIN 3 END ~Global("Mediate", "GLOBAL", 1)~ ~False()~

/* Fixpack 3.0 fixes this problem in the engine, rolling back as it is no longer necessary.

// Ravel's dialogue suffers from the same problem as the pickpockets in terms of deactivating item boosts
// after a permanent stat change, so that future stat checks in her dialogue don't count those item boosts.
// Fix same way, by leaving dialogue briefly after the stat boosts to reset them.
// Remainder of changes (addition to INTERUPT.BCS) in QwinnFix.tph

// Version 2.10 - emergency fix, resetting Ravel_Curst_Portal to 0 for the duration of the "boon" cutscene
// so that AR0610.BCS doesn't start the Trigit spawn and attack during it, then setting it back.
REPLACE_TRANS_ACTION DRAVEL BEGIN 168 END BEGIN 0 END
  ~SetGlobal("Ravel_EiVene", "GLOBAL", 2)~
  ~SetGlobal("Ravel_EiVene","GLOBAL",2) SetGlobal("Ravel_Cut_Scene","AR0610",9) StartCutScene("Interupt")~
ALTER_TRANS DRAVEL BEGIN 168 END BEGIN 0 END BEGIN "EPILOGUE" ~EXIT~ END
ADD_STATE_TRIGGER DRAVEL 169 ~Global("Ravel_Cut_Scene","AR0610",9)~

REPLACE_TRANS_ACTION DRAVEL BEGIN 179 180 END BEGIN 0 END
  ~GiveExperience (Protagonist, 90000)~
  ~GiveExperience(Protagonist,90000) SetGlobal("Ravel_Cut_Scene","AR0610",10) StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DRAVEL BEGIN 181 END BEGIN 0 END
  ~GiveExperience (Protagonist, 120000)~
  ~GiveExperience(Protagonist,120000) SetGlobal("Ravel_Cut_Scene","AR0610",10) StartCutScene("Interupt")~
ALTER_TRANS DRAVEL BEGIN 179 180 181 END BEGIN 0 END BEGIN "EPILOGUE" ~EXIT~ END
ADD_STATE_TRIGGER DRAVEL 182 ~Global("Ravel_Cut_Scene","AR0610",10)~

REPLACE_TRANS_ACTION DRAVEL BEGIN 223 END BEGIN 0 END
  ~GiveExperience (Protagonist, 90000)~
  ~GiveExperience(Protagonist,90000)SetGlobal("Ravel_Curst_Portal","GLOBAL",0)SetGlobal("Ravel_Cut_Scene","AR0610",11)StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DRAVEL BEGIN 223 END BEGIN 1 END
  ~GiveExperience (Protagonist, 120000)~
  ~GiveExperience(Protagonist,120000)SetGlobal("Ravel_Curst_Portal","GLOBAL",0)SetGlobal("Ravel_Cut_Scene","AR0610",11)StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DRAVEL BEGIN 223 END BEGIN 2 END
  ~GiveExperience (Protagonist, 180000)~
  ~GiveExperience(Protagonist,180000)SetGlobal("Ravel_Curst_Portal","GLOBAL",0)SetGlobal("Ravel_Cut_Scene","AR0610",11)StartCutScene("Interupt")~
ALTER_TRANS DRAVEL BEGIN 223 END BEGIN 0 1 2 END BEGIN "EPILOGUE" ~EXIT~ END
ADD_STATE_TRIGGER DRAVEL 224 ~Global("Ravel_Cut_Scene","AR0610",11)~
ADD_TRANS_ACTION DRAVEL BEGIN 224 END BEGIN 0 END ~SetGlobal("Ravel_Curst_Portal","GLOBAL",1)~
*/



// Telling TO you intend to unmake him with your true name would set the quit game variable, then start the long
// pre-fight cutscene, then the game would abort before the fight started.  Changing so that it properly just
// initiates the "Unmake" ending.
ALTER_TRANS DTRANS BEGIN 113 END BEGIN 0 END BEGIN "EPILOGUE" ~EXIT~ END
ALTER_TRANS DTRANS BEGIN 113 END BEGIN 0 END BEGIN "ACTION" ~QuitGame(1, 0, 0)~ END

// When Diligence calls for the guards from dialogue, Matter-Of-Course wouldn't react.
REPLACE_ACTION_TEXT DDILIGNC ~RunAwayFrom~ ~Help() RunAwayFrom~

// Mercykillers in Smoldering Corpse Bar wouldn't help each other if they went hostile from dialogue.
REPLACE_ACTION_TEXT DMERKIL1 ~Enemy()~ ~Help() Enemy()~
REPLACE_ACTION_TEXT DMERKIL2 ~Enemy()~ ~Help() Enemy()~
REPLACE_ACTION_TEXT DMERKIL3 ~Enemy()~ ~Help() Enemy()~

// You could tell Kesai-Serris about your Dreambuilder dream just by getting the quest to build the Dreambuilder. You must now actually use the Dreambuilder to do so.
REPLACE_TRIGGER_TEXT DKESAI ~Global("Dream", "GLOBAL", 0)~ ~Global("AR3017_Visited","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DKESAI ~GlobalGT("Dream", "GLOBAL", 0)~ ~Global("AR3017_Visited","GLOBAL",1)~

// The variable that tracked whether Nordom was present during your meeting with the Rubikon wizard was set incorrectly... if he wasn't there, he'd remember what the wizard said about the Director's fate, and vice versa.
REPLACE_TRANS_ACTION DRUBIKON BEGIN 8 END BEGIN 0 END ~2~ ~1~
REPLACE_TRANS_ACTION DRUBIKON BEGIN 8 END BEGIN 1 END ~1~ ~2~

// Dodecahedron bug - the text in states 5 and 12 are too big to fit into one screen, and if that happens and you don't have a reply, the dialogue hangs.
ALTER_TRANS DP_JRNL BEGIN 10 END BEGIN 0 END BEGIN "REPLY" ~#16191~ END

// Final fight with TO could crash if you were fighting him alone, Trias was alive, and Fhjull was dead.
EXTEND_BOTTOM DTRANS 141
  IF ~!Dead("Trias")Dead("Fhjull")~ THEN
     REPLY #68158 DO ~StartCutSceneMode()StartCutScene("1204tb2")~ EXIT
 END


// ============= CLAN DLAN FIXES - bugs discovered by Clan Dlan during their translation work ==================

// Coaxmetal journal entry points to wrong strref
ALTER_TRANS DCOAX BEGIN 55 END BEGIN 2 END BEGIN "JOURNAL" ~#26092~ END

// Bad epilogue in Brokah's dialogue, refers to his own file instead of his wife's, which drops her line.
ALTER_TRANS DBROKAH BEGIN 5 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DMICCAH 9~ END

// Female cafe patron sends to wrong state in Morte's dialogue, which drops 2 lines by Morte and one by her
ALTER_TRANS DCWCAFEF BEGIN 50 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DMORTE 269~ END

// Reversed epilogues in Fhjull's dialogue (transitions for "I'm not going to torture you" and
// "I'm not going to kill you
ALTER_TRANS DFHJULL BEGIN 29 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 45~ END
ALTER_TRANS DFHJULL BEGIN 29 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 44~ END

// Incorrect transitions in Dak'kon's dialogue, and one bad strref reference
ALTER_TRANS DDAKKON BEGIN 33 END BEGIN 2 END BEGIN "EPILOGUE" ~GOTO 67~ END
ALTER_TRANS DDAKKON BEGIN 212 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 213~ END
ALTER_TRANS DDAKKON BEGIN 238 END BEGIN 2 END BEGIN "REPLY" ~#59470~ END
ALTER_TRANS DDAKKON BEGIN 243 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 193~ END
ALTER_TRANS DDAKKON BEGIN 328 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 232~ END

// Hailcii reply returns to its own state
ALTER_TRANS DHAILCII BEGIN 30 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 31~ END

// Practical Incarnation "More questions" reply leads to wrong state
ALTER_TRANS DINCAR1 BEGIN 25 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 20~ END

// Asking Lenny about the Hive, he responds about the Lower Ward
ALTER_TRANS DLENNY BEGIN 30 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 29~ END

// Few wrong transitions in Lothar's script (offering him a wererat skull, and telling him you don't have a skull for him yet.
ALTER_TRANS DLOTHAR BEGIN 12 END BEGIN 7 END BEGIN "EPILOGUE" ~GOTO 35~ END
ALTER_TRANS DLOTHAR BEGIN 12 END BEGIN 8 END BEGIN "EPILOGUE" ~GOTO 13~ END

// Morte/Grace banter about Mechanus being "boring" was misdirected into the conversation path about the Source.
ALTER_TRANS DMORTE BEGIN 576 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DGRACE 184~ END

// ======================================== SAROSSA'S CURSES ====================================================

// Sarossa's curses weren't working.
ADD_TRANS_ACTION DSAROSSA BEGIN 7 END BEGIN 1 END
   ~PermanentStatChange(Protagonist,STR,Lower,1)SetGlobal("SarossaStatChange","GLOBAL",4)~
// Her calling the guards wasn't doing anything if you took the "Leave" option.  Making that set Alarm1 (which
// isn't as bad as Alarm2)
ADD_TRANS_ACTION DSAROSSA BEGIN 16 END BEGIN 1 END ~SetGlobal ("Alarm1", "GLOBAL", 1)~

// Remove infinite curse loops

// The final upshot after all this is this:
// Lie to her the first time:  She drains 1 point strength
// Lie to her 2nd time:  She drains a point of dex
// Lie to her 3rd time:  She drains a point of con
// Any time up till this point, and you can apologize and she'll return whatever she drained
// Lie to her a 4th time, or once after apologizing "truthfully", and she will call the guards, and most of
// the foundry won't talk to you anymore.
ALTER_TRANS DSAROSSA BEGIN 13 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 11~ END

ADD_TRANS_TRIGGER DSAROSSA 5 ~Global("SarossaStatChange","GLOBAL",0)~ DO 1
EXTEND_TOP DSAROSSA 5 #2
IF ~Global("SarossaStatChange","GLOBAL",4)~ THEN
  REPLY #8440 /* ~Lie: "Yes."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_2","GLOBAL","Good","GLOBAL",-1)
PermanentStatChange (Protagonist,DEX,Lower,1)
SetGlobal("SarossaStatChange","GLOBAL",5)~ GOTO 11
IF ~Global("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8440 /* ~Lie: "Yes."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_2","GLOBAL","Good","GLOBAL",-1)
PermanentStatChange (Protagonist,CON,Lower,1)
SetGlobal("SarossaStatChange","GLOBAL",6)~ GOTO 11
IF ~GlobalGT("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8440 /* ~Lie: "Yes."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_2","GLOBAL","Good","GLOBAL",-1)
SetGlobal("SarossaStatChange","GLOBAL",7)~ GOTO 16
END

ADD_TRANS_TRIGGER DSAROSSA 6 ~Global("SarossaStatChange","GLOBAL",0)~ DO 5
EXTEND_TOP DSAROSSA 6 #6
IF ~Global("SarossaStatChange","GLOBAL",4)~ THEN
  REPLY #8448 /* ~Lie: "I apologize for causing you and yours pain."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_3","GLOBAL","Good","GLOBAL",-1)
PermanentStatChange (Protagonist,DEX,Lower,1)
SetGlobal("SarossaStatChange","GLOBAL",5)~ GOTO 11
IF ~Global("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8448 /* ~Lie: "I apologize for causing you and yours pain."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_3","GLOBAL","Good","GLOBAL",-1)
PermanentStatChange (Protagonist,CON,Lower,1)
SetGlobal("SarossaStatChange","GLOBAL",6)~ GOTO 11
IF ~GlobalGT("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8448 /* ~Lie: "I apologize for causing you and yours pain."~ */
  DO
~IncrementGlobalOnce("Evil_Sarossa_3","GLOBAL","Good","GLOBAL",-1)
SetGlobal("SarossaStatChange","GLOBAL",7)~ GOTO 16
END

ADD_TRANS_TRIGGER DSAROSSA 30 ~Global("SarossaStatChange","GLOBAL",0)~ DO 1
EXTEND_TOP DSAROSSA 30 #2
IF ~Global("SarossaStatChange","GLOBAL",4)~ THEN
  REPLY #8559 /* ~Lie: "Yes."~ */
  DO ~PermanentStatChange (Protagonist,DEX,Lower,1) SetGlobal("SarossaStatChange","GLOBAL",5)~ GOTO 11
IF ~Global("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8559 /* ~Lie: "Yes."~ */
  DO ~PermanentStatChange (Protagonist,CON,Lower,1) SetGlobal("SarossaStatChange","GLOBAL",6)~ GOTO 11
IF ~GlobalGT("SarossaStatChange","GLOBAL",5)~ THEN
  REPLY #8559 /* ~Lie: "Yes."~ */ DO ~SetGlobal("SarossaStatChange","GLOBAL",7)~ GOTO 16
END

// Added this in Version 3.0 - oops.
SET_WEIGHT DSAROSSA 3 #3

// Added this in Version 4.0
// This state is both bugged and redundant with state 4
ADD_STATE_TRIGGER DSAROSSA 42 ~False()~
// Replace set of G_Test2 to 12 with new variable, so it doesn't interfere with Dillon's epilogue to Thildon's fate
// And since she accepts any answer unless it's a lie, you'll only get the anger over her brother/father state once,
// then she's either forgiven you or you get the "Apologize for lying" state.  Much simpler this way.
REPLACE_ACTION_TEXT DSAROSSA ~SetGlobal ("G_Test2", "GLOBAL", 12)~ ~~
ADD_STATE_TRIGGER DSAROSSA 4 ~Global("Sarossa_Saros_Anger","AR0503",0)~
ADD_TRANS_ACTION DSAROSSA BEGIN 4 END BEGIN 0 1 2 3 4 END ~SetGlobal("Sarossa_Saros_Anger","AR0503",1)~

// ======================================== VERSION 3.0 ==============================================
// ~This is a placeholder to prevent future mods from putting a string with a sound file into strref 106498, which causes problems.~ []
REPLACE_SAY DTESTB 0 @106498

// Fix to Eli's dialogue to give him a proper line to say when he teaches you pickpocketing after you
// fail to pickpocket him.  Had to search for one because the one it should be in dialog.tlk is a bad
// copy of another line.  The one I chose isn't used anywhere else.
REPLACE_SAY DELI 52 #26793

// Need to reset Pickpocket variable once it's used.
ADD_TRANS_ACTION DELI BEGIN 50 51 END BEGIN END ~SetGlobal("CW_PP_Eli","GLOBAL",0)~

// Agril-Shanak wasn't setting a variable properly when he warned you he'd kill you next time he saw you.
// Also, was possible to get his "Free me" dialogue in Curst in Carceri, which was very bad.
// Finally, fixed a bad epilogue in one of the "I'll think about it" responses.
ADD_TRANS_ACTION DAGRIL BEGIN 21 END BEGIN 0 END ~SetGlobal("Free_Agril","GLOBAL",3)~
REPLACE_TRIGGER_TEXT DAGRIL ~NumTimesTalkedTo(0)~ ~~
ALTER_TRANS DAGRIL BEGIN 17 END BEGIN 2 END BEGIN "EPILOGUE" ~EXIT~ END

// ================================================== FROM PER'S BUGLIST =======================================================

// "* Bug: The three twig plots in Ravel's secret garden were only supposed to create one Black-Barbed Branch Wand each, but they're bugged so only the
// first one is flagged as taken no matter which one you use."
// This is an important fix - there is a use for the unconverted seeds later on in the game (talking to Mebbeth after returning from the Outlands)
// but this bug would allow you to convert all the seeds into wands, so you wouldn't have any left when you needed them.
REPLACE_TRIGGER_TEXT DBBPLOT1 ~!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)~
                              ~GlobalOrGlobal("BBPlot_Secret_2","GLOBAL","BBPlot_Secret_3","GLOBAL")~
REPLACE_TRIGGER_TEXT DBBPLOT2 ~!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)~
                              ~GlobalOrGlobal("BBPlot_Secret_1","GLOBAL","BBPlot_Secret_3","GLOBAL")~
REPLACE_TRIGGER_TEXT DBBPLOT3 ~!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)!Global("BBPlot_Secret_1", "GLOBAL", 0)~
                              ~GlobalOrGlobal("BBPlot_Secret_1","GLOBAL","BBPlot_Secret_2","GLOBAL")~
REPLACE_ACTION_TEXT DBBPLOT2 ~SetGlobal("BBPlot_Secret_1", "GLOBAL", 1)~ ~SetGlobal("BBPlot_Secret_2","GLOBAL",1)~
REPLACE_ACTION_TEXT DBBPLOT3 ~SetGlobal("BBPlot_Secret_1", "GLOBAL", 1)~ ~SetGlobal("BBPlot_Secret_3","GLOBAL",1)~

// Vhailor +1 Strength bonus was ungettable, in my judgment ranges for his bonus were 10 points too low.
REPLACE_TRANS_TRIGGER DVHAIL BEGIN 66 END BEGIN 0 END ~GlobalLT("Law", "GLOBAL", 15)~ ~GlobalLT("Law", "GLOBAL", 25)~
REPLACE_TRANS_TRIGGER DVHAIL BEGIN 66 END BEGIN 1 END
   ~GlobalGT("Law", "GLOBAL", 14)GlobalLT("Law", "GLOBAL", 25)~
   ~GlobalGT("Law", "GLOBAL", 24)GlobalLT("Law", "GLOBAL", 35)~
REPLACE_TRANS_TRIGGER DVHAIL BEGIN 66 END BEGIN 2 END ~GlobalGT("Law", "GLOBAL", 24)~ ~GlobalGT("Law", "GLOBAL", 34)~

// Removing duplicate journal entry when convincing Vhailor to die
ALTER_TRANS DVHAIL BEGIN 152 END BEGIN 0 END BEGIN "JOURNAL" ~~ END

// Several instances of telling Grace you are the 10th student were missing the 3000xp reward that you get if you ask her where the tenth student is
// first.  Also, the "ten stones beneath brothel" entry pointed to wrong strref in the original version that gave 3000xp, doesn't mention the stones.
ADD_TRANS_ACTION DGRACE BEGIN 120 END BEGIN 0 1 2 END ~AddexperienceParty(3000)~
ALTER_TRANS DGRACE BEGIN 122 END BEGIN 2 END BEGIN "REPLY" ~#28591~ END

// Standardizing Ignus xp reward for asking him about Reekwind's story to 8k xp- was 10k xp if you asked him at beginning of conversation, 6k xp after.
REPLACE_TRANS_ACTION DIGNUS BEGIN 16 END BEGIN 3 END ~10000~ ~8000~
REPLACE_TRANS_ACTION DIGNUS BEGIN 26 27 END BEGIN 3 END ~6000~ ~8000~

// Renouncing Dustmen for the Godsmen after finishing tests, you kept Dead Truce
ADD_TRANS_ACTION DKELDOR BEGIN 56 END BEGIN 2 END ~SetGlobal("Dead_Truce","GLOBAL",0)~

// Iannis experience award doubled up in some conversation paths in Iannis's dialogue
REPLACE_TRANS_ACTION DIANNIS BEGIN 29 30 END BEGIN 0 END
~SetGlobal("Know_Deionarra_Legacy", "GLOBAL", 2)~ ~~
REPLACE_TRANS_ACTION DIANNIS BEGIN 29 30 END BEGIN 0 END
~AddPartyExperience(8000)~ ~~
REPLACE_TRANS_ACTION DIANNIS BEGIN 29 30 END BEGIN 0 END
  ~FadeFromBlack()~
  ~FadeFromBlack()SetGlobal("Know_Deionarra_Legacy","GLOBAL",2)AddPartyExperience(8000)~

// Giving Conall the Anarchist password first would make Leena's quest to kill Vorten inaccessible
REPLACE_ACTION_TEXT DANARCH2 ~SetGlobal("Know_Anarchists", "GLOBAL", 1)~ ~~

// Snitching the Anarchists to Corvus had no effect.
REPLACE_ACTION_TEXT DHGCORV ~SetGlobal("Know_Anarchists","GLOBAL",2)~ ~SetGlobal("Know_Anarchists","GLOBAL",2)SetGlobal("Join_Anarchists","GLOBAL",2)~
REPLACE_ACTION_TEXT DHGCORV ~GlobalSet("Know_Anarchists","GLOBAL",2)~ ~SetGlobal("Know_Anarchists","GLOBAL",2)SetGlobal("Join_Anarchists","GLOBAL",2)~

// If Vhailor aggroes on you in dialogue, and you die or leave the area, and return, he just stands there and doesn't attack again.
// Same goes for Ignus and other PC's, tho Vhailor is the worst (and he can aggro on Grace or Annah instead of you, also.
// Creating these scripts in QwinnFix.tph and assigning them here.
REPLACE_ACTION_TEXT DVHAIL ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~
REPLACE_ACTION_TEXT DVHAIL ~Attack("Annah")~ ~Attack("Annah")ChangeAIScript("MDKAnnah",DEFAULT)~
REPLACE_ACTION_TEXT DVHAIL ~Attack("Grace")~ ~Attack("Grace")ChangeAIScript("MDKGrace",DEFAULT)~

REPLACE_ACTION_TEXT DIGNUS ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~
REPLACE_ACTION_TEXT DMORTE ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~
REPLACE_ACTION_TEXT DANNAH ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~
REPLACE_ACTION_TEXT DNORDOM ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~
REPLACE_ACTION_TEXT DDAKKON ~Attack(Protagonist)~ ~Attack(Protagonist)ChangeAIScript("MDKTNO",DEFAULT)~

// ============================================ END PER BUGFIXES ===================================================

// Missing journal entry from Soego in the Dead Nations if you had anyone in your party or left right away.
ALTER_TRANS DSOEGO BEGIN 71 END BEGIN 1 2 END BEGIN "JOURNAL" ~#21805~ END

// Waking up dialogue for Emoric and Phineas T. Lort
ADD_STATE_TRIGGER DEMORIC 96 ~Internal(Myself,INTERNAL_9,1)~
ADD_STATE_TRIGGER DPHINEAS 11 ~Internal(Myself,INTERNAL_9,1)~
ADD_TRANS_ACTION DEMORIC BEGIN 95 END BEGIN END ~SetInternal(Myself,9,1)~
ADD_TRANS_ACTION DPHINEAS BEGIN 10 END BEGIN END ~SetInternal(Myself,9,1)~
ADD_TRANS_ACTION DEMORIC BEGIN 96 END BEGIN END ~SetInternal(Myself,9,0)~
ADD_TRANS_ACTION DPHINEAS BEGIN 11 END BEGIN END ~SetInternal(Myself,9,0)~
SET_WEIGHT DEMORIC 96 #-100
SET_WEIGHT DPHINEAS 11 #-100

// Emoric dialogue check to see if Soego was still alive checked Mortuary Soego, not Dead Nations Soego
// Same with male zombies in Dead Nations
REPLACE_TRIGGER_TEXT DEMORIC ~Dead("Soego")~ ~Dead("Soego2")~
REPLACE_TRIGGER_TEXT DZOMCITM ~Dead("Soego")~ ~Dead("Soego2")~

// Allows you to tell the living dabus in the Alley of Lingering Sighs about the dead dabus before you
// talk to the alley itself.  This restores a few lines in the Alley's dialogue, and even increases the
// xp reward.
EXTEND_TOP DADABUS 4 #7
  IF ~Global("Know_Dead_Dabus","GLOBAL",1)CheckStatGT(Protagonist,12,INT)~ THEN REPLY #50348 GOTO 25
  IF ~Global("Know_Dead_Dabus","GLOBAL",2)~ THEN REPLY #50348 GOTO 25
 END
EXTEND_TOP DADABUS 18 #8
  IF ~Global("Know_Dead_Dabus","GLOBAL",1)CheckStatGT(Protagonist,12,INT)~ THEN REPLY #50348 GOTO 28
  IF ~Global("Know_Dead_Dabus","GLOBAL",2)~ THEN REPLY #50348 GOTO 28
 END
EXTEND_TOP DADABUS 20 #4
  IF ~Global("Know_Dabus_Speak","GLOBAL",1)Global("Know_Dead_Dabus","GLOBAL",1)CheckStatGT(Protagonist,12,INT)~ THEN REPLY #50348 GOTO 25
  IF ~Global("Know_Dabus_Speak","GLOBAL",1)Global("Know_Dead_Dabus","GLOBAL",2)~ THEN REPLY #50348 GOTO 25
 END
EXTEND_TOP DADABUS 20 #7
  IF ~Global("Know_Dabus_Speak","GLOBAL",0)Global("Know_Dead_Dabus","GLOBAL",1)CheckStatGT(Protagonist,12,INT)~ THEN REPLY #50348 GOTO 28
  IF ~Global("Know_Dabus_Speak","GLOBAL",0)Global("Know_Dead_Dabus","GLOBAL",2)~ THEN REPLY #50348 GOTO 28
 END

// A question for Asonje had an improper check on Pharod's quest attached.
REPLACE_TRANS_TRIGGER DZM1094 BEGIN 22 END BEGIN 5 END ~Global( "Pharod", "GLOBAL", 0 )~ ~~

// Talking to Yi'minn, you can ask the same question and get the same answer via about six different paths, but only one updates a major variable.
// The update doesn't seem really appropriate.  Taking it out.
REPLACE_TRANS_ACTION ~DYI'MINN~ BEGIN 2 END BEGIN 1 END ~SetGlobal("Know_Githyanki", "GLOBAL", 1)~ ~~

// In the Anarchist Skull's dialogue (in Lothar's kip), a state string doesn't really match the question, which means you can get repetitive
// questions with different replies.
ALTER_TRANS DANSKULL BEGIN 10 11 END BEGIN 0 END BEGIN "REPLY" ~#31734~ END

// The evil skull (Stern) is missing journal entries to several replies.
ALTER_TRANS DEVSKULL BEGIN 5 END BEGIN 1 2 3 END BEGIN "JOURNAL" ~#31712~ END

// You could "give" Scofflaw Penn Giltspur's handbill even if you didn't have it in your possession.
ADD_TRANS_TRIGGER DSCOFF 0  ~PartyHasItem("GiltBill")~ DO 6
ADD_TRANS_TRIGGER DSCOFF 12 ~PartyHasItem("GiltBill")~ DO 5
ADD_TRANS_TRIGGER DSCOFF 30 ~PartyHasItem("GiltBill")~ DO 1

// Several Lower Ward dialogue files had the second conversation state weight too high to ever be seen.
// Also female auction watcher in Curst
SET_WEIGHT DGENAF 17 #-1
SET_WEIGHT DLWGF 18 #-1
SET_WEIGHT DLWGM 18 #-1
SET_WEIGHT DCSTGENF 17 #-1
SET_WEIGHT DCSTGENF 18 #-2

// Harmonium Slave Guard in Lower Ward had a bad epilogue in his dialogue.
ALTER_TRANS DSGUARD3 BEGIN 5 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 2~ END

// Second-visit trigger in Market Worker 4 is misplaced
REPLACE_TRIGGER_TEXT DMW4 ~NumTimesTalkedToGT(0)~ ~~
ADD_STATE_TRIGGER DMW4 10 ~NumTimesTalkedToGT(0)~

// Foundry Fix - Added Alarm1 set at some appropriate places.  For Thildon, this effectively recreates the 3 alarm sets removed at the top of this file.
ADD_TRANS_ACTION DTHILDON BEGIN 23 END BEGIN 1 END ~SetGlobal("Alarm1","GLOBAL",1)~
ADD_TRANS_ACTION DSAROSSA BEGIN 0 END BEGIN 1 END ~SetGlobal("Alarm1","GLOBAL",1)~

// Foundry Fix - Have to give Keldor Alarm1 and Alarm2 states. Borrowing them from Kellera's dialogue, as they seem appropriate.
APPEND DKELDOR
  IF WEIGHT #-2 ~Global("Alarm2","GLOBAL",1)~ THEN BEGIN KELDOR-ALARM1
    SAY #6342
    IF ~~ THEN REPLY #6343 EXIT
  END

  IF WEIGHT #-1 ~Global("Alarm1","GLOBAL",1)~ THEN BEGIN KELDOR-ALARM2
    SAY #6344
    IF ~~ THEN REPLY #6347 EXIT
  END
END

// Foundry Fix - Bedai-Lihn answers "Who are you?" with way TMI as soon as you enter the Foundry. Putting a condition on that question.
ADD_TRANS_TRIGGER DBEDAI 59 ~GlobalGT("Sabotage","GLOBAL",1)~ 81 DO 6

// Foundry Fix - If you tell a guard that Bedai asked you to kill Sandoz, they tell you to talk to Keldor, but then set the quest complete
// variable so that it is impossible to do so or get the rewards.
REPLACE_ACTION_TEXT GFIGRD ~SetGlobal ("F_Ass", "GLOBAL", 5)~ ~~

// Foundry Journal Fixes - Missing or incorrect journal entries
ALTER_TRANS DKELDOR BEGIN 47 END BEGIN 0 END BEGIN "JOURNAL" ~#39499~ END
ALTER_TRANS DSAROS BEGIN 16 END BEGIN 1 END BEGIN "JOURNAL" ~#39514~ END

// This prevents being able to repeat information about the murder to Saros before you've acquired it.
ADD_TRANS_ACTION GFSUPE BEGIN 16 END BEGIN 12 END ~SetGlobal("G_Test2","GLOBAL",2)~
ADD_TRANS_ACTION GFSUPE BEGIN 29 END BEGIN 1 END  ~SetGlobal("G_Test2","GLOBAL",2)~
ADD_TRANS_ACTION GFSUPE BEGIN 30 END BEGIN 0 END  ~SetGlobal("G_Test2","GLOBAL",2)~
REPLACE_TRIGGER_TEXT DSAROS ~GlobalGT("G_Test2", "GLOBAL", 0)~ ~GlobalGT("G_Test2","GLOBAL",1)~

// Weapon workers can set the Sabotage quest value to 1, which breaks a lot of things and accomplishes nothing beneficial.
// One example of a break - as soon as they tell you it's a weapon, you can go to Keldor and tell him Bedai asked you to sabotage it,
// without her ever actually doing so, and complete the quest. Pretty bad especially if you pickpocketed token to do this early.
REPLACE_TRANS_TRIGGER GFWEAPS BEGIN 14 END BEGIN 2  END ~GlobalGT("Sabotage", "GLOBAL",0)~ ~~
REPLACE_TRANS_TRIGGER GFWEAPS BEGIN 14 END BEGIN 16 END ~Global("Sabotage","GLOBAL", 0)~ ~False()~

// Minor restoration of a couple of lines in Keldor's dialogue.  Creating G_Suspect variables in Setup-PST-Fix.tp2.
// Keldor's 44.3 can't be restored because you never get a Sardos "I have no alibi" conversation, you just jump straight to G_Test2 = 4.
ADD_TRANS_ACTION DTHILDON BEGIN 37 END BEGIN 0 1 2 END ~SetGlobal("G_Suspect_T","GLOBAL",1)~
ADD_TRANS_ACTION DTHILDON BEGIN 37 END BEGIN 0 END ~SetGlobal("G_Suspect_S","GLOBAL",1)~
REPLACE_TRANS_TRIGGER DKELDOR BEGIN 44 END BEGIN 1 END ~Global("G_Test2", "GLOBAL", 3)~ ~Global("G_Test2","GLOBAL",2)Global("G_Suspect_T","GLOBAL",1)~
REPLACE_TRANS_TRIGGER DKELDOR BEGIN 44 END BEGIN 2 END ~Global("G_Test2", "GLOBAL", 3)~ ~Global("G_Test2","GLOBAL",2)Global("G_Suspect_S","GLOBAL",1)~

// Bad transition in Hailcii dialogue
ALTER_TRANS DHAILCII BEGIN 30 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 43~ END

// A state weight in Kii'na's dialogue was too low.
SET_WEIGHT DKIINA 60 #8

// Fixing potential duplicate journal entry in Kii'na's dialogue
ALTER_TRANS DKIINA BEGIN 53 END BEGIN END BEGIN "JOURNAL" ~#39486~ END

// In Kii'na's dialogue when you don't know the language, she says she agrees to speak to you but the variable
// isn't set in a couple of cases. It also makes sense to remove it if Dak'kon and she almost come to blows.
ADD_TRANS_ACTION DKIINA BEGIN 29 END BEGIN 0 1 END ~SetGlobal("Kiina_Speak","GLOBAL",1)~
ADD_TRANS_ACTION DKIINA BEGIN 48 END BEGIN 0 END ~SetGlobal("Kiina_Speak","GLOBAL",0)~

// Dak'kon's potential interruption makes NumTimesTalkedTo and NumTimesTalkedToGT fail to work properly.
// Also adding more responses to the Know_Yiminn = 1 states so that his behavior upon talking to him after
// your having done enough for the githzerai for him to want to trap you makes sense.
// Adding variable Know_Yiminn
REPLACE_TRIGGER_TEXT ~DYI'MINN~ ~NumTimesTalkedTo(0)~ ~Global("Know_Yiminn","AR0500",0)~
REPLACE_TRIGGER_TEXT ~DYI'MINN~ ~NumTimesTalkedToGT(0)~ ~Global("Know_Yiminn","AR0500",1)~
ADD_TRANS_ACTION ~DYI'MINN~ BEGIN 0 1 2 25 47 48 END BEGIN END ~SetGlobal("Know_Yiminn","AR0500",1)~
EXTEND_TOP ~DYI'MINN~ 21 22
  IF ~Global("Know_Githyanki","GLOBAL",1)~ THEN REPLY #44392 GOTO 3
  IF ~Global("Know_Githyanki","GLOBAL",0)~ THEN REPLY #44393 GOTO 4
  IF ~GlobalGT("Know_Githzerai_Speak","GLOBAL",0)~ THEN REPLY #44394 DO ~SetGlobal("Yiminn_zerai","AR0500",1)~ GOTO 5
  IF ~~ THEN REPLY #44398 GOTO 6
  IF ~~ THEN REPLY #44401 GOTO 7
END

// Things with Kiina get weird unless we track independently if Dak'kon has talked to her.  New variable Dakkon_Know_Kiina
ADD_TRANS_ACTION DKIINA BEGIN 29 30 END BEGIN END ~SetGlobal("Dakkon_Know_Kiina","AR0500",1)~
REPLACE_STATE_TRIGGER DKIINA 27 ~NearbyDialog("DDakkon")Global("Dakkon_Know_Kiina","AR0500",0)GlobalLT("Vristigor","GLOBAL",2)~

// New variable Dakkon_Kiina_Morale exists to make sure repeatedly agreeing not to talk to her doesn't create an infinite
// Dak'kon morale exploit.
ADD_TRANS_TRIGGER DDAKKON 134 ~Global("Dakkon_Kiina_Morale","AR0500",0)~ DO 5
ADD_TRANS_ACTION DDAKKON BEGIN 134 END BEGIN 5 END ~SetGlobal("Dakkon_Kiina_Morale","AR0500",1)~
EXTEND_BOTTOM DDAKKON 134
  IF ~Global("Dakkon_Kiina_Morale","AR0500",1)~ THEN REPLY #43553 GOTO 135
END
ADD_TRANS_TRIGGER DDAKKON 136 ~Global("Dakkon_Kiina_Morale","AR0500",0)~ DO 2
ADD_TRANS_ACTION DDAKKON BEGIN 136 END BEGIN 2 END ~SetGlobal("Dakkon_Kiina_Morale","AR0500",1)~
EXTEND_TOP DDAKKON 136 #3
  IF ~Global("Dakkon_Kiina_Morale","AR0500",1)~ THEN REPLY #43559 GOTO 135
END

// Removed possibility of Iron Nalls creating an Annah-Zombie
REPLACE_TRIGGER_TEXT DIRONNA ~InParty("Annah")~ ~NearbyDialog("DAnnah")~

// Prevent possibility of getting Qui-Sai "Talk to Eli" quest stuck in your quest book
ADD_TRANS_TRIGGER DQUISAI 21 ~GlobalGT("Qui_Sai_Quest","GLOBAL",0)~ DO 0
ADD_TRANS_ACTION DQUISAI BEGIN 21 END BEGIN 0 END ~SetGlobal("Qui_Sai_Quest","GLOBAL",3)~
EXTEND_TOP DQUISAI 21 #1
  IF ~Global("Qui_Sai_Quest","GLOBAL",0)CheckStatGT(Protagonist,14,INT)Global("CW_Thorn_Ans","GLOBAL",0)~ THEN 
    REPLY #29048 DO ~SetGlobal("CW_Qui_Question","GLOBAL",4)AddexperienceParty(10000)~ GOTO 22
END

// Adding call to new script from QwinnFix.tph that plays alternate "What can change the nature..." cutscene with Ravel
// if you pass the stat check.
REPLACE_TRANS_ACTION DRAVEL BEGIN 97 END BEGIN 0 END ~StartCutScene("0610Cut9")~ ~StartCutScene("0610CutC")~

// Curst Thug allows you to ask one question, then "turns and walks away".  Except he doesn't walk away, and you get to
// repeat the same conversation over and over, asking him all you want.  Make him leave area after one question.
ADD_TRANS_ACTION DCSTTHG3 BEGIN 7 8 9 10 11 END BEGIN 0 END ~EscapeArea()~

// Lots of fixes needed to Tainted Barse's dialogue.  He'll notice if you turn him down now, and you won't
// get the nonsensical response that "You asked me to do something" when he hadn't yet.
REPLACE_TRANS_TRIGGER DTBARSE BEGIN 4 END BEGIN 3 END ~Global("Slavers", "GLOBAL", 0)~ ~Global("Slavers","GLOBAL",1)Global("Curst_Key","GLOBAL",0)~
REPLACE_TRANS_ACTION DTBARSE BEGIN 6 END BEGIN 1 END ~SetGlobal("Curst_Key", "GLOBAL", 1)~ ~SetGlobal("Slavers","GLOBAL",6)~
ALTER_TRANS DTBARSE BEGIN 6 END BEGIN 1 END BEGIN "JOURNAL" ~~ END
ALTER_TRANS DTBARSE BEGIN 6 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 9~ END

// Kester journal entry for splitting the inheritance is inappropriate - the blacksmith IS pleased. Using other entry
// without that remark from smith's dialogue.
ALTER_TRANS DKESTER BEGIN 17 END BEGIN 0 END BEGIN "JOURNAL" ~#61386~ END

// Kester's state triggers are bizarre and need tweaking.
// Originally: ~!Global("Mediate","GLOBAL",3)GlobalLT("Mediate","GLOBAL",4)NumTimesTalkedToGT(0)~
REPLACE_STATE_TRIGGER DKESTER 9 ~GlobalLT("Mediate","GLOBAL",4)NumTimesTalkedToGT(0)~
// Simplifying and correcting ~!Global("Mediate","GLOBAL",2)GlobalGT("Mediate","GLOBAL",1)GlobalLT("Mediate","GLOBAL",5)~
REPLACE_STATE_TRIGGER DKESTER 10 ~Global("Mediate","GLOBAL",4)~
// Two of the replies in that Medidate 4 state were non-sensical, picking better lines from dialogue file.
ALTER_TRANS DKESTER BEGIN 10 END BEGIN 4 END BEGIN "REPLY" ~#59032~ END
ALTER_TRANS DKESTER BEGIN 10 END BEGIN 5 END BEGIN "REPLY" ~#68291~ END


// ========================================== KNOW_GITHYANKI FIXES =============================================

// The way this variable gets set is exceedingly inconsistent.  You can ask some people what the difference is
// without ever having heard of githyanki.  It makes metagaming knowledge virtually required to avoid having the
// encounters end disastrously. Preventing other gith from explaining what a githyanki is before you've heard of
// one solves these problems.

// Adding variable Met_Githyanki

ADD_TRANS_ACTION ~DYI'MINN~ BEGIN 4 7 14 END BEGIN END ~SetGlobal("Met_Githyanki","GLOBAL",1)~
ADD_TRANS_TRIGGER DDAKKON 149 ~Global("Know_Githyanki","GLOBAL",1)~ DO 1
REPLACE_TRIGGER_TEXT DKIINA   ~Global("Know_Githyanki", "GLOBAL", 0)~ ~Global("Know_Githyanki","GLOBAL",0)Global("Met_Githyanki","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DHAILCII ~Global("Know_Githyanki", "GLOBAL", 0)~ ~Global("Know_Githyanki","GLOBAL",0)Global("Met_Githyanki","GLOBAL",1)~

// Hailcii's questions and sets are inconsistent.
ADD_TRANS_ACTION DHAILCII BEGIN 3 END BEGIN 4 END ~SetGlobal("Know_Githyanki","GLOBAL",1)~
APPEND DHAILCII
  IF ~~ THEN BEGIN Hailcii-Githyanki-1
    SAY #45174
    IF ~~ THEN REPLY #45175 GOTO Hailcii-Githyanki-2
    IF ~~ THEN REPLY #45176 GOTO 30
    IF ~~ THEN REPLY #45177 EXIT
  END
  IF ~~ THEN BEGIN Hailcii-Githyanki-2
    SAY #45181
    IF ~~ THEN REPLY #45182 GOTO 30
    IF ~~ THEN REPLY #45183 EXIT
  END
END

EXTEND_TOP DHAILCII 21 #4
  IF ~Global("Know_Githyanki","GLOBAL",0)Global("Met_Githyanki","GLOBAL",1)~ THEN REPLY #45146 DO ~SetGlobal("Know_Githyanki","GLOBAL",1)~ GOTO 6
  IF ~Global("Know_Githyanki","GLOBAL",1)~ THEN REPLY #45147 GOTO 6
  IF ~Global("Know_Githzerai_Speak","GLOBAL",0)~ THEN REPLY #45261 GOTO 7
END
EXTEND_TOP DHAILCII 29 30 44 #3
  IF ~Global("Know_Githyanki","GLOBAL",0)Global("Met_Githyanki","GLOBAL",1)~ THEN REPLY #45146 DO ~SetGlobal("Know_Githyanki","GLOBAL",1)~
      GOTO Hailcii-Githyanki-1
  IF ~Global("Know_Githyanki","GLOBAL",1)~ THEN REPLY #45147 GOTO Hailcii-Githyanki-1
END

// Restored journal entry for Dak'kon's explanation of the difference between Githzerai and Githyanki
ALTER_TRANS DDAKKON BEGIN 149 END BEGIN 0 END BEGIN "JOURNAL" ~#39453~ END


// =========================================== LOTHAR/SKULL FIXES ==============================================

// Incomplete trigger allows you to ask Lower Ward market customer about Lothar after you've dealt with Lothar
ADD_TRANS_TRIGGER DMCM4CLU 2 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 0

// Asking Hamrys about missing skull sets variable Know_Lothar when it shouldn't, as he doesn't mention Lothar
REPLACE_TRANS_ACTION DHAMRYS BEGIN 2 END BEGIN 2 END ~SetGlobal("Know_Lothar", "GLOBAL", 1)~ ~~

// Asking Byron about missing skull sets variable Know_Lothar before it should. Proper update already in place.
REPLACE_TRANS_ACTION DBYRON  BEGIN 5 END BEGIN 3 END ~SetGlobal("Know_Lothar", "GLOBAL", 1)~ ~~

// Asking several people about skull doesn't set variable Know_Lothar when it should, because they do identify him,
// including Lothar himself
ADD_TRANS_ACTION DSCOFF BEGIN 4 END BEGIN 1 END ~SetGlobal("Know_Lothar","GLOBAL",1)~
ADD_TRANS_ACTION DANARCH1 BEGIN 0 1 END BEGIN 3 END ~SetGlobal("Know_Lothar","GLOBAL",1)~
ADD_TRANS_ACTION DLENNY BEGIN 6 END BEGIN 0 END ~SetGlobal("Know_Lothar","GLOBAL",1)~
ADD_TRANS_ACTION DSABAST BEGIN 19 END BEGIN 0 END ~SetGlobal("Know_Lothar","GLOBAL",1)~
ADD_TRANS_ACTION DMW1 BEGIN 7 END BEGIN 0 END ~SetGlobal("Know_Lothar","GLOBAL",1)~
ADD_TRANS_ACTION DLOTHAR BEGIN 19 END BEGIN 0 END ~SetGlobal("Know_Lothar","GLOBAL",1)~

// Several incomplete triggers regarding asking about Morte being stolen
ADD_TRANS_TRIGGER DLWGF 14 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 1
ADD_TRANS_TRIGGER DLWGM 14 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 1
ADD_TRANS_TRIGGER DANARCH1 0 ~!Global("AR0508_Visited","GLOBAL",1)~ 1 DO 3
ADD_TRANS_TRIGGER DSCOFF 0 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 3
ADD_TRANS_TRIGGER DSCOFF 12 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 4
ADD_TRANS_TRIGGER DSCOFF 30 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 0
ADD_TRANS_TRIGGER DGILTSP 5 ~!Global("Know_Lothar","GLOBAL",1)~ DO 0
ADD_TRANS_TRIGGER DGILTSP 5 ~!Global("AR0508_Visited","GLOBAL",1)~ DO 1

// =============================================================================================================

// Spaces in Variables section:
// These seem to work even with the space in the variable, they must be automatically stripped out, but
// getting rid of them to be safe, and so they get included in Near Infinity searches.

// Variable names in Vaxis's dialogue checking if Morte has done his quip yet have extra space in them
REPLACE_TRIGGER_TEXT DVAXIS ~Morte_Vaxis_Quip _1~ ~Morte_Vaxis_Quip_1~
REPLACE_TRIGGER_TEXT DVAXIS ~Morte_Vaxis _Quip_1~ ~Morte_Vaxis_Quip_1~
REPLACE_ACTION_TEXT  DVAXIS ~Morte_Vaxis _Quip_1~ ~Morte_Vaxis_Quip_1~

// Chaotic alignment hit when baiting Clerk's Ward audience members had an extra space
REPLACE_ACTION_TEXT DCWACTF  ~Chaotic_ Audience _1~ ~Chaotic_Audience_1~
REPLACE_ACTION_TEXT DCWACTM  ~Chaotic_ Audience _1~ ~Chaotic_Audience_1~
REPLACE_ACTION_TEXT DCWPOETF ~Chaotic_ Audience _1~ ~Chaotic_Audience_1~

// Jumble's chaotic hits had an extra space
REPLACE_ACTION_TEXT DJUMBLE  ~Chaotic_ Jumble _1~ ~Chaotic_Jumble_1~

// Nameless Zombie in Dead Nations - Speak with Dead check had an extra name
REPLACE_TRIGGER_TEXT DNONAME ~Speak_With_ Dead~ ~Speak_With_Dead~

// Craddock's check on if you got quest from Baen had space
REPLACE_TRIGGER_TEXT DCRADDO ~Baen _Quest~ ~Baen_Quest~

// Absorbing Paranoid Incarnation variable had space, though it doesn't appear to be used anywhere
REPLACE_ACTION_TEXT DINCAR2 ~Absorb_Paranoid _Incarnation~ ~Absorb_Paranoid_Incarnation~

// ==================================== "GAINED AN ABILITY" SOUND ====================================
// Moved to UB RS&B 4.0, since it really is a restoration



// ========================================= VERSION 4.0 =============================================

// If you aborted joining the Godsmen and then talked to Keldor again, you could become a Godsman without taking the
// oath or the appropriate checks applied.
REPLACE_TRANS_ACTION DKELDOR BEGIN 12 END BEGIN 12 END ~SetGlobal("Join_Godsmen", "GLOBAL", 6)~ ~~

// Nordom dialogue error, asking Nordom about Mechanus when Morte is NOT around.
ALTER_TRANS DNORDOM BEGIN 64 END BEGIN 2 END BEGIN "REPLY" ~#55293~ END

// Error in Raimon's dialogue
ALTER_TRANS WDRGUARD BEGIN 10 END BEGIN 0 END BEGIN "REPLY" ~#48264~ END

// Vivian response if you were evil to her has trigger, but good response does not, so if you are evil you get same response twice.
ADD_TRANS_TRIGGER DVIVIAN 31 ~Global("Evil_Vivian_1","GLOBAL",0)~ DO 0

// Replace use of Pendant of Yemeth quest variable with new variable Evil_PuzSkel
REPLACE_TRIGGER_TEXT DPUZSKEL ~Evil_Adyzoel_1", "GLOBAL"~ ~Evil_PuzSkel","AR1500"~
REPLACE_ACTION_TEXT DPUZSKEL ~Evil_Adyzoel_1", "GLOBAL"~ ~Evil_PuzSkel","AR1500"~

// Path in Dak'kon dialogue doesn't set variable required to get Xachariah's name from him later despite getting you the information you need
ADD_TRANS_ACTION DDAKKON BEGIN 91 END BEGIN 1 END ~SetGlobal("Fell_Dakkon_Truth","GLOBAL",1)~

// Killing Vorten no longer creates quest in your journal even if you didn't have it.  See QwinnFix.tph for rest of fix.
REPLACE_TRIGGER_TEXT DANARCH1 ~Global("Kill_Vorten", "GLOBAL", 2)~ ~Global("Kill_Vorten", "GLOBAL", 1)Dead("Vorten")~
ADD_TRANS_TRIGGER DANARCH1 7 ~!Dead("Vorten")~ DO 1 2 3
REPLACE_TRIGGER_TEXT DHGCORV ~Global("Kill_Vorten","GLOBAL", 1)~ ~Global("Kill_Vorten","GLOBAL",1)!Dead("Vorten")~
REPLACE_TRIGGER_TEXT DHGCORV ~GlobalGT("Kill_Vorten","GLOBAL", 1)~ ~GlobalGT("Kill_Vorten","GLOBAL",0)Dead("Vorten")~
REPLACE_TRIGGER_TEXT DSCOFF ~Global("Kill_Vorten", "GLOBAL", 1)~ ~Global("Kill_Vorten","GLOBAL",1)!Dead("Vorten")~

// Also redoing quest.ini so that Kill Vorten quest closed after turning Anarchists in to Vorten.
// This sets the variable quest.ini will look for to consider the quest closed.
ADD_TRANS_ACTION DHGCORV BEGIN 37 END BEGIN 0 END ~SetGlobal("Kill_Vorten","GLOBAL",4)~
ADD_TRANS_ACTION DHGCORV BEGIN 35 END BEGIN 2 END ~SetGlobal("Kill_Vorten","GLOBAL",5)~
ADD_TRANS_ACTION DHGCORV BEGIN 35 END BEGIN 3 END ~SetGlobal("Kill_Vorten","GLOBAL",6)~

// Weapon workers would incorrectly think Bedai was arrested for the Godsman murder which actually isn't possible
REPLACE_TRIGGER_TEXT GFWEAPS ~!Global ("G_Test2", "GLOBAL", 8)~ ~~
ADD_TRANS_TRIGGER GFWEAPS 2 ~False()~ DO 12
ADD_TRANS_TRIGGER GFWEAPS 14 ~False()~ DO 13
REPLACE_TRIGGER_TEXT GFWEAPS ~!Global ("G_Test2", "GLOBAL", 12)~ ~~
REPLACE_TRIGGER_TEXT GFWEAPS ~Global ("G_Test2", "GLOBAL", 12)~ ~~

// Removing options to keep asking Bedai about the murder after it's been solved
// REPLACE_TRIGGER_TEXT DBEDAI ~GlobalGT("G_Test2","GLOBAL",6)~ ~GlobalGT("G_Test2","GLOBAL",6)GlobalLT("G_Test2","GLOBAL",9)~

// Jolmi, Yi'minn and Death's Advocate weren't incrementing the Death counter when you died in dialogue with them.
ADD_TRANS_ACTION DJOLMI BEGIN 10 END BEGIN 0 END ~IncrementGlobal("Death","GLOBAL",1)~
ADD_TRANS_ACTION ~DYI'MINN~ BEGIN 44 END BEGIN 0 END ~IncrementGlobal("Death","GLOBAL",1)~
ADD_TRANS_ACTION DDEATHAD BEGIN 41 47 END BEGIN 0 END ~IncrementGlobal("Death","GLOBAL",1)~

// Prevent restarting dialogue with Ravel just prior to her attack, which allows major XP exploits.
ADD_TRANS_ACTION DRAVEL BEGIN 237 END BEGIN 0 1 END ~SetGlobal("Ravel_Cut_Scene","AR0610",9)~

// Added Tek'elach to the list of Curst-In-Carceri critters that wouldn't remember prior meetings, in the section where most
// of them were initially handled.

// Fixes to Barkis's dialogue.
ALTER_TRANS DBARKIS BEGIN 2 END BEGIN 11 END BEGIN "EPILOGUE" ~GOTO 35~ END
REPLACE_TRANS_TRIGGER DBARKIS BEGIN 24 END BEGIN 0 END ~GlobalGT ("Mochai", "GLOBAL", 3)~ ~~
EXTEND_TOP DBARKIS 24 #1
  IF ~GlobalGT ("Mochai", "GLOBAL", 3)~ THEN REPLY #10381 GOTO 17
 END

// Zombie 1201 had a redoable chaotic alignment hit when you tried to take note.  Solution is to remove hit altogether, that hit is supposed to be
// for talking to zombies.
ALTER_TRANS DZM1201 BEGIN 0 END BEGIN 0 END BEGIN "ACTION" ~~ END

// When you tell Nordom to go hostile, he stays in party, which causes problems (such as remaining hostile after resurrection)
ADD_TRANS_ACTION DNORDOM BEGIN 81 END BEGIN 4 END ~LeaveParty()~

// Ditto angering Ignus
ADD_TRANS_ACTION DIGNUS BEGIN 29 END BEGIN 0 END ~LeaveParty()~

// Return_Fhjull variable wasn't being set, making state 25 impossible to reach.  This effectively restores a previously unheard sound file.
ADD_TRANS_ACTION DFHJULL BEGIN 24 END BEGIN END ~SetGlobal("Return_Fhjull","GLOBAL",1)~

// When Vlask sells you a second bead, you don't actually get it.
REPLACE_ACTION_TEXT DVLASK ~GiveItem( "VKey", Protagonist )~ ~GiveItemCreate("Vkey",Protagonist,1,0,0)~
REPLACE_ACTION_TEXT DVLASK ~GiveItem("Vkey", Protagonist )~ ~GiveItemCreate("Vkey",Protagonist,1,0,0)~
REPLACE_ACTION_TEXT DVLASK ~GiveItem("VKey", Protagonist)~ ~GiveItemCreate("Vkey",Protagonist,1,0,0)~

// One path in Vlask's dialogue doesn't start his exit cutscene
ALTER_TRANS DVLASK BEGIN 4 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 5~ END

// Drusilla obsessed state has bad weight, can never be seen
SET_WEIGHT DSCPAT2 15 #0

// Neither Annah nor Grace reacts when you sleep with a Harlot in front of them.  Annah's reaction should override, just like with Ucho in Clerks.
REPLACE_TRANS_TRIGGER DHARLOTN BEGIN 5 END BEGIN 0 END ~!NearbyDialog("DGrace")~ ~~

// If you killed Mar after getting his axe through dialogue, you'd get a second ax
REPLACE_TRANS_ACTION DMAR BEGIN 15 END BEGIN 1 END ~GiveItemCreate("Hax", protagonist, 1, 0, 0)~ ~GiveItem("Hax",Protagonist)~

// Fixes to Kuu-Yin's dialogue
ALTER_TRANS DKUUYIN BEGIN 4 END BEGIN 0 END BEGIN "JOURNAL" ~~ END
ALTER_TRANS DKUUYIN BEGIN 3 END BEGIN 0 END BEGIN "JOURNAL" ~#66390~ END
ADD_TRANS_ACTION DKUUYIN BEGIN 3 END BEGIN 2 END ~EscapeArea()~

// Noroch wasn't giving the copper and bandage rewards indicated by the text if you took care of the pickpocket before being given the quest
ADD_TRANS_ACTION DNOROCHJ BEGIN 7 END BEGIN 0 3 END
~GivePartyGold(300)
GiveItemCreate("Bandage",Protagonist,1,0,0)
GiveItemCreate("Bandage",Protagonist,1,0,0)
GiveItemCreate("Bandage",Protagonist,1,0,0)~
ADD_TRANS_ACTION DNOROCHJ BEGIN 7 END BEGIN 1 4 END ~GivePartyGold(200)~
ADD_TRANS_ACTION DNOROCHJ BEGIN 7 END BEGIN 2 5 END ~GivePartyGold(100)~

// Morale hits for having Dak'kon kill An'azi painfully are inconsistent
ADD_TRANS_ACTION DDAKKON BEGIN 124 END BEGIN 1 END ~MoraleDec("Dakkon",1)~
ADD_TRANS_ACTION DDAKKON BEGIN 126 END BEGIN 1 END ~MoraleDec("Dakkon",1)~

// Adding variable set for purpose of fixing the "Get stolen evidence" quest.  See QwinnFix.tph for rest.
ADD_TRANS_ACTION DHGCORV BEGIN 31 END BEGIN 0 1 END ~SetGlobal("Evidence_Papers","GLOBAL",5)~

// FFG banter uses inappropriate voiced line (FFG326) for Morte's first banter, an appropriate one exists (FFG121).
REPLACE_SAY BGRACE 0 @101

// Soego's dialogue:  Experience award duplicated
REPLACE_TRANS_ACTION DSOEGO BEGIN 60 END BEGIN 0 END ~AddPartyExperience(500)~ ~~
REPLACE_TRANS_ACTION DSOEGO BEGIN 60 END BEGIN 0 END ~AddPartyExperience (500)~ ~~
REPLACE_TRANS_ACTION DSOEGO BEGIN 60 END BEGIN 0 END ~SetGlobal ("Gate_Open", "GLOBAL", 1)~ ~~
ADD_TRANS_ACTION DSOEGO BEGIN 60 END BEGIN 0 END ~AddPartyExperience(500)SetGlobal("Gate_Open","GLOBAL",1)~

// Dustman conversation - you get to claim "Adahn" even with low INT, supposed to be >12 INT only
REPLACE_TRANS_TRIGGER DDUST BEGIN 9 END BEGIN 7 END ~CheckStatLT~ ~CheckStatGT~
REPLACE_TRANS_TRIGGER DDUSTFEM BEGIN 9 END BEGIN 7 END ~CheckStatLT~ ~CheckStatGT~

// Female dustman lacks the Adahn and Chaotic hits that the male dustman has
ADD_TRANS_ACTION DDUSTFEM BEGIN 9 END BEGIN 7 END ~IncrementGlobal("Adahn","GLOBAL",1)IncrementGlobal("Law","GLOBAL",-1)~

// Blackrose needs an EscapeArea() when he says Farewell, he has no reason to remain and no valid dialogue states after this point.
ADD_TRANS_ACTION DBLACKR BEGIN 10 END BEGIN 0 END ~EscapeArea()~

// Set Lim-Lim fled variable
ADD_TRANS_ACTION DPETLIMC BEGIN 3 END BEGIN END ~SetGlobal("Buy_LL","GLOBAL",2)~
REPLACE_ACTION_TEXT D300MER5 ~Enemy()~ ~~
ADD_TRANS_ACTION D300MER5 BEGIN 12 13 END BEGIN 0 END ~RunAwayFrom(Protagonist,30)SetInternal(Myself,INTERNAL_1,1)~

// Cutscenes in Fortress should take away lives, not add to them.
REPLACE_ACTION_TEXT DMACH1 ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL",1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~
REPLACE_ACTION_TEXT DMACH1 ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL", 1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~
REPLACE_ACTION_TEXT DMACH2 ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL",1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~
REPLACE_ACTION_TEXT DMACH2 ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL", 1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~
REPLACE_ACTION_TEXT DMACH3 ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL",1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~
REPLACE_ACTION_TEXT DMACH4 ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",1)~ ~IncrementGlobal("Fortress_Death_Counter","GLOBAL",-1)~

// Scofflaw Penn would kick you out, and you'd get a journal entry that the door was locked, but it would remain open until you entered again.
REPLACE_TRANS_ACTION DSCOFF BEGIN 53 END BEGIN 0 END ~IncrementGlobal("Penn_Out", "GLOBAL", 1)~ ~SetGlobal("Penn_Out","GLOBAL",2)~

// Missing line in Vhailor's altercation with Grace and Annah restored
ALTER_TRANS DGRACE BEGIN 200 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DVHAIL 101~ END

// Remove infinite morale loop in Kesai's dialogue
ADD_TRANS_TRIGGER DKESAI 33 ~Global("Kesai_Eyes_Flirt","GLOBAL",0)~ DO 0 1
ADD_TRANS_ACTION DKESAI BEGIN 33 END BEGIN 0 1 END ~SetGlobal("Kesai_Eyes_Flirt","GLOBAL",1)~

// Aelwyn journal entry issues
ALTER_TRANS DAELWYN BEGIN 29 END BEGIN 2 END BEGIN "JOURNAL" ~#56812~ END
ALTER_TRANS DAELWYN BEGIN 31 END BEGIN 0 END BEGIN "JOURNAL" ~#56812~ END
ALTER_TRANS DAELWYN BEGIN 31 END BEGIN 1 END BEGIN "JOURNAL" ~~ END
REPLACE_TRANS_ACTION DAELWYN BEGIN 29 END BEGIN 1 END ~SetGlobal("Aelwyn", "GLOBAL", 5)~ ~~
ADD_TRANS_ACTION DAELWYN BEGIN 31 END BEGIN 0 END ~SetGlobal("Aelwyn","GLOBAL",5)~

// Talking to weapons workers, you get option about Kellera talking to Dak'kon after you already have, which is indeed odd.
ADD_TRANS_ACTION DKELLERA BEGIN 9 END BEGIN 0 END ~SetGlobal("Kellera_Met_Dakkon","AR0512",1)~
ADD_TRANS_ACTION DKELLERA BEGIN 21 END BEGIN END ~SetGlobal("Kellera_Met_Dakkon","AR0512",1)~
ADD_TRANS_TRIGGER GFWEAPS 5 ~Global("Kellera_Met_Dakkon","AR0512",0)~ DO 0

// Specialization check in Pillar of Skull's dialogue was reversed for mage and thief.
REPLACE_TRANS_TRIGGER DPILLAR BEGIN 57 END BEGIN 1 END ~Global("Specialist", "GLOBAL", 5)~ ~Global("Specialist","GLOBAL",6)~
REPLACE_TRANS_TRIGGER DPILLAR BEGIN 57 END BEGIN 2 END ~Global("Specialist", "GLOBAL", 6)~ ~Global("Specialist","GLOBAL",5)~


// ============================================== Replacing NumTimesTalkedTo ========================================================
// In many cases, you have an option to ignore a person when you initiate dialogue.  If you then speak to them again, the game reacts
// as if you had been introduced, and you know their name. These fixes delay getting to the new state until that introduction actually
// takes place.
// These all require new variables, set up in Setup-PST-Fix.tp2

REPLACE_TRIGGER_TEXT DROBERTA ~NumTimesTalkedTo(0)~ ~Global("Roberta","AR0700",0)~
REPLACE_TRIGGER_TEXT DROBERTA ~NumTimesTalkedToGT(0)~ ~Global("Roberta","AR0700",1)~
ADD_TRANS_ACTION DROBERTA BEGIN 2 END BEGIN END ~SetGlobal("Roberta","AR0700",1)~




// ===================================================== V4.0 FACTION STUFF =======================================================

// If you abort your conversation about joining the Dustmen, you're supposed to lose the chance to ever do so again. But, if you become a
// Godsman, Sensate or Xaositect, you could still ask to join again and you'd get Noroch's quest, but after that Emoric would no longer
// acknowledge your desire to join. If you belong to no faction or the Anarchists, then it does the proper check and you can't ask to join
// again. Making it so you are no longer started on Noroch's quest if you've cut yourself off in this manner, regardless of your current
// faction status.
ADD_TRANS_TRIGGER DEMORIC 6 ~Global("Join_Dustmen","GLOBAL",0)~ DO 3 4 5


// When you ask Emoric to join the Dustmen, if you already belong to a faction, he asks you if you're willing to renounce your old faction.
// But the state where you actually -do- renounce your faction is orphaned. I'm restoring it, seeing as how the only other faction leader
// that gives a quest chain as a requirement for joining, Keldor the Godsman, also requires you to actually renounce your other faction
// membership before he'll start you on his quest chain. Interestingly, you can actually still avoid renouncing your faction at the
// beginning and still get Emoric's quest chain by lying to him with a high charisma, which is a pretty cool option that becomes trivial
// unless the actual renunciation if you don't lie is restored. Either way, when you finally complete his quest chain and actually become
// a Dustman, at that point you WILL lose any other faction memberships (except Anarchists, since you'd be infiltrating). This won't always
// be acknowledged in dialogue, but it will happen, so the lying doesn't actually allow you to join two factions, it just lets you remain
// in your old faction until you actually take the Dustman oath.
// First, fixing the bugs in the orphaned state:
// You could get two identical "Renounce old faction" responses if you are a Xaositect, and the second line would actually make you renounce
// Sensates even if you didn't belong to them.
REPLACE_TRANS_TRIGGER DEMORIC BEGIN 47 END BEGIN 2 END
   ~!Global ("Join_Dustmen", "GLOBAL", 1)~ ~!Global("Join_Chaosmen","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",3)~
ALTER_TRANS DEMORIC BEGIN 47 END BEGIN 0 1 2 3 END BEGIN "EPILOGUE" ~GOTO 46~ END
ALTER_TRANS DEMORIC BEGIN 45 END BEGIN 0 1 END BEGIN "EPILOGUE" ~GOTO 47~ END
ADD_TRANS_TRIGGER DEMORIC 45 ~False()~ DO 1

// You could restart Emoric's quest chain by completing most of it, then before joining join the Anarchists, then pick the Infiltrate option.
// This was a bug in vanilla, nothing to do with my overhaul.
ADD_TRANS_TRIGGER DEMORIC 6 ~Global("Dustman_Initiation","GLOBAL",0)~ DO 7

// If completing quest and a member of Anarchists, make it clear at -that- time that you're infiltrating.
ADD_TRANS_TRIGGER DEMORIC 72 ~!Global("Join_Anarchists","GLOBAL",1)~ DO 0
EXTEND_TOP DEMORIC 72
  IF ~Global("Join_Anarchists","GLOBAL",1)~ THEN REPLY @115 DO ~SetGlobal("Dustman_Initiation","GLOBAL",6)~ GOTO 73
 END

// FACTION OVERHAUL
// SENSATES
ALTER_TRANS DSPLINT BEGIN 17 END BEGIN 2 END BEGIN "REPLY" ~@102~ "EPILOGUE" ~GOTO 24~ END
ADD_TRANS_TRIGGER DSPLINT 17
 ~!Global("Join_Godsmen","GLOBAL",6)!Global("Join_Dustmen","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",3)~ DO 2
ADD_TRANS_ACTION DSPLINT BEGIN 17 END BEGIN 2 END
 ~SetGlobal("Join_Sensates","GLOBAL",1)SetGlobal("Sensate_Access","GLOBAL",1)IncrementGlobalOnce("Chaotic_Splinter_1","GLOBAL","Law","GLOBAL",-1)~
ADD_TRANS_TRIGGER DSPLINT 17 ~False()~ DO 6

ADD_TRANS_TRIGGER DSPLINT 23 ~!Global("Join_Anarchists","GLOBAL",1)~ DO 0 1 3
ADD_TRANS_TRIGGER DSPLINT 23 ~False()~ DO 2 4
REPLACE_TRANS_TRIGGER DSPLINT BEGIN 26 END BEGIN 0 END ~Global ("Join_Sensates", "GLOBAL", 1)~ ~!Global("Join_Anarchists","GLOBAL",1)~
REPLACE_TRANS_TRIGGER DSPLINT BEGIN 26 END BEGIN 1 END ~Global ("Join_Sensates", "GLOBAL", 0)~ ~Global("Join_Anarchists","GLOBAL",1)~
EXTEND_TOP DSPLINT 23 #5
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Godsmen","GLOBAL",6)~ THEN REPLY @103 DO
    ~SetGlobal("Join_Godsmen","GLOBAL",7)SetGlobal("Join_Sensates","GLOBAL",1)IncrementGlobalOnce("Chaotic_Splinter_1","GLOBAL","Law","GLOBAL",-1)
     SetGlobal("Sensate_Access","GLOBAL",1)~ GOTO 24
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Dustmen","GLOBAL",1)~ THEN REPLY @104 DO
    ~SetGlobal("Join_Dustmen","GLOBAL",2)SetGlobal("Join_Sensates","GLOBAL",1)IncrementGlobalOnce("Chaotic_Splinter_1","GLOBAL","Law","GLOBAL",-1)
     SetGlobal("Sensate_Access","GLOBAL",1)SetGlobal("Dead_Truce","GLOBAL",0)~ GOTO 24
  IF ~Global("Join_Anarchists","GLOBAL",1)GlobalGT("Join_Chaosmen","GLOBAL",0)!Global("Join_Chaosmen","GLOBAL",2)~ THEN REPLY @105 DO
    ~SetGlobal("Join_Chaosmen","GLOBAL",2)SetGlobal("Join_Sensates","GLOBAL",1)IncrementGlobalOnce("Chaotic_Splinter_1","GLOBAL","Law","GLOBAL",-1)
     SetGlobal("Sensate_Access","GLOBAL",1)~ GOTO 24
 END

// XAOSITECTS
ALTER_TRANS DBARKING BEGIN 25 END BEGIN 2 END BEGIN "REPLY" ~@109~ "EPILOGUE" ~GOTO 28~ END
ADD_TRANS_TRIGGER DBARKING 25 ~!Global("Join_Godsmen","GLOBAL",6)!Global("Join_Dustmen","GLOBAL",1)!Global("Join_Sensates","GLOBAL",1)~ DO 2
ADD_TRANS_ACTION DBARKING BEGIN 25 END BEGIN 2 END
  ~SetGlobal("Join_Chaosmen","GLOBAL",1)AddexperienceParty(1000)IncrementGlobalOnce("Chaotic_Wilder_2","GLOBAL","Law","GLOBAL",-1)~
ADD_TRANS_TRIGGER DBARKING 25 ~False()~ DO 6

ADD_TRANS_TRIGGER DBARKING 27 ~!Global("Join_Anarchists","GLOBAL",1)~ DO 0 1 3
ADD_TRANS_TRIGGER DBARKING 27 ~False()~ DO 2 4
EXTEND_TOP DBARKING 27 #5
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Godsmen","GLOBAL",6)~ THEN REPLY @110 DO
    ~SetGlobal("Join_Godsmen","GLOBAL",7)SetGlobal("Join_Chaosmen","GLOBAL",1)IncrementGlobalOnce("Chaotic_Wilder_2","GLOBAL","Law","GLOBAL",-1)
     AddexperienceParty(1000)~ GOTO 28
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Dustmen","GLOBAL",1)~ THEN REPLY @111 DO
    ~SetGlobal("Join_Dustmen","GLOBAL",2)SetGlobal("Join_Chaosmen","GLOBAL",1)IncrementGlobalOnce("Chaotic_Wilder_2","GLOBAL","Law","GLOBAL",-1)
     SetGlobal("Dead_Truce","GLOBAL",0)AddexperienceParty(1000)~ GOTO 28
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Sensates","GLOBAL",1)~ THEN REPLY @112 DO
    ~SetGlobal("Join_Sensates","GLOBAL",2)SetGlobal("Join_Chaosmen","GLOBAL",1)IncrementGlobalOnce("Chaotic_Wilder_2","GLOBAL","Law","GLOBAL",-1)
     ApplySpell(Protagonist,SPECIAL_REMOVE_SENSORY_TOUCH)AddexperienceParty(1000)~ GOTO 24
 END

// DUSTMEN
ADD_TRANS_TRIGGER DEMORIC 6 ~!Global("Join_Anarchists","GLOBAL",1)~ DO 3 4 5 6
ADD_TRANS_TRIGGER DEMORIC 6
   ~!Global("Join_Godsmen","GLOBAL",6)!Global("Join_Sensates","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",3)~ DO 7
EXTEND_TOP DEMORIC 6 #7
  IF ~Global("Dustman_Initiation","GLOBAL",0)Global("Join_Anarchists","GLOBAL",1)Global("Join_Godsmen","GLOBAL",6)~ THEN REPLY #14844 GOTO 41
  IF ~Global("Dustman_Initiation","GLOBAL",0)Global("Join_Anarchists","GLOBAL",1)Global("Join_Sensates","GLOBAL",1)~ THEN REPLY #14844 GOTO 41
  IF ~Global("Dustman_Initiation","GLOBAL",0)Global("Join_Anarchists","GLOBAL",1)GlobalGT("Join_Chaosmen","GLOBAL",0)!Global("Join_Chaosmen","GLOBAL",2)~ THEN REPLY #14844 GOTO 41
 END
ADD_TRANS_TRIGGER DEMORIC 47 ~!Global("Join_Anarchists","GLOBAL",1)~ DO 0 1 2
ADD_TRANS_TRIGGER DEMORIC 47 ~False()~ DO 3
EXTEND_TOP DEMORIC 47 #4
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Godsmen","GLOBAL",6)~ THEN REPLY @106 DO
    ~SetGlobal("Join_Godsmen","GLOBAL",7)~
    GOTO 46
  IF ~Global("Join_Anarchists","GLOBAL",1)GlobalGT("Join_Chaosmen","GLOBAL",0)!Global("Join_Chaosmen","GLOBAL",2)~ THEN REPLY @107 DO
    ~SetGlobal("Join_Chaosmen","GLOBAL",2)~
    GOTO 46
  IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Sensates","GLOBAL",1)~ THEN REPLY @108 DO
    ~SetGlobal("Join_Sensates","GLOBAL",2)ApplySpell(Protagonist,SPECIAL_REMOVE_SENSORY_TOUCH)~ GOTO 46
 END
ALTER_TRANS DEMORIC BEGIN 79 END BEGIN 2 3 4 END BEGIN "REPLY" ~#15858~ "JOURNAL" ~#61611~ END
ADD_TRANS_ACTION DEMORIC BEGIN 79 END BEGIN 2 3 4 END ~SetGlobal("Dead_Truce","GLOBAL",1)~
ADD_TRANS_TRIGGER DEMORIC 79 ~!Global("Join_Godsmen","GLOBAL",6)!Global("Join_Sensates","GLOBAL",1)!Global("Join_Chaosmen","GLOBAL",1)
  !Global("Join_Chaosmen","GLOBAL",3)~ DO 1
EXTEND_TOP DEMORIC 79 #2
   IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Godsmen","GLOBAL",6)~ THEN
       REPLY #15860 DO ~SetGlobal("Join_Godsmen","GLOBAL",7)SetGlobal("Join_Dustmen","GLOBAL",1)GiveExperience(Protagonist,1000)~ GOTO 80
   IF ~Global("Join_Anarchists","GLOBAL",1)Global("Join_Sensates","GLOBAL",1)~ THEN
       REPLY #15860 DO ~SetGlobal("Join_Sensates","GLOBAL",2)ApplySpell(Protagonist,SPECIAL_REMOVE_SENSORY_TOUCH)
       SetGlobal("Join_Dustmen","GLOBAL",1)GiveExperience(Protagonist,1000)~ GOTO 80
   IF ~Global("Join_Anarchists","GLOBAL",1)GlobalGT("Join_Chaosmen","GLOBAL",0)!Global("Join_Chaosmen","GLOBAL",2)~ THEN
       REPLY #15860 DO ~SetGlobal("Join_Chaosmen","GLOBAL",2)SetGlobal("Join_Dustmen","GLOBAL",1)GiveExperience(Protagonist,1000)~ GOTO 80
  END


// ================================================== END V4.0 FACTION STUFF =======================================================

/*
// Sigh.  The Iannis fixes will never end.
// Talk to Iannis, find out his daughter died but not her name, you can then tell him about sensory stones when you don't know he's -her- father.
// Replace Know_Iannis_Deionarra_Truth with Know_Iannis_Daughter_Truth.  Then add in Daughter stuff, including changing some back.
REPLACE_TRIGGER_TEXT DIANNIS ~Know_Iannis_Deionarra_Death~ ~Know_Iannis_Daughter_Death~
REPLACE_ACTION_TEXT DIANNIS ~Know_Iannis_Deionarra_Death~ ~Know_Iannis_Daughter_Death~
ADD_TRANS_ACTION DIANNIS BEGIN 59 60 63 END BEGIN END ~SetGlobal("Know_Iannis_Deionarra_Death","GLOBAL",1)~
REPLACE_TRANS_TRIGGER DIANNIS BEGIN 1 END BEGIN 9 END ~Know_Iannis_Daughter_Death~ ~Know_Iannis_Deionarra_Death~
*/


// Dabus dialogues:  Redoing where FloatRebus(Myself) appears based on the dialogue cues.
REPLACE_ACTION_TEXT DDABUS ~FloatRebus(Myself)~ ~~
REPLACE_ACTION_TEXT DDABUS ~FloatRebus(myself)~ ~~
ADD_TRANS_ACTION DDABUS BEGIN 0 END BEGIN 0 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 3 END BEGIN 0 1 2 4 11 12 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 4 9 11 END BEGIN 1 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 5 END BEGIN 7 8 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 8 13 14 15 16 17 18 19 END BEGIN END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 10 12 END BEGIN 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 21 END BEGIN 0 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DDABUS BEGIN 22 END BEGIN 0 1 2 4 12 END ~FloatRebus(Myself)~

REPLACE_ACTION_TEXT DFELL ~FloatRebus(Myself)~ ~~
ADD_TRANS_ACTION DFELL BEGIN 1 END BEGIN 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 2 END BEGIN 0 1 2 5 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 3 END BEGIN 0 1 2 4 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 4 END BEGIN 0 1 2 3 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 8 END BEGIN 0 1 2 11 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 13 END BEGIN 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 57 103 104 105 END BEGIN 0 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 55 56 60 END BEGIN 0 1 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 14 17 18 19 20 23 26 27 29 31 34 37 40 43 46 47 48 END BEGIN 0 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 49 50 51 52 58 59 61 62 63 64 65 67 69 70 71 74 77 END BEGIN 0 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 80 83 86 89 92 96 99 100 101 107 END BEGIN 0 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 15 16 21 22 24 25 28 53 66 68 72 73 75 76 END BEGIN 0 1 2 3 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 81 82 84 85 87 88 90 91 93 97 98 106 END BEGIN 0 1 2 3 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 54 END BEGIN 0 1 2 3 4 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 41 42 44 45 END BEGIN 0 1 2 3 4 5 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DFELL BEGIN 32 33 35 36 38 39 94 95 END BEGIN 0 1 2 3 4 5 6 END ~FloatRebus(Myself)~

ADD_TRANS_ACTION DADABUS BEGIN 0 14 15 16 END BEGIN 0 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 2 END BEGIN 0 1 2 11 12 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 3 5 8 END BEGIN 1 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 4 END BEGIN END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 7 9 END BEGIN 1 2 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 10 END BEGIN 3 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 11 12 13 END BEGIN 0 1 2 3 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 18 END BEGIN 7 8 9 10 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 20 END BEGIN 0 1 2 4 5 6 7 8 16 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 22 END BEGIN 0 END ~FloatRebus(Myself)~
ADD_TRANS_ACTION DADABUS BEGIN 23 24 27 END BEGIN 0 1 END ~FloatRebus(Myself)~

// Sandoz unnecessarily gets his KAPUTZ variable set when he goes to kill himself.  This could cause it to become value 2 when he actually dies,
// breaking some triggers (see GFIGRD.DLG).
REPLACE_ACTION_TEXT DSANDOZ ~SetGlobal("Sandoz_DEAD", "KAPUTZ", 1)~ ~~

// Jasilya updating the Slavers variable when you save her serves no purpose, and only screws up the quest dialogues from Tainted Barse
// and Marquez if you save her before ever talking to them.
REPLACE_TRANS_ACTION DJAS BEGIN 0 END BEGIN 0 END ~SetGlobal("Slavers", "GLOBAL", 4)~ ~~

// One dialogue path with Sere that should open up Hamrys quest failed to set the variable that does so
ADD_TRANS_ACTION DSERE BEGIN 2 END BEGIN 4 END ~SetGlobal("Know_Hamrys_Father","GLOBAL",1)~

// Adding "Vhailor, stop!" and less evil option to Trias's dialogue when Vhailor kills Trias, based on Colin McComb's agreement that its being missing is a bug.
// Will replace this if Colin McComb ever writes up the new dialogue, which he has expressed an interest in doing.
EXTEND_TOP DVHAIL 14
  IF ~~ THEN REPLY #54779 EXTERN DTRIAS 113
 END
EXTEND_TOP DTRIAS 113
  IF ~~ THEN REPLY @113 /* "Damnit, Vhailor, do you realize what you've done?!" */
    DO ~AddexperienceParty(375000)Kill(Myself)~ EXTERN DVHAIL DVHAIL-TRIAS
 END
ADD_TRANS_ACTION DTRIAS BEGIN 113 END BEGIN END ~SetGlobal("Trias_Redeem","GLOBAL",0)~
APPEND DVHAIL
  IF ~~ THEN BEGIN DVHAIL-TRIAS
    SAY @114 /* Vhailor turns from Trias's corpse to face you squarely. *You are MERCIFUL and WEAK. STEEL your HEART before the disease SPREADS.*~ [VHA013] */
    IF ~~ THEN REPLY #62707 /* "We'll discuss this some other time. Let's move on." */ EXIT
  END
END

// Red abishai weren't aggroing if you angered them in dialogue.
ADD_TRANS_ACTION DABISHAI BEGIN 5 END BEGIN 1 END ~Enemy()Attack(Protagonist)~

// Fix to Adyzoel's dialogue, "we've talked" variable wasn't set when Annah is in party.  Only relevant to UB
ADD_TRANS_ACTION DANNAH BEGIN 98 END BEGIN 0 END ~SetGlobal("Adyzoel","AR0400",1)~

// Rubikon wizard encounter could be redone, with commensurate rewards, every reset
REPLACE_TRIGGER_TEXT DRUBIKON ~NumTimesTalkedTo(0)~ ~Global("Know_Rubikon","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DRUBIKON ~NumTimesTalkedToGT(0)~ ~Global("Know_Rubikon","GLOBAL",1)~
ADD_TRANS_ACTION DRUBIKON BEGIN 0 END BEGIN END ~SetGlobal("Know_Rubikon","GLOBAL",1)~

// Tek'elach "Know_Curst_Cure" variable wasn't being set, setting it, its only use is for Tek'elach to note that he'd explained something to you before.
// Inaccessible until v4.0 allowed you to talk to him again in Carceri.
ADD_TRANS_ACTION DTEK BEGIN 16 END BEGIN 0 END ~SetGlobal("Know_Curst_Cure","GLOBAL",1)~

// New variable "Finger":  replace NumTimesTalkedTo(0), etc., in DFINGER dialogue, since that doesn't work for an item dialogue.
REPLACE_TRIGGER_TEXT DFINGER ~NumTimesTalkedTo(0)~ ~Global("Finger","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DFINGER ~NumTimesTalkedToGT(0)~ ~Global("Finger","GLOBAL",1)~
ADD_TRANS_ACTION DFINGER BEGIN 0 END BEGIN 0 1 END ~SetGlobal("Finger","GLOBAL",1)~

// Prevent Soego infinite loop for Adahn and Chaotic points
REPLACE_TRIGGER_TEXT DSOEGO ~NumTimesTalkedTo( 1 )~ ~Global("Soego_Adahn","AR0201",0)~
REPLACE_TRIGGER_TEXT DSOEGO ~NumTimesTalkedToGT( 1 )~ ~Global("Soego_Adahn","AR0201",1)~
ADD_TRANS_ACTION DSOEGO BEGIN 43 53 END BEGIN 3 END ~SetGlobal("Soego_Adahn","AR0201",1)~

// Female mourner's dialogue didn't get some of the fixes that the male file did.  Also, fix done to the male file left an inappropriate leftover trigger
ADD_TRANS_TRIGGER DMOURN2 13 ~False()~ DO 1
EXTEND_TOP DMOURN2 5 #7
  IF ~~ THEN REPLY #7855 GOTO 20
 END
REPLACE_TRANS_TRIGGER DMOURN1 BEGIN 13 END BEGIN 0 END ~Global ("Know_Dustmen", "GLOBAL", 1)~ ~~

// In both mourner dialogues, adding triggers to prevent getting a journal entry implying you never heard of Deionarra even if you had.
ADD_TRANS_TRIGGER DMOURN1 30 ~Global("Deionarra","GLOBAL",0)~ DO 1 2
ADD_TRANS_TRIGGER DMOURN2 30 ~Global("Deionarra","GLOBAL",0)~ DO 1 2

// Talking with Gris, if Annah was with you, variable meant to be set when he tells you of his stash wasn't getting set.
// It was also getting set before he actually told you where it was.  Fixing.
REPLACE_TRANS_ACTION DGRIS BEGIN 8 END BEGIN 2 END ~SetGlobal("Know_Gstash", "GLOBAL", 1)~ ~~
ADD_TRANS_ACTION DGRIS BEGIN 19 END BEGIN 0 END ~SetGlobal("Know_Gstash","GLOBAL",1)~

// In Brothel, talking to Luis, you could say "I've talked to nine prostitutes" without ever talking to Vivian
ADD_TRANS_TRIGGER DARMOIRE 12 ~GlobalGT("Vivian","GLOBAL",0)~ DO 9

// In Brothel, talking to all of the patrons, you could say "I've talked to nine prostitutes" without ever talking to Dolora
ADD_TRANS_TRIGGER DBROCUS 2 ~GlobalGT("Dolora","GLOBAL",0)~ DO 8
ADD_TRANS_TRIGGER DBROCUS2 2 ~GlobalGT("Dolora","GLOBAL",0)~ DO 8
ADD_TRANS_TRIGGER DBROCUS4 2 ~GlobalGT("Dolora","GLOBAL",0)~ DO 9
ADD_TRANS_TRIGGER DBROCUS5 2 ~GlobalGT("Dolora","GLOBAL",0)~ DO 8
ADD_TRANS_TRIGGER DBROCUS6 10 ~GlobalGT("Dolora","GLOBAL",0)~ DO 9
ADD_TRANS_TRIGGER DKESAI 26 ~GlobalGT("Dolora","GLOBAL",0)~ DO 13

// Condition on reply in Dimtree's dialogue is the opposite of what it should be.
REPLACE_TRANS_TRIGGER DDIMTREE BEGIN 13 END BEGIN 0 END ~!Global("Dimtree_zombie","GLOBAL", 0)~ ~Global("Dimtree_zombie","GLOBAL",0)~

// Decrement to Kill_Githzerai variable unnecessary - in fact, harmful - when killing Ana'zi
REPLACE_ACTION_TEXT DDAKKON ~IncrementGlobal("Kill_Githzerai", "GLOBAL", -1)~ ~~
REPLACE_ACTION_TEXT DANAZI  ~IncrementGlobal("Kill_Githzerai", "GLOBAL", -1)~ ~~

// When curing Reekwind's curse, you should get all story-related variables set when he writes them in your journal, but an important one
// re: Ignus wasn't set. I checked and yes, Reekwind -does- write the relevant bit of info in your journal.
// Being careful to not reset the variable after you've talked to Ignus.
ADD_TRANS_TRIGGER DREEK 52 ~GlobalGT("Know_Ignus_Teacher","GLOBAL",0)~ DO 0
EXTEND_TOP DREEK 52
  IF ~Global("Know_Ignus_Teacher","GLOBAL",0)~ THEN REPLY #11630
  DO ~SetGlobal("Story_Reekwind_Curse", "GLOBAL", 1)SetGlobal("Story_Reekwind_Alley", "GLOBAL", 1)SetGlobal("Story_Reekwind_Ignus", "GLOBAL", 1)SetGlobal("Story_Reekwind_Pharod", "GLOBAL", 1)SetGlobal("Know_Ignus_Teacher","GLOBAL",1)~
  GOTO 53
 END

// Fixed error in Reekwind's dialogue, check on variable that was meant to keep a certain dialogue path from looping wasn't doing so.
// Also, the variable was checked in one reply where it didn't really make sense to, and is not checked in similar replies in other states.
REPLACE_TRANS_TRIGGER DREEK BEGIN 10 END BEGIN 1 END ~Global("Loop", "AR0300", 1)~ ~Global("Loop", "AR0300", 0)~
REPLACE_TRANS_TRIGGER DREEK BEGIN 11 END BEGIN 0 END ~Global("Loop", "AR0300", 0)~ ~~

// Several Smoldering Corpse bar patrons keep referring to Ignus burning by the doorway after he's been freed.
// A couple of them had a variable check against that, but the variable was never set.
ADD_TRANS_ACTION DIGNUS BEGIN 7 END BEGIN 0 END ~SetGlobal("Ignus_Free","GLOBAL",1)~
// And others were missing the check.
ADD_TRANS_TRIGGER DMOOCH 5 ~!Global("Ignus_Free","GLOBAL",1)~ 7 DO 5
ADD_TRANS_TRIGGER DSCPAT1 0 ~!Global("Ignus_Free","GLOBAL",1)~ 6 DO 4
ADD_TRANS_TRIGGER DSCPAT1 1 ~!Global("Ignus_Free","GLOBAL",1)~ DO 3
ADD_TRANS_TRIGGER DSCPAT3 0 ~!Global("Ignus_Free","GLOBAL",1)~ 7 DO 4
ADD_TRANS_TRIGGER DSCPAT4 0 ~!Global("Ignus_Free","GLOBAL",1)~ 7 DO 4

// Nordom isn't being detected when he's present at Rubikon Wizard fight. Switching NearbyDialog to InParty.
REPLACE_TRIGGER_TEXT DRUBIKON ~NearbyDialog("Dnordom")~ ~InParty("Nordom")~

// No longer have to kill specific people in Clerk's Ward to get Diligence to call Harmonium off
REPLACE_TRANS_TRIGGER DDILIGNC BEGIN 26 END BEGIN 0 END ~GlobalGT("MK_Counter", "GLOBAL", 0)~ ~BitCheck("0600_Status","AR0600",BIT10)~
REPLACE_TRANS_TRIGGER DDILIGNC BEGIN 32 END BEGIN 1 END ~GlobalGT("MK_Counter", "GLOBAL", 0)~ ~BitCheck("0600_Status","AR0600",BIT10)~

// Tweak to Tek'elach's dialogue so that, when you meet him in Carceri, you don't get normal Curst dialog reply
ADD_TRANS_TRIGGER DTEK 2 ~Global("AR0800_Visited","GLOBAL",0)~ DO 4

// Agril's dialogue checked wrong variable for Carceri discussion
REPLACE_TRIGGER_TEXT DAGRIL ~Global("Free_Fiend","GLOBAL", 3)~ ~Global("Free_Agril","GLOBAL",3)~

// This fix was documented and supposed to be in v3.0 but somehow didn't make it.
ALTER_TRANS DMORTE BEGIN 152 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END

// Morte's comment re: Ebb Creakknees could never be seen
// Oops.  I was changing weight of DMORTE 50 in v3.0 forward until now.
SET_WEIGHT DEBB 50 #-1

// Can't buy Mochai a drink on first meeting, though you can on future meetings.  Adding to first meeting.
EXTEND_TOP DMOOCH 5 #2
  IF ~PartyGoldGT(5)~ REPLY #10638 DO ~TakePartyGold(5)~ GOTO 6
 END
 


// ================================================ MORE PICKPOCKET FIXES ==================================================

// Ash-mantle, trigger check for your having given him directions was reversed
ALTER_TRANS DASHMAN BEGIN 42 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 45~ END
ALTER_TRANS DASHMAN BEGIN 42 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 43~ END

// Yellow Fingers - meeting him for first time with both Annah and Morte, Annah has a potential banter which will segue into Morte's banter
// if he's also around. The reverse isn't true, if you get Morte's banter it won't go to Annah's.  Clearly the intent was to have both banters go off
// if you had them both with you, but this didn't happen because Morte's state had priority over Annah's.
SET_WEIGHT DCOLYLFN 2 #-1


// Ash-Mantle, an absolute ton of inappropriate "Enemy()" sets.  Full review and fix.
REPLACE_ACTION_TEXT DASHMAN ~SetGlobal ("Remove_Ash", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT DASHMAN ~SetGlobal("Remove_Ash", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT DASHMAN ~Enemy()~ ~~
REPLACE_ACTION_TEXT DASHMAN ~Enemy ()~ ~~
// Telling him to leave and not come back, flees non-hostile, can be talked to again (see state 44), removed from area next time entered.
ADD_TRANS_ACTION DASHMAN BEGIN 19 END BEGIN 0 END ~SetGlobal("Remove_Ash","GLOBAL",1)~
// "Attack Him".  He flees hostile, disappears next time you return.
ADD_TRANS_ACTION DASHMAN BEGIN 20 21 22 23 END BEGIN 6 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 24 25 END BEGIN 3 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
// "Prepare to die".  He flees hostile, disappears next time you return.
ADD_TRANS_ACTION DASHMAN BEGIN 18 END BEGIN 3 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 28 END BEGIN 4 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 29 END BEGIN 7 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 30 35 41 END BEGIN 1 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 31 32 33 36 40 END BEGIN 2 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
ADD_TRANS_ACTION DASHMAN BEGIN 38 END BEGIN 5 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
// He attacks you.
ADD_TRANS_ACTION DASHMAN BEGIN 34 END BEGIN 0 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~
// He flees, hostile, disappears.
ADD_TRANS_ACTION DASHMAN BEGIN 26 27 END BEGIN 0 END ~SetGlobal("Remove_Ash","GLOBAL",1)Enemy()~



// ALIGNMENT FIXES

// Replace Good Incarnation's Kill(Myself) with DestroySelf() when you absorb him so it doesn't trigger the two point chaos and law alignment hits.
// SetAnimState(ANIM_MIMEDIE) already exists so he will fall to the floor as he's supposed to.  Do set his death variable manually, though, so
// AR1203.BCS check Dead("Incar3") continues to work.
REPLACE_ACTION_TEXT DINCAR3 ~Kill(Myself)Deactivate(Myself)~ ~DestroySelf()SetGlobal("Incar3_DEAD","KAPUTZ",1)~

// Remove duplicate Lady and Murder hits in Nihl Xander's dialogue
REPLACE_ACTION_TEXT DXANDER ~IncrementGlobal ("Murder", "GLOBAL", 1)~ ~~
REPLACE_ACTION_TEXT DXANDER ~IncrementGlobal ("Lady", "GLOBAL", 1)~ ~~


// WRITTEN BUT NEVER READ VARIABLE PURGE
// Absorb_Practical_Incarnation:  Ditto.
REPLACE_TRANS_ACTION DINCAR1 BEGIN 53 END BEGIN 0 END ~SetGlobal("Absorb_Practical_Incarnation", "GLOBAL", 1)~ ~~

// Absorb_Paranoid_Incarnation:  Obvious where it's set.  Never read.
REPLACE_TRANS_ACTION DINCAR2 BEGIN 41 END BEGIN 0 END ~SetGlobal("Absorb_Paranoid_Incarnation", "GLOBAL", 1)~ ~~

// Absorb_Good_Incarnation:  Ditto. The variable that the sphere uses is "Absorb_Real_Incarnation".
REPLACE_TRANS_ACTION DINCAR3 BEGIN 25 END BEGIN 0 END ~SetGlobal("Absorb_Good_Incarnation", "GLOBAL", 1)~ ~~

// Alley_Puzzle1_SC:  Set when seeing the boards you need to remove in the Pregnant Alley, but never read and does nothing.
REPLACE_ACTION_TEXT DPAPUZ2 ~SetGlobal("Alley_Puzzle1_SC", "GLOBAL", 1)~ ~~

// Await_Death_Answer:  Tracks your response to Awaiting Death when he asks why you want to die.  Never read.
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 0 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 1)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 1 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 2)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 2 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 3)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 3 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 4)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 4 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 5)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 18 END BEGIN 5 END ~SetGlobal("Await_Death_Answer", "GLOBAL", 5)~ ~~

// Await_Life_Answer:  Tracks your response to Awaiting Death when he asks why you want to live.  Never read.
REPLACE_TRANS_ACTION DAWAIT BEGIN 19 END BEGIN 0 END ~SetGlobal("Await_Life_Answer", "GLOBAL", 1)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 19 END BEGIN 1 END ~SetGlobal("Await_Life_Answer", "GLOBAL", 2)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 19 END BEGIN 2 END ~SetGlobal("Await_Life_Answer", "GLOBAL", 3)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 19 END BEGIN 3 END ~SetGlobal("Await_Life_Answer", "GLOBAL", 4)~ ~~
REPLACE_TRANS_ACTION DAWAIT BEGIN 19 END BEGIN 4 END ~SetGlobal("Await_Life_Answer", "GLOBAL", 5)~ ~~

// Curst_Loot:  Jujog's dialogue, set if you just say "Farewell".  Does nothing.
REPLACE_TRANS_ACTION DJUJOG BEGIN 2 END BEGIN 4 END ~SetGlobal("Curst_Loot", "GLOBAL", 1)~ ~~

// Deionarra_SS_Annah:  Set if Annah is the one to comfort you at Longing memory stone.  Deionarra_SS_Grace gets used, but this one doesn't.
REPLACE_TRANS_ACTION DANNAH BEGIN 262 END BEGIN END ~SetGlobal("Deionarra_SS_Annah", "GLOBAL", 1)~ ~~

// Doubtful_Answer:  set when you tell the Doubtful Skeleton in Dead Nations whether he should accept the True Death or keep on living. Never read.
REPLACE_TRANS_ACTION DDOUBT BEGIN 6 END BEGIN 0 END ~SetGlobal("Doubtful_Answer", "GLOBAL", 1)~ ~~
REPLACE_TRANS_ACTION DDOUBT BEGIN 6 END BEGIN 1 END ~SetGlobal("Doubtful_Answer", "GLOBAL", 2)~ ~~

// Know_Iannis_Loss:  Set in Dustmen Mourners dialogue, when they tell you about Iannis.  Never read.
REPLACE_TRANS_ACTION DMOURN1 BEGIN 30 END BEGIN END ~SetGlobal("Know_Iannis_Loss", "GLOBAL", 1)~ ~~
REPLACE_TRANS_ACTION DMOURN2 BEGIN 30 END BEGIN END ~SetGlobal("Know_Iannis_Loss", "GLOBAL", 1)~ ~~

// Red_Shroud:  set when Ilquix and Grace discuss Grace's mother in the Abyss.  Never read.
REPLACE_TRANS_ACTION DGRACE BEGIN 11 END BEGIN END ~SetGlobal("Red_Shroud", "GLOBAL", 1)~ ~~

// Surrendered:  set when you surrender to Practical and Paranoid Incarnations.  It is set simultaneously with Game_Over.
REPLACE_TRANS_ACTION DINCAR1 BEGIN 48 50 END BEGIN 0 END ~SetGlobal("Surrendered", "GLOBAL", 1)~ ~~
REPLACE_TRANS_ACTION DINCAR2 BEGIN 42 END BEGIN 0 END ~SetGlobal("Surrendered", "GLOBAL", 1)~ ~~

// Trias_Cause:  set when Tek'elach tells you Trias caused the slide.  Was inaccessible until v4.0 made the conversation possible.
REPLACE_TRANS_ACTION DTEK BEGIN 23 END BEGIN 0 END ~SetGlobal("Trias_Cause","GLOBAL", 1)~ ~~

// Trias_Curse:  set when you betray Trias and kill him.  Also see QwinnFix.tph, need to remove same set in 0901TRIA.BCS.
REPLACE_TRANS_ACTION DTRIAS BEGIN 107 END BEGIN 0 END ~SetGlobal("Trias_Curse", "GLOBAL", 1)~ ~~

// Warning_Dhall:  Set when Morte complains as you first approach Dhall.  Never read.
REPLACE_TRANS_ACTION DMORTE BEGIN 102 END BEGIN 0 END ~SetGlobal( "Warning_Dhall", "GLOBAL", 1 )~ ~~


// READ BUT NEVER WRITTEN VARIABLE PURGE
// Feign_Death:  In Pox's dialogue.  Pretty much useless.
REPLACE_TRANS_TRIGGER DPOX BEGIN 12 END BEGIN END ~Global ("Feign_Death", "GLOBAL", 0)~ ~~
REPLACE_TRANS_TRIGGER DPOX BEGIN 12 END BEGIN END ~Global ("Feign_Death", "GLOBAL", 1)~ ~False()~

// Token:  Checked in Bedai and Foundry Guard's dialogue, but never written.
REPLACE_TRANS_TRIGGER DBEDAI BEGIN 48 END BEGIN 0 END ~Global ("Token", "GLOBAL", 0)~ ~~
REPLACE_TRANS_TRIGGER DBEDAI BEGIN 48 END BEGIN 1 END ~Global("Token", "GLOBAL", 2)~ ~False()~
REPLACE_TRIGGER_TEXT GFGUARD ~Global ("Token" , "GLOBAL" , 1)~ ~False()~

// READ AND WRITTEN BUT USELESS VARIABLE PURGE
// Alley:  Set when female Hiver tells you where the Alley of Dangerous Angles is.  Simply has no effect whatsoever.
REPLACE_TRANS_TRIGGER DHIVEF1 BEGIN 36 END BEGIN 0 END ~Global ( "Alley", "GLOBAL", 0)~ ~~
REPLACE_TRANS_TRIGGER DHIVEF1 BEGIN 36 END BEGIN 1 END ~GlobalGT( "Alley", "GLOBAL", 0)~ ~False()~
REPLACE_TRANS_ACTION DHIVEF1 BEGIN 36 END BEGIN 0 END ~SetGlobal( "Alley", "GLOBAL", 1)~ ~~


// ====================================================== VERSION 4.1 ==============================================================
// Fix to Mochai's dialogue: several of the poison attempts allude to your creating a distraction that you never actually make, and the stat checks are
// inconsistent.
// See QwinnFix.tph for string sets that change 6 lines from ~Poison her drink with the embalming fluid.~ to ~Distract her: "What's that over there?"~
ALTER_TRANS DMOOCH BEGIN 5 END BEGIN 7 8 END BEGIN "EPILOGUE" ~GOTO 15~ END
ALTER_TRANS DMOOCH BEGIN 7 END BEGIN 6 7 END BEGIN "EPILOGUE" ~GOTO 15~ END
ALTER_TRANS DMOOCH BEGIN 13 END BEGIN 0 1 END BEGIN "EPILOGUE" ~GOTO 15~ END
ADD_TRANS_TRIGGER DMOOCH 15 ~CheckStatGT(Protagonist,12,DEX)~ DO 0
REPLACE_ACTION_TEXT DMOOCH ~IncrementGlobalOnce("Evil_Mochai_Three", "GLOBAL", "Good", "GLOBAL", -1)~ ~~
ADD_TRANS_ACTION DMOOCH BEGIN 15 END BEGIN 0 END ~IncrementGlobalOnce("Evil_Mochai_Three","GLOBAL","Good","GLOBAL",-1)~
EXTEND_TOP DMOOCH 15 #1
  IF ~CheckStatLT(Protagonist,13,DEX)PartyHasItem("Embalm")~ REPLY #10655 DO ~IncrementGlobalOnce("Evil_Mochai_Three","GLOBAL","Good","GLOBAL",-1)~ GOTO 17
 END

// The "Distract her" option doesn't make much sense if you don't have the Embalming Fluid.
ADD_TRANS_TRIGGER DMOOCH 14 ~PartyHasItem("Embalm")~ DO 0

// Some of the replies in state 14 really make much more sense as a response to state 13, enough so I believe it was probably intended that way, moving them.
EXTEND_TOP DMOOCH 13 #3
  IF ~PartyGoldGT(99)~ THEN REPLY #10650 /* ~Lie: "I'd lend you the money, but I don't have it. Answer some other questions, will you?"~ */ GOTO 7
  IF ~PartyGoldLT(100)~ THEN REPLY #10651 /* ~Truth: "I'd lend you the money, but I don't have it. Answer some other questions, will you?"~ */ GOTO 7
  IF ~~ THEN REPLY #10652 /* ~"I'll be back with some money."~ */ EXIT
 END
ADD_TRANS_TRIGGER DMOOCH 14 ~False()~ DO 3 4 5

// One dialogue state appears to be getting skipped for no reason in Hive merchant dialogue the first time you meet him.
ALTER_TRANS D300MER1 BEGIN 0 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 2~ END

// Carver has his subsequent conversation trigger on the wrong state
REPLACE_TRIGGER_TEXT DR_BONE ~NumTimesTalkedToGT(0)~ ~~
ADD_STATE_TRIGGER DR_BONE 1 ~NumTimesTalkedToGT(0)~

// Hezobol has his subsequent conversation trigger on the wrong state. Also getting rid of area check, it's useless.
REPLACE_TRIGGER_TEXT DHEZOBOL ~Global("Current_Area", "GLOBAL", 900)~ ~~
REPLACE_TRIGGER_TEXT DHEZOBOL ~NumTimesTalkedToGT(0)~ ~~
ADD_STATE_TRIGGER DHEZOBOL 5 ~NumTimesTalkedToGT(0)~

// Guard in Lower Ward has his subsequent conversation trigger on the wrong state
REPLACE_TRIGGER_TEXT DSGUARD1 ~NumTimesTalkedToGT(0)~ ~~
ADD_STATE_TRIGGER DSGUARD1 4 ~NumTimesTalkedToGT(0)~

// Buried Villagers will now talk about the attack on Pharod without you actually having to walk into his area first.
REPLACE_TRIGGER_TEXT DFBVGER  ~Dead("Pharod")~ ~GlobalGT("AR0403_Visited","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DMBVGER  ~Dead("Pharod")~ ~GlobalGT("AR0403_Visited","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DBVPCGRD ~Dead("Pharod")~ ~GlobalGT("AR0403_Visited","GLOBAL",0)~

// Bad transition in Lower Ward slave's dialogue
ALTER_TRANS DMSLAVE2 BEGIN 1 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END

// Yvana repeatedly asks to touch your face if you try to end conversation early. That dialogue should only occur the first time you meet her.
// Thanks to nevill for report.
ALTER_TRANS DYVANA BEGIN 44 END BEGIN 2 END BEGIN "EPILOGUE" ~EXIT~ END

// If you do Litany of Curses on Krystall or Rotten William, that can mess up the script that makes all other thugs aggro.  At least have them
// aggro if you talk to them again.  (Problem with fixing scripting is it could make them aggro on player when they fight Blackrose or other thugs.)
ADD_TRANS_ACTION DGATHUG BEGIN 6 END BEGIN 0 END ~Enemy()SetGlobal("0301_Good_Angry","AR0301",1)~
ADD_TRANS_ACTION DBATHUG BEGIN 6 END BEGIN 0 END ~Enemy()SetGlobal("0301_Bad_Angry","AR0301",1)~

// Adding Spawn_Ebb set to Ebb's dialogue, rather than doing in scripting, as he was still respawning for a second or two.
ADD_TRANS_ACTION DEBB BEGIN 65 74 END BEGIN END ~SetGlobal("Spawn_Ebb","GLOBAL",0)~

// Annah's fight with Hiver - attacking via script Name is dangerous, no way to give every Hiver a different script name.
// Moving attack commands to Hiver's dialogue, and out of Annah's, so it can use Myself.
// Thanks to devSin for this report.
REPLACE_TRANS_ACTION DANNAH BEGIN 181 183 END BEGIN END ~Forceattack(Protagonist, "GhiveM")~ ~~
REPLACE_TRANS_ACTION DANNAH BEGIN 181 183 END BEGIN END ~Attack("GhiveM")~ ~~
ADD_TRANS_ACTION DGHIVEM BEGIN 53 END BEGIN END ~ForceAttack("Annah",Myself)~

// Same deal for Razor Angels.  Also, getting rid of an inappropriate forceattack.
REPLACE_TRANS_ACTION DRANGEL BEGIN 12 END BEGIN 1 END ~ForceAttack(Protagonist, "RAngel")~ ~~
REPLACE_TRANS_ACTION DRANGEL BEGIN 12 END BEGIN 2 END ~ForceAttack(Protagonist, Myself)~ ~~

// The two Hivers in the flophouse no longer get special dialogues that make them leave the area, screwing up their stringhead conversation.
// Also give them a fallback state so you don't get no valid dialogue.
REPLACE_TRIGGER_TEXT DGHIVEM ~RandomNum(20~ ~!Global("Current_Area","GLOBAL",305)RandomNum(20~
APPEND DGHIVEM
  IF ~NumTimesTalkedTo(0)CreatureInArea("AR0305")~ THEN BEGIN FLOPHOUSE-1
    SAY #33211 // "I done heard o' ye, berk... ye were askin' 'round about old Pharod, aye? If ye've yet ta find him, try lookin' north o' here, in Ragpicker's Square."
    IF ~Global("Pharod","GLOBAL",0)~ THEN REPLY #33212 EXIT // "I'll try there, then. Farewell."
    IF ~GlobalGT("Pharod","GLOBAL",0)~ THEN REPLY #33213 EXIT // "I found him already, but thanks. Farewell."
  END
END

// Choking logic fixed. Can only get partial memory and xp one time, and "Choke_Dustman" variable now tracks if you've gotten the memory in all cases.
// Choking Dustmen, then Harlot, you can get a 2nd memory.  Choking Tiresias, no memory.
REPLACE_TRIGGER_TEXT DAWAIT ~"Choke_Dustman"~ ~"Choke_Memory"~
ADD_TRANS_ACTION DAWAIT BEGIN 48 END BEGIN 0 END ~SetGlobal("Choke_Memory","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DDUST ~"Choke"~ ~"Choke_Memory"~
ADD_TRANS_ACTION DDUST BEGIN 42 END BEGIN 0 END ~SetGlobal("Choke_Memory","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DDUSTFEM ~"Choke"~ ~"Choke_Memory"~
ADD_TRANS_ACTION DDUSTFEM BEGIN 42 END BEGIN 0 END ~IncrementGlobal("Choke","GLOBAL",1)SetGlobal("Choke_Memory","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DDUSTGU ~"Choke"~ ~"Choke_Memory"~
REPLACE_TRANS_ACTION DDUSTGU BEGIN 18 END BEGIN 0 END ~GiveExperience (Protagonist, 250)~ ~~
ADD_TRANS_ACTION DDUSTGU BEGIN 8 END BEGIN 0 END ~SetGlobal("Choke_Memory","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DHARLOTD ~"Choke"~ ~"Choke_Memory"~
ADD_TRANS_ACTION DHARLOTD BEGIN 23 END BEGIN 0 END ~SetGlobal("Choke_Memory","GLOBAL",1)~
REPLACE_TRIGGER_TEXT DIANNIS ~"Choke"~ ~"Choke_Memory"~
REPLACE_TRANS_ACTION DIANNIS BEGIN 45 END BEGIN 0 END ~"Choke_Dustman"~ ~"Choke"~
REPLACE_TRANS_TRIGGER DINCAR2 BEGIN 7 END BEGIN END ~"Choke"~ ~"Choke_Memory"~
REPLACE_TRANS_TRIGGER DINCAR2 BEGIN 9 END BEGIN 3 END ~"Choke"~ ~"Choke_Memory"~

// Lenny shouldn't offer to teach thieving if your DEX is less than 9
ADD_TRANS_TRIGGER DLENNY 5  ~CheckStatGT(Protagonist,8,DEX)~ DO 2
ADD_TRANS_TRIGGER DLENNY 33 ~CheckStatGT(Protagonist,8,DEX)~ 34 38 40 DO 1

// Same for Sebastion, mage, and INT less than 9
ADD_TRANS_TRIGGER DSABAST 43 ~CheckStatGT(Protagonist,8,INT)~ 45 DO 1

// Vaxis has inconsistent stat checks on whether you'd look good as a zombie
REPLACE_TRANS_ACTION DVAXIS BEGIN 61 END BEGIN END ~CheckStatLT(Protagonist, 10, CHR)~ ~CheckStatLT(Protagonist, 13, CHR)~
REPLACE_TRANS_ACTION DVAXIS BEGIN 61 END BEGIN END ~CheckStatGT(Protagonist, 9, CHR)~  ~CheckStatGT(Protagonist, 12, CHR)~

// Part of reassigning Trash Warren thug dialogues. See QwinnFix.tph.
REPLACE_TRANS_ACTION DTHUGT2 BEGIN 3 8 END BEGIN 0 END ~EscapeArea()~ ~SetGlobal("Thug_Escape","GLOBAL",2)~
REPLACE_TRANS_ACTION DTHUGT1 BEGIN 7 END BEGIN 0 END ~EscapeArea()~ ~~
REPLACE_ACTION_TEXT DTHUGT1 ~EscapeArea()~ ~SetGlobal("Thug_Escape","GLOBAL",1)~
REPLACE_ACTION_TEXT DTHUGT2 ~EscapeArea()~ ~SetGlobal("Thug_Escape","GLOBAL",1)~


// ===================================================== EscapeAreaRunning!  Woohoo! ===================================================

// Harlots should run away from you when Annah interferes, not get the whole hive attacking you. So getting rid of Enemy() call here as well.
ALTER_TRANS DHARLOTN BEGIN 35 END BEGIN 0 END BEGIN "ACTION" ~EscapeAreaRunning()~ END

REPLACE_TRANS_ACTION DBERROG BEGIN 9 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_ACTION_TEXT DCOLYLFN ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_ACTION_TEXT DCSLAVE  ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DCSTCPR3 BEGIN 9 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DCSTCSUS BEGIN 4 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DDAMSEL  BEGIN 9 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DEBB     BEGIN 65 74 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DFBVGER  BEGIN 0 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_ACTION_TEXT  DGHIVEF  ~RunAwayFrom (Protagonist, 600)~ ~~
REPLACE_TRANS_ACTION DGHIVEF  BEGIN 45 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DGHIVEM  BEGIN 44 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DHAODA   BEGIN 2 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DKIINA   BEGIN 8 37 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DLIMX    BEGIN 2 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DPETLIMC BEGIN 3 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DMBVGER  BEGIN 0 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DRADINE  BEGIN 0 3 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DRKCHSR  BEGIN 18 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DTHUGT2  BEGIN 3 END BEGIN 0 END ~EscapeArea()~ ~EscapeAreaRunning()~
REPLACE_TRANS_ACTION DUHIR    BEGIN 0 END BEGIN END ~EscapeArea()~ ~EscapeAreaRunning()~


// Fewer Skipped Introductions - when ignoring someone, don't magically know their name and have them recognize you the next time you talk to them
// Did this fix for Roberta in v4.0 with a new variable, since then learned about SetNumTimesTalkedTo.
// I'm pretty picky about where I'm doing this.  If there's any reason at all not to, I don't.
ADD_TRANS_ACTION D300MER8 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DAILEENA BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DANZE    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DARLO    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DBINIAN  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DBVCOLL  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCHEKKA  BEGIN 0 END BEGIN 2 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCINDER  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCOLLECH BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCOLLECT BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCSTCPR1 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCSTCPR1 BEGIN 1 END BEGIN 2 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWACTF  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWACTM  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWCAFEF BEGIN 0 END BEGIN 3 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWCAFEM BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWPOETF BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWPOETM BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWRUSHB BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWRUSHF BEGIN 0 END BEGIN 3 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DCWRUSHM BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DDERAN   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DDORFIN  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DDORN    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DDYLANA  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DELDAN   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DFSLAVE1 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGENSHPF BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGENSHPM BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGERIK   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGHOCITF BEGIN 0 6 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGHOCITM BEGIN 0 6 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGIB     BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGORT    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DGROSUK  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHAMRYS  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHGDRIX  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAG1 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAG2 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAR3 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAR4 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAR5 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DHIVVAR6 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKARINA  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKEMAK   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKIRI    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKITLA   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKITLA   BEGIN 1 END BEGIN 2 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKNFGHL  BEGIN 0 END BEGIN 2 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKNFGHL  BEGIN 10 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DKORUR   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
REPLACE_TRANS_ACTION DKUUYIN BEGIN 24 END BEGIN 1 END ~SetGlobal("KYName", "GLOBAL", 1)~ ~SetNumTimesTalkedTo(0)~
ALTER_TRANS DKUUYIN BEGIN 24 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END
ADD_TRANS_ACTION DLAZLO   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DLEIGHIS BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DLENNY   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCF1HLP BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCF2NUE BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCF3ANG BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCF4CLU BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCM1HLP BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCM2NUE BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCM3ANG BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMCM4CLU BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMENGINE BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMSLAVE1 BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMSLAVE2 BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMSLAVE3 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMURK    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMW2     BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMW3     BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DMW4     BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DNODD    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DPEATO   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DPHINEAS BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DRAE     BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSABAST  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSGUARD1 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSGUARD2 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSGUARD3 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSGUARD4 BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSHERYL  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DSKELCIT BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DTHORP   BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DTIRES   BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DTPAINT  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DTRIST   BEGIN 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DULTHERA BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DVOORSHA BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DVORTEN  BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DXANTHIA BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DYELAAN  BEGIN 0 1 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~
ADD_TRANS_ACTION DZERB    BEGIN 0 END BEGIN 1 END ~SetNumTimesTalkedTo(0)~

