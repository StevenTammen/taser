universal_keypress_hook(pressed_key) {

    ; This code is necessary to automatically exit the Caps Lock and Number
    ; Lock layers implicitly, without having to explicitly re-lock base.

    ; Note that any time you have a leader press (e.g., Shift Leader), you are already 
    ; resetting leader and locked state. The resetting in this hook may not always be necessary,
    ; then, but it will never be wrong per se, and that is why it can end up here in this
    ; universal hook that runs on absolutely every key press.

    ; At present, there is no way to distinguish between numbers that were entered from
    ; Number Leader vs. those entered from Number Lock. Same deal for uppercase letters
    ; too: there is no way to tell from the sent_keys_stack whether an uppercase letter
    ; came from Shift Leader, Caps Leader, or Caps Lock. In practice, none of this is a
    ; problem. These conditionals don't just check if the pressed key is an
    ; uppercase letter or a number, but also check if locked = "caps" or "number",
    ; respectively. So that handles the Shift Leader case. It actually doesn't matter
    ; for Caps and Number whether the press is on the Leader vs. Lock versions of those
    ; layers, since for number and uppercase letter presses, locked will be set equal to "number"
    ; or "caps" already, before you even get to this hook. (And thus the right thing will
    ; happen).
    if((locked == "caps") && (not is_caps_lock_press(pressed_key))) {
        locked := "base"
    }
    else if((locked == "number") && (not is_number_lock_press(pressed_key))) {
        locked := "base"
    }
}

; Permutations to implement hotstring functionality
;-------------------------------------------------

; This layout has hotstrings built-in for performance reasons (so as not to have even more applications hooking into keyboard input),
; and to deal with all the complex logic related to layers and intelligent backspacing. Every single return statement for an action/key 
; should be followed by one of these functions, which together represent an exhaustive set of possible return permutations vis-a-vis hotstring logic,
; including the fall-back hotstring_neutral_key() that is used for anything that doesn't at all interact with hotstrings. {Backspace} is an exception,
; since it has complex one-off logic.

completely_internal_key() {
    universal_keypress_hook("")
    return ""
}

eat_keypress() {
    universal_keypress_hook("")
    return ""
}

; This function doesn't do anything per se, but is just here to make the code more readable/understandable
; through consistency. It implicitly makes it clear that things that call this are hotstring neutral.

; -------------------------

; Things this function is used for:

; Base Lock, Shift Leader, Caps Leader, Number Leader

; Raw Leader is also hotstring neutral. So that whatever raw keypress
; (e.g., for comma or closing parenthesis, or whatever) can still trigger
; hotstrings.

; Space when already autospaced (sending "")

; Basically everything on Command Layer, Actions Layer, Selection Layer
;   These keys won't themselves clear anything in the sent_keys_stack/clear hotstring memory,
;   but only because doing so is unnecessary, given that everything will be cleared when entering
;   any of these layers. A partial list is given below, for the sake of example.

; When in jump microstate (and sending raw keys)

; Actual modifier combinations (like the actual thing that sends Ctrl + A).
; It is impossible to get modifiers active (leader or lock) without going through
; Actions or Command, which will have cleared hotstrings already (as above).
; Compare the raw behavior when entering flags for jumping (as just above).

; -------------------------

; Partial list of of hotstring neutral keys from various layers (to get the basic idea):

; See modifiable_hotstring_neutral_action_key() for things like Esc that can be used
; with modifiers. I've put an asterisk next to these in the list below.

; Things that can't be modified (e.g., cut/copy/paste after/etc.) just use
; hotstring_neutral_key() directly, with no wrapper function.

; Command
; --------
; Actions Lock
; *Esc
; *Insert
; *Scroll Lock
; *F1-F12 (on Function layer accessed from Command Layer)
; Focus tab/window/desktop
; Hint-based open/open in new tab/etc.
; Etc.

; Actions
; --------
; Cut/copy/paste before/paste after
; *Delete
; Undo/redo

; Selection
; --------
; Jump to text object
; Select text object
; *Left/up/down/right
; *Home/end
; *PgUp/PgDn
; Move forward/backward
; Extend forward/backward
; Shrink forward/backward
; Undo/redo selection

hotstring_neutral_key(pressed_key, keys_to_return) {
    universal_keypress_hook(pressed_key)
    return keys_to_return
}

; Rework which keys/actions call which hotstring functions (e.g., make more keys use the neutral function)

; Add pressed_key to all functions, and add it to all calls of the various functions. Default value?

