
; TODO: what about one_key_back and two_keys_back for things that aren't single characters or actions? L ike "move one word left" (Ctrl + Left)?
; What about media keys?
; The stuff on Function layer for adding links and heasders etc, in markdown?



; Layer Keys
;-------------------------------------------------

; leaders = ["shift", "caps", "number", "command", "function", "actions"]

shift_leader() {
    leader := "shift"
    locked := "base"
    return completely_internal_key()
}

caps_leader() {
    leader := "caps"
    locked := "base"
    return completely_internal_key()
}

number_leader() {
    leader := "number"
    locked := "base"
    return completely_internal_key()
}

command_leader() {
    leader := "command"
    locked := "base"
    return completely_internal_key()
}

function_leader() {
    leader := "function"
    locked := "base"
    return completely_internal_key()
}

actions_leader() {
    leader := "actions"
    locked := "base"
    return completely_internal_key()
}

; locks = ["base", "caps", "number", "function", "actions", "selection"]

base_lock() {
    leader := ""
    locked := "base"
    return completely_internal_key()
}

caps_lock() {
    leader := ""
    locked := "caps"
    return completely_internal_key()
}

number_lock() {
    leader := ""
    locked := "number"
    return completely_internal_key()
}

function_lock() {
    leader := ""
    locked := "function"
    return completely_internal_key()
}

actions_lock() {
    leader := ""
    locked := "actions"
    return completely_internal_key()
}

selection_lock() {
    leader := ""
    locked := "selection"
    return completely_internal_key()
}

; Input State Keys
;-------------------------------------------------

toggle_prose() {
    input_state := "prose"
    return completely_internal_key()
}

toggle_code() {
    input_state := "code"
    return completely_internal_key()
}

; State Cancel Key
;-------------------------------------------------

cancel() {
    leader := ""
    locked := "base"
    raw_state := ""
    in_raw_microstate := False
    modifier_state := ""
    return completely_internal_key()
}

; Raw state Keys
;-------------------------------------------------

raw_leader() {
    raw_state = "leader"
    return completely_internal_key()
}

raw_lock() {
    raw_state = "lock"
    return completely_internal_key()
}

; Modifier State Keys
;-------------------------------------------------

mod_control_leader() {
    modifier_state := "leader"
    mod_control_down := True
    return completely_internal_key()
}

