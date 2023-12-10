; TODO
; Add optional paremeter to most helper functions called CanBeModified, and then pass it 
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

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; Change Masking Key
;-------------------------------------------------

; Prevents masked Hotkeys from sending LCtrls that can interfere with the script.
; See https://autohotkey.com/docs/commands/_MenuMaskKey.htm
#MenuMaskKey VK07

; General State Variables
;-------------------------------------------------

; TODO: allow for customization with .ini file

; For tracking autospacing after ,;: and .?! and so on
; Possible values: {"autospaced", "cap-autospaced", "not-autospaced"}
global autospacing := "not-autospaced"

; For tracking text input mode
; Possible values: {"prose", "code"}
global inputMode := "prose"

; For tracking the language being typed
; Possible values: {"english"}
; Eventually (?): {"english", "ancient greek", "biblical hebrew"}
global language := "english"

; For tracking prose markup language
; Possible values: {"markdown"}
; Eventually (?): {"markdown", "org", "asciidoc"}
global proseLanguage := "markdown"

; For tracking whether or not matched pair characters
; are entered together, or tracked and then entered through ).
; The former is almost always better in practice (if you navigate away,
; you actually save keypresses), but you need the latter to be able
; to pratice in typing test sort of environments, which is why we
; implement it both ways, and then make it toggleable
global manuallyAutomatching := True

; We store the current stack of characters to match as a string stack
; (last character in string = top of stack). Used in implementing
; intelligent automatching behavior with the ) key
global automatching := ""

; For tracking automatching state X keypresses back. Used in implementing intelligent backspacing behavior
global automatchingStack := []

; For tracking autospacing state X key presses back. Used in implementing intelligent backspacing behavior
global autospacingStack := []

; For tracking how to undo sent keys X key presses back. Used in implementing intelligent backspacing behavior
global undoSentKeysStack := []

; Hotstrings
;-------------------------------------------------

; TODO: Hotstrings are stored in a separate include file
global hotstrings := {}

hotstrings["btw"] := "by the way"

hotstrings["bw"] := "between"

hotstrings["g"] := "God"
hotstrings["g's"] := "God's"

hotstrings["hs"] := "Holy Spirit"

hotstrings["i"] := "I"
hotstrings["i'd"] := "I'd"
hotstrings["i'll"] := "I'll"
hotstrings["i'm"] := "I'm"
hotstrings["i've"] := "I've"

hotstrings["jc"] := "Jesus Christ"
hotstrings["jesus"] := "Jesus"

hotstrings["probly"] := "probably"

hotstrings["u"] := "you"
hotstrings["ur"] := "your"
hotstrings["u'd"] := "you'd"
hotstrings["u'll"] := "you'll"
hotstrings["u're"] := "you're"
hotstrings["u've"] := "you've"

; Only letters and the apostrophe key are used in hotstrings.
; All other tracked key presses (see sentKeysStack just below) serve as delimiters.
global hostringCharacters := ["'", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

; For tracking sent keys X key presses back. Used in implementing intelligent hotstring behavior.
; Many types of key presses (such as modifiers and function keys) simply aren't tracked. As a rule of thumb, if a
; key press outputs something to the screen (adds something to the bytes in a file), it is tracked, and otherwise not.
global sentKeysStack := []

; Certain delimiters disable hostring behavior implicitly. Think characters used in usernames and email addresses,
; but not much else. Helps prevent undesirable "surprising" behavior
inactiveDelimiters := ["-", "_", "dot", "@"]

global lastDelimiter := ""

global currentBrief := ""

; TODO: Ctrl + Backspace behavior

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
global pressesLeftUntilJump := 0

; There are two types of jumps: moving and selecting. For AceJump,
; sending a capital letter for the second flag character will lead
; to jumpselecting instead of just jumping. This variable is set upfront
; for each jump operation, and controls whether the second letter character
; will be sent capitalized or not.
global jumpSelecting := False

; For tracking the raw microstate. This is conceptually similar to the raw layer,
; but is completely automatic. It is mostly used when entering filenames and 
; the like for fuzzy search etc., so that numbers will not be autospaced
global inRawMicrostate := False

; Modifier Variables
;-------------------------------------------------

; The shift_layer() and num_layer() keys are involved
; The mod_control(), mod_alt(), mod_shift() keys are
; also involved

global modifiersLeader := False
global modifiersHeldDown := False

global modControlDown := False
global modAltDown := False
global modShiftDown := False

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

; Imports: Libraries
;-------------------------------------------------

#Include <utility-functions>
#Include <window-management>
#Include <desktop-management>
#Include <reusable-key-templates>
#Include <assignable-actions>

; Imports: Layers
;-------------------------------------------------

#Include <layers/Base>
#Include <layers/Func>
#Include <layers/ShiftClipboard>
#Include <layers/Clipboard>
#Include <layers/ShiftNav>
#Include <layers/Nav>
#Include <layers/NavFirst>
#Include <layers/Num>
#Include <layers/NumFirst>
#Include <layers/Shift>
#Include <layers/ShiftFirst>

; Actions
; Templates
; Languages
; Apostrophe layer for diacritics

; Greek
; Hebrew
; Russian
; Ukranian

; Main Layout
;-------------------------------------------------

SendInput %turnOnHotstrings%

; Left Top
;-------------------------------------------------

*Tab::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_top_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_top_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_pinky_extension_num_first()
        }
        else {
            keysToSend := left_top_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_pinky_extension_num_first()
        }
        else {
            keysToSend := left_top_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_top_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_top_pinky_extension_shift()
        }
    }
    else {
        keysToSend := left_top_pinky_extension_base()
    }
    SendInput %keysToSend%
