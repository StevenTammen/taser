; Shift
;-------------------------------------------------

; Left Top
;-------------------------------------------------

left_top_pinky_extension_actions_lock() {
    ; TODO
}

left_top_pinky_actions_lock() {
    return paste_after()
}

left_top_ring_actions_lock() {
    return delete()
}

left_top_middle_actions_lock() {
    return cut()
}

left_top_index_actions_lock() {
    return copy()
}

left_top_index_extension_actions_lock() {
    return append_after()
}

; Right Top
;-------------------------------------------------

right_top_index_extension_actions_lock() {
    ; TODO
}

right_top_index_actions_lock() {
    ; TODO
}

right_top_middle_actions_lock() {
    ; TODO
}

right_top_ring_actions_lock() {
    ; TODO
}

right_top_pinky_actions_lock() {
    ; TODO
}

right_top_pinky_extension_actions_lock() {
    ; TODO
}

; Left Middle
;-------------------------------------------------

left_middle_pinky_extension_actions_lock() {
    ; TODO
}

left_middle_pinky_actions_lock() {
    ; TODO
}

left_middle_ring_actions_lock() {
    ; TODO
}

left_middle_middle_actions_lock() {
    ; TODO
}

left_middle_index_actions_lock() {
    ; TODO
}

left_middle_index_extension_actions_lock() {
    return undo()
}

; Right Middle
;-------------------------------------------------

right_middle_index_extension_actions_lock() {
    ; TODO
}

right_middle_index_actions_lock() {
    ; TODO
}

right_middle_middle_actions_lock() {
    ; TODO
}

right_middle_ring_actions_lock() {
    ; TODO
}

right_middle_pinky_actions_lock() {
    ; TODO
}

right_middle_pinky_extension_actions_lock() {
    ; TODO
}

; Left Bottom
;-------------------------------------------------

left_bottom_pinky_extension_actions_lock() {
    return command_leader()
}

left_bottom_pinky_actions_lock() {
    return paste_before()
}

left_bottom_ring_actions_lock() {
    return mod_control_leader()
}

left_bottom_middle_actions_lock() {
    return mod_alt_leader()
}

left_bottom_index_actions_lock() {
    return mod_shift_leader()
}

left_bottom_index_extension_actions_lock() {
    return insert_before()
}

; Right Bottom
;-------------------------------------------------

right_bottom_index_extension_actions_lock() {
    ; TODO
}

right_bottom_index_actions_lock() {
    ; TODO
}

right_bottom_middle_actions_lock() {
    ; TODO
}

right_bottom_ring_actions_lock() {
    ; TODO
}

right_bottom_pinky_actions_lock() {
    ; TODO
}

right_bottom_pinky_extension_actions_lock() {
    ; TODO
}

; Left Thumbs
;-------------------------------------------------

left_thumb_inner_actions_lock() {
    return actions_lock()
}

left_thumb_neutral_actions_lock() {
    return redo()
}

left_thumb_outer_actions_lock() {
    return selection_lock()
}

; Right Thumbs
;-------------------------------------------------

right_thumb_outer_actions_lock() {
    ; TODO
}

right_thumb_neutral_actions_lock() {
    ; TODO
}

right_thumb_inner_actions_lock() {
    ; TODO
}