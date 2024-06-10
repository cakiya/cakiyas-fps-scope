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
    static new(ID, windowName) {
        this.ID := ID
        this.window := windowName
    }
    static delete() { ; on exit script
        if (WinExist(FpsScope.window)) {
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
    static getAllWindows() { ; returns a 2d array of the ids and names [[id1, id2], [name1, name2]]
        IDs := WinGetList()
        names := Array()
        index := 1
        Loop IDs.Length {
            title := WinGetTitle(IDs[index])
            names.Push(title)
            index := index + 1
        }
        return [IDs, names]
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
    if (ExitCode = 1) { ; dont do anything.

    } else {
        FpsScope.delete()
    }
}

; ============= MAIN ==============
main() {
    windows := FpsScope.getAllWindows()
    windowIDs := windows[1]
    windowNames := windows[2]
    ID := "" ; our window's ID
    name := "" ; our window's name

    guiObject := gui()
    guiObject.Opt("+Resize -MaximizeBox")
    guiObject.AddText(, "Choose a program from the dropdown:")
    guiObject.AddText(, "(do not select an empty option)")
    ddOption := guiObject.AddDropDownList("vColorChoice", windowNames)

    btn := guiObject.AddButton("Default w80 xs", "OK")
    btn.OnEvent("Click", ok)
    ok(btn, info) {
        ID := windowIDs[ddOption.Value]
        name := windowNames[ddOption.Value]
        guiObject.Destroy()
        FpsScope.new(ID, name)
    }

    btn := guiObject.AddButton("Default w80 yp", "REFRESH")
    btn.OnEvent("Click", refresh)
    refresh(btn, info) {
        guiObject.Destroy()
        main()
    }

    ; EXIT button
    btn := guiObject.AddButton("Default w80 yp", "EXIT")
    btn.OnEvent("Click", exit)
    exit(btn, info) {
        ExitApp 1
    }

    ; when you click the x, closes properly
    guiObject.OnEvent("Close", close)
    close(guiObject) {
        ExitApp 1
    }

    guiObject.Show()
}
main()



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