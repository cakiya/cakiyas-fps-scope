#Requires AutoHotkey v2.0
Persistent
OnExit ExitFunc

class FpsScope{
    static new(windowName) {
        this.window := windowName
    }
    static delete() {
        if (WinWait(windowName, , 1)) {
            ; WinSetStyle "+0xC00000", "A"
            WinSetAlwaysOnTop 0, FpsScope.window
            WinSetExStyle "-0x20", FpsScope.window
            WinSetTransparent "OFF", FpsScope.window
        }
    }
    static show() {
        ; WinSetStyle "-0xC00000", "A" ; removes title bar
        WinSetAlwaysOnTop 1, FpsScope.window
        WinSetExStyle "+0x20", FpsScope.window
        WinSetTransparent 200, FpsScope.window
    }               
    static hide() {
        WinSetTransparent 100, FpsScope.window
    }
}

ExitFunc(ExitReason, ExitCode) {
    FpsScope.delete()
}

; ============= MAIN ==============
promptObj := InputBox("Type in the name of a window.", "FPS scope")
windowName := promptObj.Value
FpsScope.new(windowName)

if (promptObj.Result = "OK") {
    ; to add: checks
} else if (promptObj.Result = "Cancel") {
    ExitApp
}

; ============ HOTKEYS ============
`::{ ;                  to scope:   `
    FpsScope.show()
    KeyWait "``"
    FpsScope.hide()
}
^+!x:: { ;              to quit:    Ctrl Shift Alt X
    ExitApp
}