; Test Number Lock and Caps Lock autolocking behavior

; Headers h1-h6 with hotstrings. Verify hotstring behavior with hotstrings including numbers,
; and also backspacing and backspacing by word

; Test function keys, function lock accessed from command layer

; Test modifiers

; Test raw leader and raw lock

; Test cancel key (to get out of modes/inlines styles, and also to just reset layer)

; Test prose mode and code mode

; Test manually getting back to base layer using Base Lock key

; Test action layer leader and lock as they are currently

; Test selection layer lock as it is currently, including with modified arrow key presses

; Test automatching of normal stuff likes parentheses and quotes, but also all the new inline styles
; Especially test adding Markdown links

; ----------------------------

; Allow for nested leader key presses (so can access Caps Leader > Inline Styles Leader, e.g.)
; without leader getting set to "" in key callbacks. Use a flag variable called is_leader_press
; and then do (if not is_leader_press leader := ""). Then always set is_leader_press := False
; in the universal key hook

; Allows accessing leader layers from other leader layers, basically

; DONE-ish - still have to modify Python code generator and regenerate keymap

; ----------------------------

; autospacing_stack -> autospacing_state_history_stack
; automatching_stack -> automatching_state_history_stack
; automatching -> automatching_stack

; DONE

; ----------------------------

; Inline styling: For now just get it working when in typing stream/insert
; = when accessed via Caps Leader

; Inline code, Bold, Italic, Bold Italic
; Link, inline LaTeX, definition/glossary shortcode
; Underline, strikethrough

; LaTeX:
; inlineMath: [['\\(', '\\)']],
; displayMath: [["\\[", "\\]"]],

; DONE

; ----------------------------

; Refactor Number and Caps layers to account for having only regualr and autlocking versions of keys (no locked versions)

; DONE

; ----------------------------

; CapSpacing ellipsis with first press being ; on Shift layer
; Refactor dot()

; DONE

; ----------------------------

; Number sequence entry

; Hundreds, thousands, millions, billions, trillions
; Add comma separators
; Dollar currency formatting

; DONE

; ----------------------------

; Voice recognition
; Rucking pack set up

; ----------------------------

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

; State Cancel Keys
;-------------------------------------------------

cancel() {
    leader := ""
    locked := "base"

    raw_state := ""
    in_raw_microstate := False

    modifier_state := ""
    mod_control_down := False
    mod_alt_down := False
    mod_shift_down := False

    return completely_internal_key()
}

insert_before() {
    leader := ""
    locked := "base"
    return completely_internal_key()
}

append_after() {
    leader := ""
    locked := "base"
    return completely_internal_key()
}

; Input State Keys
;-------------------------------------------------

toggle_prose() {
    leader := ""
    locked := "base"
    input_state := "prose"
    return completely_internal_key()
}

toggle_code() {
    leader := ""
    locked := "base"
    input_state := "code"
    return completely_internal_key()
}

; Raw state Keys
;-------------------------------------------------

raw_leader() {
    leader := ""
    locked := "base"
    raw_state := "leader"
    return completely_internal_key()
}

raw_lock() {
    leader := ""
    locked := "base"
    raw_state := "lock"
    return completely_internal_key()
}

; Modifier State Keys
;-------------------------------------------------

mod_control_leader() {
    leader := ""
    locked := "base"
    modifier_state := "leader"
    mod_control_down := True
    return completely_internal_key()
}

mod_alt_leader() {
    leader := ""
    locked := "base"
    modifier_state := "leader"
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift_leader() {
    leader := ""
    locked := "base"
    modifier_state := "leader"
    mod_shift_down := True
    return completely_internal_key()
}

mod_control_lock() {
    leader := ""
    locked := "base"
    modifier_state := "lock"
    mod_control_down := True
    return completely_internal_key()
}

mod_alt_lock() {
    leader := ""
    locked := "base"
    modifier_state := "lock"
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift_lock() {
    leader := ""
    locked := "base"
    modifier_state := "lock"
    mod_shift_down := True
    return completely_internal_key()
}

mod_control() {
    ; Actuated from base layer, so no need to lock it
    mod_control_down := True
    return completely_internal_key()
}

mod_alt() {
    ; Actuated from base layer, so no need to lock it
    mod_alt_down := True
    return completely_internal_key()
}

mod_shift() {
    ; Actuated from base layer, so no need to lock it
    mod_shift_down := True
    return completely_internal_key()
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

uppercase_a_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("A")
}

uppercase_b_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("B")
}

uppercase_c_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("C")
}

