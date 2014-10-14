

// DAMARYS.DLG
// Missing journal entries for Amaryse
ALTER_TRANS DAMARYS BEGIN 5 7 END BEGIN 1 END BEGIN "JOURNAL" ~#22633~ END

// DANNAH.DLG
// Longlist:  "When Annah first joins the party her AI script isn't set if
// you have her take you directly to the painted door."
ADD_TRANS_ACTION DANNAH BEGIN 224 END BEGIN 1 END ~ChangeAIScript("pcannah",DEFAULT)~

// DBEDAI.DLG
// Longlist: "DBEDIA.DLG  You can ask Bedia about the weak spots but this doesn't allow
// you to sabotage the project.  Add Action SetGlobal("Sabotage","GLOBAL",4)
// Response 201 set flag, add Action 28"
ADD_TRANS_ACTION DBEDAI BEGIN 68 END BEGIN 0 END ~SetGlobal("Sabotage","GLOBAL",4)~

// DCINDER.DLG
// Longlist: "Response 61 set flag, add journal entry StrRef: 31880."
ALTER_TRANS DCINDER BEGIN 23 END BEGIN 0 END BEGIN "JOURNAL" ~#31880~ END

// DCINDER.DLG
// Longlist:  "Response 64, 65
// Asking who is looking into the matter should allow you to ask Corvus about the
// investigation. Instead asking where you can find Pikit does this.
// Response 64 remove Action and flag
// Response 65 set flag, add Action 2"
REPLACE_TRANS_ACTION DCINDER BEGIN 24 END BEGIN 0 END
  ~SetGlobal("Corvus_Zac","GLOBAL", 1)~ ~~
ADD_TRANS_ACTION DCINDER BEGIN 24 END BEGIN 1 END
  ~SetGlobal("Corvus_Zac","GLOBAL",1)~

// DCINDER.DLG
// Longlist:  "If you do ask about Pikit you have to go through the conversation again
// to ask who's investigating."
// State 26  First transition index 65 # transitions 3
EXTEND_TOP DCINDER 26
  IF ~~ THEN REPLY #34356 DO ~SetGlobal("Corvus_Zac","GLOBAL",1)~ GOTO 27
END

// DCOAX.DLG
// Longlist:  "You can get the same journal entry twice.  Response 69, 76
// Response 76 change journal entry to StrRef: 26106  StrRef: 26105 has a typo.
ALTER_TRANS DCOAX BEGIN 19 END BEGIN 0 END BEGIN "JOURNAL" ~#26106~ END

// DCSTCROG 
// Prevent Curst Citizen infinite gold bug
// Qwinn - Taken from Restored Curst Citizens, which was moved to PST-UB
REPLACE_TRIGGER_TEXT DCSTCROG ~True()~ ~!Global("Curst_Rogue_Paid","GLOBAL",1)~

// DDAKKON.DLG
// Longlist: "If you show Fell the dismembered arm and can understand him perfectly you
// get a journal entry. If you understand him but still have someone translate you don't.
// Response 395 set flag, add Jornal entry 24274"
// Qwinn:  Also need to add to Response 405, see QwinnFix.d for that
ALTER_TRANS DDAKKON BEGIN 94 END BEGIN 2 END BEGIN "JOURNAL" ~#24274~ END

// DDAKKON.DLG
// Longlist: When having Dak'kon translate for you it's possible to interupt the conversation
// before getting to the part that mentions suffering as stated in the journal entry.
// State 97 # transitions 1   // State 98 # transitions 3
ADD_TRANS_TRIGGER DDAKKON 97 ~False()~ DO 1 2
ADD_TRANS_TRIGGER DDAKKON 98 ~False()~ DO 3 4

// DDAKKON.DLG
// Longlist: "After speaking with Kii'na, when you tell Dak'kon "Let's go, Dak'kon" and when
// Morte is in your party it returns to the dialog for when you first approached her.
// Response 550 Next dialog DMORTE.DLG Next dialog state 466
ALTER_TRANS DDAKKON BEGIN 144 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DMORTE 466~ END

// DDAKKON.DLG
// Longlist:  Response 665 Action 176. Asking Dak'kon how he came to be in your debt makes
// you more good. I suspect this action should be attached to something else but am not
// clear on what.  Remove action and flag.
// Qwinn:  "Good_Dakkon_2" only happens in one other place - response 796.  It's when, after
// you learn the whole Circle, you try to convince Dakkon that you never helped him and need
// serve you no longer.  I can't find any other conversation path like it, so the faction hit
// probably shouldn't be reattached anywhere else.
REPLACE_TRANS_ACTION DDAKKON BEGIN 193 END BEGIN 10 END
  ~IncrementGlobalOnce("Good_Dakkon_2", "GLOBAL", "Good", "GLOBAL", 3)~ ~~

// DDAKKON.DLG
// "In the memory with Dak'kon instead of "Echo: Know the words of Zerthimon..." shake off the
// memory and it will go into the dialog where you show Dak'kon the 8th circle.
// Response 1190 Change Next dialog state from 325 to 225."
ALTER_TRANS DDAKKON BEGIN 348 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 225~ END

// DDEATHAD.DLG
// Longlist:  "Copy responses 41-48, 175-177   Paste at end and sort
// State 17   First transition index 179  # transitions 11"
// Qwinn:  This is actually an excellent fix that salvages some responses from an
// orphaned state (66) that in turn restores another 18 or so very cool and interesting
// orphaned states (21-38) during the death lecture.  Thanks to the wonders of WeiDU, though,
// I can handle this much better than recreating all the transitions for the existing
// state 17 and orphaning all the old responses.
EXTEND_TOP DDEATHAD 17
  IF ~~ THEN REPLY #64426 /* ~"What's a petitioner?"~ */ GOTO 21
  IF ~~ THEN REPLY #64427 /* ~"Can a petitioner die?"~ */ GOTO 24
  IF ~~ THEN REPLY #64428 /* ~"Why do petitioners lose their memories?"~ */ GOTO 28
