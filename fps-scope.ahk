#Requires AutoHotkey v2.0

Persistent  ; Prevent the script from exiting automatically.
OnExit ExitFunc

class FpsScope{
    static new(windowName) {
        this.window := windowName
    }
    static delete() {
        if (WinWait(windowName, , 1)) {
            WinSetAlwaysOnTop 0, FpsScope.window
            WinSetTransparent "OFF", FpsScope.window
            WinSetEnabled 1, FpsScope.window
        }
    }
    static show() {
        WinSetEnabled 0, FpsScope.window
        WinSetAlwaysOnTop 1, FpsScope.window
        WinSetTransparent "OFF", FpsScope.window
    }  
    static hide() {
        WinSetTransparent 0, FpsScope.window
    }
}

ExitFunc(ExitReason, ExitCode){
    FpsScope.delete()
}

; ============= MAIN ==============
promptObj := InputBox("Type in the name of a window.", "FPS scope")
windowName := promptObj.Value ; can use promptObj.Result to test for cancel and shit
FpsScope.new(windowName)

if (promptObj.Result = "OK") {
    ; to add: checks
} else if (promptObj.Result = "Cancel") {
    ExitApp
}



; ============ HOTKEYS ============
`::{ ; `                        to scope
    FpsScope.show()
    KeyWait "``"
    FpsScope.hide()
}
^+!x:: { ; Ctrl Shift Alt X     to quit
    ExitApp
}