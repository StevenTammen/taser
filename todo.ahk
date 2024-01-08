/*

x Rename to key types and assignable keys, rather than actions
x Make cancel function clear leader and lock base

Add conditional checks to modifier key locations on base lock layer. Make all modifier leader and lock keys lock base layer (always start modifiers from base layer)




*/





; TODO
; Add optional paremeter to most helper functions called can_be_modified, and then pass it 
;through to modifiers method. short circut if key cannot be modified. Defaults to true, so
; only short circuits if you explicitly passs false in as parameter
;
; colon (special with numbers -- needs to be semicolon in some cases), including backspace behavior
;
; Comma between numbers for thousands separators, but still works for like "there were 50, 5 of which were done"
;
; write up why not Shift + Tab but put semicolon on shift layer too

; Layer keys

; modifiers

; Mapping keys to layers

; Building out actual layout (after mapping keys to layers, mapping layers to physical keypresses)

; Resetting Kinesis layout, then reconfiguring to exact replica of what TBK Mini will be

; Testing thoroughly

; Test sendlevel, make briefs for I'm, I'll, I've, you're, etc. using regular expression triggers

; List of keys still autospaced when input mode is code:
; Space
; Comma
; Colon (datatypes in Typeascript, properties in JSON, Python blocks)
; ([{ (properly handle autospaced keys that come after, just ! for now I think)
; Exclamation mark (used in != and as prefix for logical not)
; Assignment operator
; ) = {Right}{Space}, maintains same behavior of getting out of pair
; Tab becomes 4 spaces (when terminal or editor not focused)
; Enter still deletes trailing spaces. No autocapitalization though



; TODO: allow for customization with .ini file



; TODO: Hotstrings are stored in a separate include file






; Microstate Variables
;-------------------------------------------------

; In my terminology, when you are in a microstate, some keypresses are a bit different
; than normal in some way, until an exit condition is met. For example, for the AceJump 
; microstate, the number of keypresses until jump is tracked, so that the jump select behavior
; can be a prefix hotkey, rather than having to worry about capitalizing the last letter in
; flags. As another example, all autospacing is disabled when the raw microstate is active.

; Escape, Enter, and Tab are common means of exiting microstates

; What is AceJump? See https://github.com/acejump/AceJump
; ---
; This variable is for tracking AceJump state for the purpose of jump selecting 
; using a prefix keypress. This is kind of janky, but I'm too lazy to go submit 
; an issue or PR for the open source project to figure out how to do it in the 
; plugin itself.
; ---
; Possible values: {0, 1, 2}. Flags themselves are two presses. 2 means we still need
; to type 2 characters to activate the flag. 1 means only one more character. And 0 means
; the AceJump microstate is not active
global presses_left_until_jump := 0

; There are two types of jumps: moving and selecting. For AceJump,
; sending a capital letter for the second flag character will lead
; to jump_selecting instead of just jumping. This variable is set upfront
; for each jump operation, and controls whether the second letter character
; will be sent capitalized or not.
global jump_selecting := False





; Unused Virtual Keys
;-------------------------------------------------

; These are mappable virtual keys that are still unused in this layout,
; at present

; "VK0E"
; "VK0F"
; "VK16"
; "VK1A"
; "VK3A"
; "VK3B"
; "VK3C"
; "VK3D"
; "VK3E"
; "VK3F"
; "VK40"
; "VK88"
; "VK89"
; "VK8A"
; "VK8B"
; "VK8C"
; "VK8D"





; Layer State Variables
;-------------------------------------------------

; These are listed here in the logical order they are checked
; (order prioririty). The order is somewhat arbitrary. All rules like
; "A must come before B" and "C must come before D" are followed, but
; the arbitrariness comes from not caring whether it is ABCD or CDAB
; or ACBD or CABD or ACDB or CADB. Any of those would work. It just
; can't be any of the orders that violate one or more of the rules.

; Needs to come before Shift (Func accessed by Shift -> Func)
global funcLeader := False
global funcDownNoUp := False
global funcLocked := False
global isFuncLayerPress := False
global lastFuncLayerPress := 0

; Needs to come before Nav (ShiftClipboard can be accessed on Nav layer)
; This one is a bit weird, since it is only checked as a layer for certain keys
; (letters = clipboard registers)
global shiftClipboardLeader := False
global shiftClipboardDownNoUp := False
global isShiftClipboardLayerPress := False
global lastShiftClipboardLayerPress := 0

; Needs to come before Nav (Clipboard can be accessed on Nav layer)
; This one is a bit weird, since it is only checked as a layer for certain keys
; (letters = clipboard registers, and then action keys that are not Num, Shift,
; or punctuation). Not Num, Shift, and punctuation so that the Clipboard layer
; enables raw functionality for autospaced things
global clipboardLeader := False
global clipboardDownNoUp := False
global isClipboardLayerPress := False
global lastClipboardLayerPress := 0

; Needs to come before Nav (ShiftNav accessed by Nav -> ShiftNav)
global shiftNavLeader := False
global shiftNavDownNoUp := False
global shiftNavLocked := False
global isShiftNavLayerPress := False
global lastShiftNavLayerPress := 0

; Needs to come before Num (Nav can be accessed on Num layer, when Num layer is locked)
global navLeader := False
global navDownNoUp := False
global navLocked := False
global navFirst := False
global isNavLayerPress := False
global lastNavLayerPress := 0

global numLeader := False
global numDownNoUp := False
global numLocked := False
global numFirst := False
global isNumLayerPress := False
global lastNumLayerPress := 0

global shiftLeader := False
global shiftDownNoUp := False
global shiftLocked := False
global shiftFirst := False
global isShiftLayerPress := False
global lastShiftLayerPress := 0

; Customizable Thresholds
;-------------------------------------------------

; The number of milliseconds that have to elapse before a second press of
; a layer key will not trigger the double press action, but instead
; get off the layer altogether. (Used if you changed your mind).
global doubleTapThreshold := 500

; The number of milliseconds that have to elapse before releasing a layer
; key will not trigger any layer behavior at all. Will only happen if you
; do not press any other keys after starting to hold the layer down. This is
; another threshold value used if you change your mind.
global changedMindThreshold := 500




; TODO
#Include <window-management>
#Include <desktop-management>




; Actions
; Templates
; Languages
; Apostrophe layer for diacritics

; Greek
; Hebrew
; Russian
; Ukranian




; Thumb keys working properly with layers

; Wire up modifiers for real

; paste, cut, copy definitions

; Hotstrings with send level?







normal_key_except_between_numbers(character, can_be_modified := True) {
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
        keys_to_return := ""
        undo_keys := ""
        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        if(sent_keys_stack_length >= 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }
        if(is_number(one_key_back)) {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else {
            autospacing := "not-autospaced"
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        ; The is_number case will never trigger a hotstring, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_trigger_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}

inactive_delimiter_key_except_between_numbers(character, can_be_modified := True) {
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
        keys_to_return := ""
        undo_keys := ""
        sent_keys_stack_length := sent_keys_stack.Length()
        one_key_back := ""
        if(sent_keys_stack_length >= 1) {
            one_key_back := sent_keys_stack[sent_keys_stack_length]
        }
        if(is_number(one_key_back)) {
            keys_to_return := "{Backspace}" . character . "{Space}"
            undo_keys := "{Backspace 2}{Space}"
        }
        else {
            autospacing := "not-autospaced"
            keys_to_return := character
            undo_keys := "{Backspace}"
        }
        ; The is_number case will never trigger a hotstring, but whatever.
        ; The conditionals inside the called logic will take care of it just fine.
        return hotstring_inactive_delimiter_key_tracked(character, keys_to_return, undo_keys)
    }
}



; -----------------------------------------

; Right now, I use this to make the colon key act like semicolon in modifier combinations
; Most of the rest of the time having the character in modifiers match the character
; sent normally makes sense
no_cap_punctuation_key_specify_mod_char(character, mod_character, can_be_modified := True) {
    if(modifier_state == "leader" || modifier_state == "locked") {
        keys_to_return := build_modifier_combo(mod_character, can_be_modified)
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

; For keys like comma, semicolon, colon in prose mode
no_cap_punctuation_key(character, can_be_modified := True) {
    ; Split out like this because of :
    ; It needs to act like ; in modifier combos
    return no_cap_punctuation_key_specify_mod_char(character, character, can_be_modified)
}
