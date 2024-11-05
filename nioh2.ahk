; 暴改成卧龙模样
#SuspendExempt
F12::Suspend  ; 按F12开启/关闭
#SuspendExempt False
HotIfWinActive("Nioh2 1.28.08") ; 仅在"Nioh2 1.28.08"窗口活动时启用

; 游戏内设置按键
settings_dodge_dash := "LShift" ; 闪避
settings_guard := "u" ; 防御
settings_low_stance := "8" ; 下段
settings_mid_stance := "7" ; 中段
settings_high_stance := "6" ; 上段
settings_sheatsh := "9" ; 收刀
settings_quick_attack := "LButton" ; 轻击
settings_strong_attack := "RButton" ; 重击
settings_swap_melee := "," ; 切换近战武器

; 自定义按键
hotkey_dodge := "Space" ; 防御闪避并切到下段
hotkey_guard_quick_attack := "a" ; 防御轻击 -> a
hotkey_guard_strong_attack := "g" ; 防御重击 -> g
; hotkey_sheatsh_and_low_stance := "x" ; 下段/下段居合(实战中几乎全用闪避残心了, 上面热键有防御闪避并切到下段, 所以不用下段了)
hotkey_sheatsh_and_mid_stance := "XButton1" ; 中段/中段居合/中段弹反 -> 鼠标侧键1
hotkey_sheatsh_and_high_stance := "XButton2" ; 上段/上段居合 -> 鼠标侧键2
hotkey_swap_melee := "5" ; 紫电 -> 5

; 启用自定义按键(不启用的行可以删掉)
Hotkey hotkey_dodge, dodge ; 防御闪避
Hotkey hotkey_guard_quick_attack, guard_quick_attack ; 防御轻击
Hotkey hotkey_guard_strong_attack, guard_strong_attack ; 防御重击
; Hotkey hotkey_sheatsh_and_low_stance, sheatsh_and_low_stance ; 单击下段/双击(第二击长按)下段居合
Hotkey hotkey_sheatsh_and_mid_stance, sheatsh_and_mid_stance ; 单击中段/双击(第二击长按)中段居合/长按中段弹反
Hotkey hotkey_sheatsh_and_high_stance, sheatsh_and_high_stance ; 单击上段/双击(第二击长按)上段居合
Hotkey hotkey_swap_melee, swap_melee ; 紫电

guarded := 0
dodge(ThisHotkey) {
    global dodge_count := 0
    global guarded
    dodge_count++
    if guarded == 0 {
        Send key_down(settings_guard) ; 先防御
        guarded := 1
        Sleep 40
    } else if guarded > 1 {
        Send key_down(settings_sheatsh) ; 如果已经处在防御闪避状态下, 收刀取消闪避后摇
        Sleep 10
        Send key_up(settings_sheatsh)
    }
    Send key_down(settings_dodge_dash) ; 闪避
    Sleep 40
    Send key_up(settings_dodge_dash)
    SetTimer low_stance, -50
    low_stance() {
        Send key_down(settings_low_stance) ; 闪避动作中切到下段
        Sleep 20
        Send key_up(settings_low_stance)
    }
    SetTimer sheatsh, -200
    sheatsh() {
        if dodge_count > 1 {
            dodge_count := 1
        } else if dodge_count == 1 {
            dodge_count := 0
            Send key_down(settings_sheatsh) ; 收刀取消闪避后摇
            Sleep 10
            Send key_up(settings_sheatsh)
            SetTimer release, -20
            release() {
                if dodge_count > 1 {
                    dodge_count := 0
                } else if dodge_count == 0 && guarded == 1 {
                    Send key_up(settings_guard) ; 结束
                    guarded := 0
                }
            }
        }
    }
}

guard_quick_attack(ThisHotkey) {
    Send key_down(settings_guard) ; 防御
    Sleep 10
    Send key_down(settings_quick_attack) ; 轻击
    KeyWait ThisHotKey
    Send key_up(settings_quick_attack)
    Send key_up(settings_guard)
}

guard_strong_attack(ThisHotkey) {
    Send key_down(settings_guard) ; 防御
    Sleep 10
    Send key_down(settings_strong_attack) ; 重击
    KeyWait ThisHotKey
    Send key_up(settings_strong_attack)
    Send key_up(settings_guard)
}

sheatsh_and_low_stance(ThisHotkey) {
    Send key_down(settings_low_stance) ; 切到下段
    Sleep 40
    Send key_up(settings_low_stance)
    f := KeyWait(ThisHotkey, "T0.2")
    if f = 0 {
        ; 长按(无效)
    } else {
        Send key_down(settings_sheatsh) ; 收刀
        Sleep 10
        Send key_up(settings_sheatsh) ; 收刀
        f := KeyWait(ThisHotkey, "D T0.2")
        if (A_PriorKey = ThisHotkey) {
            if f = 0 {
                ; 单击(上面已执行收刀)
            } else {
                ; 双击
                Send key_down(settings_sheatsh) ; 居合
                KeyWait(ThisHotkey, "T10")
                Send key_up(settings_sheatsh) ; 居合
            }
        }
    }
}

sheatsh_and_mid_stance(ThisHotkey) {
    global guarded
    Send key_down(settings_mid_stance) ; 切到中段
    Sleep 30
    Send key_up(settings_mid_stance)
    SetTimer mid_stance, -1
    mid_stance() {
        Send key_down(settings_guard) ; 防御
        guarded := 2
        KeyWait(ThisHotkey, "T60")
        Send key_up(settings_guard)
        guarded := 0
    }
    f := KeyWait(ThisHotkey, "T0.2")
    if f = 0 {
        ; 长按(上面timer已执行防御)
    } else {
        Sleep 10
        Send key_down(settings_sheatsh) ; 收刀
        Sleep 10
        Send key_up(settings_sheatsh) ; 收刀
        f := KeyWait(ThisHotkey, "D T0.2")
        if (A_PriorKey = ThisHotkey) {
            if f = 0 {
                ; 单击(上面已执行收刀)
            } else {
                ; 双击
                Send key_down(settings_sheatsh) ; 居合
                KeyWait(ThisHotkey, "T10")
                Send key_up(settings_sheatsh) ; 居合
            }
        }
    }
}

sheatsh_and_high_stance(ThisHotkey) {
    Send key_down(settings_high_stance) ; 切到上段
    Sleep 40
    Send key_up(settings_high_stance)
    f := KeyWait(ThisHotkey, "T0.2")
    if f = 0 {
        ; 长按(无效)
    } else {
        Send key_down(settings_sheatsh) ; 收刀
        Sleep 10
        Send key_up(settings_sheatsh) ; 收刀
        f := KeyWait(ThisHotkey, "D T0.2")
        if (A_PriorKey = ThisHotkey) {
            if f = 0 {
                ; 单击(上面已执行收刀)
            } else {
                ; 双击
                Send key_down(settings_sheatsh) ; 居合
                KeyWait(ThisHotkey, "T10")
                Send key_up(settings_sheatsh) ; 居合
            }
        }
    }
}

swap_melee(ThisHotkey) {
    Send key_down(settings_sheatsh)
    Sleep 20
    Send key_up(settings_sheatsh)
    Send key_down(settings_swap_melee)
    Sleep 40
    Send key_up(settings_swap_melee)
}

key_down(k) {
    return "{" . k . " down}"
}

key_up(k) {
    return "{" . k . " up}"
}
