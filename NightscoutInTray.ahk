SetWorkingDir %A_ScriptDir%
#SingleInstance force

Menu, Tray, NoStandard
Menu, Tray, Add , Refresh, Pau
Menu, Tray, Add , Stop, Pau2
Menu, Tray, Add , Start, Start
Menu, Tray, Add , Reload App, Rel
Menu, Tray, Add , Settings, Set
Menu, Submenu, add, NS Url, Set 
Menu, Submenu, add, Units, Units
Menu, tray, add, Settings, :Submenu ; then add the menu to the traz as a submenu 
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
try {
		FileRead, OutputVar, hostname.txt
		WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
		;~ WinHTTP.SetProxy(0)
		WinHTTP.Open("GET", OutputVar "/api/v1/entries.json?count=1", 0)
		WinHTTP.SetRequestHeader("Content-Type", "application/json")
		Body := ""
		WinHTTP.Send(Body)
		Result := WinHTTP.ResponseText
		Status := WinHTTP.Status
		if (status != 200) {
			;msgbox % "status: " status "`n`nresult: " result
			;SetTimer, Pau, Off 
			Menu, Tray, Icon , ns.ico
			return
		}
		Else {


			Cgm :=  RegExMatch(Result, "sgv..(\d*),", SubPat)	
			numberDev := 18
			result2 := Round(SubPat.Value(1) / numberDev, 1)
			;msgbox % "status: " status "`n`nresult: " SubPat.Value(1)  result2
			FileRead, OutputVar2, units.txt
			if (OutputVar2 != "mg") {
				hIcon :=  "numbers2/" result2
				}
				else {
				hIcon :=  "numbers/" SubPat.Value(1) 
				}
			Menu, Tray, Tip , %Result%
			Menu, Tray, Icon , %hIcon%.ico
			return
		}
	} 
catch e
    ;MsgBox % "Error in " e.What ", which was called at line " e.Line  


f11::
         
Start:
SetTimer, Pau, 150000
GOTO Pau

Units:
FileRead, OutputVar, units.txt
InputBox, UserInput, Units, Please enter Units: [mg/mmol]., , %OutputVar%
if ErrorLevel
    MsgBox, CANCEL was pressed.
else
    MsgBox, You save url: "%UserInput%" in units.txt file
	FileDelete units.txt 
	FileAppend, %UserInput%, units.txt
Return

Set:
FileRead, OutputVar, hostname.txt
InputBox, UserInput, NS URL, Please enter a NS URL., , %OutputVar%
if ErrorLevel
    MsgBox, CANCEL was pressed.
else
    MsgBox, You save url: "%UserInput%" in hostname.txt file
	FileDelete hostname.txt 
	FileAppend, %UserInput%, hostname.txt
Return
 
Exi:
ExitApp
Return
Rel:
Reload
Return     
