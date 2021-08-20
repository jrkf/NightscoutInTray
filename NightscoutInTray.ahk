SetWorkingDir %A_ScriptDir%
#SingleInstance force

Menu, Tray, NoStandard
Menu, Tray, Add , Refresh, Pau
Menu, Tray, Add , Stop, Pau2
Menu, Tray, Add , Start, Start
Menu, Tray, Add , Reload App, Rel
Menu, Tray, Add , Exit, Exi
Menu, Tray, Default, Exit
Menu, Tray, Icon , ns.ico,, 1
SetTimer, Pau, 150000
GOTO Pau
Return


Pau2:                          
msgbox % "Pobieranie danych z NS zostalo zatrzymane"
SetTimer, Pau, Off
Return

Pau:
FileRead, OutputVar, hostname.txt
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
;~ WinHTTP.SetProxy(0)
WinHTTP.Open("GET", OutputVar "/api/v1/entries.json?count=1", 0)
WinHTTP.SetRequestHeader("Content-Type", "application/json")
Body := "{}"
WinHTTP.Send(Body)
Result := WinHTTP.ResponseText
Status := WinHTTP.Status
if (status != 200) {
msgbox % "status: " status "`n`nresult: " result
SetTimer, Pau, Off 
}
Else {
Cgm :=  RegExMatch(Result, "sgv..(\d*),", SubPat)
;msgbox % "status: " status "`n`nresult: " SubPat.Value(1)
Menu, Tray, Tip , %Result%
hIcon :=  "numbers/" SubPat.Value(1)
Menu, Tray, Icon , %hIcon%.ico
}


f11::
         
Start:
SetTimer, Pau, 6000
GOTO Pau

Exi:
ExitApp
Return
Rel:
Reload
Return          