return

*b::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_pinky_nav_first()
        }
        else {
            keysToSend := left_top_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_pinky_nav_first()
        }
        else {
            keysToSend := left_top_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_pinky_num_first()
        }
        else {
            keysToSend := left_top_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_pinky_num_first()
        }
        else {
            keysToSend := left_top_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_pinky_shift_first()
        }
        else {
            keysToSend := left_top_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_pinky_shift_first()
        }
        else {
            keysToSend := left_top_pinky_shift()
        }
    }
    else {
        keysToSend := left_top_pinky_base()
    }
    SendInput %keysToSend%
return

*y::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_ring_nav_first()
        }
        else {
            keysToSend := left_top_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_ring_nav_first()
        }
        else {
            keysToSend := left_top_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_ring_num_first()
        }
        else {
            keysToSend := left_top_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_ring_num_first()
        }
        else {
            keysToSend := left_top_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_ring_shift_first()
        }
        else {
            keysToSend := left_top_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_ring_shift_first()
        }
        else {
            keysToSend := left_top_ring_shift()
        }
    }
    else {
        keysToSend := left_top_ring_base()
    }
    SendInput %keysToSend%
return

*o::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_middle_nav_first()
        }
        else {
            keysToSend := left_top_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_middle_nav_first()
        }
        else {
            keysToSend := left_top_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_middle_num_first()
        }
        else {
            keysToSend := left_top_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_middle_num_first()
        }
        else {
            keysToSend := left_top_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_middle_shift_first()
        }
        else {
            keysToSend := left_top_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_middle_shift_first()
        }
        else {
            keysToSend := left_top_middle_shift()
        }
    }
    else {
        keysToSend := left_top_middle_base()
    }
    SendInput %keysToSend%
return

*u::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_index_nav_first()
        }
        else {
            keysToSend := left_top_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_index_nav_first()
        }
        else {
            keysToSend := left_top_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_index_num_first()
        }
        else {
            keysToSend := left_top_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_index_num_first()
        }
        else {
            keysToSend := left_top_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_index_shift_first()
        }
        else {
            keysToSend := left_top_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_index_shift_first()
        }
        else {
            keysToSend := left_top_index_shift()
        }
    }
    else {
        keysToSend := left_top_index_base()
    }
    SendInput %keysToSend%
return

*'::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_top_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_top_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_top_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_top_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_top_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_top_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_top_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_top_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_top_index_extension_nav_first()
        }
        else {
            keysToSend := left_top_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_top_index_extension_nav_first()
        }
        else {
            keysToSend := left_top_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_top_index_extension_num_first()
        }
        else {
            keysToSend := left_top_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_top_index_extension_num_first()
        }
        else {
            keysToSend := left_top_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_top_index_extension_shift_first()
        }
        else {
            keysToSend := left_top_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_top_index_extension_shift_first()
        }
        else {
            keysToSend := left_top_index_extension_shift()
        }
    }
    else {
        keysToSend := left_top_index_extension_base()
    }
    SendInput %keysToSend%
return

; Right Top
;-------------------------------------------------

