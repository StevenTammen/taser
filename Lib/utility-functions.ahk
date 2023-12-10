; Utility Functions
;-------------------------------------------------

build_modifier_combo(keyToCombine, canBeModified := True) {

    ; Take the symbols that are accessed via Shift on the
    ; number row on QWERTY. It is not possible to have Ctrl + @,
    ; for example. That would just be Ctrl + Shift + 2. So when
    ; we set up all our generic re-usable functions, it makes
    ; sense to be able to disable the modifier behavior for
    ; keys like this. We simply "eat" the keypress, as that
    ; will probably lead to the least unexpected behavior
    ; overall. In UX design, cf. "The principle of least surprise"
    if(not canBeModified) {
        return ""
    }

    combination := ""

    if(modControlDown) {
        combination := combination . "^"
        if(modifiersLeader) {
            modControlDown := False
        }
    }
    if(modAltDown) {
        combination := combination . "!"
        if(modifiersLeader) {
            modAltDown := False
        }
    } 
    if(modShiftDown) {
        combination := combination . "+"
        if(modifiersLeader) {
            modShiftDown := False
        }
    }

    combination := combination . keyToCombine

    if(modifiersLeader) {
        modifiersLeader := False
    }

    return combination
}

is_number(character) {
    numbers := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    return (contains(numbers, character))
}

is_hotstring_character(character) {
    return (contains(hostringCharacters, character))
}

get_index(haystack, needle) {
    for index, value in haystack {
        if (value = needle) {
            return index
        }
    }
    return -1
}

contains(haystack, needle) {
    return get_index(haystack, needle) != -1
}

prose_mode_should_be_active() {
    ; Check if certain windows are open
    ; Terminal should always implicitly be code mode, for example
    ; File manager too
    ; if() {
    ;     return False
    ; }
    return (inputMode = "prose")
}

in_raw_microstate() {
    ; Check if certain other conditions are met?
    ; if() {
    ;     return True
    ; }
    return (inRawMicrostate)
}

; TODO function for seeing if a JetBrains editor is active = full AceJump

; TODO function for seeing if browser is active = set up bindings for SurfingKeys

reset_entry_related_variables() {
    autospacing := "not-autospaced"
    autospacingStack := []
    automatching := ""
    automatchingStack := []
    sentKeysStack := []
    undoSentKeysStack := []
    lastDelimiter := ""
    currentBrief := ""
}

just_starting_new_entry() {
    return (sentKeysStack.Length() = 0)
}

; https://www.autohotkey.com/boards/viewtopic.php?t=68429
StrCmp(Str1, Op, Str2, CS:=1) { ; requires AutoHotkey v1.1.31+
    Local R, SCS := A_StringCaseSense
    StringCaseSense, % (CS := !!CS)
    Switch Op {
        Case ">" : R := (Str1 > Str2) 
        Case ">=" : R := (Str1 >= Str2)
        Case "<" : R := (Str1 < Str2)
        Case "<=" : R := (Str1 <= Str2)
        Case "==" : R := (Str1 == Str2)
        Case "!=","<>" : R := (Str1 != Str2)
        default : R := (CS ? (Str1 == Str2) : (Str1 = Str2)) 
    }
    StringCaseSense, %SCS%
    Return R
}

; If the character passed in is not an lowercase letter, returns ""
; Otherwise, returns the uppercase version of the lowercase letter passed in
get_uppercase(character) {
    if(StrCmp(character, "==", "a")) 
        return "A"
    else if(StrCmp(character, "==", "b")) 
        return "B"
    else if(StrCmp(character, "==", "c")) 
        return "C"
    else if(StrCmp(character, "==", "d")) 
        return "D"
    else if(StrCmp(character, "==", "e")) 
        return "E"
    else if(StrCmp(character, "==", "f")) 
        return "F"
    else if(StrCmp(character, "==", "g")) 
        return "G"
    else if(StrCmp(character, "==", "h")) 
        return "H"
    else if(StrCmp(character, "==", "i")) 
        return "I"
    else if(StrCmp(character, "==", "j")) 
        return "J"
    else if(StrCmp(character, "==", "k")) 
        return "K"
    else if(StrCmp(character, "==", "l")) 
        return "L"
    else if(StrCmp(character, "==", "m")) 
        return "M"
    else if(StrCmp(character, "==", "n")) 
        return "N"
    else if(StrCmp(character, "==", "o")) 
        return "O"
    else if(StrCmp(character, "==", "p")) 
        return "P"
    else if(StrCmp(character, "==", "q")) 
        return "Q"
    else if(StrCmp(character, "==", "r")) 
        return "R"
    else if(StrCmp(character, "==", "s")) 
        return "S"
    else if(StrCmp(character, "==", "t")) 
        return "T"
    else if(StrCmp(character, "==", "u")) 
        return "U"
    else if(StrCmp(character, "==", "v")) 
        return "V"
    else if(StrCmp(character, "==", "w")) 
        return "W"
    else if(StrCmp(character, "==", "x")) 
        return "X"
    else if(StrCmp(character, "==", "y")) 
        return "Y"
    else if(StrCmp(character, "==", "z")) 
        return "Z"
    else
        return ""
}

