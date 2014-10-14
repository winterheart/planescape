//===============================================================================
// Qwinn's Ultimate WEIDU Planescape: Torment Fixpack
//===============================================================================

//===============================================================================
// Platter's Fixpack 1.37 Section (dialogue fixes only)
//===============================================================================

// FILE FORMAT:
// For each fix, I list:

// 1.  A description of the bug.  Sometimes when tired I just cut and paste it from
// the Fixpack Readme, and I indicated when I did so.  As of this writing (04/19/08)
// that Readme can be found online at:  http://planescape.outshine.com/.  Much
// credit goes to the Platter's Fixpack team for compiling such useful and well
// organized documentation of their work.

// 2.  CREDIT = the coder who originally dealt with the bug.  All fixes in this
// file were originally referenced in Platter's Fixpack 1.37 Readme, but that Fixpack
// had many authors, and I extend the credit to whichever author Platter's readme did.
// Note that the credit goes to that author for originally documenting and fixing the
// bug via Near Infinity or some other tool, but all WeiDU work and almost all
// code written in this file was written solely by Qwinn.  If I ever directly implement
// their scripting, I give extra credit when the bug is listed.

// 3.  Qwinn's Notes.  Not all fixes include this, because quite often the fix was
// pretty straightforward.  If there's anything noteworthy, I include it here.  Find
// all that noteworthy stuff by just searching on Qwinn.

// 4.  WeiDU code fixing the bug.

// NOTE:  These are listed in the order of the Fixpack Readme File, but at the end, there's
// another section containing the undocumented fixes I found.


// Fixpack: "Some of the random banters between party members would not happen because of a bug in their triggers."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT BMORTE ~NearbyDialog("Annah")~ ~NearbyDialog("DANNAH")~
REPLACE_TRIGGER_TEXT BNORDOM ~NearbyDialog("Annah")~ ~NearbyDialog("DANNAH")~
REPLACE_TRIGGER_TEXT BNORDOM ~NearbyDialog("Grace")~ ~NearbyDialog("DGRACE")~
REPLACE_TRIGGER_TEXT BNORDOM ~NearbyDialog("Morte")~ ~NearbyDialog("DMORTE")~

// Fixpack: "You couldn't initiate dialog with half of the shoppers in the Lower Ward Marketplace."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DMCM4CLU ~False()~ ~NumTimesTalkedTo(0)~
ALTER_TRANS DMCM4CLU BEGIN 7 END BEGIN 0 END BEGIN "EPILOGUE" ~EXIT~ END

// Fixpack: "The "Tattoo of Grosuk's Demise" wasn't available at Fell's shop if you killed Grosuk for Sebastion."
// CREDIT:  Platter
ADD_TRANS_ACTION DSABAST BEGIN 42 57 END BEGIN 0 END ~SetGlobal("Kill_Grosuk","GLOBAL",4)~

// Fixpack: "You couldn't ask Grace about Vhailor when talking to her about your companions."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DGRACE ~InParty("Vhailor")~ ~InParty("Vhail")~

// Fixpack:  "Barking-Wilder was supposed to give you a special item if you had a "Cranium Rat Tail" when
// you asked him "Can I see what items the Chaosmen sell to their members?" while being a member of the Chaosmen."
// CREDIT:  Barren
// This was in UB Restored Items component until v4.0, moved it back here after noting MCA believed it to be in game.
ALTER_TRANS DBARKING BEGIN 6 END BEGIN 10 END BEGIN "EPILOGUE" ~GOTO 30~ END

// Fixpack: "Corvus experience loop."
// CREDIT:  Platter
ADD_TRANS_ACTION DHGCORV BEGIN 35 END BEGIN 2 3 END ~SetGlobal("Know_Anarchists","GLOBAL",2)~

// Fixpack: "If you caught Yellow-Fingers stealing from you and Morte was in your party there was a certain
// dialog path that could lead into Sharegrave's dialog, messing up the quest to find the source of Pharod's
// bodies for him."
// CREDIT:  Platter
// Qwinn:  There were two such dialog paths. I fix the second one in QwinnFix.d.
ALTER_TRANS DMORTE BEGIN 196 END BEGIN 2 END BEGIN "EPILOGUE" ~EXTERN DCOLYLFN 53~ END

// Fixpack: "There was a bug preventing you from being able to ask Nordom to make "Winged Bolts.""
// CREDIT:  Platter
REPLACE_TRANS_TRIGGER DNORDOM BEGIN 99 END BEGIN 1 END ~1~ ~0~