END

// DFELL.DLG
// Longlist:  "When you say: "I feel like I know you, Fell." that should make it possible
// for you to ask about how you died and the curtain, or frames in the back room depending
// on another trigger. However if you say it to him right after asking who he is it isn't set.
// Response 96 set flag, add Action 23
// Response 102 set flag, add Action 24"
ADD_TRANS_ACTION DFELL BEGIN 15 16 END BEGIN 3 END ~SetGlobal("Fell","GLOBAL",2)~

// DFORGE.DLG
// Longlist:  "Response 114 Directs back to it's own state.  Next dialog state 29"
ALTER_TRANS DFORGE BEGIN 28 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 29~ END

// DGAOHA.DLG
// Longlist:  "Wrong value
// Response trigger 19 PartyGoldGT(5) -> PartyGoldGT(4)
// Response trigger 20 PartyGoldGT(5) -> PartyGoldGT(4)"
// Qwinn:  Also needs to be applied to response triggers 6 and 7.
REPLACE_TRIGGER_TEXT DGAOHA ~PartyGoldGT(5)~ ~PartyGoldGT(4)~

// DGRACE.DLG
// Longlist:  "If you show Fell the dismembered arm and can understand him perfectly you
// get a journal entry. If you understand him but still have someone translate you don't."
// Response 208 set flag, add Journal entry 24274
ALTER_TRANS DGRACE BEGIN 30 END BEGIN 2 END BEGIN "JOURNAL" ~#24274~ END

// DGRACE.DLG
// Longlist:  "When having Grace translate for you it's possible to interupt the conversation
// before getting to the part that mentions suffering as stated in the journal entry.
// State 31 # transitions 3"
ADD_TRANS_TRIGGER DGRACE 31 ~False()~ DO 3 4

// DHGCORV.DLG
// Longlist:  "Asking Corvus about Byron and Lenny is too restrictive. He only answers you if
// "Karina_Friend" is set to 3. But if you say to Karina "What did I do?" It gets set to 4
// and Corvus no longer tells you. The same happens when telling him about the Anarchists.
// The conditions should be:
// Response Triggers 11, 13, and 22 change to GlobalGT("Karina_Friend","GLOBAL"2)
// Response Triggers 12, 14, and 23 change to GlobalLT("Karina_Friend","GLOBAL"3)"
// Qwinn:  Good fix.  Applying it to state trigger 4 as well.
REPLACE_TRIGGER_TEXT DHGCORV ~!Global("Karina_Friend","GLOBAL", 3)~
                             ~GlobalLT("Karina_Friend","GLOBAL",3)~
REPLACE_TRIGGER_TEXT DHGCORV ~Global("Karina_Friend","GLOBAL", 3)~
                             ~GlobalGT("Karina_Friend","GLOBAL",2)~

// DHGCORV.DLG
// Longlist:  "You still get the journal entry for Lenny even if Corvus didn't tell you.
// Response 61 remove journal entry and flag"
ALTER_TRANS DHGCORV BEGIN 24 END BEGIN 1 END BEGIN "JOURNAL" ~~ END

// DHGCORV.DLG
// Longlist:  "You can continue to ask about the merchant Zac after Byron has been arrested.
// Response trigger 7 add !Global("Byron_Arrested","GLOBAL",1)"
ADD_TRANS_TRIGGER DHGCORV 2 ~!Global("Byron_Arrested","GLOBAL",1)~ DO 10

// DIANNIS.DLG
//
// A variety of issues:
//
// Longlist:  "---Repitition---  Response 174 remove text flag"
// Qwinn:  Nah.  It's not repetition. The first "Dammit..." (no exclamation point) is because
// Iannis calls the guards.  The second "Dammit...!" (exclamation point) is because Vhailor
// -also- decides to kill you.  I think the writer felt that the additional information that
// a formerly amenable walking plate armored suit of death is joining in on the attack merits
// at -least- a secondary "Dammit...!", and I can't argue with that.  IOW, the repetition was
// intended for dramatic effect, heh.

// DIANNIS.DLG
// ---Bad Journal Entries---  (listing all the response #'s and journal #'s from longlist alongside
// the code containing the same information - now that's repetition)
ALTER_TRANS DIANNIS BEGIN 75 END BEGIN 1 END BEGIN "JOURNAL" ~#30329~ END
ALTER_TRANS DIANNIS BEGIN 75 END BEGIN 2 END BEGIN "JOURNAL" ~#30330~ END
ALTER_TRANS DIANNIS BEGIN 75 END BEGIN 3 END BEGIN "JOURNAL" ~#30330~ END
ALTER_TRANS DIANNIS BEGIN 75 END BEGIN 4 END BEGIN "JOURNAL" ~#30331~ END
ALTER_TRANS DIANNIS BEGIN 90 END BEGIN 0 END BEGIN "JOURNAL" ~#30329~ END
ALTER_TRANS DIANNIS BEGIN 90 END BEGIN 1 END BEGIN "JOURNAL" ~#30330~ END
ALTER_TRANS DIANNIS BEGIN 90 END BEGIN 2 END BEGIN "JOURNAL" ~#30331~ END

