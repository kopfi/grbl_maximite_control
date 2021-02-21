' file: USB.BAS
' author: Michael Kopfensteiner
'
' This application forwards data from the USB serial connection to the 
' GRBL controller and vice versa.
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

OPTION VIDEO OFF
OPTION USB ON
MODE 3

LIBRARY LOAD "B:\LIB\COM.LIB"

TOUCH REMOVE ALL
COLOR WHITE, BLACK

CLS
LOADBMP "B:\IMG\USB.BMP",0,0

TOUCH INTERRUPT handle_touch_input
TOUCH SIZE 200,30
TOUCH CREATE 11,140,200,"Ende",Cyan,B

open_controller_serial

LET aborted = 0
LET returnLine$ = ""
LET nextLine$ = ""
DO
    ON aborted GOTO APPEXIT
    
    'print all machine lines, that arrived until now
    returnLine$ = read_raw$
    IF returnLine$ <> "" THEN
        PRINT returnLine$
    ENDIF

    LET nextChar$ = INKEY$
    
    IF nextChar$ <> "" THEN
        ' soft-reset; this resets our linebuffer too
        IF ASC(nexChar$) = 18 THEN
            returnLine$ = send_raw$(nextChar$,0)
            print_machine_lines
            LET nextLine$ = ""

        'realtime commands currently bypass the normal send routine too
        ELSEIF nextChar$ = "?" OR nextChar$ = "~" OR nextChar$ = "!" THEN
            returnLine$ = send_raw$(nextChar$,0)
            print_machine_lines

        ' send line on LF or CR
        ELSEIF ASC(nextChar$) = 10 OR ASC(nextChar$) = 13 THEN
            ' the input line is complete
            returnLine$ = send_raw$(nextLine$,1)
            LET nextLine$ = ""
            print_machine_lines
            
        ' in any other case, store the symbol in our linebuffer
        ELSE
            LET nextLine$ = nextLine$ + nextChar$
        ENDIF
    ELSE
        ' wait sleep a little and check INKEY$ again later
        PAUSE 20
    ENDIF
LOOP

SUB print_machine_lines
    DO WHILE returnLine$ <> ""
        PRINT returnLine$
        ON aborted GOTO APPEXIT

        returnLine$ = read_raw$()
    LOOP
END SUB

SUB handle_touch_input
	IF TouchVal(11) THEN
		TouchVal(11) = 0
		LET aborted = 1
	ENDIF
END SUB

APPEXIT:
    close_controller_serial
    TOUCH INTERRUPT 0
    TOUCH REMOVE ALL
	CLS
    RUN "B:\MENU.BAS"
