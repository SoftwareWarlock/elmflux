module Component.NavBar (navBarSignal) where

import Graphics.Element exposing (Element)
import Html exposing (button, text, Html, div, a, ul, li, h1, toElement)
import Html.Attributes exposing (href)

navbar : Html
navbar = 
        div [] 
        [ ul []
             [ li [] [ a [href "#/mouseSignal" ] [text "Mouse Signals" ] ]
             , li [] [ a [href "#/keyboardSignal" ] [text "Keyboard Signals" ] ] 
             , li [] [ a [href "#/windowSignal" ] [text "Window Signals" ] ] 
             , li [] [ a [href "#/timeSignal" ] [text "Time Signals" ] ] 
             ]
        ]

navBarSignal : Signal Element
navBarSignal = 
  Signal.constant (toElement 150 50 navbar)