

// ====================== First approach - TO & TNO on roof ==========================
REPLACE_STATE_TRIGGER DTRANS 2 ~~ 3 4

APPEND DTRANS
   IF ~Global("Transcendent_Final_Speech", "GLOBAL", 1)~ THEN BEGIN Subtitle-1-1
     SAY @200001
     IF ~~ THEN DO ~FaceObject("Nameless")~ GOTO Subtitle-1-2
   END

   IF ~~ THEN BEGIN Subtitle-1-2
     SAY @200002
     IF ~GlobalGT("Fortress_Party_Roof","GLOBAL",1)~ THEN GOTO 2
     IF ~Global("Fortress_Party_Roof","GLOBAL",1)Global("Fortress_Annah","GLOBAL",0)Global("Fortress_Grace","GLOBAL",0)~ THEN GOTO 3
     IF ~Global("Fortress_Party_Roof","GLOBAL",1)~ THEN GOTO 4
   END
END

// ====================== TO & TNO - Prefight cutscene ===============================

ALTER_TRANS DTRANS BEGIN 141 END BEGIN 0 1 2 3 END BEGIN "ACTION" ~~ END
ALTER_TRANS DTRANS BEGIN 141 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO Prefight-1-1~ END
ALTER_TRANS DTRANS BEGIN 141 END BEGIN 1 END BEGIN "EPILOGUE" ~GOTO Prefight-1-2~ END
ALTER_TRANS DTRANS BEGIN 141 END BEGIN 2 END BEGIN "EPILOGUE" ~GOTO Prefight-1-3~ END
ALTER_TRANS DTRANS BEGIN 141 END BEGIN 3 END BEGIN "EPILOGUE" ~GOTO Prefight-1-2~ END

ALTER_TRANS DTRANS BEGIN 138 END BEGIN 0 END BEGIN "EPILOGUE" ~GOTO Deceive-1-1~ END
REPLACE_SAY DTRANS 139 @200009
ALTER_TRANS DTRANS BEGIN 139 END BEGIN END BEGIN "REPLY" ~~ END
APPEND DTRANS
   IF ~~ THEN BEGIN Deceive-1-1
     SAY #66129
     IF ~~ THEN REPLY #66130 GOTO 139
   END
END

REPLACE_TRANS_ACTION DTRANS BEGIN 142 END BEGIN 0 END
   ~StartCutScene("1204trb1")~ ~SetGlobal("Transcendent_Final_Speech","GLOBAL",3)StartCutScene("1204trb")~
REPLACE_TRANS_ACTION DTRANS BEGIN 142 END BEGIN 1 END
   ~StartCutScene("1204trb2")~ ~SetGlobal("Transcendent_Final_Speech","GLOBAL",4)StartCutScene("1204trb")~
REPLACE_TRANS_ACTION DTRANS BEGIN 142 END BEGIN 2 END
   ~StartCutScene("1204trb3")~ ~SetGlobal("Transcendent_Final_Speech","GLOBAL",5)StartCutScene("1204trb")~
REPLACE_TRANS_ACTION DTRANS BEGIN 142 END BEGIN 3 END
   ~StartCutScene("1204trb2")~ ~SetGlobal("Transcendent_Final_Speech","GLOBAL",4)StartCutScene("1204trb")~



APPEND DTRANS
   IF ~Global("Transcendent_Final_Speech", "GLOBAL", 3)~ THEN BEGIN Prefight-1-1
     SAY @200003
     IF ~~ THEN GOTO Prefight-2
   END

   IF ~Global("Transcendent_Final_Speech", "GLOBAL", 4)~ THEN BEGIN Prefight-1-2
     SAY @200004
     IF ~~ THEN GOTO Prefight-2
   END

   IF ~Global("Transcendent_Final_Speech", "GLOBAL", 5)~ THEN BEGIN Prefight-1-3
     SAY @200005
     IF ~~ THEN GOTO Prefight-2
   END

   IF ~~ THEN BEGIN Prefight-2
     SAY @200006
     IF ~~ THEN GOTO Prefight-3
   END

   IF ~~ THEN BEGIN Prefight-3
     SAY @200007
     IF ~~ THEN GOTO Prefight-4
   END

   IF ~~ THEN BEGIN Prefight-4
     SAY @200008
     IF ~~ THEN DO ~Enemy()~ EXIT
   END
END

// ================================ TO & RAVEL ======================================

