#Requires AutoHotkey >=2.0-
#SingleInstance Force
SendMode("Event")

; Name        : Null Strafe Movement
; Description : Force single strafe input only
; Version     : v1.0.1
; Author      : https://github.com/GNanosecond
; Repository  : https://github.com/GNanosecond/null-movement

; ＼(＾O＾)／

; = = = PROPERTIES = = =
targetPollRate := 60
; (default target 60 FPS)

/*
= = = /PROPERTIES = = =
*/

keyQueue := []

_targetFPS := Integer(1000 / targetPollRate)
if (!_targetFPS) {
	_targetFPS := 1
}

^Escape:: {
	send("{CTRL Down}{Escape Down}{Escape Up}{CTRL Up}")
	ExitApp(0)
}

addKeyQueue(keyID) {
	if (keyQueue.Length) {
		if (keyQueue[-1] == keyID) {
			return
		}
		send("{" . keyQueue[-1] . " Up}")
	}
	keyQueue.Push(keyID)
	send("{" . keyID . " Down}")
}

*a:: {
	addKeyQueue("a")
}

*d:: {
	addKeyQueue("d")
}

while (true) {
	sleep(_targetFPS)
	readjust := False
	while (keyQueue.Length) {
		if (GetKeyState(keyQueue[-1]) and !GetKeyState(keyQueue[-1], "P")) {
			Send("{" . keyQueue.Pop() . " Up}")
			readjust := True
			Continue
		} else {
			Break
		}
	}
	curKey := 0
	While (curKey < keyQueue.Length) {
		curKey++
		if (!GetKeyState(keyQueue[curKey], "P")) {
			readjust := True
			if (GetKeyState(keyQueue[curKey])) {
				Send("{" . keyQueue[curKey] . " Up}")
			}
			keyQueue.RemoveAt(curKey, 1)
			Continue
		}
	}
	if (readjust and keyQueue.Length) {
		Send("{" . keyQueue[-1] . " Down}")
	}
}