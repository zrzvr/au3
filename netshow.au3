#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=netshow.exe
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#most source from AutoIt forum 

Global $aArray = _IPDetails(), $sData
 _ArrayDisplay($aArray,"NetShow")
global $msg

For $A = 1 To $aArray[0][0]
;    $sData &= "Description: " & $aArray[$A][0] & @CRLF &
	$sData &= "IP Address: " & $aArray[$A][1] & @CRLF & _
	"Default Gateway: " & $aArray[$A][3] & @CRLF & "DNS Servers: " & $aArray[$A][4] & @CRLF & @CRLF

;	"MAC: " & $aArray[$A][2] & @CRLF &

Next
$sData = StringTrimRight($sData, 4)
; MsgBox(0, "Network Status", $sData,10)
traytip("Network Status",$sData,10,1)
sleep(5000)
Exit
while True
	$msg = TrayGetMsg()
    Select
		Case $msg = 0
			sleep(1)
            ContinueLoop
;        Case $msg = $exititem
;            ExitLoop
		case else
			ExitLoop
    EndSelect
WEnd



Func _IPDetails()
    Local $iCount = 0
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
    Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True", "WQL", 0x30), $aReturn[1][5] = [[0, 5]]
    If IsObj($oColItems) Then
        For $oObjectItem In $oColItems
            $aReturn[0][0] += 1
            $iCount += 1

            If $aReturn[0][0] <= $iCount + 1 Then
                ReDim $aReturn[$aReturn[0][0] * 2][$aReturn[0][1]]
            EndIf

            $aReturn[$iCount][0] = _IsString($oObjectItem.Description)
            $aReturn[$iCount][1] = _IsString($oObjectItem.IPAddress(0))
            $aReturn[$iCount][2] = _IsString($oObjectItem.MACAddress)
            $aReturn[$iCount][3] = _IsString($oObjectItem.DefaultIPGateway(0))
            $aReturn[$iCount][4] = _IsString(_WMIArrayToString($oObjectItem.DNSServerSearchOrder(), " - ")) 
;            $aReturn[$iCount][5] = _IsString($oObjectItem.ServiceName(0))

		Next
        ReDim $aReturn[$aReturn[0][0] + 1][$aReturn[0][1]]
        Return $aReturn
    EndIf
    Return SetError(1, 0, $aReturn)
EndFunc   ;==>_IPDetails

Func _IsString($sString)
    If IsString($sString) Then
        Return $sString
    EndIf
    Return "Not Available"
EndFunc   ;==>_IsString

Func _WMIArrayToString($aArray, $sDelimeter = "|")
    If IsArray($aArray) = 0 Then
        Return SetError(1, 0, "Not Available")
    EndIf
    Local $iUbound = UBound($aArray) - 1, $sString
    For $A = 0 To $iUbound
        $sString &= $aArray[$A] & $sDelimeter
    Next
    Return StringTrimRight($sString, StringLen($sDelimeter))
EndFunc   ;==>_WMIArrayToString