uppercase_d_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("D")
}

uppercase_e_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("E")
}

uppercase_f_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("F")
}

uppercase_g_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("G")
}

uppercase_h_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("H")
}

uppercase_i_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("I")
}

uppercase_j_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("J")
}

uppercase_k_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("K")
}

uppercase_l_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("L")
}

uppercase_m_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("M")
}

uppercase_n_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("N")
}

uppercase_o_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("O")
}

uppercase_p_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("P")
}

uppercase_q_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("Q")
}

uppercase_r_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("R")
}

uppercase_s_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("S")
}

uppercase_t_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("T")
}

uppercase_u_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("U")
}

uppercase_v_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("V")
}

uppercase_w_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("W")
}

uppercase_x_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("X")
}

uppercase_y_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("Y")
}

uppercase_z_autolock_caps_layer() {
    return uppercase_letter_key_autolock_caps_layer("Z")
}

; Numbers
;-------------------------------------------------

; ASCII 48 (base 10)
zero() {
    return number_key("0")
}

; ASCII 49 (base 10)
one() {
    return number_key("1")
}

; ASCII 50 (base 10)
two() {
    return number_key("2")
}

; ASCII 51 (base 10)
three() {
    return number_key("3")
}

; ASCII 52 (base 10)
four() {
    return number_key("4")
}

; ASCII 53 (base 10)
five() {
    return number_key("5")
}

; ASCII 54 (base 10)
six() {
    return number_key("6")
}

; ASCII 55 (base 10)
seven() {
    return number_key("7")
}

; ASCII 56 (base 10)
eight() {
    return number_key("8")
}

; ASCII 57 (base 10)
nine() {
    return number_key("9")
}

zero_autolock_number_layer() {
    return number_key_autolock_number_layer("0")
}

one_autolock_number_layer() {
    return number_key_autolock_number_layer("1")
}

two_autolock_number_layer() {
    return number_key_autolock_number_layer("2")
}

three_autolock_number_layer() {
    return number_key_autolock_number_layer("3")
}

four_autolock_number_layer() {
    return number_key_autolock_number_layer("4")
}

five_autolock_number_layer() {
    return number_key_autolock_number_layer("5")
}

six_autolock_number_layer() {
    return number_key_autolock_number_layer("6")
}

seven_autolock_number_layer() {
    return number_key_autolock_number_layer("7")
}

eight_autolock_number_layer() {
    return number_key_autolock_number_layer("8")
}

nine_autolock_number_layer() {
    return number_key_autolock_number_layer("9")
}

; Prose Punctuation
;-------------------------------------------------

; ASCII 39 (base 10)
apostrophe() {
    return normal_key("'")
}

; ASCII 45 (base 10)
hyphen() {
    return inactive_delimiter_key("-")
}

en_dash() {
    return normal_key("–", False)
}

em_dash() {
    return normal_key("—", False)
}

; ASCII 47 (base 10)
back_slash() {
    return normal_key("/")
}

; ASCII 44 (base 10)
comma() {
    ; Autospaces in code too. One of the few things to do so
    return no_cap_punctuation_key(",")
}

; ASCII 59 (base 10)
semicolon() {
    ; Autospaces in code too. One of the few things to do so
    return no_cap_punctuation_key(";")
}

; ASCII 58 (base 10)
colon() {
    ; Autospaces in code too. One of the few things to do so
    ; Used for properties in CSS, and also used a lot in JSON.
    ; Also used for declaring types in Typescript
    return no_cap_punctuation_key(":", False)
}

