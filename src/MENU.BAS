' file: MENU.BAS
' author: Kopfensteiner Michael
'
' This application displays the main menu and awaits a user interaction.
' There is nothing more to be done here.
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

TOUCH REMOVE ALL
COLOR WHITE, BLACK

CLS
LOADBMP "B:\IMG\MENU.BMP",0,0

TOUCH SIZE 100,30
TOUCH CREATE 11,10,220,"Ende",Cyan,B

TOUCH SIZE 120,110
TOUCH CREATE 12,40,92,"Execute File",NONE
TOUCH CREATE 13,180,92,"USB",NONE
TOUCH CREATE 14,320,92,"Jogging",NONE

DO
    IF TouchVal(11) THEN
        ' Exit button clicked
        TouchVal(11) = 0
        GOTO APPEXIT
    ELSEIF TouchVal(12) THEN
        ' "Execute File" button clicked
        TouchVal(12) = 0
        RUN "B:\GFILE.BAS"
    ELSEIF TouchVal(13) THEN
        ' "USB" button clicked
        TouchVal(13) = 0
        RUN "B:\USB.BAS"
    ELSEIF TouchVal(14) THEN
        ' "Jogging" button clicked
        TouchVal(14) = 0
    ENDIF 
    PAUSE 50
LOOP

APPEXIT:
    TOUCH REMOVE ALL
	CLS
    RUN "B:\AUTORUN.BAS"