*k::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_index_extension_nav_first()
        }
        else {
            keysToSend := right_top_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_index_extension_nav_first()
        }
        else {
            keysToSend := right_top_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_index_extension_num_first()
        }
        else {
            keysToSend := right_top_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_index_extension_num_first()
        }
        else {
            keysToSend := right_top_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_index_extension_shift_first()
        }
        else {
            keysToSend := right_top_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_index_extension_shift_first()
        }
        else {
            keysToSend := right_top_index_extension_shift()
        }
    }
    else {
        keysToSend := right_top_index_extension_base()
    }
    SendInput %keysToSend%
return

*d::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_index_nav_first()
        }
        else {
            keysToSend := right_top_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_index_nav_first()
        }
        else {
            keysToSend := right_top_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_index_num_first()
        }
        else {
            keysToSend := right_top_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_index_num_first()
        }
        else {
            keysToSend := right_top_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_index_shift_first()
        }
        else {
            keysToSend := right_top_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_index_shift_first()
        }
        else {
            keysToSend := right_top_index_shift()
        }
    }
    else {
        keysToSend := right_top_index_base()
    }
    SendInput %keysToSend%
return

*c::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_middle_nav_first()
        }
        else {
            keysToSend := right_top_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_middle_nav_first()
        }
        else {
            keysToSend := right_top_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_middle_num_first()
        }
        else {
            keysToSend := right_top_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_middle_num_first()
        }
        else {
            keysToSend := right_top_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_middle_shift_first()
        }
        else {
            keysToSend := right_top_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_middle_shift_first()
        }
        else {
            keysToSend := right_top_middle_shift()
        }
    }
    else {
        keysToSend := right_top_middle_base()
    }
    SendInput %keysToSend%
return

*l::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_ring_nav_first()
        }
        else {
            keysToSend := right_top_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_ring_nav_first()
        }
        else {
            keysToSend := right_top_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_ring_num_first()
        }
        else {
            keysToSend := right_top_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_ring_num_first()
        }
        else {
            keysToSend := right_top_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_ring_shift_first()
        }
        else {
            keysToSend := right_top_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_ring_shift_first()
        }
        else {
            keysToSend := right_top_ring_shift()
        }
    }
    else {
        keysToSend := right_top_ring_base()
    }
    SendInput %keysToSend%
return

*p::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_pinky_nav_first()
        }
        else {
            keysToSend := right_top_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_pinky_nav_first()
        }
        else {
            keysToSend := right_top_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_pinky_num_first()
        }
        else {
            keysToSend := right_top_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_pinky_num_first()
        }
        else {
            keysToSend := right_top_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_pinky_shift_first()
        }
        else {
            keysToSend := right_top_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_pinky_shift_first()
        }
        else {
            keysToSend := right_top_pinky_shift()
        }
    }
    else {
        keysToSend := right_top_pinky_base()
    }
    SendInput %keysToSend%
return

*q::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_top_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_top_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_top_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_top_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_top_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_top_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_top_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_top_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_top_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_top_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_top_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_top_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_top_pinky_extension_num_first()
        }
        else {
            keysToSend := right_top_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_top_pinky_extension_num_first()
        }
        else {
            keysToSend := right_top_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_top_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_top_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_top_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_top_pinky_extension_shift()
        }
    }
    else {
        keysToSend := right_top_pinky_extension_base()
    }
    SendInput %keysToSend%
return

; Left Middle
;-------------------------------------------------

*1::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_pinky_extension_num_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_pinky_extension_num_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_middle_pinky_extension_shift()
        }
    }
    else {
        keysToSend := left_middle_pinky_extension_base()
    }
    SendInput %keysToSend%
return

*1 Up::
    if(isShiftClipboardLayerPress){
        shift_clipboard_layer_up()
    }
    else if(isClipboardLayerPress) {
        clipboard_layer_up()
    }
return

*h::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_pinky_nav_first()
        }
        else {
            keysToSend := left_middle_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_pinky_nav_first()
        }
        else {
            keysToSend := left_middle_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_pinky_num_first()
        }
        else {
            keysToSend := left_middle_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_pinky_num_first()
        }
        else {
            keysToSend := left_middle_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_pinky_shift_first()
        }
        else {
            keysToSend := left_middle_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_pinky_shift_first()
        }
        else {
            keysToSend := left_middle_pinky_shift()
        }
    }
    else {
        keysToSend := left_middle_pinky_base()
    }
    SendInput %keysToSend%
return