; ASCII 46 (base 10)
period() {
    if(prose_mode_should_be_active()) {

        is_modifiers_press := (modifier_state == "leader" or modifier_state == "locked")
        is_hint_actuation_press := presses_left_until_hint_actuation > 0
        is_raw_press := (raw_state == "leader" or raw_state == "lock" or in_raw_microstate())
        expect_autospaced_period :=  (not is_modifiers_press) and
                                (not is_hint_actuation_press) and
                                (not is_raw_press)

        ; Don't even do checks for ellipsis expansion unless actually going to enter
        ; a period character (as opposed to a modifier combo, etc.)
        if(expect_autospaced_period) {
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
            ; Multiple consecutive presses after pressing Shift Leader = transform into ellipsis *with* capitalization.
            ; Semicolon is the character on the same position as period on Shift Leader, which is why we check
            ; its value when looking at one_key_back
            else if(one_key_back = ";") {
                autospacing := "cap-autospaced"
                keys_to_return := "{Backspace 2}" . ".." . "{Space}"
                undo_keys := "{Backspace 3};{Space}"
                ; The name we use for the keypress on the stack is important. It can't simply be "."
                ; because then we would trigger the non-capitlized ellipsis conditional case above.
                ; Using this name means we'll fall through to the normal behavior below on the third press,
                ; which is what we want since that will complete an autospaced autocapitalized ellipsis.
                return hotstring_trigger_delimiter_key_tracked("cap-ellipsis", keys_to_return, undo_keys)
            }
            ; Normal period behavior
            else {
                return cap_punctuation_key(".")
            }
        }
        ; It also follows the normal pattern for all modifier, hint actuation, and raw presses
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

; ASCII 34 (base 10)
quotes() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("""", """", False)
    }
    ; Let text editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("""", False)
    }
}

single_quotes() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("'", "'", False)
    }
    ; Let text editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("'", False)
    }
}

; ASCII 40 (base 10)
open_parenthesis() {
    if(prose_mode_should_be_active()) {
        return matched_pair_key("(", ")", False)
    }
    ; Let text editors handle auto-pairing
    else { ; Code mode is active
        return normal_key("(", False)
    }
}

; ASCII 41 (base 10)
; Functions similarly in prose and code input modes.
; Just lacks the trailing {Space} and autospacing in code mode
close_parenthesis() {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(")", False)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else if(presses_left_until_hint_actuation = 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
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
        else {
            stack_entry := automatching_stack.Pop()
            first_character := SubStr(stack_entry, 1, 1)
            ; Representing the fact that this stack entry corresponds to between_characters
            ; rather than opening_characters or closing_characters
            is_between_characters_completion := first_character == "b"
            automatch_characters := ""
            if(is_between_characters_completion) {
                ; From second character in string to the end of the string
                automatch_characters := SubStr(stack_entry, 2)
            }
            else {
                ; No leading "b" in this case
                automatch_characters := stack_entry
            }
            if(autospacing = "autospaced") {
                keys_to_return := "{Backspace}"
                Loop % automatch_characters.Length() {
                    keys_to_return := keys_to_return . "{Right}"
                }
                undo_keys := ""
                if(not is_between_characters_completion) {
                    keys_to_return := keys_to_return . "{Space}"
                    undo_keys := undo_keys . "{Backspace}"
                }
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Left}"
                }
                undo_keys := undo_keys . "{Space}"
            }
            ; Pass through capitalization
            else if (autospacing = "cap-autospaced") {
                keys_to_return := "{Backspace}"
                Loop % automatch_characters.Length() {
                    keys_to_return := keys_to_return . "{Right}"
                }
                undo_keys := ""
                if(not is_between_characters_completion) {
                    keys_to_return := keys_to_return . "{Space}"
                    undo_keys := undo_keys . "{Backspace}"
                }
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Left}"
                }
                undo_keys := undo_keys . "{Space}"
            }
            else { ; autospacing = "not-autospaced"
                autospacing := "autospaced"
                keys_to_return := ""
                Loop % automatch_characters.Length() {
                    keys_to_return := keys_to_return . "{Right}"
                }
                undo_keys := ""
                if(not is_between_characters_completion) {
                    keys_to_return := keys_to_return . "{Space}"
                    undo_keys := undo_keys . "{Backspace}"
                }
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Left}"
                }
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
            ; When we are manually automatching = taking typing tests, we will never have
            ; between_characters completion to worry about. So we can keep this function
            ; a bit simpler than the instant automatching equivalent defined above
            automatch_characters := automatching_stack.Pop()
            if(autospacing = "autospaced") {
                keys_to_return := "{Backspace}" . automatch_characters . "{Space}"
                undo_keys := "{Backspace}"
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Backspace}"
                }
                undo_keys := undo_keys . "{Space}"
            }
            ; Pass through capitalization
            else if (autospacing = "cap-autospaced") {
                keys_to_return := "{Backspace}" . automatch_characters . "{Space}"
                undo_keys := "{Backspace}"
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Backspace}"
                }
                undo_keys := undo_keys . "{Space}"
            }
            else { ; autospacing = "not-autospaced"
                autospacing := "autospaced"
                keys_to_return := automatch_characters . "{Space}"
                undo_keys := "{Backspace}"
                Loop % automatch_characters.Length() {
                    undo_keys := undo_keys . "{Backspace}"
                }
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
    ; Let text editors handle auto-pairing
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

; Symbols / Remaining Characters
;-------------------------------------------------

; This one is weird since we want the character saved in
; sent_keys_stack to be "dot" rather than ".", so that there
; is no confusion with period.
dot() {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(".", can_be_modified)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    ; In AceJump flags, it is only ever the first press that
    ; may end up a non-letter character. This is because the 
    ; plugin uses the capitalization of the second character
    ; (always a letter) to control its jump_selecting behavior.
    else if(presses_left_until_hint_actuation = 2) {
        presses_left_until_hint_actuation := presses_left_until_hint_actuation - 1
        ; Always comes after jump key that clears sent_keys_stack
        return hotstring_neutral_key(".")
    }
    else {
        return number_formatter("dot", "", "")
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

; ASCII 60 (base 10)
less_than() {
    ; Let text editors handle auto-pairing when in HTML etc. files
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
    ; Let text editors handle auto-pairing
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

; Number Lock Special Keys
;-------------------------------------------------

number_lock_colon() {
    return normal_key(":", False)
}


add_commas_to_non_decimal_portion(non_decimal_portion) {
    num_digits := non_decimal_portion.Length()
    ; With three or less digits, we don't add any commas at all
    if(num_digits <= 3) {
        return non_decimal_portion
    }
    else{
        new_non_decimal_portion := ""
        Loop % num_digits {
            ; We add a comma after every third digit, unless that digit is the end of the non_decimal_portion
            if((Mod(A_Index, 3) == 0) and (A_Index != num_digits)) {
                new_non_decimal_portion := new_non_decimal_portion . non_decimal_portion[A_Index] . ","
            }
            else {
                new_non_decimal_portion := new_non_decimal_portion . non_decimal_portion[A_Index]
            }
        }
    return new_non_decimal_portion
    }
}


; eleven thousand two hundred = 112{hundred} --> 11,200
; five hundred thousand = 5{hundred}{thousand} --> 500,000
; seven hundred dollars = 7{hundred}{dollars} --> $700

; This is a helper method used to do most of the number formatting
; If zeroes_to_add = "" this function will just add commas to
; the number. Otherwise, it will add zeroes, and then add commas.
; It is smart enough to not try to add commas if a currency operation
; follows an operation that has already added commas (thousand, e.g.).
; It will also eat presses that don't make sense (thousand followed by
; billion, e.g.).
number_formatter(operation_name, zeroes_to_add, currency_symbol_to_add) {

    ; Eat keypress if have nothing on sent_keys_stack := just moved location or whatever
    i := sent_keys_stack.Length()
    if(i == 0) {
        return eat_keypress()
    }

    ; Get string representing all the contiguous number-related presses on the top of the stack.
    ; Dot included, for decimal numbers.
    ; -----------------------------------------------------
    ; There are five cases we have, based upon how the number looks:
    ;   . (just decimal point, has_decimal == True)
    ;   111 (just non_decimal_portion, has_decimal == False)
    ;   111. (just non_decimal_portion, has_decimal == True)
    ;   .111 (just decimal_portion, has_decimal == True)
    ;   111.111 (both decimal and non_decimal portions, has_decimal == True)
    commas_already_added := False
    numbers := ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    has_decimal := False
    non_decimal_portion := ""
    decimal_portion := ""
    While (i >= 1) {
        stack_item := sent_keys_stack[i]
        if(contains(numbers, stack_item)) {
            non_decimal_portion := stack_item . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "hundred") {
            commas_already_added := True
            non_decimal_portion := "00" . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "thousand") {
            commas_already_added := True
            non_decimal_portion := "000" . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "million") {
            commas_already_added := True
            non_decimal_portion := "000000" . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "billion") {
            commas_already_added := True
            non_decimal_portion := "000000000" . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "trillion") {
            commas_already_added := True
            non_decimal_portion := "000000000000" . non_decimal_portion
            i := i - 1
        }
        else if(stack_item == "dot") {
            commas_already_added := True
            has_decimal := True
            decimal_portion := non_decimal_portion
            non_decimal_portion := ""
            i := i - 1
        }
        else if(stack_item == "add_commas") {
            commas_already_added := True
            i := i - 1
        }
        else {
            break
        }
    }

    ; Short circuit if there are no number related presses on top of stack.
    ; Most operations will simply not do anything if they don't follow a number sequence.
    ; Dot is an exception, since it can be used after letters etc. in some cases (usernames, e.g.)
    if(non_decimal_portion == "" and decimal_portion == "" and (not has_decimal)) {
        if(operation_name == "dot") {
            return hotstring_inactive_delimiter_key_tracked("dot", ".", "{Backspace}")
        }
        else {
            return eat_keypress()
        }
    }

    ; Also short circuit if we are adding a decimal point but there are already one
    ; or more present in the number string. Cf. IP addresses and sections in documents
    ; (like section A.1.5, or whatever)
    if(operation_name == "dot" and has_decimal) {
        return hotstring_inactive_delimiter_key_tracked("dot", ".", "{Backspace}")
    }

    ; Also short circuit if we are adding a decimal point and we don't have any commas to add
    ; TODO: what if you have something like "Manual section 4200.1"? Raw dot then?
    if((operation_name == "dot") and (not commas_already_added) and (non_decimal_portion.Length() <= 3)) {
        return hotstring_inactive_delimiter_key_tracked("dot", ".", "{Backspace}")
    }

    ; Get string representing the old_number, including any added commas
    if(commas_already_added) {
        non_decimal_portion := add_commas_to_non_decimal_portion(non_decimal_portion)
    }
    old_number := non_decimal_portion
    if(has_decimal) {
        old_number := old_number . "." . decimal_portion
    }
     
    ; In practice, has_decimal controls whether zeroes get added to the decimal or
    ; non_decimal portion, and since commas only ever get added to the non-decimal
    ; portion, they are neither here nor there when it comes to the five cases
    ; enumerated above
    new_non_decimal_portion := ""
    new_decimal_portion := ""
    new_number := ""
    if(has_decimal) {
        ; First add zeroes, if applicable
        new_decimal_portion := decimal_portion . zeroes_to_add
        ; Then add commas, if applicable
        if(needs_commas_added) {
            new_non_decimal_portion := add_commas_to_non_decimal_portion(non_decimal_portion)
        }
        new_number := new_non_decimal_portion . "." . new_decimal_portion
        ; Then add currency symbol, if applicable
        if(currency != "") {
            currency_properties := currency_map[currency]
            currency_symbol := currency_properties["symbol"]
            symbol_location := currency_properties["symbol_location"]
            if(symbol_location == "prefix") {
                new_number := currency_symbol . new_number
            }
            else if(symbol_location == "postfix") {
                new_number := new_number . currency_symbol
            }
        }
    }
    else {
        ; First add zeroes, if applicable
        new_non_decimal_portion := non_decimal_portion . zeroes_to_add
        ; Then add commas, if applicable
        if(needs_commas_added) {
            new_non_decimal_portion := add_commas_to_non_decimal_portion(new_non_decimal_portion)
        }
        ; Then add decimal point, if applicable (will be mutually exclusive with adding
        ; zeroes, in practice. Dot operation vs. hundred, thousand, etc.)
        if(operation_name == "dot") {
            new_non_decimal_portion := new_non_decimal_portion . "."
        }
        new_number := new_non_decimal_portion
        ; Then add currency symbol, if applicable
        if(currency != "") {
            currency_properties := currency_map[currency]
            currency_symbol := currency_properties["symbol"]
            symbol_location := currency_properties["symbol_location"]
            if(symbol_location == "prefix") {
                new_number := currency_symbol . new_number
            }
            else if(symbol_location == "postfix") {
                new_number := new_number . currency_symbol
            }
        }
    }

    ; For efficiency's sake, we only want to be backspacing/re-adding the bare minimum.
    ; What that means: if the old_number and new number share the first few characters,
    ; there is no point in backspacing them only to add the exact same characters back.
    ; So we need to figure out how many "shared" characters there are. There are some additional
    ; wrinkles too:
    ;   - Any time you are using a currency with a prefix symbol location, there will be nothing
    ;     shared, since the currency symbol needs to go before everything else that was there.
    ;   - Commas count. In practice this mostly comes into play with the dot operator if it 
    ;     follows like hundred, thousand, etc., since commas would already have been added in
    ;     such a case.
    old_number_with_shared_removed := old_number
    new_number_with_shared_removed := new_number
    Loop % old_number.Length() {
        if(old_number[A_Index] == new_number[A_Index]) {
            old_number_with_shared_removed := SubStr(old_number_with_shared_removed, 2)
            new_number_with_shared_removed := SubStr(new_number_with_shared_removed, 2)
        }
        else {
            break
        }
    }

    ; For keys_to_return, we want to backspace the old number, and then send the
    ; new formatted number (with zeroes and/or commas added as applicable).
    keys_to_return := ""
    Loop % old_number_with_shared_removed.Length() {
        keys_to_return := keys_to_return . "{Backspace}"
    }
    keys_to_return := keys_to_return . new_number_with_shared_removed
    
    ; For undo_keys, we want to backspace the new number, and then re-send the
    ; old number
    undo_keys := ""
    Loop % new_number_with_shared_removed.Length() {
        undo_keys := undo_keys . "{Backspace}"
    }
    undo_keys := undo_keys . old_number_with_shared_removed

    ; We don't need to be triggering hotstrings with formatting operations on numbers
    hotstring_inactive_delimiter_key_tracked(operation_name, keys_to_return, undo_keys)
}

number_lock_format_with_commas() {
    return number_formatter("add_commas", "", "")
}

number_lock_hundred() {
    return number_formatter("hundred", "00", "")
}

number_lock_thousand() {
    return number_formatter("thousand", "000", "")
}

number_lock_million() {
    return number_formatter("million", "000000", "")
}

number_lock_billion() {
    return number_formatter("billion", "000000000", "")
}

number_lock_trillion() {
    return number_formatter("trillion", "000000000000", "")
}

number_lock_format_as_dollars() {
    return number_formatter("dollars", "", "dollars")
}

number_lock_format_as_other_other_currency(currency) {
    return number_formatter(currency, "", currency)
}

number_lock_write_out_number() {
    ; TODO
}


; Inline things (bold styling, italic styling, links, footnotes, etc.)
;-------------------------------------------------

insert_bold() {
    if(prose_language == "markdown") {
        return matched_pair_key("**", "**")
    }
    else if(prose_language == "org") {
        return matched_pair_key("*", "*")
    }
}

insert_italic() {
    if(prose_language == "markdown") {
        return matched_pair_key("*", "*")
    }
    else if(prose_language == "org") {
        return matched_pair_key("/", "/")
    }
}

insert_bold_italic() {
    if(prose_language == "markdown") {
        return matched_pair_key("***", "***")
    }
    else if(prose_language == "org") {
        return matched_pair_key("*/", "/*")
    }
}

insert_inline_code() {
    if(prose_language == "markdown") {
        return matched_pair_key("``", "``")
    }
    else if(prose_language == "org") {
        return matched_pair_key("~", "~")
    }
}

insert_inline_latex() {
    if(prose_language == "markdown") {
        return matched_pair_key("\( ", " \)")
    }
    else if(prose_language == "org") {
        return matched_pair_key("\( ", " \)")
    }
}

insert_strikethrough() {
    if(prose_language == "markdown") {
        return matched_pair_key("~~", "~~")
    }
    else if(prose_language == "org") {
        return matched_pair_key("+", "+")
    }
}

insert_underline() {
    if(prose_language == "markdown") {
        return matched_pair_key("<u>", "</u>")
    }
    else if(prose_language == "org") {
        return matched_pair_key("_", "_")
    }
}

; You don't have to use this, since verbatim is often styled the same as code in practice.
; Some people do prefer to preserve a semantic distinction between the usages though. For example,
; In setting apart variable names vs. file paths.
; I personally just use code for everything, so don't have this bound in my layout.
; https://emacs.stackexchange.com/questions/77820/code-vs-verbatim
; https://stackoverflow.com/questions/18991981/difference-between-code-and-verbatim-in-org-mode
; https://irreal.org/blog/?p=11123
; https://www.wisdomandwonder.com/emacs/13918/choosing-between-code-and-verbatim-markup-in-org-mode
insert_verbatim() {
    if(prose_language == "markdown") {
        ; Does not exist in markdown
        return eat_keypress()
    }
    else if(prose_language == "org") {
        return matched_pair_key("=", "=")
    }
}

insert_link() {
    if(prose_language == "markdown") {
        two_blank_construct("[", "](", ")")
    }
    else if(prose_language == "org") {
        two_blank_construct("[[", "][", "]]", False)
    }
}

insert_footnote() {
    if(prose_language == "markdown") {
        return matched_pair_key("[^", "]")
    }
    else if(prose_language == "org") {
        return matched_pair_key("[fn:", "]")
    }
}

; This is a hugo shortcode I use
insert_definition_shortcode() {
    if(prose_language == "markdown") {
        return matched_pair_key("{{% def """, """ %}}")
    }
    else if(prose_language == "org") {
        return matched_pair_key("{{% def """, """ %}}")
    }
}

; Whitespace Characters (Space, Enter, Tab)
;-------------------------------------------------

; ASCII 32 (base 10)
space() {
    if(modifier_state == "leader" or modifier_state == "locked") {
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

enter() {
    if(modifier_state == "leader" or modifier_state == "locked") {
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

tab() {
    if(modifier_state == "leader" or modifier_state == "locked") {
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

; Backspace (by character and by word)
;-------------------------------------------------

; TODO: handle behavior when using colon as semicolon too
; TODO: make work with matchedPairStack

; TODO: make work with automatic locking of number and caps. Will have to track that state too, just like autospacing?

backspace() {
    keys_to_return := ""
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Backspace}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else if(presses_left_until_hint_actuation = 1) { 
        presses_left_until_hint_actuation := presses_left_until_hint_actuation + 1
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
            autospacing_state_history_stack.pop()
            autospacing := autospacing_state_history_stack[autospacing_state_history_stack.Length()]

            ; Same deal with the automatching
            automatching_state_history_stack.pop()
            automatching_stack := automatching_state_history_stack[automatching_state_history_stack.Length()]
            
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

; Function Keys
;-------------------------------------------------

function_f1() {
    return modifiable_hotstring_trigger_action_key("{F1}")
}

function_f2() {
    return modifiable_hotstring_trigger_action_key("{F2}")
}

function_f3() {
    return modifiable_hotstring_trigger_action_key("{F3}")
}

function_f4() {
    return modifiable_hotstring_trigger_action_key("{F4}")
}

function_f5() {
    return modifiable_hotstring_trigger_action_key("{F5}")
}

function_f6() {
    return modifiable_hotstring_trigger_action_key("{F6}")
}

function_f7() {
    return modifiable_hotstring_trigger_action_key("{F7}")
}

function_f8() {
    return modifiable_hotstring_trigger_action_key("{F8}")
}

function_f9() {
    return modifiable_hotstring_trigger_action_key("{F9}")
}

function_f10() {
    return modifiable_hotstring_trigger_action_key("{F10}")
}

function_f11() {
    return modifiable_hotstring_trigger_action_key("{F11}")
}

function_f12() {
    return modifiable_hotstring_trigger_action_key("{F12}")
}

; Movement and Selection (including physical key actions Left/Up/Down/Right and Home/PgUp/PgDn/End)
;-------------------------------------------------

left() {
    return modifiable_hotstring_trigger_action_key("{Left}")
}

up() {
    return modifiable_hotstring_trigger_action_key("{Up}")
}

down() {
    return modifiable_hotstring_trigger_action_key("{Down}")
}

right() {
    return modifiable_hotstring_trigger_action_key("{Right}")
}

home() {
    return modifiable_hotstring_trigger_action_key("{Home}")
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

; Actions (including physical key actions Del, Esc, Insert, Scroll Lock)
;-------------------------------------------------

delete() {
    return modifiable_hotstring_neutral_action_key("{Delete}")
}

escape() {
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo("{Escape}")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; Clears certain microstates
        in_raw_microstate := False
        presses_left_until_hint_actuation := 0

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