mod_alt_leader() {
    modifier_state := "leader"
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift_leader() {
    modifier_state := "leader"
    mod_shift_down := True
    return completely_internal_key()
}

mod_control_lock() {
    modifier_state := "lock"
    mod_control_down := True
    return completely_internal_key()
}

mod_alt_lock() {
    modifier_state := "lock"
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift_lock() {
    modifier_state := "lock"
    mod_shift_down := True
    return completely_internal_key()
}

mod_control() {
    mod_control_down := True
    return completely_internal_key()
}

mod_alt() {
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift() {
    mod_shift_down := True
    return completely_internal_key()
}

; Space, Backspace, Enter, Tab, Etc.
;-------------------------------------------------

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; ASCII 32 (base 10)
space() {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Space}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        if(sent_keys_stack_length >= 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }

        ; To prevent typos, if you press Space after something 
        ; that has been autospaced, just do nothing. Capitalization
        ; is passed through. We do want to allow for multiple spaces
        ; in a row, however, so there is a special case for that. There
        ; is also a special case for {Enter}, so that we can add spaces
        ; at the beginning of lines
        if(autospacing = "autospaced") {
            ; We have to use what is essentially the "pressed_keysStack"
            ; (not that I actually track that) here, since we don't actually
            ; actually add {Space} to the sent_keys_stack in the case that we
            ; are "eating" the press to prevent typos. But we still need some way
            ; to check if the last key we pressed (even if it wasn't sent) was
            ; {Space}, to properly handle this conditional case.
            last_triggered_hotkey := A_PriorHotkey
            if(last_triggered_hotkey = "*Space") {
                keys_to_return := "{Space}"
                undo_keys := "{Backspace}"
            }
            else { ; last_triggered_hotkey != "*Space", so not multiple spaces in a row
                return hotstring_neutral_key("")
            }
        }
        ; We always pass through cap autospacing. We just don't do anything unless
        ; we are adding spaces to the beginning of a new line
        else if(autospacing = "cap-autospaced") {
            last_triggered_hotkey := A_PriorHotkey
            if(one_key_back = "{Enter}" or last_triggered_hotkey = "*Space") {
                keys_to_return := "{Space}"
                undo_keys := "{Backspace}"
            }
            else {
                return hotstring_neutral_key("")
            }
        }
        else {
            autospacing := "autospaced"
            keys_to_return := "{Space}"
            undo_keys := "{Backspace}"
        }
        return hotstring_trigger_delimiter_key_tracked("{Space}", keys_to_return, undo_keys)
    }
}

; #NotTemplateKey
; TODO: handle behavior when using colon as semicolon too
; TODO: make work with matchedPairStack
backspace() {
    keys_to_return := ""
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Backspace}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else if(presses_left_until_jump = 1) { 
        presses_left_until_jump := presses_left_until_jump + 1
        keys_to_return := "{Backspace}"
    }
    else {
        if(just_starting_new_entry()) {
            keys_to_return := "{Backspace}"
        }
        else {
            key_being_undone := sent_keys_stack.pop()

            ; The autospacing needs to be set to what it was *before* the keypress being
            ; undone
            autospacing_stack.pop()
            autospacing := autospacing_stack[autospacing_stack.Length()]

            ; Same deal with the automatching, if we are manually automatching
            if(manually_automatching) {
                automatching_stack.pop()
                automatching := automatching_stack[automatching_stack.Length()]
            }

            keys_to_return := undo_sent_keys_stack.pop()

            ; Deal with updating variables controlling hotstring state, so that hotstrings
            ; work perfectly, even when backspacing is involved

            ; Could alternatively check if (not is_hotstring_character(key_being_undone)). That is
            ; logically equivalent to current_brief = ""
            if(current_brief = "") {
                update_hotstring_state_based_on_current_sent_keys_stack()
            }
            else {
                StringTrimRight, current_brief, current_brief, 1
            }
        }
    }
    return keys_to_return
}

; In this function, we define a "word" as any character that is not {Space} or {Enter}.
; This function will undo all keypresses up to but not including the last {Space} or {Enter}.
; All {Spaces} on top of the stack will be deleted, but an {Enter} on top of the stack will
; just remove that {Enter} alone, and not do anything else. Examples:
;
; If sent_keys_stack is 'one{Space}two{Enter}{Enter}', calling this function will yield 'one{Space}two{Enter}'
; If sent_keys_stack is 'one{Space}two{Enter}', calling this function will yield 'one{Space}two'
; If sent_keys_stack is 'one{Space}two{Space}{Space}', calling this function will yield 'one{Space}'
; If sent_keys_stack is 'one{Space}two{Space}', calling this function will yield 'one{Space}'
; If sent_keys_stack is 'one{Space}two', calling this function will yield 'one{Space}'
;
; You can replace the letters with any of the other characters that are tracked on sent_keys_stack, and so 
; long as they are not {Space} or {Enter}, they are treated no differently than letters. Thus:
;
; If sent_keys_stack is 'This{Space}is{Space}a{Space}sentence.', calling this function will yield 'This{Space}is{Space}a{Space}'
; If sent_keys_stack is 'Is{Space}it{Space}8:00?', calling this function will yield 'Is{Space}it{Space}'
;
; There is one other special case: backspacing all spaces on a new line, those used to indent something.
; If we have backspaced one or more spaces, and then hit an {Enter}, we stop there. This will leave us
; at the beginning of the line. For example:
;
; If sent_keys_stack is 'line{Space}one{Enter}{Space}{Space}', calling this function will yield 'line{Space}one{Enter}'
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
; In fact, if the sent_keys_stack is empty (as it would be if I just jumped somewhere), this function actually sends
; Control + Backspace. (I'll handle that Excel exception later).
;
; TODO: make work with matchedPairStack
internal_backspace_by_word() {
    ; Short circuit if the sent_keys_stack is empty
    if(sent_keys_stack.Length() = 0) {
        return "^{Backspace}"
    }

    keys_to_return := remove_word_from_top_of_stack()

    return keys_to_return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
enter() {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Enter}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        if(sent_keys_stack_length >= 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }
        if(autospacing = "autospaced") {
            autospacing := "cap-autospaced"
            keys_to_return := "{Backspace}" . "{Enter}"
            undo_keys := "{Backspace}{Space}"
        }
        else if(autospacing = "cap-autospaced") {
            if(one_key_back = "{Enter}") {
                keys_to_return := "{Enter}"
                undo_keys := "{Backspace}"
            }
            else { ; one_key_back != "{Enter}", so not multiple Enters in a row. Would happen after .?!
                keys_to_return := "{Backspace}" . "{Enter}"
                undo_keys := "{Backspace}{Space}"
            }
        }
        else {
            autospacing := "cap-autospaced"
            keys_to_return := "{Enter}"
            undo_keys := "{Backspace}"
        }

        ; Clears certain microstates
        in_raw_microstate := False

        return hotstring_trigger_delimiter_key_tracked("{Enter}", keys_to_return, undo_keys)
    }
}

; #NotTemplateKey
tab() {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Tab}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; Clears certain microstates
        in_raw_microstate := False

        keys_to_return := "{Tab}"
        return hotstring_neutral_key(keys_to_return)
    }
}


