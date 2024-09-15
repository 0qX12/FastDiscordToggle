#SingleInstance, Force

; Путь к ini-файлу для сохранения настроек автозагрузки
IniFilePath := A_ScriptDir "\user_choice.ini"

; Функция для добавления текущего скрипта в автозагрузку
AddToStartup() {
    ; Путь к ярлыку в папке автозагрузки
    StartupShortcutPath := A_Startup "\FastDiscordToggle.ahk.lnk"
    
    ; Проверяем, существует ли ярлык
    if FileExist(StartupShortcutPath) {
        MsgBox, 64, Уведомление, Ярлык уже существует в автозагрузке!
        return
    }
    
    ; Создание ярлыка в автозагрузке
    FileCreateShortcut, %A_ScriptFullPath%, %StartupShortcutPath%
    
    ; Проверяем ошибки при создании ярлыка
    if ErrorLevel {
        MsgBox, 16, Ошибка, Не удалось добавить скрипт в автозагрузку! Возможно, недостаточно прав доступа.
    } else {
        MsgBox, 64, Успех, Скрипт успешно добавлен в автозагрузку!
    }
}

; Проверка настроек автозагрузки
If FileExist(IniFilePath) {
    IniRead, userChoice, %IniFilePath%, Settings, AutoStart
    if (userChoice = "Yes") {
        AddToStartup()
    }
} else {
    ; Запрос на добавление скрипта в автозагрузку, если ini-файл не существует
    MsgBox, 4, Вопрос, Хотите ли вы добавить скрипт в автозагрузку?
    IfMsgBox Yes
    {
        IniWrite, Yes, %IniFilePath%, Settings, AutoStart
        AddToStartup()
    } else {
        IniWrite, No, %IniFilePath%, Settings, AutoStart
    }
}

; Горячие клавиши

; Ctrl + L - Выход из скрипта
^l::ExitApp

; F1 - Мьют/размьют микрофона с возвратом к активному окну
F1::
    ToggleDiscordHotkey("^+m") ; Комбинация для мьюта микрофона
return

; F3 - Отключение/включение наушников с возвратом к активному окну
F3::
    ToggleDiscordHotkey("^+d") ; Комбинация для дефена наушников
return

; Функция для активации Discord и отправки хоткея
ToggleDiscordHotkey(hotkey) {
    ; Сохраняем активное окно
    WinGet, active_window, ID, A
    
    ; Если окно Discord существует
    if WinExist("ahk_exe Discord.exe") {
        WinActivate ; Активируем Discord
        Sleep, 50
        Send, %hotkey% ; Отправляем нужную комбинацию клавиш
        Sleep, 50
        WinActivate, ahk_id %active_window% ; Возвращаемся в активное окно
    }
}
