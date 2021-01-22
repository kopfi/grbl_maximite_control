' file: GFILE.BAS
' author: Kopfensteiner Michael
'
' This application asks the user to select a GCode File and sends this
' file, line by line, to the GRBL Controller.
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
OPTION VIDEO OFF
MODE 3
LIBRARY LOAD "B:\LIB\COM.LIB"
LIBRARY LOAD "B:\LIB\FSEL.LIB"
LIBRARY LOAD "B:\LIB\GCODE.LIB"

TOUCH REMOVE ALL
COLOR WHITE, BLACK

CHDIR("B:\JOBS")
DO
    LET filename$ = file_select("*.tap",0)

    ON filename$ = "Cancel" OR filename$ = "" GOTO APPEXIT

    open_controller_serial
    open_gcode
    close_controller_serial
LOOP

APPEXIT:
    CHDIR("B:\")
    TOUCH REMOVE ALL
	CLS
    RUN "B:\MENU.BAS"