; Lowercase Letters
;-------------------------------------------------

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



; Uppercase Letters
;-------------------------------------------------

; ASCII 65 (base 10)
uppercase_a() {
    return uppercase_letter_key("A")
}

; ASCII 66 (base 10)
uppercase_b() {
    return uppercase_letter_key("B")
}

; ASCII 67 (base 10)
uppercase_c() {
    return uppercase_letter_key("C")
}

; ASCII 68 (base 10)
uppercase_d() {
    return uppercase_letter_key("D")
}

; ASCII 69 (base 10)
uppercase_e() {
    return uppercase_letter_key("E")
}

; ASCII 70 (base 10)
uppercase_f() {
    return uppercase_letter_key("F")
}

; ASCII 71 (base 10)
uppercase_g() {
    return uppercase_letter_key("G")
}

; ASCII 72 (base 10)
uppercase_h() {
    return uppercase_letter_key("H")
}

; ASCII 73 (base 10)
uppercase_i() {
    return uppercase_letter_key("I")
}

; ASCII 74 (base 10)
uppercase_j() {
    return uppercase_letter_key("J")
}

; ASCII 75 (base 10)
uppercase_k() {
    return uppercase_letter_key("K")
}

; ASCII 76 (base 10)
uppercase_l() {
    return uppercase_letter_key("L")
}

; ASCII 77 (base 10)
uppercase_m() {
    return uppercase_letter_key("M")
}

; ASCII 78 (base 10)
uppercase_n() {
    return uppercase_letter_key("N")
}

; ASCII 79 (base 10)
uppercase_o() {
    return uppercase_letter_key("O")
}

; ASCII 80 (base 10)
uppercase_p() {
    return uppercase_letter_key("P")
}

; ASCII 81 (base 10)
uppercase_q() {
    return uppercase_letter_key("Q")
}

; ASCII 82 (base 10)
uppercase_r() {
    return uppercase_letter_key("R")
}

; ASCII 83 (base 10)
uppercase_s() {
    return uppercase_letter_key("S")
}

; ASCII 84 (base 10)
uppercase_t() {
    return uppercase_letter_key("T")
}

; ASCII 85 (base 10)
uppercase_u() {
    return uppercase_letter_key("U")
}

; ASCII 86 (base 10)
uppercase_v() {
    return uppercase_letter_key("V")
}

; ASCII 87 (base 10)
uppercase_w() {
    return uppercase_letter_key("W")
}

; ASCII 88 (base 10)
uppercase_x() {
    return uppercase_letter_key("X")
}

; ASCII 89 (base 10)
uppercase_y() {
    return uppercase_letter_key("Y")
}

; ASCII 90 (base 10)
uppercase_z() {
    return uppercase_letter_key("Z")
}

; Punctuation
;-------------------------------------------------

; ASCII 44 (base 10)
comma() {
    ; Autospaces in code too. One of the few things to do so
    return no_cap_punctuation_key(",")
}

; ASCII 59 (base 10)
semicolon() {
    if(prose_mode_should_be_active()) {
        return no_cap_punctuation_key(";")
    }
    ; Autospaces in code too. One of the few things to do so.
    else { ; Code mode is active
        return no_cap_punctuation_key(";")
    }
}

