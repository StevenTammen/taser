; Shift
;-------------------------------------------------

; Left Top
;-------------------------------------------------

left_top_pinky_extension_caps_leader() {
    ; TODO
}

left_top_pinky_caps_leader() {
    return uppercase_b_autolock_caps_layer()
}

left_top_ring_caps_leader() {
    return uppercase_y_autolock_caps_layer()
}

left_top_middle_caps_leader() {
    return uppercase_o_autolock_caps_layer()
}

left_top_index_caps_leader() {
    return uppercase_u_autolock_caps_layer()
}

left_top_index_extension_caps_leader() {
    ; TODO
}

; Right Top
;-------------------------------------------------

right_top_index_extension_caps_leader() {
    return uppercase_k_autolock_caps_layer()
}

right_top_index_caps_leader() {
    return uppercase_d_autolock_caps_layer()
}

right_top_middle_caps_leader() {
    return uppercase_c_autolock_caps_layer()
}

right_top_ring_caps_leader() {
    return uppercase_l_autolock_caps_layer()
}

right_top_pinky_caps_leader() {
    return uppercase_p_autolock_caps_layer()
}

right_top_pinky_extension_caps_leader() {
    return uppercase_q_autolock_caps_layer()
}

; Left Middle
;-------------------------------------------------

left_middle_pinky_extension_caps_leader() {
    ; TODO
}

left_middle_pinky_caps_leader() {
    return uppercase_h_autolock_caps_layer()
}

left_middle_ring_caps_leader() {
    return uppercase_i_autolock_caps_layer()
}

left_middle_middle_caps_leader() {
    return uppercase_e_autolock_caps_layer()
}

left_middle_index_caps_leader() {
    return uppercase_a_autolock_caps_layer()
}

left_middle_index_extension_caps_leader() {
    ; TODO
}

; Right Middle
;-------------------------------------------------

right_middle_index_extension_caps_leader() {
    return uppercase_m_autolock_caps_layer()
}

right_middle_index_caps_leader() {
    return uppercase_t_autolock_caps_layer()
}

right_middle_middle_caps_leader() {
    return uppercase_s_autolock_caps_layer()
}

right_middle_ring_caps_leader() {
    return uppercase_r_autolock_caps_layer()
}

right_middle_pinky_caps_leader() {
    return uppercase_n_autolock_caps_layer()
}

right_middle_pinky_extension_caps_leader() {
    return uppercase_v_autolock_caps_layer()
}

; Left Bottom
;-------------------------------------------------

left_bottom_pinky_extension_caps_leader() {
    return command_leader()
}

left_bottom_pinky_caps_leader() {
    return uppercase_x_autolock_caps_layer()
}

left_bottom_ring_caps_leader() {
    ; You access the modified versions of the bottom row base layer keys
    ; from the Caps layer
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo("""", False)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; TODO
    }
}

left_bottom_middle_caps_leader() {
    ; You access the modified versions of the bottom row base layer keys
    ; from the Caps layer
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(")", False)
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; TODO
    }
}

left_bottom_index_caps_leader() {
    ; You access the modified versions of the bottom row base layer keys
    ; from the Caps layer
    if(modifier_state == "leader" or modifier_state == "locked") {
        keys_to_return := build_modifier_combo(",")
        return hotstring_trigger_action_key_untracked_reset_entry_related_variables(keys_to_return)
    }
    else {
        ; TODO
    }
}

left_bottom_index_extension_caps_leader() {
    ; TODO
}

; Right Bottom
;-------------------------------------------------

right_bottom_index_extension_caps_leader() {
    return uppercase_w_autolock_caps_layer()
}

right_bottom_index_caps_leader() {
    return uppercase_g_autolock_caps_layer()
}

right_bottom_middle_caps_leader() {
    return uppercase_f_autolock_caps_layer()
}

right_bottom_ring_caps_leader() {
    return uppercase_j_autolock_caps_layer()
}

right_bottom_pinky_caps_leader() {
    return uppercase_z_autolock_caps_layer()
}

right_bottom_pinky_extension_caps_leader() {
    return caps_leader()
}

; Left Thumbs
;-------------------------------------------------

left_thumb_inner_caps_leader() {
    return actions_leader()
}

left_thumb_neutral_caps_leader() {
    ; TODO
}

left_thumb_outer_caps_leader() {
    return selection_lock()
}

; Right Thumbs
;-------------------------------------------------

right_thumb_outer_caps_leader() {
    return number_leader()
}

right_thumb_neutral_caps_leader() {
    ; TODO
}

right_thumb_inner_caps_leader() {
    return caps_leader()
}