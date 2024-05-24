#Requires AutoHotkey v2.0
Persistent  ; Prevent the script from exiting automatically.
OnExit FpsScope.Exiting

;; todo: verify that the window grabbed is valid
;; add a centering feature

class FpsScope{

    static new(windowName) {
        this.window := windowName
    }

    static Exiting(*)
    {
        MsgBox "FPS scope Exiting"
        WinSetAlwaysOnTop 0, FpsScope.window
        WinSetTransparent "OFF", FpsScope.window
    }

    ; static centerWindow() { 
    ;     WinWait this.window

    ;     cur_width := 0
    ;     cur_height := 0
    ;     cur_height_client := 0
    ;     WinGetPos , ,&cur_width, &cur_height
    ;     WinGetClientPos , , , &cur_height_client
    ;     cur_height := cur_height-cur_height_client + cur_height

    ;     centered_x := A_ScreenWidth/2 - cur_width/2
    ;     centered_y := A_ScreenHeight/2 - cur_height/2
    ;     WinMove centered_x, centered_y
    ; }

    static show() {
        WinWait this.window
        WinSetAlwaysOnTop(1, this.window)
        WinSetTransparent "OFF", this.window
    }  

    static hide() {
        WinWait this.window
        WinSetTransparent 0, this.window
    }
}

; ============= MAIN ==============
promptObj := InputBox("Type in the name of a window.", "FPS scope")
windowName := promptObj.Value ; can use promptObj.Result to test for cancel and shit
FpsScope.new(windowName)

; ============ HOTKEYS ============
`::{ ; `                        to scope
    FpsScope.show()
    KeyWait "``" ; Wait for user to physically release it.
    FpsScope.hide()
}
; ^+!/:: { ; Ctrl Shift Alt /   to center (not implemented)
;     scope.center_window()
; }
^+!x:: { ; Ctrl Shift Alt X     to quit
    ExitApp
}
