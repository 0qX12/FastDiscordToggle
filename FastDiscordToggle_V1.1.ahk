#SingleInstance, Force

IniFilePath := A_ScriptDir "\user_choice.ini"

AddToStartup() {
    StartupShortcutPath := A_Startup "\FastDiscordToggle.ahk.lnk"
    
    if FileExist(StartupShortcutPath) {
        return
    }
    
    FileCreateShortcut, %A_ScriptFullPath%, %StartupShortcutPath%
    
    if ErrorLevel {
        MsgBox, 16, Ошибка, Не удалось добавить скрипт в автозагрузку! Возможно, недостаточно прав доступа.
    } else {
        MsgBox, 64, Успех, Скрипт успешно добавлен в автозагрузку!
    }
}

If FileExist(IniFilePath) {
    IniRead, userChoice, %IniFilePath%, Settings, AutoStart
    if (userChoice = "Yes") {
        AddToStartup()
    }
} else {
    MsgBox, 4, Вопрос, Хотите ли вы добавить скрипт в автозагрузку?
    IfMsgBox Yes
    {
        IniWrite, Yes, %IniFilePath%, Settings, AutoStart
        AddToStartup()
    } else {
        IniWrite, No, %IniFilePath%, Settings, AutoStart
    }
}

^l::ExitApp

F1::
    ToggleDiscordHotkey("^+m")
return

F3::
    ToggleDiscordHotkey("^+d")
return

ToggleDiscordHotkey(hotkey) {
    WinGet, active_window, ID, A
    if WinExist("ahk_exe Discord.exe") {
        WinActivate
        Sleep, 50
        Send, %hotkey%
        Sleep, 50
        WinActivate, ahk_id %active_window%
    }
}
