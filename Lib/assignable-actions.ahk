; Assignable Actions
;-------------------------------------------------

; TODO: what about oneKeyBack and twoKeysBack for things that aren't single characters or actions? L ike "move one word left" (Ctrl + Left)?
; What about media keys?
; The stuff on Function layer for adding links and heasders etc, in markdown?

; Layer Keys
;-------------------------------------------------

func_layer_down() {
    keysToReturn := ""
    funcLeader := True
    funcDownNoUp := True
    isFuncLayerPress := True
    lastFuncLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

func_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastFuncLayerPress > changedMindThreshold) {
        funcLeader := False
    }
    funcDownNoUp := False
    isFuncLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_func_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastFuncLayerPress < doubleTapThreshold) {
        funcLocked := True
    }
    else {
        funcLeader := False
        funcLocked := False
    }
    return hotstring_neutral_key(keysToReturn)
}

shift_clipboard_layer_down() {
    keysToReturn := ""
    shiftClipboardLeader := True
    shiftClipboardDownNoUp := True
    isShiftClipboardLayerPress := True
    lastShiftClipboardLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

shift_clipboard_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastShiftClipboardLayerPress > changedMindThreshold) {
        shiftClipboardLeader := False
    }
    shiftClipboardDownNoUp := False
    isShiftClipboardLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_shift_clipboard_layer() {
    keysToReturn := ""
    shiftClipboardLeader := False
    return hotstring_neutral_key(keysToReturn)
}

clipboard_layer_down() {
    keysToReturn := ""
    clipboardLeader := True
    clipboardDownNoUp := True
    isClipboardLayerPress := True
    lastClipboardLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

clipboard_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastClipboardLayerPress > changedMindThreshold) {
        clipboardLeader := False
    }
    clipboardDownNoUp := False
    isClipboardLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_clipboard_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastFuncLayerPress < doubleTapThreshold) {
        return escape()
    }
    else {
        clipboardLeader := False
    }
    return hotstring_neutral_key(keysToReturn)
}

shift_nav_layer_down() {
    keysToReturn := ""
    shiftNavLeader := True
    shiftNavDownNoUp := True
    isShiftNavLayerPress := True
    lastNavLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

shift_nav_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastShiftNavLayerPress > changedMindThreshold) {
        shiftNavLeader := False
    }
    shiftNavDownNoUp := False
    isShiftNavLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_shift_nav_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastShiftNavLayerPress < doubleTapThreshold) {
        shiftNavLocked := True
    }
    else {
        shiftNavLeader := False
        shiftNavLocked := False
    }
    return hotstring_neutral_key(keysToReturn)
}

nav_layer_down() {
    keysToReturn := ""
    navLeader := True
    navDownNoUp := True
    navFirst := True
    isNavLayerPress := True
    lastNavLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

nav_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastNavLayerPress > changedMindThreshold) {
        navLeader := False
    }
    navDownNoUp := False
    isNavLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_nav_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastNavLayerPress < doubleTapThreshold) {
        navFirst := False
        navLocked := True
    }
    else {
        navLeader := False
        navLocked := False
    }
    return hotstring_neutral_key(keysToReturn)
}

num_layer_down() {
    keysToReturn := ""
    numLeader := True
    numDownNoUp := True
    numFirst := True
    isNumLayerPress := True
    lastNumLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

num_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastNumLayerPress > changedMindThreshold) {
        numLeader := False
    }
    numDownNoUp := False
    isNumLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_num_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastNumLayerPress < doubleTapThreshold) {
        numFirst := False
        numLocked := True
    }
    else {
        numLeader := False
        numLocked := False
    }
    return hotstring_neutral_key(keysToReturn)
}

shift_layer_down() {
    keysToReturn := ""
    shiftLeader := True
    shiftDownNoUp := True
    shiftFirst := True
    isShiftLayerPress := True
    lastShiftLayerPress := A_TickCount
    return hotstring_neutral_key(keysToReturn)
}

shift_layer_up() {
    keysToReturn := ""
    currentTime := A_TickCount
    if(currentTime - lastShiftLayerPress > changedMindThreshold) {
        shiftLeader := False
    }
    shiftDownNoUp := False
    isShiftLayerPress := False
    return hotstring_neutral_key(keysToReturn)
}

double_press_shift_layer() {
    keysToReturn := ""
    currentTime := A_TickCount
    if (currentTime - lastShiftLayerPress < doubleTapThreshold) {
        shiftFirst := False
        shiftLocked := True
    }
    else {
        shiftLeader := False
        shiftLocked := False
    }
    return hotstring_neutral_key(keysToReturn)
}

; Modifiers
;-------------------------------------------------

mod_control() {
    keysToReturn := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
}

mod_alt() {
    keysToReturn := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
}

mod_shift() {
    keysToReturn := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
}

; Actions
;-------------------------------------------------

