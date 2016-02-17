module Page.SignalFilter (view) where 

import Signal.Extra as Extra
import Graphics.Element as Element exposing (Element, flow, down)

import Keyboard
import Char

-- COMPONENT
import Component.Sandbox exposing (displaySimpleSandbox)
import Component.Note exposing (signalNote)


-- VIEW
view : Signal Element
view =
  Extra.mapMany (flow down)
    [ keyboardPressesElement
    , keyboardCharNote
    , keyboardCharElement
    , keyboardDigitNote
    , keyboardDigitElement
    ]

keyboardPressesElement : Signal Element
keyboardPressesElement =
  displaySimpleSandbox [ ( Keyboard.presses, "Keyboard.presses : Signal KeyCode") ]

keyboardCharNote : Signal Element
keyboardCharNote =
  signalNote "keyboardChar = Signal.map Char.fromCode Keyboard.presses"

keyboardChar : Signal Char
keyboardChar =
  Signal.map Char.fromCode Keyboard.presses

keyboardCharElement : Signal Element
keyboardCharElement =
  displaySimpleSandbox [ ( keyboardChar, "keyboardChar: Signal Char" ) ]

keyboardDigit : Signal Char
keyboardDigit =
  Signal.filter Char.isDigit '0' keyboardChar

keyboardDigitNote : Signal Element
keyboardDigitNote =
  signalNote "keyboardDigit = Signal.filter Char.isDigit 0 keyboardChar"

keyboardDigitElement : Signal Element
keyboardDigitElement =
  displaySimpleSandbox [ (keyboardDigit, "keyboardDigit : Signal Bool")]