*i::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_ring_nav_first()
        }
        else {
            keysToSend := left_middle_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_ring_nav_first()
        }
        else {
            keysToSend := left_middle_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_ring_num_first()
        }
        else {
            keysToSend := left_middle_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_ring_num_first()
        }
        else {
            keysToSend := left_middle_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_ring_shift_first()
        }
        else {
            keysToSend := left_middle_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_ring_shift_first()
        }
        else {
            keysToSend := left_middle_ring_shift()
        }
    }
    else {
        keysToSend := left_middle_ring_base()
    }
    SendInput %keysToSend%
return

*e::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_middle_nav_first()
        }
        else {
            keysToSend := left_middle_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_middle_nav_first()
        }
        else {
            keysToSend := left_middle_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_middle_num_first()
        }
        else {
            keysToSend := left_middle_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_middle_num_first()
        }
        else {
            keysToSend := left_middle_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_middle_shift_first()
        }
        else {
            keysToSend := left_middle_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_middle_shift_first()
        }
        else {
            keysToSend := left_middle_middle_shift()
        }
    }
    else {
        keysToSend := left_middle_middle_base()
    }
    SendInput %keysToSend%
return

*a::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_index_nav_first()
        }
        else {
            keysToSend := left_middle_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_index_nav_first()
        }
        else {
            keysToSend := left_middle_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_index_num_first()
        }
        else {
            keysToSend := left_middle_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_index_num_first()
        }
        else {
            keysToSend := left_middle_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_index_shift_first()
        }
        else {
            keysToSend := left_middle_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_index_shift_first()
        }
        else {
            keysToSend := left_middle_index_shift()
        }
    }
    else {
        keysToSend := left_middle_index_base()
    }
    SendInput %keysToSend%
return

*.::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_middle_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_middle_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_middle_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_middle_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_middle_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_middle_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_middle_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_middle_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_middle_index_extension_nav_first()
        }
        else {
            keysToSend := left_middle_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_middle_index_extension_nav_first()
        }
        else {
            keysToSend := left_middle_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_middle_index_extension_num_first()
        }
        else {
            keysToSend := left_middle_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_middle_index_extension_num_first()
        }
        else {
            keysToSend := left_middle_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_middle_index_extension_shift_first()
        }
        else {
            keysToSend := left_middle_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_middle_index_extension_shift_first()
        }
        else {
            keysToSend := left_middle_index_extension_shift()
        }
    }
    else {
        keysToSend := left_middle_index_extension_base()
    }
    SendInput %keysToSend%
return

; Right Middle
;-------------------------------------------------

*m::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_index_extension_nav_first()
        }
        else {
            keysToSend := right_middle_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_index_extension_nav_first()
        }
        else {
            keysToSend := right_middle_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_index_extension_num_first()
        }
        else {
            keysToSend := right_middle_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_index_extension_num_first()
        }
        else {
            keysToSend := right_middle_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_index_extension_shift_first()
        }
        else {
            keysToSend := right_middle_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_index_extension_shift_first()
        }
        else {
            keysToSend := right_middle_index_extension_shift()
        }
    }
    else {
        keysToSend := right_middle_index_extension_base()
    }
    SendInput %keysToSend%
return

*t::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_index_nav_first()
        }
        else {
            keysToSend := right_middle_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_index_nav_first()
        }
        else {
            keysToSend := right_middle_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_index_num_first()
        }
        else {
            keysToSend := right_middle_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_index_num_first()
        }
        else {
            keysToSend := right_middle_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_index_shift_first()
        }
        else {
            keysToSend := right_middle_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_index_shift_first()
        }
        else {
            keysToSend := right_middle_index_shift()
        }
    }
    else {
        keysToSend := right_middle_index_base()
    }
    SendInput %keysToSend%
return

*s::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_middle_nav_first()
        }
        else {
            keysToSend := right_middle_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_middle_nav_first()
        }
        else {
            keysToSend := right_middle_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_middle_num_first()
        }
        else {
            keysToSend := right_middle_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_middle_num_first()
        }
        else {
            keysToSend := right_middle_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_middle_shift_first()
        }
        else {
            keysToSend := right_middle_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_middle_shift_first()
        }
        else {
            keysToSend := right_middle_middle_shift()
        }
    }
    else {
        keysToSend := right_middle_middle_base()
    }
    SendInput %keysToSend%
return

