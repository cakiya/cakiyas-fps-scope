#Requires AutoHotkey v2.0
Persistent
OnExit ExitFunc

;==============Hotkeys===============
;  scope        `
;  center       Ctrl Shift Alt /
;  quit         Ctrl Shift Alt X
;  You can set them to something else at the bottom of the file.
;====================================

class FpsScope{
    static new(windowName) {
        this.window := windowName
    }
    static delete() {
        if (WinWait(windowName, , 1)) {
            WinSetStyle "+0xC00000", FpsScope.window
            WinSetAlwaysOnTop 0, FpsScope.window
            WinSetExStyle "-0x20", FpsScope.window
            WinSetTransparent "OFF", FpsScope.window
        }
    }
    static show() {
        WinSetAlwaysOnTop 1, FpsScope.window
        WinSetExStyle "+0x20", FpsScope.window ; makes it clickthrough
        WinSetTransparent 200, FpsScope.window
    }
    static hide() {
        WinSetTransparent 100, FpsScope.window
    }
    static getAllWindows() {
        IDs := WinGetList()
        Names := [IDs.Length]
        index := 0
        for ID in IDs {
            Names[index] := WinGetTitle(ID)
            index := index + 1
        }
    }
    static centerWindow() {
        WinSetStyle "^0xC00000", FpsScope.window
        WinGetPos &OutX, &OutY, &OutWidth, &OutHeight, FpsScope.window
        WinCenterX := OutWidth/2
        WinCenterY := OutHeight/2
        WinMove (A_ScreenWidth/2)-WinCenterX, (A_ScreenHeight/2)-WinCenterY, , , FpsScope.window
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

; FpsScope.getAllWindows()



; ============ HOTKEYS ============
`::{ ;                      to scope:   `
    FpsScope.show()
    KeyWait "``"
    FpsScope.hide()
}
^+!/::{ ;                   to center:   Ctrl Shift Alt /
    FpsScope.centerWindow()
}
^+!x:: { ;                  to quit:    Ctrl Shift Alt X
    ExitApp
}