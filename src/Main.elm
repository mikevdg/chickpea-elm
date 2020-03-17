module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Html exposing (Html, div, h1, img)
import Html.Attributes exposing (src)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "OData client"
    , body =
        [ layout [] <|
            column [ width fill, spacingXY 0 20 ]
                [ navBar
                , el [ centerX ] <| text "OData client"
                ]
        ]
    }


borderColour : Color
borderColour =
    rgb255 80 80 80

bggray : Color
bggray = rgb255 230 230 230

navBar : Element Msg
navBar =
    row
        [ width fill
        , paddingXY 30 4
        , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
        , Border.color borderColour
        , Background.color bggray
        ]
        [ el [ alignLeft ] <| text "VisExp"
        , el [ alignRight ] <| text "Menu"
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
