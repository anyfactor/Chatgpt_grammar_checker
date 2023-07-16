F8::{
    input_prompt := A_Clipboard
    A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
    Send "^c"
    ClipWait  ; Wait for the clipboard to contain text.

    TrayTip "Grammar Check Triggered", "Grammar check command recieved please wait..."
    Sleep 3000   ; Let it display for 3 seconds.
    HideTrayTip

    RunWait A_ComSpec ' /c cd "<path_to_powershell_script>" & powershell.exe .\test.ps1'
    MsgBox input_prompt "`n"`n"" A_Clipboard

    ; Copy this function into your script to use it.
    HideTrayTip() {
        TrayTip  ; Attempt to hide it the normal way.
        if SubStr(A_OSVersion,1,3) = "10." {
            A_IconHidden := true
            Sleep 200  ; It may be necessary to adjust this sleep.
            A_IconHidden := false
        }
    }
}