; #NotTemplateKey
; #CustomCharacterNotCustomAction
enter() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Enter}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        sentKeysStackLength := sentKeysStack.Length()
        oneKeyBack := ""
        if(sentKeysStackLength >= 1) {
            oneKeyBack := sentKeysStack[sentKeysStackLength]
        }
        if(autospacing = "autospaced") {
            autospacing := "cap-autospaced"
            keysToReturn := "{Backspace}" . "{Enter}"
            undoKeys := "{Backspace}{Space}"
        }
        else if(autospacing = "cap-autospaced") {
            if(oneKeyBack = "{Enter}") {
                keysToReturn := "{Enter}"
                undoKeys := "{Backspace}"
            }
            else { ; oneKeyBack != "{Enter}", so not multiple Enters in a row. Would happen after .?!
                keysToReturn := "{Backspace}" . "{Enter}"
                undoKeys := "{Backspace}{Space}"
            }
        }
        else {
            autospacing := "cap-autospaced"
            keysToReturn := "{Enter}"
            undoKeys := "{Backspace}"
        }

        ; Clears certain microstates
        inRawMicrostate := False

        return hotstring_trigger_delimiter_key_tracked("{Enter}", keysToReturn, undoKeys)
    }
}

; #NotTemplateKey
tab() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Tab}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        ; Clears certain microstates
        inRawMicrostate := False

        keysToReturn := "{Tab}"
        return hotstring_neutral_key(keysToReturn)
    }
}

; #NotTemplateKey
shift_tab() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Tab}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        ; Clears certain microstates
        inRawMicrostate := False

        keysToReturn := "+{Tab}"
        return hotstring_neutral_key(keysToReturn)
    }
}

left() {
    return modifiable_hotstring_trigger_action_key("{Left}")
}

shift_left() {
    return modifiable_hotstring_trigger_shift_action_key("{Left}")
}

up() {
    return modifiable_hotstring_trigger_action_key("{Up}")
}

shift_up() {
    return modifiable_hotstring_trigger_shift_action_key("{Up}")
}

down() {
    return modifiable_hotstring_trigger_action_key("{Down}")
}

shift_down() {
    return modifiable_hotstring_trigger_shift_action_key("{Down}")
}

right() {
    return modifiable_hotstring_trigger_action_key("{Right}")
}

shift_right() {
    return modifiable_hotstring_trigger_shift_action_key("{Right}")
}

home() {
    return modifiable_hotstring_trigger_action_key("{Home}")
}

shift_home() {
    return modifiable_hotstring_trigger_shift_action_key("{Home}")
}

page_up() {
    return modifiable_hotstring_trigger_action_key("{PgUp}")
}

page_down() {
    return modifiable_hotstring_trigger_action_key("{PgDn}")
}

end() {
    return modifiable_hotstring_trigger_action_key("{End}")
}

shift_end() {
    return modifiable_hotstring_trigger_shift_action_key("{End}")
}

; #NotTemplateKey
; TODO: handle behavior when using colon as semicolon too
; TODO: make work with matchedPairStack
backspace() {
    keysToReturn := ""
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Backspace}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else if(pressesLeftUntilJump = 1) { 
        pressesLeftUntilJump := pressesLeftUntilJump + 1
        keysToReturn := "{Backspace}"
    }
    else {
        if(just_starting_new_entry()) {
            keysToReturn := "{Backspace}"
        }
        else {
            keyBeingUndone := sentKeysStack.pop()

            ; The autospacing needs to be set to what it was *before* the keypress being
            ; undone
            autospacingStack.pop()
            autospacing := autospacingStack[autospacingStack.Length()]

            ; Same deal with the automatching, if we are manually automatching
            if(manuallyAutomatching) {
                automatchingStack.pop()
                automatching := automatchingStack[automatchingStack.Length()]
            }

            keysToReturn := undoSentKeysStack.pop()

            ; Deal with updating variables controlling hotstring state, so that hotstrings
            ; work perfectly, even when backspacing is involved

            ; Could alternatively check if (not is_hotstring_character(keyBeingUndone)). That is
            ; logically equivalent to currentBrief = ""
            if(currentBrief = "") {
                update_hotstring_state_based_on_current_sent_keys_stack()
            }
            else {
                StringTrimRight, currentBrief, currentBrief, 1
            }
        }
    }
    return keysToReturn
}

; In this function, we define a "word" as any character that is not {Space} or {Enter}.
; This function will undo all keypresses up to but not including the last {Space} or {Enter}.
; All {Spaces} on top of the stack will be deleted, but an {Enter} on top of the stack will
; just remove that {Enter} alone, and not do anything else. Examples:
;
; If sentKeysStack is 'one{Space}two{Enter}{Enter}', calling this function will yield 'one{Space}two{Enter}'
; If sentKeysStack is 'one{Space}two{Enter}', calling this function will yield 'one{Space}two'
; If sentKeysStack is 'one{Space}two{Space}{Space}', calling this function will yield 'one{Space}'
; If sentKeysStack is 'one{Space}two{Space}', calling this function will yield 'one{Space}'
; If sentKeysStack is 'one{Space}two', calling this function will yield 'one{Space}'
;
; You can replace the letters with any of the other characters that are tracked on sentKeysStack, and so 
; long as they are not {Space} or {Enter}, they are treated no differently than letters. Thus:
;
; If sentKeysStack is 'This{Space}is{Space}a{Space}sentence.', calling this function will yield 'This{Space}is{Space}a{Space}'
; If sentKeysStack is 'Is{Space}it{Space}8:00?', calling this function will yield 'Is{Space}it{Space}'
;
; There is one other special case: backspacing all spaces on a new line, those used to indent something.
; If we have backspaced one or more spaces, and then hit an {Enter}, we stop there. This will leave us
; at the beginning of the line. For example:
;
; If sentKeysStack is 'line{Space}one{Enter}{Space}{Space}', calling this function will yield 'line{Space}one{Enter}'
;
; Some programs use Control + Backspace to do something similar to what this function implements. I still favor using
; this function (as it does not behave inconsistently with non-letter characters = backspacing "through" some of them,
; yet stopping at others), and this internal function will also work in situations where Control + Backspace has been
; bound to a different action. One particularly notable example of such is Microsoft Excel, where rather than deleting
; one word back, Control + Backspace takes you back to the active cell (if you had scrolled such that it was out of view).
;
; Control + Backspace can still be accessible, just as one would expect. This function does not somehow override that
; key combination inherently, in other words. In my particular layout, I have this function mapped to the backspace key
; on my clipboard layer, and Control + Backspace (accessed through modifiers) works completely normally.
;
; In fact, if the sentKeysStack is empty (as it would be if I just jumped somewhere), this function actually sends
; Control + Backspace. (I'll handle that Excel exception later).
;
; TODO: make work with matchedPairStack
internal_backspace_by_word() {
    ; Short circuit if the sentKeysStack is empty
    if(sentKeysStack.Length() = 0) {
        return "^{Backspace}"
    }

    keysToReturn := remove_word_from_top_of_stack()

    return keysToReturn
}

delete() {
    return modifiable_hotstring_neutral_action_key("{Delete}")
}

; #NotTemplateKey
escape() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Escape}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        ; Clears certain microstates
        inRawMicrostate := False
        pressesLeftUntilJump := 0

        keysToReturn := "{Escape}"
        return hotstring_neutral_key(keysToReturn)
    }
}