*r::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_ring_nav_first()
        }
        else {
            keysToSend := right_middle_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_ring_nav_first()
        }
        else {
            keysToSend := right_middle_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_ring_num_first()
        }
        else {
            keysToSend := right_middle_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_ring_num_first()
        }
        else {
            keysToSend := right_middle_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_ring_shift_first()
        }
        else {
            keysToSend := right_middle_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_ring_shift_first()
        }
        else {
            keysToSend := right_middle_ring_shift()
        }
    }
    else {
        keysToSend := right_middle_ring_base()
    }
    SendInput %keysToSend%
return

*n::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_pinky_nav_first()
        }
        else {
            keysToSend := right_middle_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_pinky_nav_first()
        }
        else {
            keysToSend := right_middle_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_pinky_num_first()
        }
        else {
            keysToSend := right_middle_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_pinky_num_first()
        }
        else {
            keysToSend := right_middle_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_pinky_shift_first()
        }
        else {
            keysToSend := right_middle_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_pinky_shift_first()
        }
        else {
            keysToSend := right_middle_pinky_shift()
        }
    }
    else {
        keysToSend := right_middle_pinky_base()
    }
    SendInput %keysToSend%
return

*v::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_middle_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_middle_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_middle_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_middle_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_middle_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_middle_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_middle_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_middle_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_middle_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_middle_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_middle_pinky_extension_num_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_middle_pinky_extension_num_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_middle_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_middle_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_middle_pinky_extension_shift()
        }
    }
    else {
        keysToSend := right_middle_pinky_extension_base()
    }
    SendInput %keysToSend%
return

; Left Bottom
;-------------------------------------------------

*2::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_pinky_extension_nav_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_pinky_extension_num_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_pinky_extension_num_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_pinky_extension_shift_first()
        }
        else {
            keysToSend := left_bottom_pinky_extension_shift()
        }
    }
    else {
        keysToSend := left_bottom_pinky_extension_base()
    }
    SendInput %keysToSend%
return

*x::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_pinky_nav_first()
        }
        else {
            keysToSend := left_bottom_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_pinky_nav_first()
        }
        else {
            keysToSend := left_bottom_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_pinky_num_first()
        }
        else {
            keysToSend := left_bottom_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_pinky_num_first()
        }
        else {
            keysToSend := left_bottom_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_pinky_shift_first()
        }
        else {
            keysToSend := left_bottom_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_pinky_shift_first()
        }
        else {
            keysToSend := left_bottom_pinky_shift()
        }
    }
    else {
        keysToSend := left_bottom_pinky_base()
    }
    SendInput %keysToSend%
return

*3::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_ring_nav_first()
        }
        else {
            keysToSend := left_bottom_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_ring_nav_first()
        }
        else {
            keysToSend := left_bottom_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_ring_num_first()
        }
        else {
            keysToSend := left_bottom_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_ring_num_first()
        }
        else {
            keysToSend := left_bottom_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_ring_shift_first()
        }
        else {
            keysToSend := left_bottom_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_ring_shift_first()
        }
        else {
            keysToSend := left_bottom_ring_shift()
        }
    }
    else {
        keysToSend := left_bottom_ring_base()
    }
    SendInput %keysToSend%
return

*4::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_middle_nav_first()
        }
        else {
            keysToSend := left_bottom_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_middle_nav_first()
        }
        else {
            keysToSend := left_bottom_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_middle_num_first()
        }
        else {
            keysToSend := left_bottom_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_middle_num_first()
        }
        else {
            keysToSend := left_bottom_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_middle_shift_first()
        }
        else {
            keysToSend := left_bottom_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_middle_shift_first()
        }
        else {
            keysToSend := left_bottom_middle_shift()
        }
    }
    else {
        keysToSend := left_bottom_middle_base()
    }
    SendInput %keysToSend%
return

*,::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_index_nav_first()
        }
        else {
            keysToSend := left_bottom_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_index_nav_first()
        }
        else {
            keysToSend := left_bottom_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_index_num_first()
        }
        else {
            keysToSend := left_bottom_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_index_num_first()
        }
        else {
            keysToSend := left_bottom_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_index_shift_first()
        }
        else {
            keysToSend := left_bottom_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_index_shift_first()
        }
        else {
            keysToSend := left_bottom_index_shift()
        }
    }
    else {
        keysToSend := left_bottom_index_base()
    }
    SendInput %keysToSend%
return