APPEND DRAVEL
   IF ~Global("Ravel_Cut_Scene", "AR0610", 12)~ THEN BEGIN Ravel-TO-5
     SAY @200052
     IF ~~ THEN EXTERN DTRANS Ravel-TO-6
   END

   IF ~~ THEN BEGIN Ravel-TO-7
     SAY @200053
     IF ~~ THEN EXTERN DTRANS Ravel-TO-8
   END

   IF ~~ THEN BEGIN Ravel-TO-9
     SAY @200054
     IF ~~ THEN DO ~SetGlobal("Ravel_Cut_Scene","AR0610",13)StartCutSceneMode()StartCutScene("0610CT3M")~ EXIT
   END
END

APPEND DTRANS
   IF ~~ THEN BEGIN Ravel-TO-6
     SAY @200057
     IF ~~ THEN EXTERN DRAVEL Ravel-TO-7
   END

   IF ~~ THEN BEGIN Ravel-TO-8
     SAY @200058
     IF ~~ THEN EXTERN DRAVEL Ravel-TO-9
   END

   IF WEIGHT #-15 ~Global("Ravel_Cut_Scene","AR0610",13)~ THEN BEGIN Ravel-TO-10
     SAY @200059
     IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("0610CT3N")~ EXIT
   END
END

// ================================ TO & IGNUS ==================================
APPEND DTRANS
  IF WEIGHT #-99 ~Global("Subtitles","GLOBAL",1)~ THEN BEGIN TO-Ignus-Arise
    SAY @200060
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CI12")~ EXIT
  END

  IF WEIGHT #-98 ~Global("Subtitles","GLOBAL",2)~ THEN BEGIN TO-Ignus-MustDie
    SAY @200061
    IF ~~ THEN EXTERN DIGNUS TO-Ignus-HAHAHAHA
  END

  IF WEIGHT #-97 ~Global("Subtitles","GLOBAL",4)Global("Fortress_Ignus","GLOBAL",1)~
    THEN BEGIN TO-Ignus-Sorcerer
    SAY @200064
    IF ~~ THEN GOTO TO-Ignus-Have-Need
  END

  IF WEIGHT #-96 ~Global("Subtitles","GLOBAL",4)Global("Fortress_Ignus","GLOBAL",0)~
    THEN BEGIN TO-Ignus-Have-Need
    SAY @200065
    IF ~~ THEN GOTO TO-Ignus-MustDie
  END
END

APPEND DIGNUS
  IF WEIGHT #-99 ~Global("Subtitles","GLOBAL",3)~ THEN BEGIN TO-Ignus-GreatPower
    SAY @200063
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CI21")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Ignus-HAHAHAHA
    SAY @200062
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CI14")~ EXIT
  END

END

// ================================ TO & VHAILOR ==================================
APPEND DTRANS
  IF WEIGHT #-95 ~Global("Subtitles","GLOBAL",5)~ THEN BEGIN TO-Vhail-Arise
    SAY @200067
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CV12")~ EXIT
  END

  IF WEIGHT #-94 ~Global("Subtitles","GLOBAL",6)~ THEN BEGIN TO-Vhail-Injustice
    SAY @200069
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CV14")~ EXIT
  END

  IF WEIGHT #-93 ~Global("Subtitles","GLOBAL",7)~ THEN BEGIN TO-Vhail-Arise
    SAY @200067
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CV22")~ EXIT
  END

  IF WEIGHT #-92 ~Global("Subtitles","GLOBAL",8)~ THEN BEGIN TO-Vhail-HaveNeed
    SAY @200068
    IF ~~ THEN GOTO TO-Vhail-Injustice
  END
END

// ================================= TO & GRACE ====================================
APPEND DGRACEF
  IF WEIGHT #-91 ~Global("Subtitles","GLOBAL",9)~ THEN BEGIN TO-Grace-Difficult
    SAY @200070
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSGC")~ EXIT
  END

  IF WEIGHT #-90 ~Global("Subtitles","GLOBAL",10)~ THEN BEGIN TO-Grace-NotAPlace
    SAY @200071
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201csG2")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Grace-Harm
    SAY @200073
    IF ~~ THEN GOTO TO-Grace-Prepare
  END

  IF ~~ THEN BEGIN TO-Grace-Prepare
    SAY @200074
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201csG8")~ EXIT
  END

END

APPEND DTRANSF
  IF WEIGHT #-88 ~Global("Subtitles","GLOBAL",11)~ THEN BEGIN TO-Grace-AahTanarri
    SAY @200072
    IF ~~ THEN DO ~SetGlobal("Subtitles","GLOBAL",12)~ EXTERN DGRACEF 0
  END

  IF WEIGHT #-87 ~Global("Subtitles","GLOBAL",13)~ THEN BEGIN TO-Grace-Nothing
    SAY @200075
    IF ~~ THEN GOTO TO-Grace-Unmake
  END

  IF ~~ THEN BEGIN TO-Grace-Unmake
    SAY @200076
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201csG9")~ EXIT
  END