// DIANNIS.DLG
// ---Incomplete Responses---
// Longlist:  "Copy Responses 307-311, 360-363  Paste and sort State 90
// First transition index 357 -> 413   # transitions 7 -> 9"
// Qwinn:  It is in fact incomplete, as this conversation branch is missing Vhailor's reactions.
// Will add just those back in, adding the triggers to the existing responses to make it all work.
ADD_TRANS_TRIGGER DIANNIS 90 ~!NearbyDialog("DVhail")~ DO 0 1
EXTEND_TOP DIANNIS 90
  IF ~NearbyDialog("DVhail")~ THEN REPLY #30322
    DO ~IncrementGlobalOnce ("Good_Iannis_8", "GLOBAL", "Good", "GLOBAL", 3)
        IncrementGlobalOnce ("Lawful_Iannis_6", "GLOBAL", "Law", "GLOBAL", 3)
        SetGlobal("Deionarra_Death_Truth", "GLOBAL", 2)~ JOURNAL #30329 EXTERN ~DVHAIL~ 6
  IF ~NearbyDialog("DVhail")~ THEN REPLY #30324
    DO ~IncrementGlobalOnce ("Good_Iannis_9", "GLOBAL", "Good", "GLOBAL", 1)
        IncrementGlobalOnce ("Chaotic_Iannis_4", "GLOBAL", "Law", "GLOBAL", -1)
        SetGlobal("Deionarra_Death_Truth", "GLOBAL", 2)~ JOURNAL #30330 EXTERN ~DVHAIL~ 7
END

// DIANNIS.DLG
// Longlist: "If Vhailor is nearby and not in party you get identical options with different results.
// Response trigger 114, 116   !InParty("Vhailor") -> !NearbyDialog("DVhail")
// Qwinn:  There's a much bigger problem with the original.  !InParty("Vhailor") will always be true
// because his correct identifier is "Vhail", not "Vhailor".  But !NearbyDialog will work fine too.
REPLACE_TRIGGER_TEXT DIANNIS ~!InParty("Vhailor")~ ~!NearbyDialog("DVhail")~

// DIANNIS.DLG
// This sets the variable properly when you confess so you can get Yves's new story afterwards
// Action 92  - SetGlobal("Iannis_Confessed","GLOBAL",2) -> SetGlobal("Iannis_Confessed","GLOBAL",1)
// Qwinn:  Talk to Yves after confessing to Iannis for a new story
REPLACE_ACTION_TEXT DIANNIS ~"Iannis_Confessed", "GLOBAL", 2~
                            ~"Iannis_Confessed", "GLOBAL", 1~

// DKIRI.DLG
// Longlist:  "Add Action SetGlobal("Know_Kiri","GLOBAL",1)   Response 8 set flag, add new Action 3"
ADD_TRANS_ACTION DKIRI BEGIN 4 END BEGIN END ~SetGlobal("Know_Kiri","GLOBAL",1)~

// DLOTHAR.DLG
// Longlist:  Morte's morale is decreased by a negative number.
// Action 4 MoraleDec("Morte", -1) -> MoraleDec("Morte", 1)
REPLACE_ACTION_TEXT DLOTHAR ~MoraleDec("Morte", -1)~ ~MoraleDec("Morte",1)~

// DMACH4.DLG
// Annah's sacrifice isn't counted -
// Action 2, 5, 10 Add IncrementGlobal("Fortress_Death_Counter","GLOBAL",1)
ADD_TRANS_ACTION DMACH4 BEGIN 2 3 5 END BEGIN 0 END
   ~IncrementGlobal("Fortress_Death_Counter", "GLOBAL",1)~

// DMANYAS1.DLG
// Longlist:  "When you recover a memory you get 1000 experience if you're a Thief
// or Mage but nothing if your a Fighter.  Response 53 set flag, add Action 31
ADD_TRANS_ACTION DMANYAS1 BEGIN 17 END BEGIN 0 END ~GiveExperience(Protagonist,1000)~

// DMAR.DLG
// Longlist:  "If you threaten Mar he gives you Coppereyes (the character) instead of
// Copper Commons (jink).  Action 9, 10
REPLACE_ACTION_TEXT DMAR ~GiveItemCreate("Copper", "Mar", 500, 0, 0)~ ~CreatePartyGold(500)~

// DMORTE.DLG
// Response 452, 453
// Become more lawful for asking Yellow Fingers "Who are you" instead of for proof.
// Response 453 remove action and flag.
// Response 452 set flag, add Action 263
// Qwinn:  This is a bug I reported to Skard, I fixed in a different way, see QwinnFix.d for the fix

// DMORTE.DLG
// Response leads to Sharegrave instead of back to Yellow-Fingers
// Response 466
// Next dialog SRGR.DLG -> DCOLYLFN.DLG
// Qwinn:  I discovered and fixed this one independently of Skard, see QwinnFix.d for the fix

// DMOURN1.DLG
// Missing chant setting for mourning Adahn.
// Add Action SetGlobal("Chant","GLOBAL",5)
// Response 43 set flag, add action 40
ADD_TRANS_ACTION DMOURN1 BEGIN 10 END BEGIN 0 END ~SetGlobal("Chant","GLOBAL",5)~

// DMOURN2.DLG
// Missing chant setting for mourning Adahn.
// Add Action SetGlobal("Chant","GLOBAL",5)
// Response 42 set flag, add action 40
ADD_TRANS_ACTION DMOURN2 BEGIN 10 END BEGIN 0 END ~SetGlobal("Chant","GLOBAL",5)~

// DP_JRNL.DLG
// You can confess to Iannis that you set the fire but the variable isn't set.
// Action 24 add SetGlobal("Know_Iannis_Fire_Responsible","GLOBAL",1)
ADD_TRANS_ACTION DP_JRNL BEGIN 19 END BEGIN 10 END
  ~SetGlobal("Know_Iannis_Fire_Responsible","GLOBAL",1)~

