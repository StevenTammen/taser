; Reusable key templates
;-------------------------------------------------

; TODO: eat raw leader press
normal_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        autospacing := "not-autospaced"
        keysToReturn := character
        undoKeys := "{Backspace}"
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

inactive_delimiter_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        autospacing := "not-autospaced"
        keysToReturn := character
        undoKeys := "{Backspace}"
        return hotstring_inactive_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

normal_key_except_between_numbers(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
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
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        }
        else {
            autospacing := "not-autospaced"
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        ; The is_number case will never trigger a hotstring, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

inactive_delimiter_key_except_between_numbers(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
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
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        }
        else {
            autospacing := "not-autospaced"
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        ; The is_number case will never trigger a hotstring, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_inactive_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

modifiable_hotstring_trigger_action_key(key) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(key)
    }
}

modifiable_hotstring_neutral_action_key(key) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        return hotstring_neutral_key(key)
    }
}

modifiable_hotstring_trigger_shift_action_key(key) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(key)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else {
        keysToReturn := "+" . key
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
}

; Like + and = and | in prose mode
space_before_and_after_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := character
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keysToReturn := character . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keysToReturn := character . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keysToReturn := character . "{Space}"
                undoKeys := "{Backspace 2}"
            }
            else {
                keysToReturn := "{Space}" . character . "{Space}"
                undoKeys := "{Backspace 3}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

; Like $ in prose mode
space_before_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := character
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keysToReturn := character
                undoKeys := "{Backspace}"
            }
            else {
                keysToReturn := "{Space}" . character
                undoKeys := "{Backspace 2}"
            }
        }
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

; Like % in prose mode
space_after_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := character
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        else if(autospacing = "autospaced") {
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        }
        else if (autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        }
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keysToReturn := character . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

lowercase_letter_key(lowercaseLetter, uppercaseLetter) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(lowerCaseLetter)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(lowercaseLetter)
    }
    else if(pressesLeftUntilJump = 1) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(jumpSelecting) {
            ; Always comes after jump key that clears sentKeysStack
            return hotstring_neutral_key(uppercaseLetter)
        }
        else { ; Just jumping, not selecting
            ; Always comes after jump key that clears sentKeysStack
            return hotstring_neutral_key(lowercaseLetter)
        }
    }
    else {
        keysToReturn := ""
        undoKeys := "{Backspace}"
        if(autospacing = "cap-autospaced"){
            keysToReturn := uppercaseLetter 
        }
        else {
            keysToReturn := lowercaseLetter
        }
        autospacing := "not-autospaced"
        return hotstring_character_key(keysToReturn, keysToReturn, undoKeys)
    }
}

uppercase_letter_key(uppercaseLetter) {
    if(pressesLeftUntilJump > 0) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        ; Always comes after jump8 key that clears sentKeysStack
        return hotstring_neutral_key(uppercaseLetter)
    }
    else {
        undoKeys := "{Backspace}"
        autospacing := "not-autospaced"
        return hotstring_character_key(uppercaseLetter, uppercaseLetter, undoKeys)
    }
}

; Numbers are not autospaced in code mode
number_key(num) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(num)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(num)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        sentKeysStackLength := sentKeysStack.Length()
        oneKeyBack := ""
        twoKeysBack := ""
        if(sentKeysStackLength >= 2) {
            oneKeyBack := sentKeysStack[sentKeysStackLength]
            twoKeysBack := sentKeysStack[sentKeysStackLength - 1]
        }
        else if (sentKeysStackLength = 1) {
            oneKeyBack := sentKeysStack[sentKeysStackLength]
        }
        if(clipboardLeader) {
            keysToReturn := num
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := num
            undoKeys := "{Backspace}"
        }
        else if(autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keysToReturn := num . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        else if(autospacing = "autospaced") {
            ; No spaces between consecutive numbers
            if(is_number(oneKeyBack)) {
                keysToReturn := "{Backspace}" . num . "{Space}"
                undoKeys := "{Backspace 2}{Space}"
            }
            ; No spaces between numbers and colon/decimal point/hyphen/slash.
            ; Could transform hyphens into en dashes automatically if desired,
            ; but I just choose not to.
            else if(is_number(twoKeysBack) and (oneKeyBack = ":" or oneKeyBack = "." or oneKeyBack = "-" or oneKeyBack = "/")) {
                keysToReturn := "{Backspace}" . num . "{Space}"
                undoKeys := "{Backspace 2}{Space}"
            }
            else {
                keysToReturn := num . "{Space}"
                undoKeys := "{Backspace 2}"
            }
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            if(just_starting_new_entry()) {
                keysToReturn := num . "{Space}"
                undoKeys := "{Backspace 2}"
            }
            else {
                keysToReturn := "{Space}" . num . "{Space}"
                undoKeys := "{Backspace 3}"
            }
        }
        ; The is_number cases will never trigger hotstrings, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_trigger_delimiter_key_tracked(num, keysToReturn, undoKeys)
    }
}