; Add the conditionals to get out of caps lock and number lock to all the hotstring functions
; (even if they probably won't get used much in practice)

; Move all the TODO stuff out of the current project, to keep the scope narrower and codebase cleaner

; Move hotstrings into a file that gets Included, not straight in file

; Do not need to automatically clear caps lock or num lock since these things simply cannot end
; up locked down when typing jump sequences (because during jump sequences, raw keys are sent,
; and pressing jump key resets layer state so that you always start out on base lock)

; TODO: function that is like neutral key but sets current_brief := "" and last_delimiter := ""

; Raw Lock
; --------
; While no hotstrings will trigger when raw_state == "lock", stuff still gets tracked
; on the sent_keys_stack and undo_keysStack. Want to keep it intact for intelligent Backspacing

; Code toggle
; --------
; While no hotstrings will trigger when input_state == "code", stuff still gets tracked
; on the sent_keys_stack and undo_keysStack. Want to keep it intact for intelligent Backspacing

; Prose Toggle
; --------
; current_brief should already be equal to "" when coming out of input_state == "code",
; but won't hurt to make sure.

; Keys that use this function trigger expansions, but then reset the entry stacks.
; Used primarily for things that are movement/actions/etc. -- something that interrupts
; a consecutive entry sequence.
hotstring_trigger_action_key_untracked_reset_entry_related_variables(pressed_key, keys_to_return) {
    universal_keypress_hook(pressed_key)
    hotstring_text := get_hotstring_text()
    keys_to_return := add_hotstring_expansion_if_triggering_hotstring(keys_to_return, hotstring_text)
    reset_entry_related_variables()
    return keys_to_return
}

; Command Leader, Actions Leader, Selection Lock

; Tab - switching between Excel cells, input fields in a browser's web form, etc.
; These all have different input sequences that are separate. Just like pressing Left/Right
; Tab should automatically reset locked := "base"?

; TODO: Enter too, but only when in Excel?
; TODO: What about Tab usage in Org mode? When used in selecting options in code completion?
; https://emacs.stackexchange.com/questions/74701/how-can-i-change-the-org-mode-tab-behavior

; Do not need to automatically clear caps lock or num lock since these things simply cannot end
; up locked down when modifiers are active (modifier keys start you out on base lock)

; Move to TODO file:
; --------
; 
; TODO modifiable_hotstring_trigger_shift_action_key
; sh-left, sh-up, sh-down, sh-right
; sh-home, sh-end
; 
; Layer keys from old layout, and threshold timing variables
;
; Key UP:: examples from old layout
;
; Virtual keys
; 
; The stuff for autospacing numbers
;
; The key templates for doing things different between numbers
;
;

; Space, Enter
; All punctuation
; All symbols (other than @, _, dot, hyphen)
hotstring_trigger_delimiter_key_tracked(pressed_key, keys_to_return, undo_keys) {
    universal_keypress_hook(pressed_key)
    autospacing_state_history_stack.push(autospacing)
    automatching_state_history_stack.push(automatching_stack)
    sent_keys_stack.push(pressed_key)
    hotstring_text := get_hotstring_text()
    keys_to_return := add_hotstring_expansion_if_triggering_hotstring(keys_to_return, hotstring_text)
    undo_keys := add_undo_keys_for_hotstring_expansion_if_triggering_hotstring(pressed_key, undo_keys, hotstring_text)
    undo_sent_keys_stack.push(undo_keys)
    last_delimiter := pressed_key
    current_brief := ""
    return keys_to_return
}

; @, _, dot, hyphen
hotstring_inactive_delimiter_key_tracked(pressed_key, keys_to_return, undo_keys) {
    universal_keypress_hook(pressed_key)
    autospacing_state_history_stack.push(autospacing)
    automatching_state_history_stack.push(automatching_stack)
    sent_keys_stack.push(pressed_key)
    undo_sent_keys_stack.push(undo_keys)
    last_delimiter := pressed_key
    current_brief := ""
    return keys_to_return
}

; a-z, A-Z, 0-9, apostrophe
hotstring_character_key(pressed_key, keys_to_return, undo_keys) {
    universal_keypress_hook(pressed_key)
    autospacing_state_history_stack.push(autospacing)
    automatching_state_history_stack.push(automatching_stack)
    sent_keys_stack.push(pressed_key)
    undo_sent_keys_stack.push(undo_keys)
    if((prose_mode_should_be_active()) or (not in_raw_microstate())) {
        current_brief := current_brief . pressed_key
    }
    return keys_to_return
}