// DPHINEAS.DLG
// Selling cranium rat tails can be tedious. This will speed it up.
// Qwinn:  This isn't properly a fix, so I'll move to optional components.  ATTENTIONFLAG

// DROBERTA.DLG
// Longlist:  "Response 32 set flag, add Action 2"
// Qwinn:  Roberta wouldn't remember that you refused her request
ADD_TRANS_ACTION DROBERTA BEGIN 11 END BEGIN 0 END ~SetGlobal("Snuff_Carl","GLOBAL",2)~

// DROBERTA.DLG
// Qwinn:  Can keep asking Roberta what's wrong after you've taken her quest.
ADD_TRANS_TRIGGER DROBERTA 4 ~Global("Snuff_Carl","GLOBAL",0)~ DO 1


// DS_CLERK
// Longlist:  "Splinter says you'll have access to privileges allowed to members but the
// Sensorium clerks still charge you.
// Response triggers 0, 1, 2, 3, 4, 5, 10, and 11 Join_Sensates -> Sensate_Access"
// Qwinn:  I disagree that this must be a bug.  What Splinter offers is access to priviledges
// that ONLY Sensates have access to, meaning the private sensoriums.  That doesn't mean
// he won't charge for the public ones.  Going with my creed on this one:  When in doubt,
// no touchy.  ATTENTIONFLAG anyway

// DSPLINT.DLG
// Longlist:  "Can still ask for Finam after reading the dodecahedron.
// Response trigger 14 add Global("P_Journal","GLOBAL",3)"
ADD_TRANS_TRIGGER DSPLINT 10 ~Global("P_Journal","GLOBAL",3)~ DO 0


// DTRIAS.DLG
// Longlist:  "Game continues if you kill Trias but don't have the knowledge you need.
// Response 278  Set flag, add action 59"
ADD_TRANS_ACTION DTRIAS BEGIN 97 END BEGIN 2 END ~SetGlobal("Game_Over","GLOBAL",3)~

// DVAXIS.DLG
// Longlist:  "Response 223 set flag, add jounal entry 64530"
ALTER_TRANS DVAXIS BEGIN 55 END BEGIN 0 END
  BEGIN "JOURNAL" ~#64530~ END

// DVHAIL.DLG
// Response 257, 258, 259, 260
// When you ask Vhailor to join you under "ASK. I shall ANSWER." lie is chaotic
// and truth is lawful good. Under "Does your heart seek JUSTICE? Or is your
// JOURNEY without PURPOSE?" truth is chaotic and lie is lawful good.
// Response 257 change Action to 83
// Response 258 change Action to 84
// Response 259 change Action to 81
// Response 260 change Action to 82
REPLACE_TRANS_ACTION DVHAIL BEGIN 82 END BEGIN 0 1 END
~IncrementGlobalOnce("Chaotic_Vhailor_2", "GLOBAL", "Law", "GLOBAL", -1)~
~IncrementGlobalOnce("Lawful_Vhailor_2", "GLOBAL", "Law", "GLOBAL", 1)IncrementGlobalOnce("Good_Vhailor_2", "GLOBAL", "Good", "GLOBAL", 1)~
REPLACE_TRANS_ACTION DVHAIL BEGIN 82 END BEGIN 2 3 END
~IncrementGlobalOnce("Lawful_Vhailor_2", "GLOBAL", "Law", "GLOBAL", 1)IncrementGlobalOnce("Good_Vhailor_2", "GLOBAL", "Good", "GLOBAL", 1)~
~IncrementGlobalOnce("Chaotic_Vhailor_2", "GLOBAL", "Law", "GLOBAL", -1)~

// DXACH.DLG
// Longlist:  "At State 28, when you ask about the floating skull, there are 2 identical
// "Farewell" responses. Or none."
// Response Trigger 99 Global(Xachariah_Request","GLOBAL",0) -> GlobalGT(Xachariah_Request","GLOBAL",0)
ALTER_TRANS DXACH BEGIN 28 END BEGIN 3 END
  BEGIN "TRIGGER" ~GlobalGT("Xachariah_Request","GLOBAL",0)~ END

// DAETHEL.DLG
// Longlist:  Tegar'in doesn't attack with Aethelgrin.  Action 6 add Help()
REPLACE_TRANS_ACTION DAETHEL BEGIN 43 END BEGIN 0 END ~Enemy()~ ~Enemy() Help()~

// DMANYAS1.DLG
// From Skard's Readme: "The rats and Wererats attack after Many-As-One lets you leave.
// It seems you should be able to leave unharassed and get attacked if you come back.
// Many-As-One sets this variable to 2 when it becomes hostile but the others still
// attack on 1."
// Qwinn:  I concur with the reasoning for the change and kudos to Skard for an elegant
// implementation that was easy to fix with WeiDU.  One minor bug corrected here:  State
// 76, Response 227 was missed in the changing of the setglobal MAO_Warn from 2 to 3.
// See SkardFix.tph for the BCS script changes for this fix
REPLACE_ACTION_TEXT DMANYAS1 ~SetGlobal("MAO_Warn", "GLOBAL", 2)~ ~SetGlobal("MAO_Warn", "GLOBAL", 3)~
REPLACE_STATE_TRIGGER DMANYAS1 13
~GlobalGT("MAO_Warn", "GLOBAL", 0)
GlobalLT("MAO_Warn","GLOBAL",3)~

// ==================================================================================
// Able Ponderthought Journal Entry Fixes

// Lots of fixes to journal entries, mainly synchronizing all entries so that you
// don't get the same entry twice.  I am doing it a bit differently.  I can correct
// grammar/spelling errors, for one thing, so I can use all the neatly grouped entries
// in the dialogue file for the faction entries (31027-31036).

// Remainder of Able changes moved to Unfinished Business, and I'm doing them a very
// different way from any previous version.