; Right now, I use this to make the colon key act like semicolon in modifier combinations
; Most of the rest of the time having the character in modifiers match the character
; sent normally makes sense
no_cap_punctuation_key_specify_mod_char(character, modCharacter, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(modCharacter, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := character
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        ; This case happens when you pass through capitalization after quotes,
        ; for example. So like the sequence "Some question?" followed by a
        ; comma keypress
        else if(autospacing = "cap-autospaced") {
            autospacing := "autospaced"
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"

        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing = "autospaced") {
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "autospaced"
            keysToReturn := character . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

; For keys like comma, semicolon, colon in prose mode
no_cap_punctuation_key(character, canBeModified := True) {
    ; Split out like this because of :
    ; It needs to act like ; in modifier combos
    return no_cap_punctuation_key_specify_mod_char(character, character, canBeModified)
}

; For keys like period, question mark, exclamation mark
cap_punctuation_key(character, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(character, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(character)
    }
    else {
        keysToReturn := ""
        undoKeys := ""
        if(clipboardLeader) {
            keysToReturn := character
            undoKeys := "{Backspace}"
            clipboardLeader := False
        }
        else if(clipboardDownNoUp or in_raw_microstate()) {
            keysToReturn := character
            undoKeys := "{Backspace}"
        }
        ; This case happens when you pass through capitalization after quotes,
        ; for example. So like the sequence "Some question?" followed by a
        ; period keypress
        else if(autospacing = "cap-autospaced") {
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        }
        ; This case happens after quotes and numbers, for example
        else if(autospacing = "autospaced") {
            autospacing := "cap-autospaced"
            keysToReturn := "{Backspace}" . character . "{Space}"
            undoKeys := "{Backspace 2}{Space}"
        } 
        else { ; autospacing = "not-autospaced"
            autospacing := "cap-autospaced"
            keysToReturn := character . "{Space}"
            undoKeys := "{Backspace 2}"
        }
        return hotstring_trigger_delimiter_key_tracked(character, keysToReturn, undoKeys)
    }
}

matched_pair_key(openingCharacter, closingCharacter, canBeModified := True) {
    if(modifiersLeader or modifiersHeldDown) {
        keysToReturn := build_modifier_combo(openingCharacter, canBeModified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jumpselecting behavior.
    else if(pressesLeftUntilJump = 2) {
        pressesLeftUntilJump := pressesLeftUntilJump - 1
        if(clipboardLeader) {
            clipboardLeader := False
        }
        ; Always comes after jump key that clears sentKeysStack
        return hotstring_neutral_key(openingCharacter)
    }
    else {
        if(manuallyAutomatching) {
            return matched_pair_key_manual_automatching(openingCharacter, closingCharacter)
        }
        else {
            return matched_pair_key_instant_automatching(openingCharacter, closingCharacter)
        }
    }
}

matched_pair_key_instant_automatching(openingCharacter, closingCharacter) {
    keysToReturn := ""
    undoKeys := ""
    if(clipboardLeader) {
        keysToReturn := openingCharacter
        undoKeys := "{Backspace}"
        clipboardLeader := False
    }
    else if(clipboardDownNoUp or in_raw_microstate()) {
        keysToReturn := openingCharacter
        undoKeys := "{Backspace}"
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing = "autospaced" or autospacing = "cap-autospaced") {
        keysToReturn := openingCharacter . closingCharacter . "{Left}"
        undoKeys := "{Delete}{Backspace}"
    }
    else { ; autospacing = "not-autospaced"
        autospacing := "autospaced"
        if(just_starting_new_entry()) {
            keysToReturn := openingCharacter . closingCharacter . "{Left}"
            undoKeys := "{Delete}{Backspace}"
        }
        else {
            keysToReturn := "{Space}" . openingCharacter . closingCharacter . "{Left}"
            undoKeys := "{Delete}{Backspace 2}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(openingCharacter, keysToReturn, undoKeys)
}

matched_pair_key_manual_automatching(openingCharacter, closingCharacter) {
    keysToReturn := ""
    undoKeys := ""
    if(clipboardLeader) {
        keysToReturn := openingCharacter
        undoKeys := "{Backspace}"
        clipboardLeader := False
    }
    else if(clipboardDownNoUp or in_raw_microstate()) {
        keysToReturn := openingCharacter
        undoKeys := "{Backspace}"
    }
    ; Capitalization is "passed through" matched pair characters like opening quotes
    else if(autospacing = "autospaced" or autospacing = "cap-autospaced") {
        keysToReturn := openingCharacter
        automatching := automatching . closingCharacter
        undoKeys := "{Backspace}"
    }
    else { ; autospacing = "not-autospaced"
        autospacing := "autospaced"
        automatching := automatching . closingCharacter
        if(just_starting_new_entry()) {
            keysToReturn := openingCharacter
            undoKeys := "{Backspace}"
        }
        else {
            keysToReturn := "{Space}" . openingCharacter
            undoKeys := "{Backspace 2}"
        }
    }
    return hotstring_trigger_delimiter_key_tracked(openingCharacter, keysToReturn, undoKeys)
}