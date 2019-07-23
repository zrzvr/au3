#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\open_icon_library-PD\icons\ico\48x48\devices\computer-3.ico
#AutoIt3Wrapper_Outfile=puttynator.exe
#AutoIt3Wrapper_Outfile_x64=puttynator64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Multi-Window Control (puTTY, KiTTY)
#AutoIt3Wrapper_Res_Fileversion=1.0.1.11
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=UL
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <ListboxConstants.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <File.au3>
Opt("SendKeyDelay", 0) ;5 milliseconds
Opt("SendKeyDownDelay", 0) ;1 millisecond
Opt("SendCapslockMode", 0)
#Region ### START Koda GUI section ### Form=au3\ciscomat\ciscomat.kxf
$ciscomat = GUICreate("Puttynator", 400, 300,20, 20)
$verinfo="V1.0.2 UL2015"
;$bRefresh = GUICtrlCreateButton("Refresh", 10, 10, 75, 25)
$lvWin = GUICtrlCreateListView("", 10, 10, 380, 80, BitOR($LVS_NOCOLUMNHEADER,$LVS_SHOWSELALWAYS, $LVS_SINGLESEL),$LVS_EX_CHECKBOXES)

_GUICtrlListView_AddColumn($lvWin, "Sessions", 200)
_GUICtrlListView_AddColumn($lvWin, "", 20)