; ASCII 58 (base 10)
colon() {
    if(prose_mode_should_be_active()) {
        return no_cap_punctuation_key(":", False)
    }
    ; Autospaces in code too. One of the few thinbgs to do so.
    ; Used for properties in CSS, and also used a lot in JSON.
    ; Also used for declaring types in Typescript
    else { ; Code mode is active
        return no_cap_punctuation_key(":", False)
    }
}

; ASCII 46 (base 10)
period() {
    if(prose_mode_should_be_active()) {

        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        if(sent_keys_stack_length >= 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }

        ; Multiple consecutive presses = transform into ellipsis *without* capitalization
        if(one_key_back = ".") {
            autospacing := "autospaced"
            keys_to_return := "{Backspace}" . "." . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
            return hotstring_trigger_delimiter_key_tracked(".", keys_to_return, undo_keys)
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
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(")", False)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(")")
    }
    else {
        if(manually_automatching) {
            return close_parenthesis_manual_automatching() 
        }
        else {
            return close_parenthesis_instant_automatching()
        }
    }
}

close_parenthesis_instant_automatching() {
    if(prose_mode_should_be_active()) {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keys_to_return := "{Backspace}" . "{Right}" . "{Space}"
            undo_keys := "{Backspace}{Left}{Space}"
        }
        ; Pass through capitalization
        else if (autospacing = "cap-autospaced") {
            keys_to_return := "{Backspace}" . "{Right}" . "{Space}"
            undo_keys := "{Backspace}{Left}{Space}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keys_to_return := "{Right}" . "{Space}"
            undo_keys := "{Backspace}{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keys_to_return, undo_keys)
    }
    else { ; Code mode is active
        keys_to_return := ""
        undo_keys := ""
        autospacing := "not-autospaced"
        if(raw_state == "leader") {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
        }
        else {
            keys_to_return := "{Right}"
            undo_keys := "{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keys_to_return, undo_keys)
    }
}

close_parenthesis_manual_automatching() {
    if(prose_mode_should_be_active()) {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
        }
        else {
            StringRight, closing_character, automatching, 1
            StringTrimRight, automatching, automatching, 1
            if(autospacing = "autospaced") {
                keys_to_return := "{Backspace}" . closing_character . "{Space}"
                undo_keys := "{Backspace 2}{Space}"
            }
            ; Pass through capitalization
            else if (autospacing = "cap-autospaced") {
                keys_to_return := "{Backspace}" . closing_character . "{Space}"
                undo_keys := "{Backspace 2}{Space}"
            }
            else { ; autospacing = "not-autospaced"
                autospacing := "autospaced"
                keys_to_return := closing_character . "{Space}"
                undo_keys := "{Backspace 2}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(")", keys_to_return, undo_keys)
    }
    else { ; Code mode is active
        keys_to_return := ""
        undo_keys := ""
        autospacing := "not-autospaced"
        if(raw_state == "leader") {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := ")"
            undo_keys := "{Backspace}"
        }
        else {
            keys_to_return := "{Right}"
            undo_keys := "{Left}"
        }
        return hotstring_trigger_delimiter_key_tracked(")", keys_to_return, undo_keys)
    }
}

; ASCII 91 (base 10)
open_bracket() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("[", "]")
    }
    ; Let editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("[", True)
    }
}

; ASCII 93 (base 10)
close_bracket() {
    ; Not used much, since I use the base-layer ) key
    ; to "close" auto-paired things
    return normal_key("]", True)
}

; Numbers
;-------------------------------------------------

; ASCII 48 (base 10)
zero() {
    return new_number_key("0")
}

; ASCII 49 (base 10)
one() {
    return new_number_key("1")
}

; ASCII 50 (base 10)
two() {
    return new_number_key("2")
}

; ASCII 51 (base 10)
three() {
    return new_number_key("3")
}

; ASCII 52 (base 10)
four() {
    return new_number_key("4")
}

; ASCII 53 (base 10)
five() {
    return new_number_key("5")
}

; ASCII 54 (base 10)
six() {
    return new_number_key("6")
}

; ASCII 55 (base 10)
seven() {
    return new_number_key("7")
}