; If the character passed in is not an uppercase letter, returns ""
; Otherwise, returns the lowercase version of the uppercase letter passed in
get_lowercase(character) {
    if (StrCmp(character, "==", "A"))
        return "a"
    else if (StrCmp(character, "==", "B"))
        return "b"
    else if (StrCmp(character, "==", "C"))
        return "c"
    else if (StrCmp(character, "==", "D"))
        return "d"
    else if (StrCmp(character, "==", "E"))
        return "e"
    else if (StrCmp(character, "==", "F"))
        return "f"
    else if (StrCmp(character, "==", "G"))
        return "g"
    else if (StrCmp(character, "==", "H"))
        return "h"
    else if (StrCmp(character, "==", "I"))
        return "i"
    else if (StrCmp(character, "==", "J"))
        return "j"
    else if (StrCmp(character, "==", "K"))
        return "k"
    else if (StrCmp(character, "==", "L"))
        return "l"
    else if (StrCmp(character, "==", "M"))
        return "m"
    else if (StrCmp(character, "==", "N"))
        return "n"
    else if (StrCmp(character, "==", "O"))
        return "o"
    else if (StrCmp(character, "==", "P"))
        return "p"
    else if (StrCmp(character, "==", "Q"))
        return "q"
    else if (StrCmp(character, "==", "R"))
        return "r"
    else if (StrCmp(character, "==", "S"))
        return "s"
    else if (StrCmp(character, "==", "T"))
        return "t"
    else if (StrCmp(character, "==", "U"))
        return "u"
    else if (StrCmp(character, "==", "V"))
        return "v"
    else if (StrCmp(character, "==", "W"))
        return "w"
    else if (StrCmp(character, "==", "X"))
        return "x"
    else if (StrCmp(character, "==", "Y"))
        return "y"
    else if (StrCmp(character, "==", "Z"))
        return "z"
    else
        return ""
}

get_hotstring_text() {

    ; Short-circuit in certain conditions
    if((not prose_mode_should_be_active()) or in_raw_microstate()) {
        return ""
    }
    else if(currentBrief = "")
    { 
        return ""
    }

    firstCharacterOfBriefIsUppercase := False
    lowercaseCharacter := get_lowercase(SubStr(currentBrief, 1, 1))
    ; It could already be lowercase. For briefs, the first character will always be a letter,
    ; at least in my system
    if(lowercaseCharacter != "") {
        firstCharacterOfBriefIsUppercase := True
        currentBrief[1] := lowercaseCharacter
    }

    hotstringText := hotstrings[currentBrief]
    if(hotstringText != "") {
        ; If the opening delimiter is not one of the "inactive" ones = those that shouldn't activate hotstrings
        if(not contains(inactiveDelimiters, lastDelimiter)) {
            if(firstCharacterOfBriefIsUppercase) {
                ; The first letter of the brief might not be the same as the first character of the hotstring
                uppercaseCharacter := get_uppercase(SubStr(hotstringText, 1, 1))
                ; It could already be uppercase (due to the first character of the hotstring always being capitalized, as with 
                ; "I'm", or because the hotstring is for an all-caps acronym like "PBI"), or might not be a letter, etc.
                if(uppercaseCharacter != "") {
                    hotstringText := uppercaseCharacter . SubStr(hotstringText, 2)
                }
            }
            return hotstringText
        }
    }

    return ""
}

add_hotstring_expansion_if_triggering_hotstring(keysToReturn, hotstringText) {
    if(hotstringText != "") {
        ; The brief will be backspaced before the hotstring text is entered. We concatenate in reverse here
        ; since we are adding to the front of the return keys
        keysToReturn := hotstringText . keysToReturn
        Loop, Parse, currentBrief
        {
            keysToReturn := "{Backspace}" . keysToReturn
        }
    }
    return keysToReturn
}