// Fixpack: "When you asked Creeden about the Hive and then what's of interest and then if he's seen a
// journal he would respond as if you had asked him about Pharod."
// CREDIT:  The SKARDAVNELNATE
ALTER_TRANS DCREED BEGIN 39 END BEGIN 4 END BEGIN "EPILOGUE" ~GOTO 54~ END

// Fixpack: "When asking Able about the Lady of Pain you could only get the option "Continue to listen"
// if you were a Thief at the time."
// CREDIT:  The SKARDAVNELNATE
REPLACE_TRANS_TRIGGER DABLE BEGIN 72 END BEGIN 0 END ~Class(Protagonist, Thief)~ ~~

// Fixpack: "In one part of Thildon's dialog it was possible to mention the murder of
// the Foundry smith before it had happened."
// CREDIT:  The SKARDAVNELNATE
ADD_TRANS_TRIGGER DTHILDON 25 ~GlobalGT("G_Test2","GLOBAL",0) GlobalLT("G_Test2","GLOBAL",9)~ DO 0

// Fixpack: "If you returned Marissa's "Crimson Veil" to her and asked for a reward the dialog indicated
// that you got a "Gold Bracelet," but you didn't because of a typo in the action."
// CREDIT:  Ash McGowen
// Qwinn:  Fixpack didn't actually fix this, Restoration and SKARDAVNELNATE did though.  Will just do the
// fix here anyway.
REPLACE_ACTION_TEXT DMARISSA ~"GoldBra"~ ~"GolBra"~
ALTER_TRANS DMARISSA BEGIN 33 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 34~ END

// Using Restoration Pack's version of Justifier, mainly because it can use new variables rather
// than reusing "Anarchist_Recruitment", which actually has a function now.

// Fixpack: "If you completed the quest to kill Qui-Sai for Scofflaw Penn the quest would
// stay in your Assigned Quests list."
// CREDIT:  The SKARDAVNELNATE
ADD_TRANS_ACTION DSCOFF BEGIN 64 END BEGIN 0 3 4 END ~SetGlobal("Waste_QuiSai","GLOBAL",2)~
ALTER_TRANS DSCOFF BEGIN 64 END BEGIN 3 4 END BEGIN "JOURNAL" ~#65433~ END

// Fixpack:  "You could only get the dialog option with the Dustmen Mourners
// admitting that you are "to blame for the death of many innocents across the planes" if you
// had given the answer "I... don't know." to Ravel when she asked you "What can change the
// nature of a man?"
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DMOURN1 ~Global ("Nature", "GLOBAL", 1)~ ~GlobalGT("Nature","GLOBAL",0)~
REPLACE_TRIGGER_TEXT DMOURN2 ~Global ("Nature", "GLOBAL", 1)~ ~GlobalGT("Nature","GLOBAL",0)~
ADD_TRANS_ACTION DRAVEL BEGIN 98 END BEGIN 5 END ~SetGlobal("Nature","GLOBAL",6)~

// Fixpack: "There was a dialog option you couldn't get with Sere the Skeptic that involves
// convincing her to become an Anarchist once you have joined that faction."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DSERE ~Global("Anarchist_Recruitment", "GLOBAL", 1)~ ~Global("Join_Anarchists","GLOBAL",1)~

// Fixpack: "Fixed a few instances where a dialog option would end the dialog when it wasn't supposed to."
// CREDIT:  Platter
ALTER_TRANS DTRIAS BEGIN 37 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO 42~ END
ALTER_TRANS DSOEGO BEGIN 109 END BEGIN 4 END BEGIN "EPILOGUE" ~GOTO 78~ END
ALTER_TRANS DSADJULI BEGIN 36 END BEGIN 2 END BEGIN "EPILOGUE" ~GOTO 50~ END
ALTER_TRANS DNORDOM BEGIN 99 END BEGIN 2 END BEGIN "EPILOGUE" ~GOTO 100~ END

// Fixpack: "You couldn't initiate dialog with the Curst Citizen who was being beaten by two Curst Guards."
// CREDIT:  Platter
ADD_STATE_TRIGGER DJANSEN 0 ~True()~