; ASCII 56 (base 10)
eight() {
    return new_number_key("8")
}

; ASCII 57 (base 10)
nine() {
    return new_number_key("9")
}

; Symbols / Remaining Characters
;-------------------------------------------------


; Number Lock Keys
;-------------------------------------------------

number_lock_zero() {
    if(locked != "number") {
        locked := "number"
    }
    zero()
}

number_lock_one() {
    if(locked != "number") {
        locked := "number"
    }
    one()
}

number_lock_two() {
    if(locked != "number") {
        locked := "number"
    }
    two()
}

number_lock_three() {
    if(locked != "number") {
        locked := "number"
    }
    three()
}

number_lock_four() {
    if(locked != "number") {
        locked := "number"
    }
    four()
}

number_lock_five() {
    if(locked != "number") {
        locked := "number"
    }
    five()
}

number_lock_six() {
    if(locked != "number") {
        locked := "number"
    }
    six()
}

number_lock_seven() {
    if(locked != "number") {
        locked := "number"
    }
    seven()
}

number_lock_eight() {
    if(locked != "number") {
        locked := "number"
    }
    eight()
}

number_lock_nine() {
    if(locked != "number") {
        locked := "number"
    }
    nine()
}

number_lock_colon() {
    return normal_key(":", False)
}

number_lock_en_dash() {
    return normal_key("–", False)
}


; Caps Lock
;-------------------------------------------------



; Actions
;-------------------------------------------------

; Normal Mode Keys

append_after() {
    locked := "base"
    return completely_internal_key()
}

insert_before() {
    locked := "base"
    return completely_internal_key()
}

; Selection
;-------------------------------------------------












; This one is weird since we want the character saved in
; sent_keys_stack to be "dot" rather than ".", so that there
; is no confusion with period.
dot() {
    if(prose_mode_should_be_active()) {

        ; Basically, copy-paste normal_key_except_between_numbers() except
        ; use "dot" rather than "." in places, and hotstring_inactive_delimiter_key_tracked()
        ; rather than the hotstring triggering version.

        if(modifier_state == "leader" || modifier_state == "locked") {
            keys_to_return := build_modifier_combo(".", can_be_modified)
            return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
        }
        ; In AceJump flags, it is only ever the first press that
        ; may end up a non-letter character. This is because the 
        ; plugin uses the capitalization of the second character
        ; (always a letter) to control its jump_selecting behavior.
        else if(presses_left_until_jump = 2) {
            presses_left_until_jump := presses_left_until_jump - 1
            return hotstring_neutral_key(".")
            ; Always comes after jump key that clears sent_keys_stack
        }
        else {
            keys_to_return := ""
            undo_keys := ""
            sent_keys_stack_length := sent_keys_stack.Length()
            one_key_back := ""
            if(sent_keys_stack_length >= 1) {
                one_key_back := sent_keys_stack[sent_keys_stack_length]
            }
            if(is_number(one_key_back)) {
                keys_to_return := "{Backspace}" . "." . "{Space}"
                undo_keys := "{Backspace 2}{Space}"
            }
            else {
                autospacing := "not-autospaced"
                keys_to_return := "."
                undo_keys := "{Backspace}"
            }
            ; The is_number case will never trigger a hotstring, but whatever.
            ; The conditionals inside the called logic will take care of it just fine.
            return hotstring_inactive_delimiter_key_tracked("dot", keys_to_return, undo_keys)
        }
    }
    else { ; Code mode is active

        ; Basically, copy-paste normal_key(), except
        ; use "dot" rather than "." in places, and hotstring_inactive_delimiter_key_tracked()
        ; rather than the hotstring triggering version.

        if(modifier_state == "leader" || modifier_state == "locked") {
            keys_to_return := build_modifier_combo(".", can_be_modified)
            return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
        }
        ; In AceJump flags, it is only ever the first press that
        ; may end up a non-letter character. This is because the 
        ; plugin uses the capitalization of the second character
        ; (always a letter) to control its jump_selecting behavior.
        else if(presses_left_until_jump = 2) {
            presses_left_until_jump := presses_left_until_jump - 1
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(".")
        }
        else {
            autospacing := "not-autospaced"
            keys_to_return := "."
            undo_keys := "{Backspace}"
            return hotstring_inactive_delimiter_key_tracked("dot", keys_to_return, undo_keys)
        }
    }
}