// Remove extraneous research entry
ALTER_TRANS DABLE BEGIN 27 END BEGIN 2 END BEGIN "JOURNAL" ~~ END
// Synchronize Fraternity of Order journal entries
ALTER_TRANS DABLE BEGIN 28 END BEGIN 3 END BEGIN "JOURNAL" ~~ END
ALTER_TRANS DABLE BEGIN 28 45 49 50 END BEGIN 0 END BEGIN "JOURNAL" ~#31027~ END
// Synchronize Godsmen journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 1 END BEGIN "JOURNAL" ~#31028~ END
// Synchronize Dustmen journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 2 3 END BEGIN "JOURNAL" ~#31029~ END
// Synchronize Harmonium journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 4 END BEGIN "JOURNAL" ~#31031~ END
// Synchronize Mercykiller journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 5 END BEGIN "JOURNAL" ~#31032~ END
// Synchronize Revolutionary League journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 6 END BEGIN "JOURNAL" ~#31033~ END
// Synchronize Society of Sensation journal entries
ALTER_TRANS DABLE BEGIN 36 END BEGIN 0 END BEGIN "JOURNAL" ~#31034~ END
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 7 END BEGIN "JOURNAL" ~#31034~ END
// Synchronize Xaositects journal entries
ALTER_TRANS DABLE BEGIN 49 50 END BEGIN 8 END BEGIN "JOURNAL" ~#31036~ END


// ================================================================================
// Pickpocket tattoo stat boost fix

/* Version 3.0 fixes this bug with PermaStatChange in the engine, rolled back as
   unnecessary

// Stolen Stat Boost
// If using a tattoo to boost Dexterity it's no longer included in the stat check after
// observing a thief's technique.

// Qwinn - removed unnecessary spacing in the Longlist documentation here
// DASHMAN.DLG
// Response 83-85, 91-93, 99-101, 107-109 // Set Flag Terminates Dialog (4)
// Action 39-41, 46-48, 53-55, 60-62 // Add StartCutScene("Interupt")
// State trigger 1, 3 // Add !Global("Ash_Technique","GLOBAL",1)
// Add State trigger Global("Ash_Technique","GLOBAL",1) // State 24 // Trigger index 4
// Action 64-67 // Add SetGlobal("Ash_Technique","GLOBAL",2)
// Add Action SetGlobal("Ash_Technique","GLOBAL",2)
// Response 116 // Set flag, add Action 121
ALTER_TRANS DASHMAN BEGIN 20 21 22 23 END BEGIN 3 4 5 END BEGIN "EPILOGUE" ~EXIT~ END
REPLACE_TRANS_ACTION DASHMAN BEGIN 20 21 22 23 END BEGIN 3 4 5 END
~TakePartyGold(5)~
~TakePartyGold(5)
StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DASHMAN BEGIN 20 21 22 23 END BEGIN 3 4 5 END
~TakePartyGold (5)~
~TakePartyGold(5)
StartCutScene("Interupt")~
ADD_STATE_TRIGGER DASHMAN 0 ~!Global("Ash_Technique","GLOBAL",1)~ 1 42
ADD_STATE_TRIGGER DASHMAN 24 ~Global("Ash_Technique","GLOBAL",1)~
ADD_TRANS_ACTION DASHMAN BEGIN 24 END BEGIN END ~SetGlobal("Ash_Technique","GLOBAL",2)~


// DCOLYLFN.DLG
// Response 185
// Set Flag Terminates Dialog (4)
// Action 46 // Add StartCutScene("Interupt")
// State trigger 3, 4  // Add !Global("Yellow_PP","GLOBAL",1)
// Add State trigger Global("Yellow_PP","GLOBAL",1)
// State 57 // Trigger index 5
// Action 69 // Add SetGlobal("Yellow_PP","GLOBAL",2)
// Add Action SetGlobal("Yellow_PP","GLOBAL",2)
// Response 219-221, 223 // Set flag, add Action 74
ALTER_TRANS DCOLYLFN BEGIN 41 END BEGIN 2 END BEGIN "EPILOGUE" ~EXIT~ END
REPLACE_TRANS_ACTION DCOLYLFN BEGIN 41 END BEGIN 2 END
~TakePartyGold(5)~
~TakePartyGold(5)
StartCutScene("Interupt")~
ADD_STATE_TRIGGER DCOLYLFN 3 ~!Global("Yellow_PP","GLOBAL",1)~ 4
ADD_STATE_TRIGGER DCOLYLFN 57 ~Global("Yellow_PP","GLOBAL",1)~
ADD_TRANS_ACTION DCOLYLFN BEGIN 57 END BEGIN END ~SetGlobal("Yellow_PP","GLOBAL",2)~


// DFLEECE.DLG
// Response 43-45, 60-62 // Set Flag Terminates Dialog (4)
// Action 30-32, 43-45 // Add StartCutScene("Interupt")
// State trigger 1 // Add !Global("Fleece_Technique","GLOBAL",1)
// Add State trigger Global("Fleece_Technique","GLOBAL",1) // State 16 Trigger index 2
// Action 47-50 Add SetGlobal("Fleece_Technique","GLOBAL",2)
// Add Action SetGlobal("Fleece_Technique","GLOBAL",2)
// Response 69 Set flag, add Action 70
ALTER_TRANS DFLEECE BEGIN 10 15 END BEGIN 3 4 5 END BEGIN "EPILOGUE" ~EXIT~ END
REPLACE_TRANS_ACTION DFLEECE BEGIN 10 15 END BEGIN 3 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 1)~
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 1)
StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DFLEECE BEGIN 10 15 END BEGIN 4 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 3)~
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 3)
StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DFLEECE BEGIN 10 15 END BEGIN 5 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 5)~
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 5)
StartCutScene("Interupt")~
ADD_STATE_TRIGGER DFLEECE 26 ~!Global("Fleece_Technique","GLOBAL",1)~
ADD_STATE_TRIGGER DFLEECE 16 ~Global("Fleece_Technique","GLOBAL",1)~
ADD_TRANS_ACTION DFLEECE BEGIN 16 END BEGIN END ~SetGlobal("Fleece_Technique","GLOBAL",2)~

// DHARLOTD.DLG
// Response 73-75, 93-95 Set Flag Terminates Dialog (4)
// Action 40-42, 54-56 Add StartCutScene("Interupt")
// State trigger 0 Add !Global("Drunk_Harlot_Technique","GLOBAL",1)
// Add State trigger Global("Drunk_Harlot_Technique","GLOBAL",1) State 17 Trigger index 1
// Action 58  Add SetGlobal("Drunk_Harlot_Technique","GLOBAL",2)
// Add Action SetGlobal("Drunk_Harlot_Technique","GLOBAL",2)
// Response 98-100, 102 Set flag, add Action 79
ALTER_TRANS DHARLOTD BEGIN 10 16 END BEGIN 3 4 5 END BEGIN "EPILOGUE" ~EXIT~ END
REPLACE_TRANS_ACTION DHARLOTD BEGIN 10 16 END BEGIN 3 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 1)~
~PermanentStatChange(Protagonist,PICKPOCKET,RAISE,1)
StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DHARLOTD BEGIN 10 16 END BEGIN 4 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 3)~
~PermanentStatChange(Protagonist,PICKPOCKET,RAISE,3)
StartCutScene("Interupt")~
REPLACE_TRANS_ACTION DHARLOTD BEGIN 10 16 END BEGIN 5 END
~PermanentStatChange (Protagonist, PICKPOCKET, 2, 5)~
~PermanentStatChange(Protagonist,PICKPOCKET,RAISE,5)
StartCutScene("Interupt")~
ADD_STATE_TRIGGER DHARLOTD 0 ~!Global("Drunk_Harlot_Technique","GLOBAL",1)~
ADD_STATE_TRIGGER DHARLOTD 17 ~Global("Drunk_Harlot_Technique","GLOBAL",1)~
ADD_TRANS_ACTION DHARLOTD BEGIN 17 END BEGIN END ~SetGlobal("Drunk_Harlot_Technique","GLOBAL",2)~
*/