END

ALTER_TRANS DTRANSF BEGIN 16 END BEGIN 0 END BEGIN "ACTION"
  ~SetGlobal("Grace_Death_Scene","GLOBAL",4)~ END
ALTER_TRANS DTRANSF BEGIN 16 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DGRACEF TO-Grace-Harm~ END

// ================================= TO & DAKKON ====================================

APPEND DDAKKON
  IF WEIGHT #-86 ~Global("Subtitles","GLOBAL",14)~ THEN BEGIN TO-Dakkon-Shadows
    SAY @200077
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSD2")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Dakkon-Bested
    SAY @200080
    IF ~~ THEN DO ~PlaySequence(ANIM_STANCEFIDGET1)~ EXTERN DTRANS TO-Dakkon-Hope
  END

  IF ~~ THEN BEGIN TO-Dakkon-Before
    SAY @200082
    IF ~~ THEN DO ~PlaySequence(ANIM_STANCEFIDGET1)~ EXTERN DTRANS TO-Dakkon-SoBeIt
  END
END

APPEND DTRANS
  IF WEIGHT #-85 ~Global("Subtitles","GLOBAL",15)~ THEN BEGIN TO-Dakkon-AahGith
    SAY @200078
    IF ~~ THEN GOTO TO-Dakkon-Submit
  END

  IF ~~ THEN BEGIN TO-Dakkon-Submit
    SAY @200079
    IF ~~ THEN EXTERN DDAKKON TO-Dakkon-Bested
  END

  IF ~~ THEN BEGIN TO-Dakkon-Hope
    SAY @200081
    IF ~~ THEN EXTERN DDAKKON TO-Dakkon-Before
  END

  IF ~~ THEN BEGIN TO-Dakkon-SoBeIt
    SAY @200083
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSD6")~ EXIT
  END
END

// ============================== TO & ANNAH ====================================

APPEND DANNAHF
  IF WEIGHT #-84 ~Global("Subtitles","GLOBAL",16)~ THEN BEGIN TO-Annah-Cold
    SAY @200084
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSA2")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Annah-Matters
    SAY @200086
    IF ~~ THEN EXTERN DTRANSF TO-Annah-Die
  END
END

APPEND DTRANSF
  IF WEIGHT #-83 ~Global("Subtitles","GLOBAL",17)~ THEN BEGIN TO-Annah-AhFiendling
    SAY @200085
    IF ~~ THEN GOTO 1
  END

  IF ~~ THEN BEGIN TO-Annah-Die
    SAY @200087
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSA4")~ EXIT
  END
END

ALTER_TRANS DTRANSF BEGIN 9 END BEGIN 0 END BEGIN "ACTION"
  ~SetGlobal("Annah_Death_Scene","GLOBAL",1)~ END
ALTER_TRANS DTRANSF BEGIN 9 END BEGIN 0 END BEGIN "EPILOGUE" ~EXTERN DANNAHF TO-Annah-Matters~ END

// ============================== TO & NORDOM ====================================

APPEND DNORDOM
  IF WEIGHT #-82 ~Global("Subtitles","GLOBAL",18)~ THEN BEGIN TO-Nordom-Processing
    SAY @200088
    IF ~~ THEN DO ~Face(6)~ GOTO TO-Nordom-Plane
  END

  IF ~~ THEN BEGIN TO-Nordom-Plane
    SAY @200089
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSN2")~ EXIT
  END

  IF WEIGHT #-81 ~Global("Subtitles","GLOBAL",20)~ THEN BEGIN TO-Nordom-Closure
    SAY @200091
    IF ~~ THEN DO ~MoveViewPoint([4370.1050],VERY_FAST)StartCutSceneMode()StartCutScene("1201CSN4")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Nordom-Harm
    SAY @200093
    IF ~~ THEN DO ~Enemy()StartCutSceneMode()StartCutScene("1201CSN5")~ EXIT
  END

  IF WEIGHT #-81 ~Global("Subtitles","GLOBAL",22)~ THEN BEGIN TO-Nordom-Stop
    SAY @200094
    IF ~~ THEN GOTO TO-Nordom-Prospect
  END

  IF ~~ THEN BEGIN TO-Nordom-Prospect
    SAY @200095
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSN6")~ EXIT
  END

  IF ~~ THEN BEGIN TO-Nordom-Intend
    SAY @200097
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSN8")~ EXIT
  END
