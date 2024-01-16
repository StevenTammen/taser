; Reusable key templates
;-------------------------------------------------

; TODO: eat raw leader press
normal_key(character, can_be_modified := True) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
    }
    else {
        autospacing := "not-autospaced"
        keys_to_return := character
        undo_keys := "{Backspace}"
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

inactive_delimiter_key(character, can_be_modified := True) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
    }
    else {
        autospacing := "not-autospaced"
        keys_to_return := character
        undo_keys := "{Backspace}"
        return hotstring_inactive_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

modifiable_hotstring_trigger_action_key(key) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(key, keys_to_return)
    }
    else {
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(key, key)
    }
}

modifiable_hotstring_neutral_action_key(key) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(key, keys_to_return)
    }
    else {
        return hotstring_neutral_key(key, key)
    }
}

; Like + and = and | in prose mode
space_before_and_after_key(character, can_be_modified := True) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
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
        else if(autospacing == "autospaced") {
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        else if (autospacing == "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        else { ; autospacing == "not-autospaced"
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
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
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
        else if(autospacing == "autospaced") {
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else if (autospacing == "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        else { ; autospacing == "not-autospaced"
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
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
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
        else if(autospacing == "autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else if (autospacing == "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else { ; autospacing == "not-autospaced"
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

lowercase_letter_key(lowercase_letter, uppercase_letter) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(lowercase_letter)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(lowercase_letter, keys_to_return)
    }
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(lowercase_letter, lowercase_letter)
    }
    else if(presses_left_until_hint_actuation == 1) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(jump_selecting) {
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(uppercase_letter, uppercase_letter)
        }
        else { ; Just jumping, not selecting
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(lowercase_letter, lowercase_letter)
        }
    }
    else {
        keys_to_return := ""
        undo_keys := "{Backspace}"
        if(autospacing == "cap-autospaced"){
            keys_to_return := uppercase_letter 
        }
        else {
            keys_to_return := lowercase_letter
        }
        autospacing := "not-autospaced"
        return hotstring_character_key(keys_to_return, keys_to_return, undo_keys)
    }
}

; Shift Leader = uppercase_a()
; Caps Leader = caps_lock_a_autolock_caps_layer()
; Caps Lock = caps_lock_a()
uppercase_letter_key(uppercase_letter) {
    ; "Eat" modifier presses, since they aren't expected for uppercase letters
    if(modifier_state == "leader" or modifier_state == "locked") {
        return ""
    }
    else if(presses_left_until_hint_actuation > 0) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(uppercase_letter, uppercase_letter)
    }
    else {
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(uppercase_letter, uppercase_letter, undo_keys)
    }
}

caps_lock_letter_key(uppercase_letter) {
    ; "Eat" modifier presses, since they aren't expected for caps lock letters
    if(modifier_state == "leader" or modifier_state == "locked") {
        return ""
    }
    else if(presses_left_until_hint_actuation > 0) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(uppercase_letter, uppercase_letter)
    }
    else {
        pressed_key := "caps_lock_" . uppercase_letter
        keys_to_return := uppercase_letter
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(pressed_key, keys_to_return, undo_keys)
    }
}

caps_lock_letter_key_autolock_caps_layer(uppercase_letter) {
    ; "Eat" modifier presses, since they aren't expected for caps lock letters
    if(modifier_state == "leader" or modifier_state == "locked") {
        return ""
    }
    else if(presses_left_until_hint_actuation > 0) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(uppercase_letter, uppercase_letter)
    }
    else {
        ; This line is the difference
        locked := "caps"
        pressed_key := "caps_lock_" . uppercase_letter
        keys_to_return := uppercase_letter
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(pressed_key, keys_to_return, undo_keys)
    }
}

; Number Leader = one_autolock_number_layer()
; Number Lock = one()
number_key(num) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(num)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(num, keys_to_return)
    }
    else {
        keys_to_return := num
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(keys_to_return, keys_to_return, undo_keys)
    }
}

number_key_autolock_number_layer(num) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(num)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(num, keys_to_return)
    }
    else {
        ; This line is the difference
        locked := "number"
        keys_to_return := num
        undo_keys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(keys_to_return, keys_to_return, undo_keys)
    }
}

