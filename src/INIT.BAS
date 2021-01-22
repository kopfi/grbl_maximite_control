' file: AUTORUN.BAS
' author: Michael Kopfensteiner
'
' This application initializes the GBRL controller to a useable state.
' Currently this means, the user is asked to do a homing-cycle. At the
' end of the programm it runs the MENU application.

OPTION USB OFF
OPTION VIDEO ON
MODE 3
LIBRARY LOAD "B:\LIB\COM.LIB"

TOUCH REMOVE ALL
COLOR WHITE, BLACK

CLS
LOADBMP "B:\IMG\WARN.BMP",0,0
TOUCH SIZE 100,30
TOUCH CREATE 11,80,192,"Nein",Yellow,B
TOUCH CREATE 12,300,192,"JA",Red,B
FONT #2

' useable width: ----------------------------------
PRINT @(20,70)  "Das System wurde neu gestartet."
PRINT @(20,88)  "Die Nullpunkt-Kalibrierung fehlt."
PRINT @(20,106) "'Homing' jetzt starten?"

DO
    TOUCH WAIT
LOOP UNTIL(TouchVal(11) OR TouchVal(12))

TouchVal(11) = 0

IF TouchVal(12) THEN
    TouchVal(12) = 0
    ' perform calibration, aka "Homing"
    
    CLS
    LOADBMP "B:\IMG\WAIT.BMP",0,0    
    
    open_controller_serial
    IF send_to_controller("$h",0) THEN
        ' an error occured while performing a homing cycle
        close_controller_serial
        COLOR RED, BLACK
        FONT #1
        PRINT @(55, 200) "Fehler: Homing fehlgeschlagen!"
        PRINT @(25, 218) "GRBL: ";gControllerError$;
        COLOR WHITE, BLACK
        PAUSE(20000)
        RUN "B:\AUTORUN.BAS"
    ENDIF

    close_controller_serial
ENDIF

RUN "B:\MENU.BAS"