END

APPEND DTRANS
  IF WEIGHT #-80 ~Global("Subtitles","GLOBAL",19)~ THEN BEGIN TO-Nordom-AhRogue
    SAY @200090
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1201CSN3")~ EXIT
  END

  IF WEIGHT #-79 ~Global("Subtitles","GLOBAL",21)~ THEN BEGIN TO-Nordom-Overstepped
    SAY @200092
    IF ~~ THEN DO ~MoveViewPoint([4370.1050],VERY_FAST)~ GOTO TO-Nordom-Submit
  END

  IF ~~ THEN BEGIN TO-Nordom-Submit
    SAY @200079
    IF ~~ THEN EXTERN DNORDOM TO-Nordom-Harm
  END

  IF WEIGHT #-78 ~Global("Subtitles","GLOBAL",23)~ THEN BEGIN TO-Nordom-Shell
    SAY @200096
    IF ~~ THEN EXTERN DNORDOM TO-Nordom-Intend
  END
END

// ===================== DEIONARRA AFTER INCARNATIONS ============================
APPEND DDEIONS
  IF WEIGHT #-77 ~Global("Subtitles","GLOBAL",24)~ THEN BEGIN Deionarra-Forgive
    SAY @200010
    IF ~~ THEN GOTO Deionarra-DeathsHalls
  END

  IF WEIGHT #-76 ~Global("Subtitles","GLOBAL",25)~ THEN BEGIN Deionarra-DeathsHalls
    SAY @200011
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1203CD13")~ EXIT
  END
END

// ========================= MORTE & ANNAH WHEN GRACE JOINS ========================
APPEND DANNAH
  IF WEIGHT #-75 ~Global("Subtitles","GLOBAL",26)~ THEN BEGIN GraceJoins-Annah
    SAY @200012
    IF ~~ THEN EXTERN DMORTE GraceJoins-Morte
  END

  IF ~~ THEN BEGIN GraceJoins-Annah2
    SAY @200014
    IF ~~ THEN DO ~SetGlobal("Subtitles","GLOBAL",0)~ EXIT
  END
END

APPEND DMORTE
  IF ~~ THEN BEGIN GraceJoins-Morte
    SAY @200013
    IF ~~ THEN EXTERN DANNAH GraceJoins-Annah2
  END
END

// =================== GRACE AND ANNAH'S COMMENTS IN FELL'S STUDIO ==================
APPEND DGRACE
  IF WEIGHT #-74 ~Global("Subtitles","GLOBAL",27)~ THEN BEGIN Grace-FellsStudio
    SAY @200015
    IF ~~ THEN DO ~SetGlobal("Subtitles","GLOBAL",0)SetGlobal("Tattoo_Parlor_Grace","AR0404",1)~
       EXIT
  END
END

APPEND DANNAH
  IF WEIGHT #-73 ~Global("Subtitles","GLOBAL",28)~ THEN BEGIN Annah-FellsStudio
    SAY @200016
    IF ~~ THEN DO ~SetGlobal("Subtitles","GLOBAL",0)SetGlobal("Tattoo_Parlor_Annah","AR0404",1)~
       EXIT
  END
END

// =================== MORTE'S COMMENT IN THE DUSTMAN BAR ============================
APPEND DMORTE
  IF WEIGHT #-72 ~Global("Subtitles","GLOBAL",29)~ THEN BEGIN Morte-DustmanBar
    SAY @200017
    IF ~~ THEN DO ~SetGlobal("Subtitles","GLOBAL",0)~ EXIT
  END
END

// ============================== FHJULL FREED ======================================
APPEND DFHJULL
  IF WEIGHT #-71 ~Global("Subtitles","GLOBAL",30)~ THEN BEGIN Fhjull-Freed
    SAY @200018
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("0901CT1B")~ EXIT
  END
END

// ============================ LEAVING FHJULL ======================================
// Version 4.0:  Changed order of the two lines, based on file number sequence and it makes more sense
APPEND DFHJULL
  IF WEIGHT #-70 ~Global("Subtitles","GLOBAL",31)~ THEN BEGIN Fhjull-NoMatter
    SAY @200020
    IF ~~ THEN GOTO Fhjull-Strange
  END

  IF ~~ THEN BEGIN Fhjull-Strange
    SAY @200019
    IF ~~ THEN DO ~StartCutSceneMode()StartCutScene("1101CUT5")~ EXIT
  END
END