; Should only be called on things that can trigger hostrings *and* do not reset entry variables
add_undo_keys_for_hotstring_expansion_if_triggering_hotstring(triggeringCharacter, undoKeys, hotstringText) {
    if(hotstringText != "") {
        ; The hotstring text will be backspaced before the brief text will be re-added
        ; All this happens *after* the undo behavior of the trigger key
        Loop, Parse, hotstringText
        {
            undoKeys := undoKeys . "{Backspace}"
        }
        undoKeys := undoKeys . currentBrief
    }
    return undoKeys
}

; Return permutations to implement hotstring functionality
;-------------------------------------------------

; This layout has hotstrings built-in for performance reasons (so as not to have even more applications hooking into keyboard input),
; and to deal with all the complex logic related to layers and intelligent backspacing. Every single return statement for an action/key 
; should be followed by one of these functions, which together represent an exhaustive set of possible return permutations vis-a-vis hotstring logic,
; including the fall-back hotstring_neutral_key() that is used for anything that doesn't at all interact with hotstrings. {Backspace} is an exception,
; since it has complex one-off logic.

; This function doesn't do anything, but is just here to make the code more readable/understandable
; through consistency. It implicitly makes it clear that things that call this are hotstring neutral.
; Used for things like {Esc}, {Tab}, +{Tab}, {Del}
hotstring_neutral_key(keysToReturn) {
    return keysToReturn
}

hotstring_trigger_action_key_untracked_reset_entry_related_variables(keysToReturn) {
    hotstringText := get_hotstring_text()
    keysToReturn := add_hotstring_expansion_if_triggering_hotstring(keysToReturn, hotstringText)
    reset_entry_related_variables()
    return keysToReturn
}

hotstring_trigger_delimiter_key_tracked(pressedKey, keysToReturn, undoKeys) {
    autospacingStack.push(autospacing)
    automatchingStack.push(automatching)
    sentKeysStack.push(pressedKey)
    hotstringText := get_hotstring_text()
    keysToReturn := add_hotstring_expansion_if_triggering_hotstring(keysToReturn, hotstringText)
    undoKeys := add_undo_keys_for_hotstring_expansion_if_triggering_hotstring(pressedKey, undoKeys, hotstringText)
    undoSentKeysStack.push(undoKeys)
    lastDelimiter := pressedKey
    currentBrief := ""
    return keysToReturn
}

hotstring_inactive_delimiter_key_tracked(pressedKey, keysToReturn, undoKeys) {
    autospacingStack.push(autospacing)
    automatchingStack.push(automatching)
    sentKeysStack.push(pressedKey)
    undoSentKeysStack.push(undoKeys)
    lastDelimiter := pressedKey
    currentBrief := ""
    return keysToReturn
}

hotstring_character_key(pressedKey, keysToReturn, undoKeys) {
    autospacingStack.push(autospacing)
    automatchingStack.push(automatching)
    sentKeysStack.push(pressedKey)
    undoSentKeysStack.push(undoKeys)
    currentBrief := currentBrief . pressedKey
    return keysToReturn
}

; Test for:
; - Empty stack
; - Clean case: several hotstring characters on top of stack, with a delimiter under them
; - Just delimiters: only delimiters on stack
; - Mixed: delimiters on top of stack, but hotstring characters under them, and then a delimiter under them
; - Bottom of stack rather than delimiter as cutoff point
update_hotstring_state_based_on_current_sent_keys_stack() {
    currentBrief := ""
    index := sentKeysStack.Length()
    While True {
        ; If you reach the end of the stack without having hit a delimiter,
        ; short circuit before trying to grab another lower thing on the stack,
        ; since there is no other lower thing on the stack
        if(index = 0) {
            lastDelimiter := ""
            break
        }
        else {
            characterOnStack := sentKeysStack[index]
            if(is_hotstring_character(characterOnStack)) {
                currentBrief := characterOnStack . currentBrief
            }
            else { ; character is delimiter
                lastDelimiter := characterOnStack
                break
            }
        }
        index := index - 1
    }
}