// Fixpack: "In some dialogs you would not get the money you were supposed to because the
// action "GivePartyGold()" was used instead of "CreatePartyGold()"."
// Dialog Files affected:  DQUINT, DPHINEAS, DFLEECE, DKESTER, DROBERTA, DTHUGP1, DDEVORE
// CREDIT:  Platter
// Qwinn:  Deprecated by my own full-game review and fixes.  See QwinnFix.tph for details.

// Fixpack: "Fixed many minor errors discovered using Near Infinity's dialog checker."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DABISHAI ~"1"~ ~1~
REPLACE_ACTION_TEXT DABISHAI ~"1"~ ~1~

REPLACE_ACTION_TEXT DANAM ~STAND2STANCE~ ~STANDTOSTANCE~

REPLACE_ACTION_TEXT DHGUARD ~"ANIM_MIMESTANDTOSTANCE"~ ~ANIM_MIMESTANDTOSTANCE~

// Mebbeth fix simplified as per SKARD suggestion in Fixpack 3.0.
REPLACE_TRIGGER_TEXT DMEBBETH ~13.,~ ~13,~

REPLACE_ACTION_TEXT DPHINEAS ~IncrementGlobal( "Evil_Phineas_1", "GLOBAL", "Good", "GLOBAL", -1 )~
                             ~IncrementGlobalOnce("Evil_Phineas_1","GLOBAL","Good","GLOBAL",-1)~

REPLACE_TRIGGER_TEXT DROYALGD ~1500~ ~"AR1500"~
REPLACE_TRIGGER_TEXT DROYALGD ~1501~ ~"AR1501"~

REPLACE_ACTION_TEXT DSHIV ~"AR0301", "GLOBAL"~ ~"AR0301"~

REPLACE_ACTION_TEXT DSPLINT ~AddPartyExperience(Protagonist, 10000)~ ~GiveExperience(Protagonist,10000)~

REPLACE_ACTION_TEXT DZ1041 ~+1~ ~1~
REPLACE_ACTION_TEXT DZ1146 ~+1~ ~1~

REPLACE_ACTION_TEXT DXANTHIA ~EscapeArea(myself)~ ~EscapeArea()~

REPLACE_ACTION_TEXT GFGUARD ~Enemy(Godsmen)~ ~Enemy()~
REPLACE_ACTION_TEXT GFGUARD ~"FALSE"~ ~FALSE~
REPLACE_TRIGGER_TEXT GFGUARD ~PartyHasItem(DrmKey)~ ~PartyHasItem("DrmKey")~

REPLACE_TRIGGER_TEXT GFWEAPS ~Dead(Kellera)~ ~Dead("Kellera")~

// Fixpack:  "You couldn't ask Annah what Fell said about your tattoos when she
// was translating for you if your Intelligence was above 14 and you understood Rebuses."
// CREDIT:  Joshua Haber
// QWINN:  More specifically, you could, but Annah would respond by talking about the
// Lady of Pain.  Corrected.
ALTER_TRANS DFELL BEGIN 66 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DANNAH 145~ END

// Fixpack: You couldn't reread the sixth circle of Zerthimon because it pointed
// to the last paragraph of the second circle instead.
// CREDIT:  Joshua Haber
ALTER_TRANS DCIRCLEZ BEGIN 1 END BEGIN 16 END BEGIN "EPILOGUE" ~GOTO 43~ END

// Fixpack:  "Emoric experience loop"
// CREDIT:  Platter
// QWINN:  Specifically, if you found out where Pharod was getting his bodies from from Quint the
// merchant rather than Pharod, and went back to Emoric before talking to Pharod, you could accept
// and cash in Emoric's quest for the info infinitely.  Once you talked to Pharod it wouldn't work
// anymore.  I mention this only because it took me 3 hours to figure out how the change in question
// could possibly prevent an experience loop, heh.  It has the nice side benefit of not allowing you
// to repeat the conversation where you get Emoric's quest an infinite number of times.
ADD_TRANS_TRIGGER DEMORIC 6 ~Global("Emoric_Pharod","GLOBAL",0)~ DO 10

// Fixpack:  "In dialog with Xachariah you should have had the option "Improvise:
// "It is I. Do you not recognize my voice?"" if you had 17 (or greater) Intelligence or Charisma,
// but it only worked for Intelligence.
// CREDIT:  Platter
REPLACE_TRANS_TRIGGER DXACH BEGIN 2 END BEGIN 2 END ~INT~ ~CHR~
REPLACE_TRANS_TRIGGER DXACH BEGIN 3 END BEGIN 1 END ~INT~ ~CHR~

