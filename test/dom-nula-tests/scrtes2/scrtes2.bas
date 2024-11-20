REM >SCRTES2 move left/right with 
REM z/x as the screen scrolls the 
REM point near the bottom should
REM appear to be stationary
MODE 4
PRINT "PRESS Z <> X to scroll"
S%=0
NS%=0
GCOL 3,7
PROCplot
REPEAT
A$=INKEY$(10)
IF (A$="X" OR A$="x") AND S%<7THENNS%=S%+1
IF (A$="Z" OR A$="z") AND S%>0THENNS%=S%-1
*FX19
?&FE22=NS%OR&20:PROCplot:S%=NS%:PROCplot
UNTILFALSE
DEFPROCplot:PLOT &45,100-S%*4,100:ENDPROC