#SuspendExempt
F12::Suspend  ; 按F12开启/关闭
#SuspendExempt False
HotIfWinActive("Nioh2 1.28.08") ; 仅在"Nioh2 1.28.08"窗口活动时启用

; 游戏内设置按键
settings_dodge := "LShift" ; 闪避
settings_guard := "XButton1" ; 防御
settings_low_stance := "Space" ; 下段
settings_sheatsh := "XButton2" ; 收刀
settings_quick_attack := "LButton" ; 轻击
settings_strong_attack := "RButton" ; 重击

; 自定义按键
hotkey_dodge := "WheelUp" ; 闪避
hotkey_guard_quick_attack := "a" ; 防御轻击
hotkey_guard_strong_attack := "g" ; 防御重击

; 启用自定义按键(不启用的行可以删掉)
Hotkey hotkey_dodge, dodge ; 闪避 -> 滚轮上滑
Hotkey hotkey_guard_quick_attack, guard_quick_attack ; 防御轻击 -> a
Hotkey hotkey_guard_strong_attack, guard_strong_attack ; 防御重击 -> g


dodge(ThisHotkey) {
    global dodge_count := 0
    global guarded := 0
    dodge_count++
    if guarded == 0 {
        Send key_down(settings_guard) ; 先防御
        guarded := 1
        Sleep 40
    } else {
        Send key_down(settings_sheatsh) ; 如果已经处在防御闪避状态下, 收刀取消闪避后摇
        Sleep 10
        Send key_up(settings_sheatsh)
    }
    Send key_down(settings_dodge) ; 闪避
    Sleep 40
    Send key_up(settings_dodge) ; 
    Sleep 10
    Send key_down(settings_low_stance) ; 闪避动作中切到下段
    Sleep 10
    Send key_up(settings_low_stance) ;
    SetTimer sheatsh, -240
    sheatsh() {
        if dodge_count > 1 {
            dodge_count := 1
        } else if dodge_count == 1 {
            dodge_count := 0
            Send key_down(settings_sheatsh) ; 收刀取消闪避后摇
            Sleep 10
            Send key_up(settings_sheatsh)
            SetTimer release, -150
            release() {
                if dodge_count > 1 {
                    dodge_count := 0
                } else if dodge_count == 0 {
                    Send key_up(settings_guard) ; 结束
                    guarded := 0
                }
            }
        }
    }
}

guard_quick_attack(ThisHotkey) {
    Send key_down(settings_guard) ; 防御
    Sleep 30
    Send key_down(settings_quick_attack) ; 轻击
    Sleep 100
    Send key_up(settings_quick_attack)
    Send key_up(settings_guard)
}

guard_strong_attack(ThisHotkey) {
    Send key_down(settings_guard) ; 防御
    Sleep 30
    Send key_down(settings_strong_attack) ; 重击
    Sleep 100
    Send key_up(settings_strong_attack)
    Send key_up(settings_guard)
}

key_down(k) {
    return "{" . k . " down}"
}

key_up(k) {
    return "{" . k . " up}"
}
