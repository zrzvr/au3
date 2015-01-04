#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         zrzvr
 Script Function: Host Up/Down in Tray, voice message when status changes
 Optional Command Line Argument: Hostname or IP

#ce ----------------------------------------------------------------------------
Opt("TrayAutoPause", 0)
 Opt("TrayMenuMode", 1)
; Opt("TrayOnEventMode", 1)

global $ip
global $p
global $tr
global $laststate=-1
global $t[2]=["Up","Down"]


;Local $exititem = TrayCreateItem("Exit")
$obj = ObjCreate ("SAPI.SpVoice")

if $cmdline[0]<1 then
	$ip=InputBox("auPing", "Enter Host: ", "192.168.2.100")

Else
	$ip=$cmdline[1]
EndIf
TraySetClick(64)
AdlibRegister("go",2000)
$tr=True
While True
	If $tr Then
		$tr = False
		$p = Ping($ip, 2000)
		If $laststate = 0 AND $p > 0 Then say(0)
		If $laststate > 0 AND $p = 0 Then say(1)
		$laststate = $p
		ConsoleWrite($p & @error)
		showping()
	EndIf
	Local $msg = TrayGetMsg()
	Select 
		Case $msg = 0
			ContinueLoop
		Case Else
			ExitLoop
	EndSelect
WEnd
Exit
AdlibUnRegister("go")

func showping()
	if $p>0 then
		TrayTip($ip,"OK",1,1)
	Else
		TrayTip($ip,"No link",1,3)
	EndIf
EndFunc

func go()
$tr=True
EndFunc

func say($x)
ConsoleWrite($x & @CRLF)
$obj.speak($t[$x])
EndFunc