remove_word_from_top_of_stack() {
    keysToReturn := ""
    index := sentKeysStack.Length()
    haveAlreadyBackSpacedWord := False
    haveAlreadyBackspacedSpace := False
    While True {
        ; If we have backspaced everything on the sentKeysStack = are at the beginning of an entry,
        ; we stop backspacing stuff
        if(index = 0) {
            currentBrief := ""
            lastDelimiter := ""
            break
        }
        else {
            itemOnTopOfStack := sentKeysStack[index]
            isSpace := itemOnTopOfStack = "{Space}"
            isEnter := itemOnTopOfStack = "{Enter}"
            isAutospaced := (autospacingStack[index] = "autospaced") or (autospacingStack[index] = "cap-autospaced")

            ; If we have already backspaced a word and we hit a {Space} or {Enter} or a space
            ; coming from autospacing, we stop backspacing stuff
            if((isSpace or isEnter or isAutospaced) and haveAlreadyBackSpacedWord) {
                currentBrief := ""
                lastDelimiter := itemOnTopOfStack
                break
            }
            ; If we hit an {Enter} after backspacing one or more spaces (but have not yet
            ; backspaced a word), we still stop. This is the case of backspacing all leading
            ; spaces on a line, if they are used to indent something.
            else if(isEnter and haveAlreadyBackspacedSpace) {
                currentBrief := ""
                lastDelimiter := itemOnTopOfStack
                break
            }
            ; This case is for backspacing leading {Spaces}. This one can be a terminal case if one
            ; the leading spaces (the one lowest on the stack, positionally) was a hotstring trigger.
            ; In such a case, we do backspace the hotstring expansion, but then stop there.
            else if(isSpace) {
                sentKeysStack.pop()
                autospacingStack.pop()
                autospacing := autospacingStack[index - 1]
                if(manuallyAutomatching) {
                    automatchingStack.pop()
                    automatching := automatchingStack[index - 1]
                }
                undoKeys := undoSentKeysStack.pop()
                keysToReturn := keysToReturn . undoKeys
                if(last_press_had_triggered_hotstring(undoKeys)) {
                    update_hotstring_state_based_on_current_sent_keys_stack()
                    break
                }
                else {
                    haveAlreadyBackspacedSpace := True
                }
            }
            ; If an {Enter} is on top of the stack, we backspace it and stop right there. This {Enter}
            ; may have a triggered a hotstring, so we also have to deal with that.
            else if(isEnter and (not haveAlreadyBackSpacedWord) and (not haveAlreadyBackspacedSpace)) {
                sentKeysStack.pop()
                autospacingStack.pop()
                autospacing := autospacingStack[index - 1]
                if(manuallyAutomatching) {
                    automatchingStack.pop()
                    automatching := automatchingStack[index - 1]
                }
                undoKeys := undoSentKeysStack.pop()
                keysToReturn := keysToReturn . undoKeys
                if(last_press_had_triggered_hotstring(undoKeys)) {
                    update_hotstring_state_based_on_current_sent_keys_stack()
                }
                break
            }
            ; Otherwise, itemOnTopOfStack is a subset of a word (a single character could compose the entire word,
            ; as with the English indefinite article 'a'; itc is a subset, not a proper subset). This one is not a 
            ; terminal conditional branch, so we don't need to adjust the hotstring variables at all. Note that this
            ; case *will* delete autospaced punctuation at the end of words, which is what we want. So if the 
            ; sentKeysStack looked something like "one.two," and we were to trigger this function, this conditional
            ; case would actually remove the comma on top of the stack, but then the backspacing would stop with the
            ; period. (Since now haveAlreadyBackspacedWord would no longer be false). Clear as mud, right?
            else {
                sentKeysStack.pop()
                autospacingStack.pop()
                autospacing := autospacingStack[index - 1]
                if(manuallyAutomatching) {
                    automatchingStack.pop()
                    automatching := automatchingStack[index - 1]
                }
                undoKeys := undoSentKeysStack.pop()
                keysToReturn := keysToReturn . undoKeys
                if(last_press_had_triggered_hotstring(undoKeys)) {
                    update_hotstring_state_based_on_current_sent_keys_stack()
                    break
                }
                else {
                    haveAlreadyBackspacedWord := True
                }
            }

            index := index -1
        }
    }
    return keysToReturn
}

last_press_had_triggered_hotstring(undoKeys){
    StringRight, lastCharacterInUndoKeys, undoKeys, 1
    ; The only time we would have hotstring characters = letters and apostrophe
    ; sent in the undoKeys (at the end = re-adding them) is when the last press
    ; had triggered a hotstring
    return is_hotstring_character(lastCharacterInUndoKeys)
}

had_triggered_hotstring(key, undoKeys) {
    spaceUndoKeysIfNotTriggeringHostring := ["{Backspace}"]
    enterUndoKeysIfNotTriggeringHostring := ["{Backspace}", "{Backspace}{Space}"]
    if(key = "{Space}") {
        return (not contains(spaceUndoKeysIfNotTriggeringHostring, undoKeys))
    }
    else { ; key = "{Enter}"
        return (not contains(enterUndoKeysIfNotTriggeringHostring, undoKeys))
    }
}

; For helping in debugging
get_string_representation_of_sent_keys_stack() {
    stringRepresentation := "`n"
    index := sentKeysStack.Length()
    while index >= 1 {
        stringRepresentation := stringRepresentation . "`n" . sentKeysStack[index]
        index := index -1
    }
    return stringRepresentation
}