//================================================================================

// Xaositect Factol
// Once you become factol you can't speak to Barking Wilder. Plus when you switch to
// another faction they can't tell you're a Chaosman.  To Sybil and Tiresesias you can
// claim to be a Xaositect after leaving them for another faction. I left it as is. Such
// is chaos. You expect them to follow rules?

// DBARKING.DLG
// Response 151 remove flag
// Next dialog DBARKING.DLG
// Next dialog state 6
ALTER_TRANS DBARKING BEGIN 35 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO 6~ END

// DEMORIC.DLG
// Response Trigger 5, 43, 85, 89
// Global("Join_Chaosmen","GLOBAL",1) -> GlobalGT("Join_Chaosmen","GLOBAL",0) !Global("Join_Chaosmen","GLOBAL",2)
// Response Trigger 6, 7, 81
// Add !Global("Join_Chaosmen","GLOBAL",3)
ALTER_TRANS DEMORIC BEGIN 6 END BEGIN 4 END
BEGIN "TRIGGER"
~Global("Dustman_Initiation","GLOBAL",0)
!Global("Join_Godsmen","GLOBAL",6)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)~ END
ALTER_TRANS DEMORIC BEGIN 47 END BEGIN 1 END
BEGIN "TRIGGER"
~!Global ("Join_Godsmen", "GLOBAL", 6)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)~ END
ALTER_TRANS DEMORIC BEGIN 79 END BEGIN 4 END
BEGIN "TRIGGER"
~!Global("Join_Godsmen","GLOBAL", 6)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)
!Global("Join_Sensates","GLOBAL", 1)
!Global("Join_Anarchists","GLOBAL", 1)~ END
ALTER_TRANS DEMORIC BEGIN 80 END BEGIN 6 END
BEGIN "TRIGGER"
~!Global("Join_Godsmen","GLOBAL", 6)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)
!Global("Join_Sensates","GLOBAL", 1)
!Global("Join_Anarchists","GLOBAL", 1)~ END
ADD_TRANS_TRIGGER DEMORIC 6 ~!Global("Join_Chaosmen","GLOBAL",3)~ DO 5 6
ADD_TRANS_TRIGGER DEMORIC 79 ~!Global("Join_Chaosmen","GLOBAL",3)~ DO 0