*5::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_bottom_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_bottom_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_bottom_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_bottom_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_bottom_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_bottom_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_bottom_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_bottom_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_bottom_index_extension_nav_first()
        }
        else {
            keysToSend := left_bottom_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_bottom_index_extension_nav_first()
        }
        else {
            keysToSend := left_bottom_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_bottom_index_extension_num_first()
        }
        else {
            keysToSend := left_bottom_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_bottom_index_extension_num_first()
        }
        else {
            keysToSend := left_bottom_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_bottom_index_extension_shift_first()
        }
        else {
            keysToSend := left_bottom_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_bottom_index_extension_shift_first()
        }
        else {
            keysToSend := left_bottom_index_extension_shift()
        }
    }
    else {
        keysToSend := left_bottom_index_extension_base()
    }
    SendInput %keysToSend%
return

; Right Bottom
;-------------------------------------------------

*w::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_index_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_index_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_index_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_index_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_index_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_index_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_index_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_index_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_index_extension_nav_first()
        }
        else {
            keysToSend := right_bottom_index_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_index_extension_nav_first()
        }
        else {
            keysToSend := right_bottom_index_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_index_extension_num_first()
        }
        else {
            keysToSend := right_bottom_index_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_index_extension_num_first()
        }
        else {
            keysToSend := right_bottom_index_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_index_extension_shift_first()
        }
        else {
            keysToSend := right_bottom_index_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_index_extension_shift_first()
        }
        else {
            keysToSend := right_bottom_index_extension_shift()
        }
    }
    else {
        keysToSend := right_bottom_index_extension_base()
    }
    SendInput %keysToSend%
return

*g::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_index_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_index_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_index_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_index_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_index_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_index_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_index_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_index_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_index_nav_first()
        }
        else {
            keysToSend := right_bottom_index_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_index_nav_first()
        }
        else {
            keysToSend := right_bottom_index_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_index_num_first()
        }
        else {
            keysToSend := right_bottom_index_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_index_num_first()
        }
        else {
            keysToSend := right_bottom_index_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_index_shift_first()
        }
        else {
            keysToSend := right_bottom_index_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_index_shift_first()
        }
        else {
            keysToSend := right_bottom_index_shift()
        }
    }
    else {
        keysToSend := right_bottom_index_base()
    }
    SendInput %keysToSend%
return

*f::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_middle_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_middle_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_middle_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_middle_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_middle_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_middle_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_middle_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_middle_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_middle_nav_first()
        }
        else {
            keysToSend := right_bottom_middle_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_middle_nav_first()
        }
        else {
            keysToSend := right_bottom_middle_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_middle_num_first()
        }
        else {
            keysToSend := right_bottom_middle_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_middle_num_first()
        }
        else {
            keysToSend := right_bottom_middle_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_middle_shift_first()
        }
        else {
            keysToSend := right_bottom_middle_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_middle_shift_first()
        }
        else {
            keysToSend := right_bottom_middle_shift()
        }
    }
    else {
        keysToSend := right_bottom_middle_base()
    }
    SendInput %keysToSend%
return

*j::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_ring_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_ring_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_ring_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_ring_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_ring_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_ring_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_ring_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_ring_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_ring_nav_first()
        }
        else {
            keysToSend := right_bottom_ring_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_ring_nav_first()
        }
        else {
            keysToSend := right_bottom_ring_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_ring_num_first()
        }
        else {
            keysToSend := right_bottom_ring_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_ring_num_first()
        }
        else {
            keysToSend := right_bottom_ring_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_ring_shift_first()
        }
        else {
            keysToSend := right_bottom_ring_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_ring_shift_first()
        }
        else {
            keysToSend := right_bottom_ring_shift()
        }
    }
    else {
        keysToSend := right_bottom_ring_base()
    }
    SendInput %keysToSend%
return

*z::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_pinky_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_pinky_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_pinky_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_pinky_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_pinky_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_pinky_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_pinky_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_pinky_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_pinky_nav_first()
        }
        else {
            keysToSend := right_bottom_pinky_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_pinky_nav_first()
        }
        else {
            keysToSend := right_bottom_pinky_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_pinky_num_first()
        }
        else {
            keysToSend := right_bottom_pinky_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_pinky_num_first()
        }
        else {
            keysToSend := right_bottom_pinky_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_pinky_shift_first()
        }
        else {
            keysToSend := right_bottom_pinky_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_pinky_shift_first()
        }
        else {
            keysToSend := right_bottom_pinky_shift()
        }
    }
    else {
        keysToSend := right_bottom_pinky_base()
    }
    SendInput %keysToSend%
