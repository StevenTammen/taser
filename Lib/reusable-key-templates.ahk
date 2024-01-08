; Reusable key templates
;-------------------------------------------------

; TODO: eat raw leader press
normal_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        autospacing := "not-autospaced"
        keys_to_return := character
        undo_keys := "{Backspace}"
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

inactive_delimiter_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        autospacing := "not-autospaced"
        keys_to_return := character
        undo_keys := "{Backspace}"
        return hotstring_inactive_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}



modifiable_hotstring_trigger_action_key(key) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(key)
    }
}

modifiable_hotstring_neutral_action_key(key) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        return hotstring_neutral_key(key)
    }
}

modifiable_hotstring_trigger_shift_action_key(key) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        keys_to_return := "+" . key
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
}

; Like + and = and | in prose mode
space_before_and_after_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := character
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keys_to_return := character . "{Space}"
                undo_keys := "{Backspace 2}"
            }
            else {
                keys_to_return := "{Space}" . character . "{Space}"
                undo_keys := "{Backspace 3}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

; Like $ in prose mode
space_before_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := character
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keys_to_return := character
                undo_keys := "{Backspace}"
            }
            else {
                keys_to_return := "{Space}" . character
                undo_keys := "{Backspace 2}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

; Like % in prose mode
space_after_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := character
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

lowercase_letter_key(lowercaseLetter, uppercaseLetter) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(lowerCaseLetter)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(lowercaseLetter)
    }
    else if(presses_left_until_jump = 1) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(jump_selecting) {
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(uppercaseLetter)
        }
        else { ; Just jumping, not selecting
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(lowercaseLetter)
        }
    }
    else {
        keys_to_return := ""
        undo_keys := "{Backspace}"
        if(autospacing = "cap-autospaced"){
            keys_to_return := uppercaseLetter 
        }
        else {
            keys_to_return := lowercaseLetter
        }
        autospacing := "not-autospaced"
        return hotstring_character_key(keys_to_return, keys_to_return, undo_keys)
    }
}

uppercase_letter_key(uppercaseLetter) {
    if(presses_left_until_jump > 0) {
        presses_left_until_jump := presses_left_until_jump - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(uppercaseLetter)
    }
    else {
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(uppercaseLetter, uppercaseLetter, undo_keys)
    }
}


new_number_key(num) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(num)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        keys_to_return := num
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(keys_to_return, keys_to_return, undo_keys)
    }
}



; Numbers are not autospaced in code mode
number_key(num) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(num)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(num)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        two_keys_back := ""
        if(sent_keys_stack_length >= 2) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
            two_keys_back := sent_keys_stack[sent_keys_stack_length - 1]
        }
        else if (sent_keys_stack_length = 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }
        if(raw_state == "leader") {
            keys_to_return := num
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := num
            undo_keys := "{Backspace}"
        }
        else if(autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := num . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        else if(autospacing = "autospaced") {
            ; No spaces between consecutive numbers
            if(is_number(one_key_back)) {
                keys_to_return := "{Backspace}" . num . "{Space}"
                undo_keys := "{Backspace 2}{Space}"
            }
            ; No spaces between numbers and colon/decimal point/hyphen/slash.
            ; Could transform hyphens into en dashes automatically if desired,
            ; but I just choose not to.
            else if(is_number(two_keys_back) and (one_key_back = ":" or one_key_back = "." or one_key_back = "-" or one_key_back = "/")) {
                keys_to_return := "{Backspace}" . num . "{Space}"
                undo_keys := "{Backspace 2}{Space}"
            }
            else {
                keys_to_return := num . "{Space}"
                undo_keys := "{Backspace 2}"
            }
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keys_to_return := num . "{Space}"
                undo_keys := "{Backspace 2}"
            }
            else {
                keys_to_return := "{Space}" . num . "{Space}"
                undo_keys := "{Backspace 3}"
            }
        }
        ; The is_number cases will never trigger hotstrings, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_trigger_delimiter_key_tracked(num, keys_to_return, undo_keys)
    }
}

; For keys like comma, semicolon, colon in prose mode
no_cap_punctuation_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := character
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        ; This case happens when you pass through capitalization after quotes,
        ; for example. So like the sequence "Some question?" followed by a
        ; comma keypress
        else if(autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"

        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing = "autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

; For keys like period, question mark, exclamation mark in prose mode
cap_punctuation_key(character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character)
    }
    else {
        keys_to_return := ""
        undo_keys := ""
        if(raw_state == "leader") {
            keys_to_return := character
            undo_keys := "{Backspace}"
            raw_state := ""
        }
        else if((raw_state == "lock") or in_raw_microstate()) {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        ; This case happens when you pass through capitalization after quotes,
        ; for example. So like the sequence "Some question?" followed by a
        ; period keypress
        else if(autospacing = "cap-autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing = "autospaced") {
            autospacing := "cap-autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "cap-autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

matched_pair_key(opening_character, closing_character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(opening_character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_jump = 2) {
        presses_left_until_jump := presses_left_until_jump - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(opening_character)
    }
    else {
        if(manually_automatching) {
            return matched_pair_key_manual_automatching(opening_character, closing_character)
        }
        else {
            return matched_pair_key_instant_automatching(opening_character, closing_character)
        }
    }
}

matched_pair_key_instant_automatching(opening_character, closing_character) {
    keys_to_return := ""
    undo_keys := ""
    if(raw_state == "leader") {
        keys_to_return := opening_character
        undo_keys := "{Backspace}"
        raw_state := ""
    }
    else if((raw_state == "lock") or in_raw_microstate()) {
        keys_to_return := opening_character
        undo_keys := "{Backspace}"
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing = "autospaced" or autospacing = "cap-autospaced") {
        keys_to_return := opening_character . closing_character . "{Left}"
        undo_keys := "{Delete}{Backspace}"
    }
    else { ; autospacing = "not-autospaced"
        autospacing := "autospaced"
        if(just_starting_new_entry()) {
            keys_to_return := opening_character . closing_character . "{Left}"
            undo_keys := "{Delete}{Backspace}"
        }
        else {
            keys_to_return := "{Space}" . opening_character . closing_character . "{Left}"
            undo_keys := "{Delete}{Backspace 2}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(opening_character, keys_to_return, undo_keys)
}

matched_pair_key_manual_automatching(opening_character, closing_character) {
    keys_to_return := ""
    undo_keys := ""
    if(raw_state == "leader") {
        keys_to_return := opening_character
        undo_keys := "{Backspace}"
        raw_state := ""
    }
    else if((raw_state == "lock") or in_raw_microstate()) {
        keys_to_return := opening_character
        undo_keys := "{Backspace}"
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing = "autospaced" or autospacing = "cap-autospaced") {
        keys_to_return := opening_character
        automatching := automatching . closing_character
        undo_keys := "{Backspace}"
    }
    else { ; autospacing = "not-autospaced"
        autospacing := "autospaced"
        automatching := automatching . closing_character
        if(just_starting_new_entry()) {
            keys_to_return := opening_character
            undo_keys := "{Backspace}"
        }
        else {
            keys_to_return := "{Space}" . opening_character
            undo_keys := "{Backspace 2}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(opening_character, keys_to_return, undo_keys)
}