// Fixpack:  "If you convinced Mortai to give you 100 coppers for signing a Dead Contract with him, he
// still only gave you 50 coppers."
// CREDIT:  Platter
ALTER_TRANS DMORTAI BEGIN 34 END BEGIN 0 END BEGIN "ACTION" ~SetGlobal("Mortai_Blackmail","GLOBAL",1)~ END

// Fixpack: "	You couldn't get the conversations you were supposed to be able to have with Nordom
// after saying "Can we discuss my immortality again?" because of a typo in a dialog action."
// CREDIT:  Platter
EXTEND_TOP DNORDOM 116
  IF ~GlobalGT("Nordom_Solution","GLOBAL",1)~ THEN
     REPLY #55586 GOTO 117
END
ALTER_TRANS DNORDOM BEGIN 116 END BEGIN 1 END BEGIN "TRIGGER" ~Global("Nordom_Solution","GLOBAL",1)~ END
ALTER_TRANS DNORDOM BEGIN 116 END BEGIN 1 END BEGIN "ACTION" ~SetGlobal("Nordom_Solution","GLOBAL",2)~ END
ALTER_TRANS DNORDOM BEGIN 9 END BEGIN 10 END  BEGIN "TRIGGER" ~GlobalGT("Nordom_Solution","GLOBAL",1)~ END
ALTER_TRANS DNORDOM BEGIN 74 END BEGIN 9 END  BEGIN "TRIGGER" ~GlobalGT("Nordom_Solution","GLOBAL",1)~ END
ALTER_TRANS DNORDOM BEGIN 113 END BEGIN 3 END BEGIN "TRIGGER" ~GlobalGT("Death", "GLOBAL", 1)~ END
ADD_TRANS_ACTION DNORDOM BEGIN 110 END BEGIN 2 END ~SetGlobal("Nordom_Solution","GLOBAL",1)~
ADD_TRANS_ACTION DNORDOM BEGIN 127 128 END BEGIN 0 END ~SetGlobal("Nordom_Solution","GLOBAL",6)~
ALTER_TRANS DNORDOM BEGIN 127 END BEGIN 0 END BEGIN "JOURNAL" ~#55681~ END


// Fixpack: "	You couldn't transform the "Entropic Blade" directly from Fists to Clubs
// proficiency because of a typo in that response trigger."
// CREDIT:  Platter
REPLACE_TRIGGER_TEXT DEBLADE ~Fistt~ ~Fist~

// Fixpack:  "If you attacked Hezobol in Carceri through dialog it would increment
// the global variable "Curst_Counter" when you chose the option "Attack him." and then again
// when you chose the next and only available option "Fight." It should have only been
// incremented once. This variable keeps track of how many things you have done in Carceri
// to lessen the chaos and weakens Trias the higher it gets."
// BUG REPORTED BY:  Platter
//
// Qwinn:  I believe the Fixpack solution to this bug was itself flawed.  I came up with a
// different fix.  See Qwinn's Fixes documention for details.

// Fixpack: "Ebb experience loop, plus a few other minor bugs in Ebb's dialog."
// CREDIT: Platter
REPLACE_TRIGGER_TEXT DEBB ~AR0904_Visited~ ~AR0902_Visited~
ADD_STATE_TRIGGER DEBB 50 ~NearbyDialog("DMorte")~
ADD_STATE_TRIGGER DEBB 53 ~!Global("No_Anarchy","AR0902",1)~ 54 55 56 57 58
ADD_TRANS_ACTION DEBB BEGIN 65 74 END BEGIN 0 END ~SetGlobal("No_Anarchy","AR0902",1)~

// Fixpack: "You could get Nemelle to reward you a second time for reuniting her and
// Aelwyn if you asked her for the command word for the Decanter after you had already
// reunited Nemelle and Aelwyn."
// CREDIT:  Platter
ALTER_TRANS DNEML BEGIN 5 END BEGIN 0 END
   BEGIN "TRIGGER"
~GlobalGT("Aelwyn","GLOBAL",0)
!Dead("Aelwyn")
!Global("Aelwyn","GLOBAL",2)
!Global("Nemelle","GLOBAL",3)~
   END
ALTER_TRANS DNEML BEGIN 5 END BEGIN 1 END
   BEGIN "TRIGGER"
~Global("Aelwyn","GLOBAL",2)
!Dead("Aelwyn")
!Global("Nemelle","GLOBAL",3)~
   END