insert() {
    return modifiable_hotstring_neutral_action_key("{Insert}")
}

scroll_lock() {
    return modifiable_hotstring_neutral_action_key("{ScrollLock}")
}

; Custom Actions (as used on Nav layer, etc.)
;-------------------------------------------------

jump_before() {
    return
}

jump_after() {
    return
}

jumpselect_before() {
    return
}

jumpselect_after() {
    return
}

jump_to_beginning_or_end_of_lines() {
    return
}

jumpselect_to_beginning_or_end_of_lines() {
    return
}

jump_to_word_and_select_it() {
    return
}

move_word_back() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^{Left}")
}

move_word_forward() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^{Right}")
}

move_sentence_back() {
    return
}

move_sentence_forward() {
    return
}

move_paragraph_back() {
    return
}

move_paragraph_forward() {
    return
}

move_section_back() {
    return
}

move_section_forward() {
    return
}

select_word_back() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^+{Left}")
}

select_word_forward() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^+{Right}")
}

select_sentence_back() {
    return
}

select_sentence_forward() {
    return
}

select_paragraph_back() {
    return
}

select_paragraph_forward() {
    return
}

select_section_back() {
    return
}

select_section_forward() {
    return
}

cut() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^x")
}

copy() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^c")
}

paste() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^v")
}

undo() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^z")
}

redo() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^y")
}

; Actions (to be accessed via Actions layer)
;-------------------------------------------------

; Function Keys
;-------------------------------------------------

function_F1() {
    return modifiable_hotstring_trigger_action_key("{F1}")
}

function_F2() {
    return modifiable_hotstring_trigger_action_key("{F2}")
}

function_F3() {
    return modifiable_hotstring_trigger_action_key("{F3}")
}

function_F4() {
    return modifiable_hotstring_trigger_action_key("{F4}")
}

function_F5() {
    return modifiable_hotstring_trigger_action_key("{F5}")
}

function_F6() {
    return modifiable_hotstring_trigger_action_key("{F6}")
}

function_F7() {
    return modifiable_hotstring_trigger_action_key("{F7}")
}

function_F8() {
    return modifiable_hotstring_trigger_action_key("{F8}")
}

function_F9() {
    return modifiable_hotstring_trigger_action_key("{F9}")
}

function_F10() {
    return modifiable_hotstring_trigger_action_key("{F10}")
}

function_F11() {
    return modifiable_hotstring_trigger_action_key("{F11}")
}

function_F12() {
    return modifiable_hotstring_trigger_action_key("{F12}")
}

; Media Keys
;-------------------------------------------------

decrease_brightness() {
    return
}

increase_brightness() {
    return
}

decrease_volume() {
    return
}

increase_volume() {
    return
}

mute() {
    return
}

play_pause() {
    return
}

rewind() {
    return
}

fastforward() {
    return
}

; Normal ASCII Keys
;-------------------------------------------------

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; ASCII 32 (base 10)
space() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo("{Space}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        sentKeysStackLength := sentKeysStack.Length()
        oneKeyBack := ""
        if(sentKeysStackLength >= 1) {
            oneKeyBack := sentKeysStack[sentKeysStackLength]
        }

        ; To prevent typos, if you press Space after something 
        ; that has been autospaced, just do nothing. Capitalization
        ; is passed through. We do want to allow for multiple spaces
        ; in a row, however, so there is a special case for that. There
        ; is also a special case for {Enter}, so that we can add spaces
        ; at the beginning of lines
        if(autospacing = "autospaced") {
            ; We have to use what is essentially the "pressedKeysStack"
            ; (not that I actually track that) here, since we don't actually
            ; actually add {Space} to the sentKeysStack in the case that we
            ; are "eating" the press to prevent typos. But we still need some way
            ; to check if the last key we pressed (even if it wasn't sent) was
            ; {Space}, to properly handle this conditional case.
            lastTriggeredHotkey := A_PriorHotkey
            if(lastTriggeredHotkey = "*Space") {
                keysToReturn := "{Space}"
                undoKeys := "{Backspace}"
            }
            else { ; lastTriggeredHotkey != "*Space", so not multiple spaces in a row
                return hotstring_neutral_key("")
            }
        }
        ; We always pass through cap autospacing. We just don't do anything unless
        ; we are adding spaces to the beginning of a new line
        else if(autospacing = "cap-autospaced") {
            lastTriggeredHotkey := A_PriorHotkey
            if(oneKeyBack = "{Enter}" or lastTriggeredHotkey = "*Space") {
                keysToReturn := "{Space}"
                undoKeys := "{Backspace}"
            }
            else {
                return hotstring_neutral_key("")
            }
        }
        else {
            autospacing := "autospaced"
            keysToReturn := "{Space}"
            undoKeys := "{Backspace}"
        }
        return hotstring_trigger_delimiter_key_tracked("{Space}", keysToReturn, undoKeys)
    }
}