// DKELDOR.DLG
// Response Trigger 26, 33, 53, 57, 77, 82, 90
// Global("Join_Chaosmen","GLOBAL",1) -> GlobalGT("Join_Chaosmen","GLOBAL",0) !Global("Join_Chaosmen","GLOBAL",2)
// Response Trigger 22, 30, 50, 54, 73, 78
// Add !Global("Join_Chaosmen","GLOBAL",3)
ALTER_TRANS DKELDOR BEGIN 10 END BEGIN 4 END
BEGIN "TRIGGER"
~!Global("Join_Dustmen","GLOBAL",1)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)
!Global("Join_Sensates","GLOBAL",1)
!Global("Join_Anarchists","GLOBAL",1)~ END
ALTER_TRANS DKELDOR BEGIN 12 END BEGIN 8 END
BEGIN "TRIGGER"
~Global("Join_Godsmen","GLOBAL",1)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)~ END
ALTER_TRANS DKELDOR BEGIN 24 25 END BEGIN 3 END
BEGIN "TRIGGER"
~Global("Join_Godsmen","GLOBAL",1)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)~ END
ALTER_TRANS DKELDOR BEGIN 51 52 END BEGIN 4 END
BEGIN "TRIGGER"
~!Global("Join_Dustmen","GLOBAL",1)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)
!Global("Join_Sensates","GLOBAL",1)
!Global("Join_Anarchists","GLOBAL",1)~ END
ALTER_TRANS DKELDOR BEGIN 56 END BEGIN 3 END
BEGIN "TRIGGER"
~!Global("Join_Godsmen","GLOBAL",6)
GlobalGT("Join_Chaosmen","GLOBAL",0)
!Global("Join_Chaosmen","GLOBAL",2)
!Global("Join_Sensates","GLOBAL",1)
!Global("Join_Anarchists","GLOBAL",1)~ END
ADD_TRANS_TRIGGER DKELDOR 10 ~!Global("Join_Chaosmen","GLOBAL",3)~ 24 25 51 52 DO 0
ADD_TRANS_TRIGGER DKELDOR 12 ~!Global("Join_Chaosmen","GLOBAL",3)~ DO 5

// DSPLINT.DLG
// Response Trigger 25, 29, 37
// Global("Join_Chaosmen","GLOBAL",1) -> GlobalGT("Join_Chaosmen","GLOBAL",0) !Global("Join_Chaosmen","GLOBAL",2)
// Response Trigger 30
// Add !Global("Join_Chaosmen","GLOBAL",3)
ALTER_TRANS DSPLINT BEGIN 17 END BEGIN 3 7 END
  BEGIN "TRIGGER" ~GlobalGT("Join_Chaosmen","GLOBAL",0) !Global("Join_Chaosmen","GLOBAL",2)~ END
ALTER_TRANS DSPLINT BEGIN 23 END BEGIN 3 END
  BEGIN "TRIGGER" ~GlobalGT("Join_Chaosmen","GLOBAL",0) !Global("Join_Chaosmen","GLOBAL",2)~ END
ADD_TRANS_TRIGGER DSPLINT 17 ~!Global("Join_Chaosmen","GLOBAL",3)~ DO 8

// ====================================================================================

// Sound fixes
// DXANDER.DLG
// Action 15 PlaySound(snap) -> PlaySoundNotRanged("SPE_11")