// Fixpack:  "Once you completed all the quests for "The Grimoire of Pestilential Thought",
// it would add the same entry to your journal every time you tried to talk to it."
// CREDIT:  Platter
EXTEND_BOTTOM DPESTAL 68
  IF ~Global("E_Book","GLOBAL",9)~ THEN
    REPLY #27283 EXIT
  END
ALTER_TRANS DPESTAL BEGIN 67 END BEGIN 1 END BEGIN "JOURNAL" ~#27281~ END
ALTER_TRANS DPESTAL BEGIN 68 END BEGIN 0 END BEGIN "TRIGGER" ~Global("E_Book","GLOBAL",8)~ END
ALTER_TRANS DPESTAL BEGIN 68 END BEGIN 0 END BEGIN "ACTION" ~SetGlobal("E_Book","GLOBAL",9)~ END
REPLACE_STATE_TRIGGER DPESTAL 68 ~GlobalGT("E_Book","GLOBAL",7)~

// Fixpack:  "Minor bug in Grace's dialog if you told her that you might love Annah and you had
// already met both Deionarra and Ravel. An option would show up twice in one situation, and never
// in another. It should have been one in each.
// CREDIT:  Platter
REPLACE_TRANS_TRIGGER DGRACE BEGIN 342 END BEGIN 3 END ~1~ ~0~

// Fixpack: "Several minor bugs with the Forge dialog in the Foundry."
// CREDIT:  Platter
REPLACE_TRANS_ACTION DFORGE BEGIN 17 END BEGIN 1 END ~SetGlobal ("G_Test1" , "GLOBAL" , 4)~ ~~
ALTER_TRANS DFORGE BEGIN 1 END BEGIN 1 END BEGIN "TRIGGER" ~PartyHasItem("LApron")~ END
ALTER_TRANS DFORGE BEGIN 4 END BEGIN 0 1 2 3 4 5 END BEGIN "ACTION" ~Damage(Protagonist,1,10)~ END
ADD_TRANS_ACTION DFORGE BEGIN 23 END BEGIN 3 END ~IncrementGlobal("Forge","GLOBAL",1)~

// Fixpack: "Montague experience loop."
// CREDIT:  Platter
ALTER_TRANS DMONTAGU BEGIN 21 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO 41~ END

// Fixpack: "Hamrys experience loop."
// CREDIT:  Platter
ADD_TRANS_TRIGGER DHAMRYS 31 ~Global("Plans_Quest","GLOBAL",0)~ DO 0
ADD_TRANS_ACTION DHAMRYS BEGIN 75 END BEGIN 0 END ~SetGlobal("Pillow_Quest","GLOBAL",5)~
ADD_TRANS_ACTION DHAMRYS BEGIN 75 END BEGIN 1 END ~SetGlobal("Plans_Quest","GLOBAL",5)~


// Fixpack: "A bugged stat check in Ghysis the Crooked's dialog if your Wisdom was below 13.
// During the part where you recall a memory you would get "Try and recall the memory" as
// dialog option #1 and #2, where #1 was the correct option and #2 was the option you should
// have only gotten if your Wisdom was 13 or higher."
// CREDIT:  Platter
ADD_TRANS_TRIGGER DGHYSIS 63 ~CheckStatGT(Protagonist,12,WIS)~ DO 2


// Fixpack: 	Sometimes all Godsmen in the Foundry would ask you to leave and refuse to talk
// to you even if you had done nothing wrong. Caused by a bug in Thildon's dialog during the
// murder investigation quest.

// Qwinn:  This fix confused the hell out of me. I have finally determined that Platter's fix
// was correct, and I extend apologies if I have ever implied otherwise. It didn't make sense
// because it could still cause all Foundry quests to be closed off permanently even
// though there was no good reason to warrant that severe a punishment. After talking to Colin
// (original programmer of the Foundry), found out that Alarm1 is supposed to reset after
// you leave the Foundry and come back. That makes it make MUCH more sense, and in light of that,
// Platter's change actually does make all the sets apply where they were supposed to be.

// I'm not going to implement Platter's change, though, not because it's not correct, but because
// you can put the Alarm set in a single place that does the job of all 3 existing alarm sets,
// with the added benefit of not getting Alarm1 and Alarm2 both set simultaneously, a headache
// I don't need.  See QwinnFix.d for code removing all 3 alarm sets and replacing them with 1.
// Sett QwinnFix.tph for the million changes required for Alarm1 and Alarm2 to reset properly.



