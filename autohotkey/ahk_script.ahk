F8::{
  ;; Provide your path to Go executable in line 18


  ;copies the content from current selection
  A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
  Send "^c"
  ClipWait  ; Wait for the clipboard to contain text.

  ; async operation via threading of some sort
  ; https://www.reddit.com/r/AutoHotkey/comments/mqbyfz/can_i_have_multiple_functionsactions_running_at/
  SetTimer trayalert, -1, 1
  SetTimer core_grammar_operation, -1, 1
  return

  core_grammar_operation(){
    ; runs the go project
    RunWait A_ComSpec ' /c "<path_to_file_main.exe>"'

    ; delay before content is posted.
    Sleep 800
    Send "^v"
  }

  trayalert(){
    ; tray alert for script being copied
    input_prompt := A_Clipboard
    TrayTip "Grammar Check Triggered", input_prompt
    Sleep 4000   ; Let it display for 3 seconds.
    HideTrayTip
  }    
  HideTrayTip() {
    ; tray alert helper function to hide the tray
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
      A_IconHidden := true
      Sleep 200  ; It may be necessary to adjust this sleep.
      A_IconHidden := false
    }
  }
}