// Text Search > DLG > PlaySound(
// Specified results
// PlaySound -> PlaySoundNotRanged
// DAWAIT.DLG	Neck snapping
// DDUST.DLG	Neck snapping, Mortuary bell
// DDUSTFEM.DLG	Neck snapping, Mortuary bell
// DDUSTGU.DLG	Neck snapping, Mortuary bell
// DEIVENE.DLG	Mortuary bell
// DHARLOTD.DLG	Neck snapping
// DIANNIS.DLG	Neck snapping
// DSANDOZ.DLG	Neck snapping
// DSOEGO.DLG	Neck snapping, Mortuary bell
// DTIRES.DLG	Neck snapping
// DTRIAS.DLG	Trias teleports away
// DZM985.DLG	Neck snapping
REPLACE_ACTION_TEXT DAWAIT   ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DDUST    ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DDUSTFEM ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DDUSTGU  ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DEIVENE  ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DHARLOTD ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DIANNIS  ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DSANDOZ  ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DSOEGO   ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DTIRES   ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DTRIAS   ~PlaySound(~ ~PlaySoundNotRanged(~
REPLACE_ACTION_TEXT DZM985   ~PlaySound(~ ~PlaySoundNotRanged(~


// ==================================================================================
// Miscellaneous Fixes

// Replacing "Attack()" with "Attack(Protagonist)":
REPLACE_ACTION_TEXT DCASSIUS ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DCGOON2 ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DCRSCAPT ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DCRSTGRD ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DEBB ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DHERMIT ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DKELLERA ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DMANTUOK ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DMANYAS1 ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DMERKIL1 ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DMERKIL2 ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DMERKIL3 ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DSHIV ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT DXANDER ~Attack()~ ~Attack(Protagonist)~
REPLACE_ACTION_TEXT GFIGRD ~Attack()~ ~Attack(Protagonist)~


// Various syntax error fixes found by NI checker.
REPLACE_ACTION_TEXT BANNAH ~LeaveParty("Annah")~ ~LeaveParty()~
REPLACE_ACTION_TEXT DANIZIUS ~FadeToBlack(3)~ ~FadeToBlack()~
REPLACE_ACTION_TEXT DBISH ~ANIM   _STANDTOSTANCE~ ~ANIM_STANDTOSTANCE~
REPLACE_ACTION_TEXT DDALLAN ~"Myself"~ ~Myself~
REPLACE_ACTION_TEXT DDEVORE ~;~ ~~ DDREAM DTEST D300MER8
REPLACE_TRIGGER_TEXT DDOLORA ~" AR0605"~ ~"AR0605"~
REPLACE_ACTION_TEXT DDOLORA ~" AR0605"~ ~"AR0605"~
REPLACE_TRIGGER_TEXT DECCO ~" AR0605"~ ~"AR0605"~
REPLACE_ACTION_TEXT DIGNUS ~`SetAnimState~ ~SetAnimState~
REPLACE_ACTION_TEXT DGHIVERM ~S_Wi107~ ~SPWI107~
REPLACE_ACTION_TEXT DIANNIS ~ClotChar~ ~ClotChrm~
REPLACE_TRIGGER_TEXT DKELDOR ~! Global~ ~!Global~
REPLACE_TRIGGER_TEXT DKESAI ~" AR0605"~ ~"AR0605"~
REPLACE_ACTION_TEXT DKESAI ~" AR0605"~ ~"AR0605"~
REPLACE_ACTION_TEXT DMONJUG ~"Geherl "~ ~"Geherl"~
REPLACE_TRIGGER_TEXT DNAMES ~("Death_of_Names_Dhall", "GLOBAL", 1)~
                            ~Global("Death_of_Names_Dhall", "GLOBAL", 1)~
REPLACE_ACTION_TEXT DPENTA ~DestroyPartyItem("AgScroll", 1, 0, 0)~ ~DestroyPartyItem("AgScroll",1)~
REPLACE_TRIGGER_TEXT DRATBONE ~Global("Lawful_Rbone_1", "GLOBAL", "Law", "GLOBAL", 1)~
                             ~Global("Lawful_Rbone_1", "GLOBAL", 1)~
REPLACE_TRIGGER_TEXT DRATBONE ~Global("Chaotic_Rbone_7", "GLOBAL", "Law", "GLOBAL", -1)~
                             ~Global("Chaotic_Rbone_7", "GLOBAL", 1)~
REPLACE_TRIGGER_TEXT DMARISSA ~! PartyHasItem~ ~!PartyHasItem~
REPLACE_ACTION_TEXT DCSTCPR3 ~GivePartyGold~ ~CreatePartyGold~ DCSTCROG
REPLACE_ACTION_TEXT DADYZOEL ~Increment GlobalOnce~ ~IncrementGlobalOnce~
REPLACE_ACTION_TEXT DRKCHSR ~30_AI~ ~Thirty_AI~
REPLACE_TRIGGER_TEXT DROYALGD ~"AR"AR1500""~ ~"AR1500"~
REPLACE_TRIGGER_TEXT DROYALGD ~"AR"AR1501""~ ~"AR1501"~
REPLACE_TRIGGER_TEXT DSARHAVA ~CheckStatGT(Protagonist, 8, GT)~ ~CheckStatGT(Protagonist, 8, INT)~
REPLACE_ACTION_TEXT DSCPAT2 ~"ANIM_MIMESPELL2"~ ~ANIM_MIMESPELL2~
REPLACE_ACTION_TEXT DSC_TRAP ~SC_Trap~ ~SCTrap~
// Version 4.1 - taking this out as it's actually creating the bug that gets fixed later on, and that fix can wind up leaving the portal to Silent King open
// after Stale Mary dies... either leaving the action broken or removing it prevents all bugs.  Removing it just to be neat about it.
// REPLACE_ACTION_TEXT DSTALEMA ~Skull_~ ~Skull~
REPLACE_ACTION_TEXT DSTALEMA ~GiveItemCreate("Skull_SM", Protagonist, 1, 0, 0)~ ~~
REPLACE_TRIGGER_TEXT DTHORNCO ~! Class~ ~!Class~
REPLACE_TRIGGER_TEXT DVIVIAN ~ScVeil~ ~SVeil~
REPLACE_ACTION_TEXT DZ1094 ~Global("Asonje", "GLOBAL", 2)~ ~GlobalSet("Asonje", "GLOBAL", 2)~
REPLACE_TRIGGER_TEXT DZM569 ~?~ ~~
REPLACE_TRIGGER_TEXT DZM825 ~?~ ~~
REPLACE_ACTION_TEXT WDRGUARD ~"ANIM_MIMEATTACK1"~ ~ANIM_MIMEATTACK1~
REPLACE_ACTION_TEXT WDRGUARD ~"ANIM_MIMEDIE"~ ~ANIM_MIMEDIE~


// DMANTUOK.DLG
// Fixing invalid item references and bugged calls to DestroyPartyItem
REPLACE_TRIGGER_TEXT DMANTUOK ~Skull_~ ~Skull~
REPLACE_ACTION_TEXT DMANTUOK ~Skull_~ ~Skull~
REPLACE_ACTION_TEXT DMANTUOK ~Progtaonist, "cheese"~ ~"Cheese", Protagonist~
REPLACE_ACTION_TEXT DMANTUOK ~Progtaonist, "Cheese"~ ~"Cheese", Protagonist~
REPLACE_ACTION_TEXT DMANTUOK ~Progtaonist, "Pcheese"~ ~"Pcheese", Protagonist~
REPLACE_ACTION_TEXT DMANTUOK ~Protagonist, "cheese"~ ~"Cheese", Protagonist~
REPLACE_ACTION_TEXT DMANTUOK ~Protagonist, "Cheese"~ ~"Cheese", Protagonist~
REPLACE_ACTION_TEXT DMANTUOK ~Protagonist, "Pcheese"~ ~"Pcheese", Protagonist~


// ============================================================================================
// Added by Skard in version 20080429

// DCOLYFLN.DLG
// Yellow-Fingers doesn't attempt to pick your pocket.
// Response 25  Remove flag Terminates dialog (3) Next dialog DCOLYFLN.DLG Next dialog state 41
ALTER_TRANS DCOLYLFN BEGIN 7 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 41~ END


// ================================== FIXPACK VERSION 2.0 =====================================

// DMENGINE.DLG, DPORTAL.DLG
// Changing the Portal Lens teleportation "Ragpicker's Square" option to actually take you to
// Ragpicker's Square, rather than the Flophouse area.
REPLACE_TRIGGER_TEXT DMENGINE ~AR0100~ ~AR0101~
REPLACE_ACTION_TEXT DMENGINE ~AR0100~ ~AR0101~
REPLACE_ACTION_TEXT DMENGINE ~2068.468~ ~1050.2350~
REPLACE_TRIGGER_TEXT DPORTAL ~AR0100~ ~AR0101~
REPLACE_ACTION_TEXT DPORTAL ~AR0100~ ~AR0101~
REPLACE_ACTION_TEXT DPORTAL ~2068.468~ ~1050.2350~