// Fixpack: "Very rare bug that could occur when having Dak'kon translate for Fell, in which
// he would go through his "joining the party" dialog again.
// CREDIT:  Platter
ALTER_TRANS DDAKKON BEGIN 87 END BEGIN 9 END BEGIN "EPILOGUE" ~GOTO 77~ END

// Fixpack: "Several dialogs had a specific stat check bug that caused the check to be ignored
// and therefore you would never fail it. So expect a few stat checks where it seemed there
// were none before. The dialogs of the following characters were affected; Mochai, Barkis,
// Barr, Mantuok, Radine, Shaddeus, Raimon, Quint, Bedai, and Thildon.
// CREDIT: Platter
REPLACE_TRIGGER_TEXT DMOOCH ~INT, 12~ ~12, INT~
REPLACE_TRIGGER_TEXT DMOOCH ~INT, 13~ ~13, INT~
REPLACE_TRIGGER_TEXT DMOOCH ~CHA, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT DMOOCH ~CHA, 13~ ~13, CHR~
REPLACE_TRIGGER_TEXT DMOOCH ~WIS, 12~ ~12, WIS~
REPLACE_TRIGGER_TEXT DMOOCH ~WIS, 13~ ~13, WIS~
REPLACE_TRIGGER_TEXT DMOOCH ~DEX, 12~ ~12, DEX~
REPLACE_TRIGGER_TEXT DMOOCH ~DEX, 13~ ~13, DEX~
REPLACE_TRIGGER_TEXT DBARKIS ~CHR, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT DBARKIS ~CHR, 13~ ~13, CHR~
REPLACE_TRIGGER_TEXT DBARKIS ~WIS, 12~ ~12, WIS~
REPLACE_TRIGGER_TEXT DBARKIS ~WIS, 13~ ~13, WIS~
REPLACE_TRIGGER_TEXT DBARR ~CHR, 11~ ~11, CHR~
REPLACE_TRIGGER_TEXT DBARR ~CHR, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT DBARR ~DEX, 9~  ~9, DEX~
REPLACE_TRIGGER_TEXT DBARR ~DEX, 10~ ~10, DEX~
REPLACE_TRIGGER_TEXT DBARR ~STR, 9~  ~9, STR~
REPLACE_TRIGGER_TEXT DBARR ~STR, 10~ ~10, STR~
REPLACE_TRIGGER_TEXT DBARR ~DEX,10~ ~10, DEX~
// Removed these two as unnecessary per SKARD in version 3.0
// REPLACE_TRIGGER_TEXT DMANTUOK ~INT, 14~ ~14, INT~
// REPLACE_TRIGGER_TEXT DMANTUOK ~INT, 11~ ~11, INT~
REPLACE_TRIGGER_TEXT DMANTUOK ~INT, 13~ ~13, INT~
REPLACE_TRIGGER_TEXT DMANTUOK ~CHR, 13~ ~13, CHR~
REPLACE_TRIGGER_TEXT DRADINE ~INT, 11~ ~11, INT~
REPLACE_TRIGGER_TEXT DRADINE ~CHR, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT WDRGUARD ~INT, 12~ ~12, INT~
REPLACE_TRIGGER_TEXT WDRGUARD ~INT, 13~ ~13, INT~
REPLACE_TRIGGER_TEXT WDRGUARD ~CHR, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT WDRGUARD ~CHR, 13~ ~13, CHR~
REPLACE_TRIGGER_TEXT WDRGUARD ~STR, 12~ ~12, STR~
REPLACE_TRIGGER_TEXT WDRGUARD ~STR, 13~ ~13, STR~
REPLACE_TRIGGER_TEXT DRAIMON ~INT, 12~ ~12, INT~
REPLACE_TRIGGER_TEXT DRAIMON ~INT, 13~ ~13, INT~
REPLACE_TRIGGER_TEXT DRAIMON ~CHR, 12~ ~12, CHR~
REPLACE_TRIGGER_TEXT DRAIMON ~CHR, 13~ ~13, CHR~
REPLACE_TRIGGER_TEXT DRAIMON ~STR, 12~ ~12, STR~
REPLACE_TRIGGER_TEXT DRAIMON ~STR, 13~ ~13, STR~
REPLACE_TRIGGER_TEXT DQUINT ~INT, 13~ ~13, INT~
REPLACE_TRIGGER_TEXT DBEDAI ~WIS, 14~ ~14, WIS~
REPLACE_TRIGGER_TEXT DBEDAI ~WIS, 15~ ~15, WIS~
REPLACE_TRIGGER_TEXT DTHILDON ~STR, 12~ ~12, STR~
REPLACE_TRIGGER_TEXT DTHILDON ~STR, 13~ ~13, STR~