; ASCII 33 (base 10)
exclamation_mark() {
    if(prose_mode_should_be_active()) {
        return cap_punctuation_key("{!}", False)
    }
    ; Used sometimes as a postfix when defining parameters in Typescript.
    ; Otherwise mostly used in !=, which is consistent across many programming languages
    else { ; Code mode is active
        return normal_key("{!}", False)
    }
}

; ASCII 34 (base 10)
quotes() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("""", """", False)
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("""", False)
    }
}

; ASCII 35 (base 10)
number_sign() {
    return normal_key("{#}", False)
}

; ASCII 36 (base 10)
dollar_sign() {
    if(prose_mode_should_be_active()) {
        return space_before_key("$", False)
    }
    ; Not used in coding much at all, unless you write lots of Bash and Perl...
    else { ; Code mode is active
        return normal_key("$", False)
    }
}

; ASCII 37 (base 10)
percent_sign() {
    if(prose_mode_should_be_active()) {
        return space_after_key("%", False)
    }
    ; Can't autospace % (mod operator but also normal %). Also can't autospace
    ; - (kabob-casing), <> (HTML tags), & (when used in HTML like &nbsp;), etc.
    ; So just don't autospace operators to be consistent
    else { ; Code mode is active
        return normal_key("%", False)
    }
}

; ASCII 38 (base 10)
ampersand() {
    if(prose_mode_should_be_active()) {
        return space_before_and_after_key("&", False)
    }
    ; Can't autospace & (AND operator, but also used in HTML like &nbsp;). 
    ; Also can't autospace - (kabob-casing), <> (HTML tags), etc. So 
    ; just don't autospace operators to be consistent
    else { ; Code mode is active
        return normal_key("&", False)
    }
}

; ASCII 39 (base 10)
apostrophe() {
    return normal_key("'")
}

single_quotes() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("'", "'", False)
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("'", False)
    }
}

; ASCII 40 (base 10)
open_parenthesis() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("(", ")", False)
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("(", False)
    }
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; ASCII 41 (base 10)
; Functions similarly in prose and code input modes.
; Just lacks the trailing {Space} and autospacing in code mode
close_parenthesis() {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(")", False)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(")")
    }
    else {
        if(manuallyAutomatching) {
            return close_parenthesis_manual_automatching() 
        }
        else {
            return close_parenthesis_instant_automatching()
        }
    }
}

close_parenthesis_instant_automatching() {
    if(prose_mode_should_be_active()) {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keysToReturn := "{Backspace}" . "{Right}" . "{Space}"
            undoKeys := "{Backspace}{Left}{Space}"
        }
        ; Pass through capitalization
        else if (autospacing = "cap-autospaced") {
            keysToReturn := "{Backspace}" . "{Right}" . "{Space}"
            undoKeys := "{Backspace}{Left}{Space}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keysToReturn := "{Right}" . "{Space}"
            undoKeys := "{Backspace}{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keysToReturn, undoKeys)
    }
    else { ; Code mode is active
        keysToReturn := ""
        undoKeys := ""
        autospacing := "not-autospaced"
        if(clipboardLeader) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
        }
        else {
            keysToReturn := "{Right}"
            undoKeys := "{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keysToReturn, undoKeys)
    }
}

close_parenthesis_manual_automatching() {
    if(prose_mode_should_be_active()) {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
        }
        else {
            StringRight, closingCharacter, automatching, 1
            StringTrimRight, automatching, automatching, 1
            if(autospacing = "autospaced") {
                keysToReturn := "{Backspace}" . closingCharacter . "{Space}"
                undoKeys := "{Backspace 2}{Space}"
            }
            ; Pass through capitalization
            else if (autospacing = "cap-autospaced") {
                keysToReturn := "{Backspace}" . closingCharacter . "{Space}"
                undoKeys := "{Backspace 2}{Space}"
            }
            else { ; autospacing = "not-autospaced"
                autospacing := "autospaced"
                keysToReturn := closingCharacter . "{Space}"
                undoKeys := "{Backspace 2}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(")", keysToReturn, undoKeys)
    }
    else { ; Code mode is active
        keysToReturn := ""
        undoKeys := ""
        autospacing := "not-autospaced"
        if(clipboardLeader) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := ")"
            undoKeys := "{Backspace}"
        }
        else {
            keysToReturn := "{Right}"
            undoKeys := "{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keysToReturn, undoKeys)
    }
}

; ASCII 42 (base 10)
asterisk() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("*", "*", False)
    }
    ; Can't autospace * (used to denote pointers in C and C++). 
    ; Also can't autospace - (kabob-casing), <> (HTML tags), etc. So 
    ; just don't autospace operators to be consistent
    else { ; Code mode is active
        return normal_key("*", False)
    }
}

; ASCII 43 (base 10)
plus_sign() {
    if(prose_mode_should_be_active()) {
        return space_before_and_after_key("{+}", False)
    }
    ; Could probably autospace +, but can't autospace - (kabob-casing), <> (HTML tags), 
    ; & (when used in HTML like &nbsp;), etc. So just don't autospace operators
    ; to be consistent
    else { ; Code mode is active
        return normal_key("{+}", False)
    }
}

; ASCII 44 (base 10)
comma() {
    ; Autospaces in code too. One of the few thinbgs to do so
    return no_cap_punctuation_key(",")
}

; ASCII 45 (base 10)
hyphen() {
    if(prose_mode_should_be_active()) {
        return inactive_delimiter_key_except_between_numbers("-")
    }
    else { ; Code mode is active
        ; We can't autospace - (minus), since it is used all the time
        ; in kabob-case for URLs and file paths
        return inactive_delimiter_key("-")
    }
}

; ASCII 46 (base 10)
period() {
    if(prose_mode_should_be_active()) {

        sentKeysStackLength := sentKeysStack.Length()
        oneKeyBack := ""
        if(sentKeysStackLength >= 1) {
            oneKeyBack := sentKeysStack[sentKeysStackLength]
        }

        ; Multiple consecutive presses = transform into ellipsis *without* capitalization
        if(oneKeyBack = ".") {
            autospacing := "autospaced"
            keysToReturn := "{Backspace}" . "." . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
            return hotstring_trigger_delimiter_key_tracked(".", keysToReturn, undoKeys)
        }
        ; Otherwise, is just normal period
        else {
            return cap_punctuation_key(".")
        }
    }
    ; Becomes dot operator in code
    else { ; Code mode is active
        return normal_key(".")
    }
}

; ASCII 47 (base 10)
back_slash() {
    if(prose_mode_should_be_active()) {
        return normal_key_except_between_numbers("/")
    }
    else { ; Code mode is active
        ; We can't autospace / (division), since it is used all the time
        ; in URLs and file paths
        return normal_key("/")
    }
}

; ASCII 48 (base 10)
zero() {
    if(prose_mode_should_be_active()) {
        return number_key("0")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("0")
    }
}

; ASCII 49 (base 10)
one() {
    if(prose_mode_should_be_active()) {
        return number_key("1")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("1")
    }
}

; ASCII 50 (base 10)
two() {
    if(prose_mode_should_be_active()) {
        return number_key("2")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("2")
    }
}

; ASCII 51 (base 10)
three() {
    if(prose_mode_should_be_active()) {
        return number_key("3")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("3")
    }
}

; ASCII 52 (base 10)
four() {
    if(prose_mode_should_be_active()) {
        return number_key("4")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("4")
    }
}

; ASCII 53 (base 10)
five() {
    if(prose_mode_should_be_active()) {
        return number_key("5")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("5")
    }
}

; ASCII 54 (base 10)
six() {
    if(prose_mode_should_be_active()) {
        return number_key("6")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("6")
    }
}

; ASCII 55 (base 10)
seven() {
    if(prose_mode_should_be_active()) {
        return number_key("7")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("7")
    }
}

; ASCII 56 (base 10)
eight() {
    if(prose_mode_should_be_active()) {
        return number_key("8")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("8")
    }
}

; ASCII 57 (base 10)
nine() {
    if(prose_mode_should_be_active()) {
        return number_key("9")
    }
    ; Numbers are not autospaced in code
    else { ; Code mode is active
        return normal_key("9")
    }
}

; ASCII 58 (base 10)
colon() {
    ; Behaves like ; in mod combinations. ; cannot be used
    ; with modifiers on this layout because it is on the
    ; shift layer itself. This is a clean workaround, since
    ; : is never itself used in combinations since it
    ; is a shifted key on QWERTY

    if(prose_mode_should_be_active()) {
        return no_cap_punctuation_key_specify_mod_char(":", ";")
    }
    ; Autospaces in code too. One of the few thinbgs to do so.
    ; Used for properties in CSS, and also used a lot in JSON.
    ; Also used for declaring types in Typescript
    else { ; Code mode is active
        return no_cap_punctuation_key_specify_mod_char(":", ";")
    }
}

; ASCII 59 (base 10)
semicolon() {
    if(prose_mode_should_be_active()) {
        return no_cap_punctuation_key(";")
    }
    ; Used to terminate statements in languages with C-like syntax
    ; Doesn't need to be autospaced to do such
    else { ; Code mode is active
        return normal_key(";")
    }
}

; ASCII 60 (base 10)
less_than() {
    ; Let editors handle auto-pairing when in HTML etc. files
    ; Can't autospace as an operator since it is also used
    ; for tags in HTML and XML, components in Angular, etc.
    return normal_key("<", False)
}

; TODO: handle with ! before it for not equals, and : after it (AutoHotkey)
; Also ==, <=, >= ?
; ASCII 61 (base 10)
equal_sign() {
    return space_before_and_after_key("=")
}

; ASCII 62 (base 10)
greater_than() {
    ; Used for block quotes in Markdown
    if(prose_mode_should_be_active()) {
        return space_after_key(">", False)
    }
    ; Can't autospace as an operator since it is also used
    ; for tags in HTML and XML, components in Angular, etc.
    else { ; Code mode is active
        return normal_key(">", False)
    }
}

; ASCII 63 (base 10)
question_mark() {
    if(prose_mode_should_be_active()) {
        return cap_punctuation_key("?", False)
    }
    ; Used as a null indicator in some programming languages,
    ; and is also used as part of the syntax for ternary operator
    ; in some programming languages
    else { ; Code mode is active
        return normal_key("?", False)
    }
}

; ASCII 64 (base 10)
at_sign() {
    return inactive_delimiter_key("@", False)
}

; ASCII 65 (base 10)
capital_A() {
    return uppercase_letter_key("A")
}

; ASCII 66 (base 10)
capital_B() {
    return uppercase_letter_key("B")
}

; ASCII 67 (base 10)
capital_C() {
    return uppercase_letter_key("C")
}

; ASCII 68 (base 10)
capital_D() {
    return uppercase_letter_key("D")
}

; ASCII 69 (base 10)
capital_E() {
    return uppercase_letter_key("E")
}

; ASCII 70 (base 10)
capital_F() {
    return uppercase_letter_key("F")
}

; ASCII 71 (base 10)
capital_G() {
    return uppercase_letter_key("G")
}

; ASCII 72 (base 10)
capital_H() {
    return uppercase_letter_key("H")
}

; ASCII 73 (base 10)
capital_I() {
    return uppercase_letter_key("I")
}

; ASCII 74 (base 10)
capital_J() {
    return uppercase_letter_key("J")
}

; ASCII 75 (base 10)
capital_K() {
    return uppercase_letter_key("K")
}

; ASCII 76 (base 10)
capital_L() {
    return uppercase_letter_key("L")
}

; ASCII 77 (base 10)
capital_M() {
    return uppercase_letter_key("M")
}

; ASCII 78 (base 10)
capital_N() {
    return uppercase_letter_key("N")
}

; ASCII 79 (base 10)
capital_O() {
    return uppercase_letter_key("O")
}

; ASCII 80 (base 10)
capital_P() {
    return uppercase_letter_key("P")
}

; ASCII 81 (base 10)
capital_Q() {
    return uppercase_letter_key("Q")
}

; ASCII 82 (base 10)
capital_R() {
    return uppercase_letter_key("R")
}

; ASCII 83 (base 10)
capital_S() {
    return uppercase_letter_key("S")
}

; ASCII 84 (base 10)
capital_T() {
    return uppercase_letter_key("T")
}

; ASCII 85 (base 10)
capital_U() {
    return uppercase_letter_key("U")
}

; ASCII 86 (base 10)
capital_V() {
    return uppercase_letter_key("V")
}

; ASCII 87 (base 10)
capital_W() {
    return uppercase_letter_key("W")
}

; ASCII 88 (base 10)
capital_X() {
    return uppercase_letter_key("X")
}

; ASCII 89 (base 10)
capital_Y() {
    return uppercase_letter_key("Y")
}

; ASCII 90 (base 10)
capital_Z() {
    return uppercase_letter_key("Z")
}

; ASCII 91 (base 10)
open_bracket() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("[", "]")
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("[")
    }
}

; ASCII 92 (base 10)
forward_slash() {
    ; Used in Windows file paths, and also for escaping things
    ; (be that in regular expressions or otherwise)
    return inactive_delimiter_key("\")
}

; ASCII 93 (base 10)
close_bracket() {
    ; Not used much, since I use the base-layer ) key
    ; to "close" auto-paired things
    return normal_key("]")
}

; ASCII 94 (base 10)
caret() {
    ; Could probably autospace ^, but can't autospace - (kabob-casing), <> (HTML tags), 
    ; & (when used in HTML like &nbsp;), etc. So just don't autospace operators
    ; to be consistent
    return normal_key("{^}", False)
}

; ASCII 95 (base 10)
underscore() {
    ; Used in the names of variables and constants in many programming languages
    return inactive_delimiter_key("_", False)
}

; ASCII 96 (base 10)
backtick() {
    ; Used in Markdown for inline code
    if(prose_mode_should_be_active()) {
        return matched_pair_key("``", "``")
    }
    ; Not used much at all
    else { ; Code mode is active
        return normal_key("``")
    }
}

; ASCII 97 (base 10)
lowercase_a() {
    return lowercase_letter_key("a", "A")
}

; ASCII 98 (base 10)
lowercase_b() {
    return lowercase_letter_key("b", "B")
}

; ASCII 99 (base 10)
lowercase_c() {
    return lowercase_letter_key("c", "C")
}

; ASCII 100 (base 10)
lowercase_d() {
    return lowercase_letter_key("d", "D")
}

; ASCII 101 (base 10)
lowercase_e() {
    return lowercase_letter_key("e", "E")
}

; ASCII 102 (base 10)
lowercase_f() {
    return lowercase_letter_key("f", "F")
}

; ASCII 103 (base 10)
lowercase_g() {
    return lowercase_letter_key("g", "G")
}

; ASCII 104 (base 10)
lowercase_h() {
    return lowercase_letter_key("h", "H")
}

; ASCII 105 (base 10)
lowercase_i() {
    return lowercase_letter_key("i", "I")
}

; ASCII 106 (base 10)
lowercase_j() {
    return lowercase_letter_key("j", "J")
}

; ASCII 107 (base 10)
lowercase_k() {
    return lowercase_letter_key("k", "K")
}

; ASCII 108 (base 10)
lowercase_l() {
    return lowercase_letter_key("l", "L")
}

; ASCII 109 (base 10)
lowercase_m() {
    return lowercase_letter_key("m", "M")
}

; ASCII 110 (base 10)
lowercase_n() {
    return lowercase_letter_key("n", "N")
}

; ASCII 111 (base 10)
lowercase_o() {
    return lowercase_letter_key("o", "O")
}

; ASCII 112 (base 10)
lowercase_p() {
    return lowercase_letter_key("p", "P")
}

; ASCII 113 (base 10)
lowercase_q() {
    return lowercase_letter_key("q", "Q")
}

; ASCII 114 (base 10)
lowercase_r() {
    return lowercase_letter_key("r", "R")
}

; ASCII 115 (base 10)
lowercase_s() {
    return lowercase_letter_key("s", "S")
}

; ASCII 116 (base 10)
lowercase_t() {
    return lowercase_letter_key("t", "T")
}

; ASCII 117 (base 10)
lowercase_u() {
    return lowercase_letter_key("u", "U")
}

; ASCII 118 (base 10)
lowercase_v() {
    return lowercase_letter_key("v", "V")
}

; ASCII 119 (base 10)
lowercase_w() {
    return lowercase_letter_key("w", "W")
}

; ASCII 120 (base 10)
lowercase_x() {
    return lowercase_letter_key("x", "X")
}

; ASCII 121 (base 10)
lowercase_y() {
    return lowercase_letter_key("y", "Y")
}

; ASCII 122 (base 10)
lowercase_z() {
    return lowercase_letter_key("z", "Z")
}

; ASCII 123 (base 10)
open_brace() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("{{}", "{}}", False)
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("{{}", False)
    }
}

; ASCII 124 (base 10)
pipe() {
    if(prose_mode_should_be_active()) {
        return space_before_and_after_key("|", False)
    }
    ; Could probably autospace |, but can't autospace - (kabob-casing), <> (HTML tags), 
    ; & (when used in HTML like &nbsp;), etc. So just don't autospace operators
    ; to be consistent
    else { ; Code mode is active
        return normal_key("|", False)
    }
}

; ASCII 125 (base 10)
close_brace() {
    ; Not used much, since I use the base-layer ) key
    ; to "close" auto-paired things
    return normal_key("{}}", False)
}

; ASCII 126 (base 10)
tilde() {
    ; Used primarily for showing approximation, like "He'll be here in ~30 minutes"
    ; A different thing on the function layer handles ~~strikethrough~~ text in Markdown
    if(prose_mode_should_be_active()) {
        return space_before_key("~", False)
    }
    ; Not used much at all
    else { ; Code mode is active
        return normal_key("~", False)
    }
}

; Slide Breaks, Markdown Headers, Etc.
;-------------------------------------------------

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
slide_break() {
    keysToReturn := "{Enter 2}" . "<!-- --- -->"
    return keysToReturn
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
notes_slide_break() {
    keysToReturn := "{Enter 2}" . "<!-- ??? -->"
    return keysToReturn 
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
webcam_break() {
    keysToReturn := "{Enter 2}" . "<!-- webcam -->"
    return keysToReturn
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
screen_recording_break() {
    keysToReturn := "{Enter 2}" . "<!-- screen -->"
    return keysToReturn
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h1_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{#}" . "{Space}"
    undoKeys := "{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("h1", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h2_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{# 2}" . "{Space}"
    undoKeys := "{Backspace 3}"
    return hotstring_trigger_delimiter_key_tracked("h2", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h3_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{# 3}" . "{Space}"
    undoKeys := "{Backspace 4}"
    return hotstring_trigger_delimiter_key_tracked("h3", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h4_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{# 4}" . "{Space}"
    undoKeys := "{Backspace 5}"
    return hotstring_trigger_delimiter_key_tracked("h4", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h5_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{# 5}" . "{Space}"
    undoKeys := "{Backspace 6}"
    return hotstring_trigger_delimiter_key_tracked("h5", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h6_header() {
    autospacing := "cap-autospaced"
    keysToReturn := "{# 6}" . "{Space}"
    undoKeys := "{Backspace 7}"
    return hotstring_trigger_delimiter_key_tracked("h6", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
strikethough() {
    ; Passes through capitalization
    keysToReturn := "~~~~" . "{Left 2}"
    undoKeys := "{Delete 2}{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("strikethrough", keysToReturn, undoKeys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
inline_latex() {
    ; Passes through capitalization right now. TODO: figure out better with code mode microstate?
    keysToReturn := "$$$$" . "{Left 2}"
    undoKeys := "{Delete 2}{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("LaTeX", keysToReturn, undoKeys)
}

; TODO
make_selected_text_link_with_clipboard_contents_as_url() {
    return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
add_footnote() {
    keysToReturn := "[^]" . "{Left}"
    return keysToReturn
}

; TODO
make_selected_text_glossary_link() {
    return
}

; Templates (to be accessed via Templates temp layer)
;-------------------------------------------------

; TODO - all the shortcodes like quote, scripture, application, etc.

; TODO - still images

; TODO: list of images (the webpage equivalent of Ken Burns effect images)

; Both still image and image sequence need to support citations being displayed where caption is

; Then when build slideshow slides, put citations at end for each of the images and Ken Burns effect slides
; Order by slide number, and link back to the slides

; Come up with citation style. The last bit of the citation should be a URL
; {*Work Title*}, {Photographer/Illustrator/etc. full name}, {URL to access} 

; Other Characters and Symbols
;-------------------------------------------------

; This one is weird since we want the character saved in
; sentKeysStack to be "dot" rather than ".", so that there
; is no confusion with period.
dot() {
    if(prose_mode_should_be_active()) {

        ; Basically, copy-paste normal_key_except_between_numbers() except
        ; use "dot" rather than "." in places, and hotstring_inactive_delimiter_key_tracked()
        ; rather than the hotstring triggering version.

        if(modifiersLeader or modifiersHeldDown) {
            keysToReturn := build_modifier_combo(".", canBeModified)
            return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
        }
        ; In AceJump flags, it is only ever the first press that
        ; may end up a non-letter character. This is because the 
        ; plugin uses the capitalization of the second character
        ; (always a letter) to control its jumpselecting behavior.
        else if(pressesLeftUntilJump = 2) {
            pressesLeftUntilJump := pressesLeftUntilJump - 1
            ; Always comes after jump key that clears sentKeysStack
            return hotstring_neutral_key(".")
        }
        else {
            keysToReturn := ""
            undoKeys := ""
            sentKeysStackLength := sentKeysStack.Length()
            oneKeyBack := ""
            if(sentKeysStackLength >= 1) {
                oneKeyBack := sentKeysStack[sentKeysStackLength]
            }
            if(is_number(oneKeyBack)) {
                keysToReturn := "{Backspace}" . "." . "{Space}"
                undoKeys := "{Backspace 2}{Space}"
            }
            else {
                autospacing := "not-autospaced"
                keysToReturn := "."
                undoKeys := "{Backspace}"
            }
            ; The is_number case will never trigger a hotstring, but whatever.
            ; The conditionals inside the called logic will take care of it just fine.
            return hotstring_inactive_delimiter_key_tracked("dot", keysToReturn, undoKeys)
        }
    }
    else { ; Code mode is active

        ; Basically, copy-paste normal_key(), except
        ; use "dot" rather than "." in places, and hotstring_inactive_delimiter_key_tracked()
        ; rather than the hotstring triggering version.

        if(modifiersLeader or modifiersHeldDown) {
            keysToReturn := build_modifier_combo(".", canBeModified)
            return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
        }
        ; In AceJump flags, it is only ever the first press that
        ; may end up a non-letter character. This is because the 
        ; plugin uses the capitalization of the second character
        ; (always a letter) to control its jumpselecting behavior.
        else if(pressesLeftUntilJump = 2) {
            pressesLeftUntilJump := pressesLeftUntilJump - 1
            ; Always comes after jump key that clears sentKeysStack
            return hotstring_neutral_key(".")
        }
        else {
            autospacing := "not-autospaced"
            keysToReturn := "."
            undoKeys := "{Backspace}"
            return hotstring_inactive_delimiter_key_tracked("dot", keysToReturn, undoKeys)
        }
    }
}

em_dash() {
    sentKeysStackLength := sentKeysStack.Length()
    oneKeyBack := ""
    if(sentKeysStackLength >= 1) {
        oneKeyBack := sentKeysStack[sentKeysStackLength]
    }

    ; Multiple consecutive presses = transform into ellipsis *with* capitalization
    ; This is a bit hardcoded atm, since we are here assuming em dash goes on the period key,
    ; which is true on my layout, but may not be true for arbitrary layouts. May refactor later.
    if(oneKeyBack = "—") {
        autospacing := "cap-autospaced"
        keysToReturn := "{Backspace}" . "." . "." . "{Space}"
        undoKeys := "{Backspace 3}" . "—"
        return hotstring_trigger_delimiter_key_tracked(".", keysToReturn, undoKeys)
    }
    else if(oneKeyBack = ".") {
        autospacing := "cap-autospaced"
        keysToReturn := "{Backspace}" . "." . "{Space}"
        undoKeys := "{Backspace 2}{Space}"
        return hotstring_trigger_delimiter_key_tracked(".", keysToReturn, undoKeys)
    }
    ; Otherwise, is just normal em dash
    else {
        return normal_key("—", False)
    }
}

en_dash() {
    ; Not used in code
    return space_before_and_after_key("–", False)
}

section_symbol() {
    return space_before_key("§", False)
}

copyright_symbol() {
    return normal_key("©", False)
}

registered_symbol() {
    return normal_key("®", False)
}

trademark_symbol() {
    return normal_key("™", False)
}

british_pound() {
    return space_before_key("£", False)
}

euro() {
    return space_before_key("€", False)
}

yuan() {
    return space_before_key("¥", False)
}

; Emoji Unicode Characters
;-------------------------------------------------

; https://www.brandwatch.com/blog/the-most-popular-emojis/

emoji_thumbs_up() {
    return
}

emoji_thumbs_down() {
    return
}

emoji_shrug() {
    return
}

emoji_joy() {
    return
}

emoji_sweat_smile() {
    return
}

emoji_sparkles() {
    return
}

emoji_pray() {
    return
}

emoji_heart() {
    return
}

emoji_smiling_face_with_hearts() {
    return
}

emoji_pleading_face() {
    return
}