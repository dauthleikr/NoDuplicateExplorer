#include <Array.au3>
#NoTrayIcon

Global $explorer

While Not $explorer
	$explorer = ProcessExists("explorer.exe")
	Sleep(100)
WEnd

While True
	Local $list[0]
	Local $windows = WinList()
	For $i = 1 To $windows[0][0]
		If StringLen($windows[$i][0]) > 0 And WinGetProcess($windows[$i][1]) == $explorer Then
			Local $exIndex = _ArraySearch($list, $windows[$i][0])
			If $exIndex >= 0 Then ;Explorer window for this path already open
				If WinActive($windows[$i][1]) Then ;This is the active explorer window, don't kill it
					For $j = 1 To $j - 1 ;Search the inactive explorer window
						If $windows[$i][0] == $windows[$j][1] And WinGetProcess($windows[$j][1]) == $explorer Then
							KillIfForgottenExplorer($windows[$j][1])
						EndIf
					Next
				Else
					KillIfForgottenExplorer($windows[$i][1])
				EndIf
			Else
				_ArrayAdd($list, $windows[$i][0])
			EndIf
		EndIf
	Next
	Sleep(512)
WEnd

Func KillIfForgottenExplorer($win)
	Local $title = WinGetTitle($win)
	;Filtering out Property dialog and simmilar explorer windows
	if $title == "Window" Or Not StringInStr(WinGetClassList($win), "UIRibbonCommandBarDock") Or WinGetClientSize($win)[0] <= 0 Then Return
	Sleep(2048) ;In case the user is just clicking through folders and is in the same folder as another window for a short period of time
	If WinGetTitle($win) <> $title Or WinActive($win) Then Return
	WinKill($win)
EndFunc   ;==>Kill