return

*6::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_bottom_pinky_extension_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_bottom_pinky_extension_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_bottom_pinky_extension_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_bottom_pinky_extension_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_bottom_pinky_extension_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_bottom_pinky_extension_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_bottom_pinky_extension_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_bottom_pinky_extension_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_bottom_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_bottom_pinky_extension_nav_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_bottom_pinky_extension_num_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_bottom_pinky_extension_num_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_bottom_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_bottom_pinky_extension_shift_first()
        }
        else {
            keysToSend := right_bottom_pinky_extension_shift()
        }
    }
    else {
        keysToSend := right_bottom_pinky_extension_base()
    }
    SendInput %keysToSend%
return

; Left Thumbs
;-------------------------------------------------

*7::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_thumb_inner_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_thumb_inner_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_thumb_inner_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_thumb_inner_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_thumb_inner_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_thumb_inner_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_thumb_inner_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_thumb_inner_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_thumb_inner_nav_first()
        }
        else {
            keysToSend := left_thumb_inner_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_thumb_inner_nav_first()
        }
        else {
            keysToSend := left_thumb_inner_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_thumb_inner_num_first()
        }
        else {
            keysToSend := left_thumb_inner_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_thumb_inner_num_first()
        }
        else {
            keysToSend := left_thumb_inner_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_thumb_inner_shift_first()
        }
        else {
            keysToSend := left_thumb_inner_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_thumb_inner_shift_first()
        }
        else {
            keysToSend := left_thumb_inner_shift()
        }
    }
    else {
        keysToSend := left_thumb_inner_base()
    }
    SendInput %keysToSend%
return

*7 Up::
    if(isNumLayerPress){
        num_layer_up()
    }
return

*Space::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_thumb_neutral_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_thumb_neutral_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_thumb_neutral_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_thumb_neutral_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_thumb_neutral_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_thumb_neutral_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_thumb_neutral_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_thumb_neutral_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_thumb_neutral_nav_first()
        }
        else {
            keysToSend := left_thumb_neutral_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_thumb_neutral_nav_first()
        }
        else {
            keysToSend := left_thumb_neutral_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_thumb_neutral_num_first()
        }
        else {
            keysToSend := left_thumb_neutral_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_thumb_neutral_num_first()
        }
        else {
            keysToSend := left_thumb_neutral_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_thumb_neutral_shift_first()
        }
        else {
            keysToSend := left_thumb_neutral_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_thumb_neutral_shift_first()
        }
        else {
            keysToSend := left_thumb_neutral_shift()
        }
    }
    else {
        keysToSend := left_thumb_neutral_base()
    }
    SendInput %keysToSend%
return

*8::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := left_thumb_outer_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := left_thumb_outer_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := left_thumb_outer_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := left_thumb_outer_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := left_thumb_outer_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := left_thumb_outer_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := left_thumb_outer_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := left_thumb_outer_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := left_thumb_outer_nav_first()
        }
        else {
            keysToSend := left_thumb_outer_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := left_thumb_outer_nav_first()
        }
        else {
            keysToSend := left_thumb_outer_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := left_thumb_outer_num_first()
        }
        else {
            keysToSend := left_thumb_outer_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := left_thumb_outer_num_first()
        }
        else {
            keysToSend := left_thumb_outer_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := left_thumb_outer_shift_first()
        }
        else {
            keysToSend := left_thumb_outer_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := left_thumb_outer_shift_first()
        }
        else {
            keysToSend := left_thumb_outer_shift()
        }
    }
    else {
        keysToSend := left_thumb_outer_base()
    }
    SendInput %keysToSend%
return

*8 Up::
    if(isNavLayerPress){
        nav_layer_up()
    }
    else if(isFuncLayerPress) {
        func_layer_up()
    }
return

; Right Thumbs
;-------------------------------------------------

*Enter::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_thumb_outer_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_thumb_outer_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_thumb_outer_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_thumb_outer_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_thumb_outer_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_thumb_outer_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_thumb_outer_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_thumb_outer_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_thumb_outer_nav_first()
        }
        else {
            keysToSend := right_thumb_outer_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_thumb_outer_nav_first()
        }
        else {
            keysToSend := right_thumb_outer_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_thumb_outer_num_first()
        }
        else {
            keysToSend := right_thumb_outer_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_thumb_outer_num_first()
        }
        else {
            keysToSend := right_thumb_outer_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_thumb_outer_shift_first()
        }
        else {
            keysToSend := right_thumb_outer_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_thumb_outer_shift_first()
        }
        else {
            keysToSend := right_thumb_outer_shift()
        }
    }
    else {
        keysToSend := right_thumb_outer_base()
    }
    SendInput %keysToSend%
