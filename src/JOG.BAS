' file: JOG.BAS
' author: Kopfensteiner Michael
'
' This application displays usefull values to assist the use of the
' hardware jogpad.
'
' Copyright (C) 2021  Michael Kopfensteiner
'
' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License
' along with this program.  If not, see <https://www.gnu.org/licenses/>.

OPTION USB OFF
OPTION VIDEO ON
MODE 3

LIBRARY LOAD "B:\LIB\COM.LIB"
LIBRARY LOAD "B:\LIB\GCODE.LIB"

TOUCH REMOVE ALL
COLOR WHITE, BLACK
CLS

TOUCH INTERRUPT handle_touch_input

TOUCH SIZE 140,30
TOUCH CREATE 11,10,10,"Ende",Cyan,B
TOUCH CREATE 13,10,115,"X = 0",Yellow,B
TOUCH CREATE 14,10,155,"Y = 0",Yellow,B
TOUCH CREATE 15,10,195,"Z = 0",Yellow,B
TOUCH CREATE 16,10,235,"Zu Nullp.",Blue,B

TOUCH SIZE 140,55
' max text length      ---------
TOUCH CREATE 12,10,50,"Homing",Red,B

open_controller_serial

LET executeLine$ = ""
LET executeFile$ = ""
LET aborted = 0
DO
    ON aborted GOTO APPEXIT
    
    IF executeLine$ <> "" THEN
        TOUCH DISABLE ALL
        LET result = send_to_controller(executeLine$,0)
        LET executeLine$ = ""
        TOUCH ENABLE ALL
    ELSEIF executeFile$ <> "" THEN
        TOUCH DISABLE ALL
        LET result = send_gcode_file(executeFile$)
        LET executeFile$ = ""
        TOUCH ENABLE ALL
    ENDIF
    
    update_position_info
    FONT #1
    COLOR WHITE, BLACK
    PRINT @(160, 126) "Status: ";gCtrlStatus$;
    IF gCtrlStatus$ <> "Jog" THEN
        FONT #1
        COLOR CYAN, BLACK
        PRINT @(160,10) "Maschinenpos.:"
        PRINT @(160,22) "X:";FORMAT$(gMX, "%07.2f");"  Y:";FORMAT$(gMY, "%07.2f");"  Z:";FORMAT$(gMZ, "%07.2f")
        
        FONT #2
        COLOR BLUE, WHITE
        '               ------------------------------
        PRINT @(160,44) "Arbeitspos.:           "
        COLOR BLUE, BLACK
        PRINT @(160,65) "X: ";FORMAT$(gWX, "%07.2f");" mm  "
        PRINT @(160,83) "Y: ";FORMAT$(gWY, "%07.2f");" mm  "
        PRINT @(160,101) "Z: ";FORMAT$(gWZ, "%07.2f");" mm  "
        
        COLOR WHITE, BLACK
    ENDIF
    ' better alternative to discard input buffers?
    LET dummy$ = INPUT$(200, #2)
    
    ' Remarks, usefull for other buttons:
    'G10 L2 ... set offset coordinate system directly
    'G10 L20 .. set offset by specifying new point
    'G92 ...... set temporary work offset
    'G92.1 .... reset temporary work offset
    
    PAUSE 20
LOOP

SUB handle_touch_input
	IF TouchVal(11) THEN
		TouchVal(11) = 0
        TOUCH DISABLE ALL
		LET aborted = 1
        EXIT SUB
    ENDIF
    
	IF TouchVal(12) THEN
        ' Homing
        TouchVal(12) = 0
        LET executeLine$ = "$h"
    ELSEIF TouchVal(13) THEN
        ' Set X = 0
        TouchVal(13) = 0
        LET executeLine$ = "G92 X0.0"
    ELSEIF TouchVal(14) THEN
        ' Set Y = 0
        TouchVal(14) = 0
        LET executeLine$ = "G92 Y0.0"
    ELSEIF TouchVal(15) THEN
        ' Set Z = 0
        TouchVal(15) = 0
        LET executeLine$ = "G92 Z0.0"
    ELSEIF TouchVal(16) THEN
        ' Goto Zero
        TouchVal(16) = 0
        LET executeFile$ = "B:\APP\JOG\TO0.NC"
    ENDIF
END SUB

APPEXIT:
    close_controller_serial
    TOUCH INTERRUPT 0
    TOUCH REMOVE ALL
	CLS
    RUN "B:\MENU.BAS"
    
