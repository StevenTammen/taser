﻿#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

*f::
    test_stack := []
    ; test_stack.Push(["a", "b", "c"])
    ; test_stack.Push(["1", "2", "3"])
    some_array := ["a", "b", "c"]
    test_stack.push(some_array)
    popped := test_stack.Pop()
    MsgBox % popped[2]
return

; global myVar := Object("i'm", "I'm")
; global hotstrings := {} ;Object("btw", "by the way", "i", "I", "i'd", "I'd", "i'll", "I'll", "i'm", "I'm", "i've", "I've")

; hotstrings["btw"] := "by the way"

; myFunc(uppercaseLetter) {
;     MsgBox % uppercaseLetter
; }

; *f::
;     x := "B"
;     y := "b"
;     MsgBox % (x = y)
; return

; global numLeader := False
; global numDownNoUp := False

; *7::
;     numLeader := True
;     numDownNoUp := True
;     return

; *7 Up::
;     numDownNoUp := False
;     return

; *t::
;     if(numLeader) {
;         numLeader := False
;         SendInput % "0"
;     }
;     else if (numDownNoUp) {
;         SendInput % "0"
;     }
;     else {
;         SendInput % "t"
;     }
;     return

; Backspace before . so can do like MyFunc().AnotherChainedFunc()

; > for Task<List[]>, => lambdas. Need to send Backspace there, and also autospace?

; ; for functionCall(); Need to send Backspace there

; Allow for spaces after ([{ for like [ 1, 2, 3 ] or { property: "value" }
; Also quotes for when concatenating spaces in string

; Need to allow for >= and <= and == and != given = autospacing

; Don't delete space before : if one_key_back was Space. So can do like `public class AmrTaskService : IAmrTaskService`
; Still need to delete normally though, because of myFunc(): in Python
; Also ternary operator like (condition) ? onething : anotherThing