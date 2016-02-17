module Component.Note (signalNote, emptySpace) where

import Text
import Graphics.Element as Element exposing (Element)

import Config.Size exposing (seriesWidth, seriesHeight, seriesValueWidth)

{- Even the note need to be a Signal
   Because at the top level we want to mapMany
 -}
signalNote : String -> Signal Element
signalNote notes = 
  Signal.constant (toElement notes)

emptySpace : Signal Element
emptySpace =
  Signal.constant (toElement "")

toElement : String -> Element
toElement str =
  let
    totalWidth = seriesWidth
    textElement = 
      Text.fromString str
        |> Text.height 20
        |> Text.typeface ["Source Sans Pro", "sans-serif"]
        |> Element.justified
  in
    Element.container totalWidth seriesHeight Element.middle textElement