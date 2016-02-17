module Component.Line (toStreamLine) where

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Time
import List
import Text
import Mouse

import Component.Size exposing (seriesWidth, seriesHeight)
import Component.ShareColor exposing (elmBlue, white)

type Action a
  = TimeSignal
  | Action a

type alias Box = {
  x : Float,
  value : String
} 

initBox x value =
  Box x value

delta = Signal.map Time.inSeconds (Time.fps 30)

(pointWidth, pointHeight) = (25, 25)

startPoint : Float
startPoint =
  negate (seriesWidth / 2)

maxDisplayPoint : Int
maxDisplayPoint =
  seriesWidth // pointHeight

objectMoveX : Float -> Form -> Form
objectMoveX x shape =
  moveX startPoint shape -- start from most left instead of origin
    |> moveX x

makeBox : Float -> String -> Form
makeBox x value =
  let
    point = oval pointWidth pointHeight
            |> filled elmBlue
            |> objectMoveX x
    displayedValue = Text.fromString value
            |> text
            |> moveY (negate pointHeight)
            |> objectMoveX x
  in
    group [point, displayedValue]

initialSeries = []

moveXAsTimePassed box =
  { box | x = box.x + (pointWidth * 0.2) }

{-| Prevent overlapping of point to point but whole series jump =(
-}
moveXAsNewBoxIsAdded box =
  { box | x = box.x + pointWidth }

toStreamLine : (String -> String) -> Signal a -> Signal Element
toStreamLine f signal =
  Signal.map view (transformIntoLine f signal)

transformIntoLine f signal=
  let
    action =
      Signal.merge (Signal.map Action signal) (Signal.map (always TimeSignal) delta)

    update action series =
      case action of
        TimeSignal ->
          List.map moveXAsTimePassed series

        {-- when new action is detected --}
        Action a   ->
          let
            value = f (toString a)
            newBox = initBox 0 value
            -- move the old series forward and only display fit-screen box for perfomance reason -}
            forwardedSeries = List.take maxDisplayPoint (List.map moveXAsNewBoxIsAdded series)
          in 
            newBox :: forwardedSeries

  in
    Signal.foldp update initialSeries action


-- VIEW
view series =
  let
    boxes = List.map (\{x, value} -> makeBox x value) series
  in
  collage seriesWidth seriesHeight
    ([ timeAxisTick
      , timeAxis
      , timeAxisArrow
      ] ++ boxes )

axisLineStyle = 
  { defaultLine
    | width = 1.5
  }

timeAxisArrow : Form
timeAxisArrow =
  let
    arrowWingPointX = seriesWidth * 0.49
    arrowHeadPoint = seriesWidth * 0.5
    axis = path [ (arrowWingPointX, 5)
                , (arrowHeadPoint, 0)
                , (arrowWingPointX, -5)
                ]
  in
    traced axisLineStyle axis

timeAxis : Form
timeAxis =
  let
    axis = path [(startPoint, 0), (seriesWidth, 0)]
  in
    traced axisLineStyle axis

timeAxisTick : Form
timeAxisTick =
  let
    axis = path [ (startPoint, 10)
                , (startPoint, -10)
                ]
  in
    traced axisLineStyle axis