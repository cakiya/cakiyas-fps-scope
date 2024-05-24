#Requires AutoHotkey v2.0

;; todo: verify that the window grabbed is valid
;; add a centering featuref

; Global vars
InputBoxObj := InputBox("Input the title of the window you wish to use as a scope.", "fps scope")
window := InputBoxObj.Value

^+!/:: { ; Ctrl Shift Alt /
    center_window()
}

^+!x:: { ; Ctrl Shift Alt X
    WinSetAlwaysOnTop(0, window)
    WinSetTransparent "OFF", window
    ExitApp
}

center_window() { 
    global window
    WinWait window

    cur_width := 0
    cur_height := 0
    cur_height_client := 0
    WinGetPos , ,&cur_width, &cur_height
    WinGetClientPos , , , &cur_height_client
    cur_height := cur_height-cur_height_client + cur_height

    centered_x := A_ScreenWidth/2 - cur_width/2
    centered_y := A_ScreenHeight/2 - cur_height/2
    WinMove centered_x, centered_y

    
}

; Change the scope key here:
`::{
    show()
    KeyWait "``" ; Wait for user to physically release it.
    hide()
}

show() {
    global window
    WinWait window
    WinSetAlwaysOnTop(1, window)
    WinSetTransparent "OFF", window
}  

hide() {
    global window
    WinWait window
    WinSetTransparent 0, window
}

; WinMaximize/WinMinimize is just like pressing the minimize and maximize buttons on the window navigation.
; - maximized only
; - does NOT work with fullscreen
; slower

; WinMoveTop/WinMoveBottom just moves it infront and behind all other windows (this one can be resized to whatever you want)
; - no smooth animation :(
; - DOES NOT WORK IF YOU ARE NOT FOCUSED ON THE SCOPE PROGRAM sometimes