; Shift
;-------------------------------------------------

; Left Top
;-------------------------------------------------

left_top_pinky_extension_actions_leader() {
    ; TODO
}

left_top_pinky_actions_leader() {
    return paste_after()
}

left_top_ring_actions_leader() {
    return delete()
}

left_top_middle_actions_leader() {
    return cut()
}

left_top_index_actions_leader() {
    return copy()
}

left_top_index_extension_actions_leader() {
    return append_after()
}

; Right Top
;-------------------------------------------------

right_top_index_extension_actions_leader() {
    ; TODO
}

right_top_index_actions_leader() {
    ; TODO
}

right_top_middle_actions_leader() {
    ; TODO
}

right_top_ring_actions_leader() {
    ; TODO
}

right_top_pinky_actions_leader() {
    ; TODO
}

right_top_pinky_extension_actions_leader() {
    ; TODO
}

; Left Middle
;-------------------------------------------------

left_middle_pinky_extension_actions_leader() {
    ; TODO
}

left_middle_pinky_actions_leader() {
    ; TODO
}

left_middle_ring_actions_leader() {
    ; TODO
}

left_middle_middle_actions_leader() {
    ; TODO
}

left_middle_index_actions_leader() {
    ; TODO
}

left_middle_index_extension_actions_leader() {
    return undo()
}

; Right Middle
;-------------------------------------------------

right_middle_index_extension_actions_leader() {
    ; TODO
}

right_middle_index_actions_leader() {
    ; TODO
}

right_middle_middle_actions_leader() {
    ; TODO
}

right_middle_ring_actions_leader() {
    ; TODO
}

right_middle_pinky_actions_leader() {
    ; TODO
}

right_middle_pinky_extension_actions_leader() {
    ; TODO
}

; Left Bottom
;-------------------------------------------------

left_bottom_pinky_extension_actions_leader() {
    return command_leader()
}

left_bottom_pinky_actions_leader() {
    return paste_before()
}

left_bottom_ring_actions_leader() {
    return mod_control_leader()
}

left_bottom_middle_actions_leader() {
    return mod_alt_leader()
}

left_bottom_index_actions_leader() {
    return mod_shift_leader()
}

left_bottom_index_extension_actions_leader() {
    return insert_before()
}

; Right Bottom
;-------------------------------------------------

right_bottom_index_extension_actions_leader() {
    ; TODO
}

right_bottom_index_actions_leader() {
    ; TODO
}

right_bottom_middle_actions_leader() {
    ; TODO
}

right_bottom_ring_actions_leader() {
    ; TODO
}

right_bottom_pinky_actions_leader() {
    ; TODO
}

right_bottom_pinky_extension_actions_leader() {
    ; TODO
}

; Left Thumbs
;-------------------------------------------------

left_thumb_inner_actions_leader() {
    return actions_leader()
}

left_thumb_neutral_actions_leader() {
    return redo()
}

left_thumb_outer_actions_leader() {
    return selection_lock()
}

; Right Thumbs
;-------------------------------------------------

right_thumb_outer_actions_leader() {
    ; TODO
}

right_thumb_neutral_actions_leader() {
    return internal_backspace_by_word()
}

right_thumb_inner_actions_leader() {
    ; TODO
}