;$cAll = GUICtrlCreateCheckbox("All", 100, 160, 37, 17)
$lCmd = GUICtrlCreateList("", 10, 150, 141, 114,$LBS_NOTIFY)
$cCat = GUICtrlCreateCombo("", 10, 120, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$tBuf = GUICtrlCreateEdit("", 160, 120, 231, 141)
GUICtrlSetData(-1, "")
GUICtrlSetState(-1, $GUI_DROPACCEPTED) ; to allow drag and dropping
$lContext=GUICtrlCreateLabel("Right Click = Context Menu",10,100)
$bSave = GUICtrlCreateButton("Save",10, 270, 75, 25)
$bDel = GUICtrlCreateButton("Delete",85, 270, 75, 25)

$bSend = GUICtrlCreateButton("Send", 160, 270, 75, 25)
$bCr = GUICtrlCreateButton("CR", 235, 270, 25, 25)
$bSpc = GUICtrlCreateButton("Spc", 260, 270, 25, 25)
$bQ = GUICtrlCreateButton("q", 285, 270, 25, 25)

$bEnd = GUICtrlCreateButton("End", 315, 270, 75, 25)

;$bOpt = GUICtrlCreateButton("Options", 10, 40, 75, 25)
;$bTile = GUICtrlCreateButton("Tile", 10, 70, 75, 25)
;$bHide = GUICtrlCreateButton("Hide", 10, 100, 75, 25)
;$bShow = GUICtrlCreateButton("Show", 10, 130, 75, 25)
;$Button2 = GUICtrlCreateButton("Buf->Clip", 320, 160, 75, 25)
;$Button3 = GUICtrlCreateButton("Clip->Buf", 400, 160, 75, 25)

$contextmenu = GUICtrlCreateContextMenu()
$cmRefresh =GUICtrlCreateMenuItem("Refresh", $contextmenu)
GUICtrlCreateMenuItem("", $contextmenu) ; separator
$cmTile=GUICtrlCreateMenuItem("Tile", $contextmenu)
$cmShow=GUICtrlCreateMenuItem("Show", $contextmenu)
$cmHide=GUICtrlCreateMenuItem("Hide", $contextmenu)
$cmLoadLayout=GUICtrlCreateMenuItem("Load Layout", $contextmenu)
$cmSaveLayout=GUICtrlCreateMenuItem("Save Layout", $contextmenu)

GUICtrlCreateMenuItem("", $contextmenu) ; separator
$cmSave=GUICtrlCreateMenuItem("Save", $contextmenu)
$submnu1 = GUICtrlCreateMenu("Send...", $contextmenu)
$cmCtrlC=GUICtrlCreateMenuItem ("Ctrl-C", $submnu1)
;$cmCtrlZ=GUICtrlCreateMenuItem("Ctrl-Z", $submnu1)
;$cmShift6=GUICtrlCreateMenuItem("Ctrl+Shift+6", $submnu1)
GUICtrlCreateMenuItem("Space", $submnu1)

GUICtrlCreateMenuItem("", $contextmenu) ; separator
$cmInfo=GUICtrlCreateMenuItem("Info", $contextmenu)
GUICtrlCreateMenuItem("", $contextmenu) ; separator
$cmEnd=GUICtrlCreateMenuItem("Exit", $contextmenu)


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$folderarray= _FileListToArray(@WorkingDir ,"*",2)
if $folderarray=0 then DirCreate("Snippets")
if not FileExists("puttynator.ini") then init()
$iniWindow = IniRead("puttynator.ini", "Setup", "Window", "[CLASS:PuTTY]")

dim $wli[10]
$wlc=0
global $wlist
global $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ!"§$%&/()=?*>;:_'
global $altgr = '@|\~'
global $nogo= '^°µ€{[]}'

refreshwin()
refreshfolders()
refreshfiles()
While 1
	$nMsg = GUIGetMsg(1)
	Select
		Case $nmsg[0]=$GUI_EVENT_CLOSE and $nMsg[1]=$ciscomat
			ExitLoop
		case $nMsg[0]=$bSend
			send2win()
		case $nMsg[0]=$lvWin
			MsgBox(0,@ScriptName,GUICtrlRead(GUICtrlRead($lvWin), 2))
		case $nMsg[0]=$lCmd
			bLoad()
		Case $nMsg[0]=$cmRefresh
			refreshwin()
		case $nMsg[0]=$cmTile
			wTile()
		case $nMsg[0]=$cmHide
			wHide()
		Case $nMsg[0]=$bSave
			bsave()
		Case $nMsg[0]=$bDel
			bdel()
		Case $nMsg[0]=$bCR
			char2win(@cr)
		Case $nMsg[0]=$bSpc
			char2win(" ")
		Case $nMsg[0]=$bQ
			char2win("q")
		Case $nMsg[0]=$cmShow
			wShow()
		Case $nMsg[0]=$cCat
			refreshfiles()
		Case $nMsg[0]=$cmSaveLayout
			saveLayout()
		case $nMsg[0]=$cmLoadLayout
			loadLayout()
		case $nMsg[0]=$cmCtrlC
			char2win(chr(3))
		case $nMsg[0]=$cmInfo
			info()
		Case $nMsg[0]=$bEnd
			ExitLoop
		Case $nMsg[0]=$cmEnd
			ExitLoop
			EndSelect
WEnd

func refreshwin()
	for $i=1 to $wlc
		guictrldelete($wli[$i])
	Next
	$wlist= winlist($iniWindow,"")
	$wlc=$wlist[0][0]
	$whdl=WinGetHandle($iniWindow)
	$wputty=$wlc & @CRLF
;	for $i=1 to $wlc
;		consolewrite($wlist[$i][0] & " ")
;		consolewrite($wlist[$i][1] & @crlf)
;	Next
	for $i=1 to $wlc
		$wli[$i] = GUICtrlCreateListViewItem($wlist[$i][0], $lvWin)
		_GUICtrlListView_SetItemChecked($lvWin, $i-1)
	Next
EndFunc

func refreshfolders()
	$folderarray= _FileListToArray(@WorkingDir ,"*",2)
	$folderlist=""
	if $folderarray=0 then DirCreate("Snippets")
	for $i=1 to $folderarray[0]
		$folderlist=$folderlist & "|" &  $folderarray[$i]
	Next
	guictrlsetdata($cCat,$folderlist,$folderarray[1] )
EndFunc

func refreshfiles()
	$categ= guictrlread($cCat)
	$filesarray=_filelisttoarray(@WorkingDir & "\" & $categ, "*",1)
	$filelist=""
	if $filesarray=0 then Return
	guictrlsetdata($lCmd,"")
	for $i=1 to $filesarray[0]
		$filelist=$filelist & "|" & $filesarray[$i]
	next
	guictrlsetdata($lCmd, $filelist,"Snippets")

EndFunc

func send2win()
for $i=1 to $wlc
	$chw= _GUICtrlListView_GetItemChecked($lvWin, $i-1)
	if $chw Then
		$txt=GUICtrlRead($tBuf)

;		ControlSendPlus($wlist[$i][0],"","",$txt,0 )
;		ControlSend($wlist[$i][0],"","",$txt,1 )

		for $j=1 to stringlen($txt)
			$chx=stringmid($txt,$j,1)
			$isShift=False
			$isAltgr=False
			$isNogo=False
			For $k = 1 To StringLen($upper)
				If asc($chx) = asc(stringmid($upper,$k,1)) Then
					$isShift = true
;					ExitLoop
				EndIf
			Next
			For $k = 1 To StringLen($altgr)
				If asc($chx) = asc(stringmid($altgr,$k,1)) Then
					$isAltGr = true
;					ExitLoop
				EndIf
			Next
			For $k = 1 To StringLen($nogo)
				If asc($chx) = asc(stringmid($nogo,$k,1)) Then
					$isNogo = true
;					ExitLoop
				EndIf
			Next
			if $isshift Then Send("{SHIFTDOWN}")
			if $isAltGr Then
				Send("{ALTDOWN}")
				Send("{CTRLDOWN}")
			EndIf
			if $chx=@LF then ContinueLoop
			if $chx=@CR then $chx= "{Enter}"

			if $chx="!" then $chx="{!}"
			if $chx="+" then $chx="{+}"
;			if $chx="^" then $chx="{^}"
;			if $chx="{" then $chx="{}"
;			if $chx="}" then $chx="{}}"
			if $chx="#" then $chx="{#}"
			if $isnogo Then
				Msgbox(0,"Complaints to AutoIt, sorry!","Please enter special character manually in each window: "& $chx & @CRLF & "Then press OK to continue")
			Else
				ControlSend($wlist[$i][0],"","",$chx,0)
			endif

			ConsoleWrite($chx & " " & $isshift & @crlf)
			if $isAltGr then
				Send("{ALTUP}")
				Send("{CTRLUP}")
			EndIf
			if $isshift then Send("{SHIFTUP}")
			sleep(10)
		Next
	EndIf
Next
EndFunc

func char2win($c)
for $i=1 to $wlc
	$chw= _GUICtrlListView_GetItemChecked($lvWin, $i-1)
	if $chw Then
		ControlSend($wlist[$i][0],"","",$c,0 )
	EndIf
Next
EndFunc

func wHide()
;	refreshwin()
	for $i=1 to $wlc
		WinSetState($wlist[$i][0], "", @SW_MINIMIZE)
	Next
EndFunc
func wshow()
;	refreshwin()
	for $i=1 to $wlc
		WinSetState($wlist[$i][0], "", @SW_RESTORE)
	Next
EndFunc

func wTile()
	refreshwin()
	$x0=IniRead("puttynator.ini", "Setup", "x0", "20")
	$y0=IniRead("puttynator.ini", "Setup", "y0", "20")
	$dx=IniRead("puttynator.ini", "Setup", "dx", "640")
	$dy=IniRead("puttynator.ini", "Setup", "dy", "480")
	$ncol=IniRead("puttynator.ini", "Setup", "ncol", "3")
	for $i=1 to $wlc
		$col=mod($i,$ncol)
		$row=int(($i)/$ncol)
		$posx=$x0+$dx*$row
		$posy=$y0+$dy*$col
		WinMove($wlist[$i][0], "",$posx ,$posy)
	Next
EndFunc

func bsave()
	$selFile=GUICtrlRead($lcmd)
	$finname=inputbox(@ScriptName,"Filename.txt",$selfile)
	$fname=guictrlread($cCat) & "\" & $finname
	if FileExists($fname) Then
		if msgbox(4,@Scriptname, "Overwrite?")=6 Then
;			ConsoleWrite($fname&@crlf)
			if FileDelete($fname) Then
			;sleep(400)
				filewrite($fname,guictrlread($tbuf))
;				MsgBox(0,@ScriptName,"OK")
			EndIf
		EndIf
	else
		filewrite($fname,guictrlread($tbuf))
		refreshfiles()

	EndIf
EndFunc

func bLoad()
;	MsgBox(0,@ScriptName,GUICtrlRead($lcmd))
	$selFolder=	GUICtrlRead($cCat)
	$selFile=GUICtrlRead($lcmd)
	$fText=fileread($selFolder & "\" & $selFile)
	GUICtrlSetData($tBuf,$fText)
EndFunc

func bDel()
	$selFolder=	GUICtrlRead($cCat)
	$selFile=GUICtrlRead($lcmd)
	FileDelete($selFolder & "\" & $selFile)
	refreshfiles()
EndFunc


func loadLayout()
	for $i=1 to $wlc
		$x=iniread("puttynator.ini",$i,"x",$i*20)
		$y=iniread("puttynator.ini",$i,"y",$i*20)
		$w=iniread("puttynator.ini",$i,"w","640")
		$h=iniread("puttynator.ini",$i,"h","480")
		WinMove($wlist[$i][0], "",$x ,$y,$w,$h)
	Next

EndFunc

func saveLayout()
	for $i=1 to $wlc
		$winpos=WinGetPos($wlist[$i] [0])
		IniWrite("puttynator.ini",$i,"x",$winpos[0])
		IniWrite("puttynator.ini",$i,"y",$winpos[1])
		IniWrite("puttynator.ini",$i,"w",$winpos[2])
		IniWrite("puttynator.ini",$i,"h",$winpos[3])
	Next

EndFunc

func info()
	msgbox(0,"Info", @ScriptName & @crlf & $verinfo, 2)
EndFunc

func init()
	filewriteline("puttynator.ini","[Setup]")
	filewriteline("puttynator.ini","Window=""[CLASS:PuTTY]""")
	filewriteline("puttynator.ini","x0=20")
	filewriteline("puttynator.ini","y0=20")
	filewriteline("puttynator.ini","dx=640")
	filewriteline("puttynator.ini","dy=400")
	filewriteline("puttynator.ini","ncol=2")
EndFunc


Func ControlSendPlus($title, $text, $className, $string, $flag)
;VERSION 2.0.3 (06/13/2004)
Local $ctrl=0,$alt=0,$upper,$start,$end,$i,$char,$and,$Chr5Index,$isUpper,$ret
If $flag = 2 OR $flag = 3 Then $ctrl = 1
If $flag = 2 OR $flag = 4 Then $alt = 1
If $flag <> 1 Then $flag = 0;set the flag to the default function style
;$upper = StringSplit('~!@#$%^&*()_+|{}:"<>?ABCDEFGHIJKLMNOPQRSTUVWXYZ', "")
$upper = StringSplit('"§$%&/()=?*>;:_ABCDEFGHIJKLMNOPQRSTUVWXYZ', "")
If $flag <> 1 Then;don't replace special chars if it's raw mode
;replace {{} and {}} with +[ and +] so they will be displayed properly
  $string = StringReplace($string, "{{}", "+[")
  $string = StringReplace($string, "{}}", "+]")
;replace all special chars with Chr(5)
;add the special char to an array.  each Chr(5) corresponds with an element
  Local $Chr5[StringLen($string) / 2 + 1]
  For $i = 1 To StringLen($string)
    $start = StringInStr($string, "{")
    If $start = 0 Then ExitLoop;no more open braces, so no more special chars
    $end = StringInStr($string, "}")
    If $end = 0 Then ExitLoop;no more close braces, so no more special chars
;parse inside of braces:
    $Chr5[$i] = StringMid($string, $start, $end - $start + 1)
;replace with Chr(5) leaving the rest of the string:
    $string = StringMid($string, 1, $start - 1) & Chr(5) & StringMid($string, $end + 1, StringLen($string))
  Next
;take out any "!", "^", or "+" characters
;add them to the $Modifiers array to be used durring key sending
  Local $Modifiers[StringLen($string) + 1]
  For $i = 1 To StringLen($string)
    $char = StringMid($string, $i, 1)
    $and = 0
    If $char = "+" Then
      $and = 1
    ElseIf $char = "^" Then
      $and = 2
    ElseIf $char = "!" Then
      $and = 4
    ElseIf $char = "" Then
      ExitLoop
    EndIf
    If $and <> 0 Then
      $Modifiers[$i] = BitOR($Modifiers[$i], $and)
      $string = StringMid($string, 1, $i - 1) & StringMid($string, $i + 1, StringLen($string))
      $i = $i - 1
    EndIf
  Next
Else;it is raw mode, so set up an all-0 modifier array
  Local $Modifiers[StringLen($string) + 1]
EndIf

;now send the chars
$Chr5Index = 1
For $i = 1 To StringLen($string)
  $char = StringMid($string, $i, 1)
  If $char = Chr(5) Then
    $char = $Chr5[$Chr5Index]
    $Chr5Index = $Chr5Index + 1
  EndIf
  $isUpper = 0
  For $j = 1 To UBound($upper) - 1
    If $char == $upper[$j] Then $isUpper = 1
  Next

;1 SHIFT, 2 CTRL, 4 ALT (programmer note to keep the bits straight)
  If $isUpper = 1 OR BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTDOWN}")
  If BitAND($Modifiers[$i], 4) = 4 AND NOT $alt Then $char = "!" & $char
  If BitAND($Modifiers[$i], 2) = 2 AND NOT $ctrl Then $char = "^" & $char
  If BitAND($Modifiers[$i], 4) = 4 AND $alt Then Send("{ALTDOWN}")
  If BitAND($Modifiers[$i], 2) = 2 AND $ctrl Then Send("{CTRLDOWN}")
  $ret = ControlSend($title, $text, $className, $char, $flag)
  If BitAND($Modifiers[$i], 4) = 4 AND $alt Then Send("{ALTUP}")
  If BitAND($Modifiers[$i], 2) = 2 AND $ctrl Then Send("{CTRLUP}")
  If $isUpper = 1 OR BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTUP}")
  If NOT $ret Then return 0;window or control not found
Next
return 1
EndFunc