format_with_commas() {
    ; TODO
}

hundred() {
    ; TODO
}

thousand() {
    ; TODO
}

million() {
    ; TODO
}

billion() {
    ; TODO
}

trillion() {
    ; TODO
}

format_as_dollars() {
    ; TODO
}

format_as_other_other_currency() {
    ; TODO
}

write_out_number() {
    ; TODO
}


; Modifiers
;-------------------------------------------------

mod_control() {
    keys_to_return := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
}

mod_alt() {
    keys_to_return := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
}

mod_shift() {
    keys_to_return := ""
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
}

; Actions
;-------------------------------------------------



; #NotTemplateKey
shift_tab() {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Tab}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; Clears certain microstates
        in_raw_microstate := False

        keys_to_return := "+{Tab}"
        return hotstring_neutral_key(keys_to_return)
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



delete() {
    return modifiable_hotstring_neutral_action_key("{Delete}")
}

; #NotTemplateKey
escape() {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Escape}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; Clears certain microstates
        in_raw_microstate := False
        presses_left_until_jump := 0

        keys_to_return := "{Escape}"
        return hotstring_neutral_key(keys_to_return)
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

paste_after() {
    return hotstring_trigger_action_key_untracked_reset_entry_related_variables("^v")
}

paste_before() {
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







; ASCII 42 (base 10)
asterisk() {
    return normal_key("*", False)
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



; ASCII 45 (base 10)
hyphen() {
    return inactive_delimiter_key("-")
}



; ASCII 47 (base 10)
back_slash() {
    return normal_key("/")
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



; ASCII 64 (base 10)
at_sign() {
    return inactive_delimiter_key("@", False)
}



; ASCII 92 (base 10)
forward_slash() {
    ; Used in Windows file paths, and also for escaping things
    ; (be that in regular expressions or otherwise)
    return inactive_delimiter_key("\")
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
    return normal_key("``")
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
    keys_to_return := "{Enter 2}" . "<!-- --- -->"
    return keys_to_return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
notes_slide_break() {
    keys_to_return := "{Enter 2}" . "<!-- ??? -->"
    return keys_to_return 
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
webcam_break() {
    keys_to_return := "{Enter 2}" . "<!-- webcam -->"
    return keys_to_return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
screen_recording_break() {
    keys_to_return := "{Enter 2}" . "<!-- screen -->"
    return keys_to_return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h1_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{#}" . "{Space}"
    undo_keys := "{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("h1", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h2_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{# 2}" . "{Space}"
    undo_keys := "{Backspace 3}"
    return hotstring_trigger_delimiter_key_tracked("h2", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h3_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{# 3}" . "{Space}"
    undo_keys := "{Backspace 4}"
    return hotstring_trigger_delimiter_key_tracked("h3", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h4_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{# 4}" . "{Space}"
    undo_keys := "{Backspace 5}"
    return hotstring_trigger_delimiter_key_tracked("h4", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h5_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{# 5}" . "{Space}"
    undo_keys := "{Backspace 6}"
    return hotstring_trigger_delimiter_key_tracked("h5", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
h6_header() {
    autospacing := "cap-autospaced"
    keys_to_return := "{# 6}" . "{Space}"
    undo_keys := "{Backspace 7}"
    return hotstring_trigger_delimiter_key_tracked("h6", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
strikethough() {
    ; Passes through capitalization
    keys_to_return := "~~~~" . "{Left 2}"
    undo_keys := "{Delete 2}{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("strikethrough", keys_to_return, undo_keys)
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
inline_latex() {
    ; Passes through capitalization right now. TODO: figure out better with code mode microstate?
    keys_to_return := "$$$$" . "{Left 2}"
    undo_keys := "{Delete 2}{Backspace 2}"
    return hotstring_trigger_delimiter_key_tracked("LaTeX", keys_to_return, undo_keys)
}

; TODO
make_selected_text_link_with_clipboard_contents_as_url() {
    return
}

; #NotTemplateKey
; #CustomCharacterNotCustomAction
; TODO
add_footnote() {
    keys_to_return := "[^]" . "{Left}"
    return keys_to_return
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

em_dash() {
    return normal_key("—", False)
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