; For keys like comma, semicolon, colon in prose mode
no_cap_punctuation_key(character, can_be_modified := True) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
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
        else if(autospacing == "cap-autospaced") {
            autospacing := "autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"

        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing == "autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing == "not-autospaced"
            autospacing := "autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

; For keys like period, question mark, exclamation mark in prose mode
cap_punctuation_key(character, can_be_modified := True) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(character, can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(character, keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        if(raw_state == "leader") {
            raw_state := ""
        }
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(character, character)
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
        else if(autospacing == "cap-autospaced") {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing == "autospaced") {
            autospacing := "cap-autospaced"
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing == "not-autospaced"
            autospacing := "cap-autospaced"
            keys_to_return := character . "{Space}"
            undo_keys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

matched_pair_key(opening_characters, closing_characters, pass_through_capitalization, can_be_modified) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        if (StrLen(opening_characters) > 1) {
            return eat_keypress()
        }
        else {
            keys_to_return := build_modifier_combo(opening_characters, can_be_modified)
            return hotstring_trigger_action_key_untracked_reset_entry_related_variables(opening_characters, keys_to_return)
        }
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation == 2) {
        if (StrLen(opening_characters) > 1) {
            return eat_keypress()
        }
        else {
            presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
            if(raw_state == "leader") {
                raw_state := ""
            }
            ; Always comes after jump key that clears sent_keys_stack
            return hotstring_neutral_key(opening_characters, opening_characters)
        }
    }
    else {
        if(manually_automatching) {
            return matched_pair_key_manual_automatching(opening_characters, closing_characters, pass_through_capitalization)
        }
        else {
            return matched_pair_key_instant_automatching(opening_characters, closing_characters, pass_through_capitalization)
        }
    }
}

matched_pair_key_instant_automatching(opening_characters, closing_characters, pass_through_capitalization) {
    keys_to_return := ""
    undo_keys := ""
    if(raw_state == "leader") {
        keys_to_return := opening_characters
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
        raw_state := ""
    }
    else if((raw_state == "lock") or in_raw_microstate()) {
        keys_to_return := opening_characters
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing == "autospaced" or autospacing == "cap-autospaced") {
        if(not pass_through_capitalization) {
            autospacing := "autospaced"
        }
        keys_to_return := opening_characters . closing_characters
        Loop % StrLen(rm_esc_chars(closing_characters)) {
            keys_to_return := keys_to_return . "{Left}"
        }
        automatching_stack.Push(closing_characters)
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(closing_characters)) {
            undo_keys := undo_keys . "{Delete}"
        } 
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    else { ; autospacing == "not-autospaced"
        autospacing := "autospaced"
        automatching_stack.Push(closing_characters)
        if(just_starting_new_entry()) {
            keys_to_return := opening_characters . closing_characters
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
        }
        else {
            keys_to_return := "{Space}" . opening_characters . closing_characters
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(opening_characters, keys_to_return, undo_keys)
}

matched_pair_key_manual_automatching(opening_characters, closing_characters, pass_through_capitalization) {
    keys_to_return := ""
    undo_keys := ""
    if(raw_state == "leader") {
        keys_to_return := opening_characters
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
        raw_state := ""
    }
    else if((raw_state == "lock") or in_raw_microstate()) {
        keys_to_return := opening_characters
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing == "autospaced" or autospacing == "cap-autospaced") {
        if(not pass_through_capitalization) {
            autospacing := "autospaced"
        }
        keys_to_return := opening_characters
        automatching_stack.Push(closing_characters)
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    else { ; autospacing == "not-autospaced"
        autospacing := "autospaced"
        automatching_stack.Push(closing_characters)
        if(just_starting_new_entry()) {
            keys_to_return := opening_characters
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
        }
        else {
            keys_to_return := "{Space}" . opening_characters
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(opening_characters, keys_to_return, undo_keys)
}

two_blank_construct(opening_characters, between_characters, closing_characters, pass_through_capitalization, is_completed_in_forward_direction) {
    if(modifier_state == "leader" or modifier_state == "locked") {
        return eat_keypress()
    }
    else if(presses_left_until_hint_actuation == 2) {
        return eat_keypress()
    }
    else {
        ; There is no point in coding a manually_automatching version since these won't ever show up in typing practice
        if(manually_automatching) {
            return eat_keypress()
        }
        else {
            ; This will be what you want almost 100% of the time. The only time you don't is if you are
            ; filling in something in reverse in one markup language (e.g., Org) to make the completion
            ; order consistent with one or more other markup languages (e.g., Markdown).
            ;
            ; For example, hyperlinks in Org have link address then link text, while Markdown links have
            ; text then link address. So if you always want the order to be link text -> link address, then
            ; you have to reverse the completion_direction for the Org form of the construct. Compare:
            ;   Markdown link: [Link text](Link address)
            ;   Org link: [[Link address][Link text]]
            if(is_completed_in_forward_direction) {
                return two_blank_construct_instant_automatching_forward_completion(opening_characters, between_characters, closing_characters, pass_through_capitalization)
            }
            else {
                ; TODO
                eat_keypress()
            }
        }
    }
}

; TODO: make it handle tabs for indentation when going from opening_characters to between_characters
; and when going from between_characters to closing_characters
two_blank_construct_instant_automatching_forward_completion(opening_characters, between_characters, closing_characters, pass_through_capitalization) {
    keys_to_return := ""
    undo_keys := ""
    if(raw_state == "leader") {
        eat_keypress()
    }
    else if((raw_state == "lock") or in_raw_microstate()) {
        eat_keypress()
    }
    ; Capitalization can be passed through, just as with matched pairs
    else if(autospacing == "autospaced" or autospacing == "cap-autospaced") {
        if(not pass_through_capitalization) {
            autospacing := "autospaced"
        }
        keys_to_return := opening_characters . between_characters . closing_characters
        Loop % StrLen(rm_esc_chars(closing_characters)) {
            keys_to_return := keys_to_return . "{Left}"
        }
        automatching_stack.Push(closing_characters)
        Loop % StrLen(rm_esc_chars(between_characters)) {
            keys_to_return := keys_to_return . "{Left}"
        }
        ; Add a "b" to the front of between_characters stuck on the automatching stack.
        ; This is so that we know when completing things which entries are for between_characters.
        ; The difference is that between_characters are autospaced upfront = we don't want
        ; any trailing spaces sent when we press ), unlike with closing_characters
        automatching_stack.Push("b" . between_characters)
        undo_keys := ""
        Loop % StrLen(rm_esc_chars(between_characters)) {
            undo_keys := undo_keys . "{Delete}"
        } 
        Loop % StrLen(rm_esc_chars(closing_characters)) {
            undo_keys := undo_keys . "{Delete}"
        } 
        Loop % StrLen(rm_esc_chars(opening_characters)) {
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    else { ; autospacing == "not-autospaced"
        autospacing := "autospaced"
        automatching_stack.Push(closing_characters)
        if(just_starting_new_entry()) {
            keys_to_return := opening_characters . between_characters . closing_characters
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            automatching_stack.Push(closing_characters)
            Loop % StrLen(rm_esc_chars(between_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            ; Add a "b" to the front of between_characters stuck on the automatching stack.
            ; This is so that we know when completing things which entries are for between_characters.
            ; The difference is that between_characters are autospaced upfront = we don't want
            ; any trailing spaces sent when we press ), unlike with closing_characters
            automatching_stack.Push("b" . between_characters)
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(between_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
        }
        else {
            keys_to_return := "{Space}" . opening_characters . between_characters . closing_characters
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            automatching_stack.Push(closing_characters)
            Loop % StrLen(rm_esc_chars(between_characters)) {
                keys_to_return := keys_to_return . "{Left}"
            }
            ; Add a "b" to the front of between_characters stuck on the automatching stack.
            ; This is so that we know when completing things which entries are for between_characters.
            ; The difference is that between_characters are autospaced upfront = we don't want
            ; any trailing spaces sent when we press ), unlike with closing_characters
            automatching_stack.Push("b" . between_characters)
            undo_keys := ""
            Loop % StrLen(rm_esc_chars(between_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(closing_characters)) {
                undo_keys := undo_keys . "{Delete}"
            } 
            Loop % StrLen(rm_esc_chars(opening_characters)) {
                undo_keys := undo_keys . "{Backspace}"
            }
            undo_keys := undo_keys . "{Backspace}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(opening_characters, keys_to_return, undo_keys)
}