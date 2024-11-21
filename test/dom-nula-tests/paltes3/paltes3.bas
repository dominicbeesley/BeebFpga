REM >test card grey scale / colour composite
MODE 2:?&FE22=&40

X%=0
FOR I%=0TO15:
    GCOL 0,I%
    XX%=X%+80
    MOVE X%,0:MOVE X%,1024:PLOT 85,XX%,1024:MOVE XX%,0:PLOT 85,X%,0
    X%=XX%
NEXT

REM GREYSCALE
FOR I%=0TO15:
    ?&FE23=I%+16*I%:?&FE23=I%+16*I%
NEXT

A$=GET$

REM PAL
FOR I%=0TO15:
    B%=((I%AND2)<>0)AND&0F
    G%=((I%AND8)<>0)AND&F0
    R%=((I%AND4)<>0)AND&0F
    IF I%AND1 THEN R%=R%AND7:G%=G%AND&70:B%=B%AND7
    ?&FE23=R%+16*I%:?&FE23=G%ORB%
NEXT