return

*Backspace::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_thumb_neutral_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_thumb_neutral_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_thumb_neutral_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_thumb_neutral_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_thumb_neutral_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_thumb_neutral_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_thumb_neutral_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_thumb_neutral_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_thumb_neutral_nav_first()
        }
        else {
            keysToSend := right_thumb_neutral_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_thumb_neutral_nav_first()
        }
        else {
            keysToSend := right_thumb_neutral_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_thumb_neutral_num_first()
        }
        else {
            keysToSend := right_thumb_neutral_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_thumb_neutral_num_first()
        }
        else {
            keysToSend := right_thumb_neutral_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_thumb_neutral_shift_first()
        }
        else {
            keysToSend := right_thumb_neutral_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_thumb_neutral_shift_first()
        }
        else {
            keysToSend := right_thumb_neutral_shift()
        }
    }
    else {
        keysToSend := right_thumb_neutral_base()
    }
    SendInput %keysToSend%
return

*9::
    keysToSend := ""
    if(funcLeader) {
        keysToSend := right_thumb_inner_func()
        funcLeader := False
    }
    else if(funcDownNoUp or funcLocked) {
        keysToSend := right_thumb_inner_func()
    }
    else if(shiftClipboardLeader) {
        keysToSend := right_thumb_inner_shift_clipboard()
        shiftClipboardLeader := False
    }
    else if(shiftClipboardDownNoUp) {
        keysToSend := right_thumb_inner_shift_clipboard()
    }
    else if(clipboardLeader) {
        keysToSend := right_thumb_inner_clipboard()
        clipboardLeader := False
    }
    else if(clipboardDownNoUp) {
        keysToSend := right_thumb_inner_clipboard()
    }
    else if(shiftNavLeader) {
        keysToSend := right_thumb_inner_shift_nav()
        shiftNavLeader := False
    }
    else if(shiftNavDownNoUp or shiftNavLocked) {
        keysToSend := right_thumb_inner_shift_nav()
    }
    else if(navLeader) {
        if(navFirst) {
            keysToSend := right_thumb_inner_nav_first()
        }
        else {
            keysToSend := right_thumb_inner_nav()
        }
        navLeader := False
    }
    else if(navDownNoUp or navLocked) {
        if(navFirst) {
            keysToSend := right_thumb_inner_nav_first()
        }
        else {
            keysToSend := right_thumb_inner_nav()
        }
    }
    else if(numLeader) {
        if(numFirst) {
            keysToSend := right_thumb_inner_num_first()
        }
        else {
            keysToSend := right_thumb_inner_num()
        }
        numLeader := False
    }
    else if(numDownNoUp or numLocked) {
        if(numFirst) {
            keysToSend := right_thumb_inner_num_first()
        }
        else {
            keysToSend := right_thumb_inner_num()
        }
    }
    else if(shiftLeader) {
        if(shiftFirst) {
            keysToSend := right_thumb_inner_shift_first()
        }
        else {
            keysToSend := right_thumb_inner_shift()
        }
        shiftLeader := False
    }
    else if(shiftDownNoUp or shiftLocked) {
        if(shiftFirst) {
            keysToSend := right_thumb_inner_shift_first()
        }
        else {
            keysToSend := right_thumb_inner_shift()
        }
    }
    else {
        keysToSend := right_thumb_inner_base()
    }
    SendInput %keysToSend%
return

*9 Up::
    if(isShiftNavLayerPress){
        shift_nav_layer_up()
    }
    else if(isShiftLayerPress) {
        shift_layer_up()
    }
return

; Mouse
;-------------------------------------------------

LButton::
    reset_entry_related_variables()
    SendInput {LButton Down}
return

LButton Up::
    SendInput {LButton Up}
return 

RButton::
    reset_entry_related_variables()
    SendInput {RButton Down}
return

RButton Up::
    SendInput {RButton Up}
return

; Thumb keys working properly with layers

; Wire up modifiers for real

; paste, cut, copy definitions

; Hotstrings with send level?