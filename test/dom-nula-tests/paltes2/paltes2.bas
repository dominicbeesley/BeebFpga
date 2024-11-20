REM >test palette flash and phys colour 
REM mapping to nula palette
MODE 1:?&FE22=&40
FOR I%=0 TO 15:READ N%:?&FE23=N%DIV256:?&FE23=N%:NEXT
:
REPEAT
    READ T$
    COLOUR 3:COLOUR 128:CLS:PRINT T$:VDU 20
    IF T$="END" THEN END
    
    REM PALETTE
    REPEAT
        READ P%
        IF P%<>-1 THEN ?&FE21=P%
    UNTIL P%=-1

    REPEAT
        READ C%
        IF C%>=0THEN READ B%,S$:COLOUR C%:COLOUR B%:PRINT S$
        IF C%<0 AND C%<>-1 THEN ?(&FE00+((C% AND &FF00) DIV 256))=(C%AND255)
    UNTIL C%=-1
    
    A$=GET$
UNTILFALSE

:
END
:

REM DATA FOR NULA PALETTE
DATA &0036, &1007, &2070, &3077, &4700, &5707, &6770, &7777
DATA &8333, &900F, &A0F0, &B0FF, &CF00, &DF0F, &EFF0, &FFFF

REM TEST 1
DATA "Test default palette"
DATA -1
DATA 0,129,"Teal on Navy"
DATA 1,128,"Navy on Teal"
DATA 2,131,"Sky blue on Silver"
DATA -1

DATA "Test high palette palette"
DATA &A8,&B8,&E8,&F8,&8C,&9C,&CC,&DC,&2E,&3E,&6E,&7E,&0F,&1F,&4F,&5F,-1
DATA 0,129,"Teal on Navy"
DATA 1,128,"Navy on Teal"
DATA 2,131,"Sky blue on Silver"
DATA -1

DATA "Test high palette Flash"
DATA &A8,&B8,&E8,&F8,&8C,&9C,&CC,&DC,&2E,&3E,&6E,&7E,&0F,&1F,&4F,&5F,-1
DATA 0,129,"Teal on Navy / Silver on Yellow"
DATA 1,128,"Navy on Teal / Yellow on Silver "
DATA 2,131,"Sky blue on Silver / D.Red on Navy"
DATA &FFFF228F,&FFFF229F
DATA -1

DATA "Test high palette Flash 2"
DATA &A8,&B8,&E8,&F8,&8C,&9C,&CC,&DC,&2E,&3E,&6E,&7E,&0F,&1F,&4F,&5F,-1
DATA 0,129,"Teal on Navy / Teal on Yellow"
DATA 1,128,"Navy on Teal / Yellow on Teal"
DATA 2,131,"Sky blue on Silver / D.Red on Silver"
DATA &FFFF23F0,&FFFF2300
DATA &FFFF2380,&FFFF2300
DATA -1


DATA "END"