// Fixpack:  "A minor bug in the Practical Incarnation's dialog. It would go back to
// the main question tree instead of ending the dialog one of the times you say "Let
// me get my bearings, and we shall speak again."
// CREDIT:  Platter
ALTER_TRANS DINCAR1 BEGIN 42 END BEGIN 1 END BEGIN "EPILOGUE" ~EXIT~ END

// Fixpack:  "A bugged stat check in Nordom's dialog when upgrading him using your Charisma."
// CREDIT:  Platter
REPLACE_TRANS_TRIGGER DNORDOM BEGIN 89 END BEGIN 2 END ~14~ ~24~

// Fixpack: "A bugged stat check in Sandoz's dialog that closed off certain solutions to the
// quest involving him unless your Intelligence was exactly 14, instead of 14 and above.
// CREDIT:  Platter
// Qwinn:  Actually, 15 and above
REPLACE_TRANS_TRIGGER DSANDOZ BEGIN 16 END BEGIN 0 END ~CheckStat(~ ~CheckStatGT(~
REPLACE_TRANS_TRIGGER DSANDOZ BEGIN 17 END BEGIN 1 END ~CheckStat(~ ~CheckStatGT(~

// Fixpack: "A bugged stat check in Yi'minn's dialog that prevented you from figuring out his
// offer to help you is a trap unless your Intelligence was exactly 14, instead of 14 and above.
// CREDIT:  Platter
// Qwinn:  Actually, 15 and above
REPLACE_TRANS_TRIGGER ~DYI'MINN~ BEGIN 10 END BEGIN 2 END ~CheckStat(~ ~CheckStatGT(~

// Fixpack: "Two bugged stat checks in Eli Havelock's dialog that occur when he is training you as
// a thief if you've never been one before.
// CREDIT:  Platter
ALTER_TRANS DELI BEGIN 39 END BEGIN 3 END BEGIN "TRIGGER" ~CheckStatGT(Protagonist,17,DEX)~ END
ALTER_TRANS DELI BEGIN 26 END BEGIN 0 END BEGIN "TRIGGER" ~CheckStatGT(Protagonist,17,DEX)~ END
REPLACE_TRANS_TRIGGER DELI BEGIN 26 END BEGIN 1 END ~!CheckStat(~ ~CheckStatLT(~

// Fixpack: "Couldn't get the upgrade for Nordom where you suggest that his "separation from
// the SOURCE is what caused his perspective shift" if both Morte and Fall-From-Grace were in
// your party."
// CREDIT:  Platter
ADD_TRANS_ACTION DMORTE BEGIN 576 END BEGIN 0 END ~SetGlobal("Know_Source","GLOBAL",1)~

// Fixpack:  "Morte would sometimes constantly say "I haven't had this much fun since...
// the last time." This fix prevents that from happening, and also fixes it if it has
// already started.
// CREDIT:  Platter
// Qwinn:  I've removed the "fixes it if it has already started" part, which means blanking
// out that sound file so you -never- hear Morte say that.  It makes Morte creepily quiet in
// my game, so I'm going to leave that sound in.  If it turns out to be a problem, I'll make
// that part an optional WeiDU install.
REPLACE_ACTION_TEXT DREEK ~ReputationInc (1)~ ~~
REPLACE_ACTION_TEXT DREEK ~ReputationInc (5)~ ~~
REPLACE_ACTION_TEXT DANGYAR ~ReputationInc (1)~ ~~

// Fixpack:  "If you insisted that Aelwyn tell you of your previous meeting instead of
// waiting for her to tell you then it wouldn't let you use that info to tell Splinter that
// you were already a Sensate."
// CREDIT:  Platter
ADD_TRANS_ACTION DAELWYN BEGIN 29 END BEGIN 2 END ~SetGlobal("PC_Was_Sensate","GLOBAL",1)~

// Fixpack:  "Sybil experience loop."
// CREDIT:  Platter
REPLACE_ACTION_TEXT DSYBIL ~AddPartyExperience(1000)~ ~AddexperienceParty(1000) ChangeDialog("Sybil","")~

// Fixpack: "Wish Scroll infinite use exploit."
// CREDIT:  Platter
ADD_TRANS_ACTION DWSCROLL BEGIN 4 END BEGIN 0 1 2 3 4 5 END ~DestroyPartyItem("Wscroll",TRUE)~
ADD_TRANS_ACTION DWSCROLL BEGIN 3 END BEGIN 1 END
~GiveItemCreate("Wring",Protagonist,1,0,0)
DestroyPartyItem("Wscroll",TRUE)~
ADD_TRANS_ACTION DWSCROLL BEGIN 3 END BEGIN 2 END
~CreatePartyGold(10000)
DestroyPartyItem("Wscroll",TRUE)~
ADD_TRANS_ACTION DWSCROLL BEGIN 3 END BEGIN 3 END
~PermanentStatChange(Protagonist,LEVEL,RAISE,1)
DestroyPartyItem("Wscroll",TRUE)~
ADD_TRANS_ACTION DWSCROLL BEGIN 3 END BEGIN 4 END
~FullHeal(Player1)
FullHeal(Player2)
FullHeal(Player3)
FullHeal(Player4)
FullHeal(Player5)
FullHeal(Player6)
FadeToBlack()
Wait(3)
FadeFromBlack()
DestroyPartyItem("Wscroll",TRUE)~
ADD_TRANS_ACTION DWSCROLL BEGIN 3 END BEGIN 5 END
~GiveItemCreate("SPWI705",Protagonist,1,1,0)
GiveItemCreate("SPWI802",Protagonist,1,1,0)
GiveItemCreate("SPWI909",Protagonist,1,1,0)
DestroyPartyItem("Wscroll",TRUE)~
ALTER_TRANS DWSCROLL BEGIN 5 6 7 8 9 10 END BEGIN 0 END BEGIN "ACTION" ~~ END

// Fixpack: "Dialog with Marissa where you couldn't get her to stone your Lim-lim."
// CREDIT:  Platter
ADD_TRANS_ACTION DMARISSA BEGIN 36 END BEGIN 0 1 END ~SetGlobal("Know_Marissa_Medusa","AR0605",1)~

// Fixpack:  "Mochai infinite money fix; - This fixes an exploit regarding the NPC Mochai in the
// Smoldering Corpse bar where you could repeatedly threaten her with the line "You're not
// really a Dustman, are you?" and get 50 gold each time."
// CREDIT:  Christopher Nice
ADD_TRANS_TRIGGER DMOOCH 3 ~Global("Bribe_Mochai","GLOBAL",0)~ 4 DO 1

// Fixpack:  "Barr stats check fix;
// This fixes a minor bug in the stat checks when trying to grab Barr's arm when bribing him in
// the Buried Village. If DEX was less than 10 and STR was greater than 9 you would get two
// choices that said, "Grab his arm and pin it." If both DEX and STR were less than 10 you
// wouldn't get the choice at all.
// CREDIT:  Christopher Nice
REPLACE_TRANS_TRIGGER DBARR BEGIN 15 16 END BEGIN 3 END ~CheckStatGT~ ~CheckStatLT~

// Fixpack:  "Ravel conversation bugs;  First, one of the links was messed up if you had killed
// Marta and talked to Ravel about what shapes she has been. This wouldn't affect anything but
// was inconsistent with how that was handled if the other two people she had been were killed.
// Second, the checks when Ravel teaches you magic weren't restrictive enough so you sometimes
// got more than one option that said "Close your eyes, listen." one of which was the one you
// were supposed to get and the other of which was a lesser reward.
// CREDIT:  Christopher Nice
ALTER_TRANS DRAVEL BEGIN 163 END BEGIN 5 END BEGIN "EPILOGUE" ~GOTO 165~ END
ADD_TRANS_TRIGGER DRAVEL 204 ~!Global("Specialist","GLOBAL",6)~ 205 DO 0 1 2


//========================================================================================
//UNDOCUMENTED FIXPACK FIXES
//========================================================================================

// A fix to a bug in Trias's dialogue that prevented you from asking Trias about his
// memories of paradise unless you had his sword.
ALTER_TRANS DTRIAS BEGIN 4 END BEGIN 4 END BEGIN "TRIGGER" ~~ "ACTION" ~~ END

