' file: AUTORUN.BAS
' author: Michael Kopfensteiner
'
' MMBasic starts this program automatically, when powered on. This
' application displays the logo and loads the INIT application.

OPTION USB OFF
OPTION VIDEO OFF
MODE 3

TOUCH REMOVE ALL
COLOR WHITE, BLACK

' Simply replace this file with anything you like, to get another logo
CLS
LOADBMP "B:\IMG\LOGO.BMP",0,0

PAUSE 1500

RUN "B:\INIT.BAS"
