//===============================================================================
// Planescape: Vengeance Restoration Pack section (dialogue fixes only)
//===============================================================================


// DANAZI.DLG, DDAKKON.DLG, DKIINA.DLG,
// Now increments Githzerai variable
// Qwinn:  There are a -lot- of bugs in the way this is implemented in Resto Pack.
// I'm doing these changes in a completely different way, also fixing some
// errors in the original at the same time.  See QwinnFix.d


// -DXANDER.DLG:
// Incorrect 'Snap' sound changed to "SPE_11.WAV"
// Fix of !Dead(Bedai) conditions: missing quotes around Bedai
REPLACE_ACTION_TEXT DXANDER ~PlaySound(snap)~ ~PlaySoundNotRanged("SPE_11")~
REPLACE_TRIGGER_TEXT DXANDER ~Dead(Bedai)~ ~Dead("Bedai")~
// Removal of Global("Regret","GLOBAL",10) dummying condition for memory of Xero Xander
// Not implementing this.  It causes an infinite xp and scroll loop, and it was deliberately
// dummied.
// REPLACE_TRIGGER_TEXT DXANDER ~Global("Regret", "GLOBAL", 10)~ ~~

// -DCOAX.DLG
// Added removed reply to continue asking questions
// Qwinn:  Also need to fix the existing "Thanks, farewell" response that acts as if you'd
// wanted to continue asking questions, see QwinnFix.d for that fix.
EXTEND_TOP DCOAX 25
  IF ~~ THEN REPLY #26380 GOTO 2
 END

// -DDHALL.DLG:
// Restored dummied stringref #5729 as a reply
EXTEND_TOP DDHALL 45
  IF ~~ THEN REPLY #5729 JOURNAL #39459 GOTO 9
 END

// -DVAULT9.DLG:
// Restored triggers for response to being attacked
// Qwinn Note:  This finishes the fix that Platter's Fixpack started in 0510VALT.BCS.
ADD_STATE_TRIGGER DVAULT9 0 ~!Global("Vault_Attack","GLOBAL",1)~ 1


// -DMARROW.DLG:
// Restored reply to attack him after he takes a chunk out of you.
// Qwinn Note:  RP actually adds it when he just eats a grub too.  Only adding when he does
// take a chunk out of you.
EXTEND_TOP DMARROW 6 #1
  IF ~~ THEN REPLY #17250 DO ~Enemy()ForceAttack(Protagonist,Myself)~ EXIT
 END

// DPOET.DLG:
// Added 3 to each intelligence check so all replies would be normally available at
// this stage of the game
REPLACE_TRIGGER_TEXT DPOET ~13, INT~ ~16, INT~
REPLACE_TRIGGER_TEXT DPOET ~12, INT~ ~15, INT~
REPLACE_TRIGGER_TEXT DPOET ~ 9, INT~ ~ 12, INT~
REPLACE_TRIGGER_TEXT DPOET ~ 8, INT~ ~ 11, INT~

// ===================================== VERSION 3.0 ============================================

// Reversed the "Gained an Ability" sound fix to Deionarra's "Raise Dead" ability gain as done by
// Restoration Pack. Redoing in QwinnFix.d, using the existing 30378 strref rather than overwriting
// an unused strref, and applying it to Stories Bones Tell and Sensory Touch as well.
