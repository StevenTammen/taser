; Nav
;-------------------------------------------------

; Left Top
;-------------------------------------------------

left_top_pinky_extension_nav() {
    return
}

left_top_pinky_nav() {
    return
}

left_top_ring_nav() {
    return
}

left_top_middle_nav() {
    return
}

left_top_index_nav() {
    return
}

left_top_index_extension_nav() {
    return
}

; Right Top
;-------------------------------------------------

right_top_index_extension_nav() {
    return
}

right_top_index_nav() {
    return
}

right_top_middle_nav() {
    return
}

right_top_ring_nav() {
    return
}

right_top_pinky_nav() {
    return
}

right_top_pinky_extension_nav() {
    return
}

; Left Middle
;-------------------------------------------------

left_middle_pinky_extension_nav() {
    return clipboard_layer_down()
}

left_middle_pinky_nav() {
    return
}

left_middle_ring_nav() {
    return
}

left_middle_middle_nav() {
    return
}

left_middle_index_nav() {
    return
}

left_middle_index_extension_nav() {
    return undo()
}

; Right Middle
;-------------------------------------------------

right_middle_index_extension_nav() {
    return
}

right_middle_index_nav() {
    return left()
}

right_middle_middle_nav() {
    return down()
}

right_middle_ring_nav() {
    return up()
}

right_middle_pinky_nav() {
    return right()
}

right_middle_pinky_extension_nav() {
    return
}

; Left Bottom
;-------------------------------------------------

left_bottom_pinky_extension_nav() {
    return jump_before()
}

left_bottom_pinky_nav() {
    return delete()
}

left_bottom_ring_nav() {
    return cut()
}

left_bottom_middle_nav() {
    return copy()
}

left_bottom_index_nav() {
    return paste()
}

left_bottom_index_extension_nav() {
    return redo()
}

; Right Bottom
;-------------------------------------------------

right_bottom_index_extension_nav() {
    return
}

right_bottom_index_nav() {
    return home()
}

right_bottom_middle_nav() {
    return move_word_back()
}

right_bottom_ring_nav() {
    return move_word_forward()
}

right_bottom_pinky_nav() {
    return end()
}

right_bottom_pinky_extension_nav() {
    return jump_after()
}

; Left Thumbs
;-------------------------------------------------

left_thumb_inner_nav() {
    return
}

left_thumb_neutral_nav() {
    return space()
}

left_thumb_outer_nav() {
    return double_press_nav_layer()
}

; Right Thumbs
;-------------------------------------------------

right_thumb_outer_nav() {
    return enter()
}

right_thumb_neutral_nav() {
    return backspace()
}

right_thumb_inner_nav() {
    return shift_nav_layer_down()
}