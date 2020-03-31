module Main exposing (..)

import Browser
import Element as El
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html, ul, li, text, div, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import DataTable as Dt

init : ( Model, Cmd Msg )
init =
    ( { schema = Dt.Loading
      , currentTable = Dt.Loading
      }
    , Cmd.map SchemaMessage Dt.httpGetSchema
    )

---- Model ----

{- The currentTable here is Dt.Loadable because it doesn't have columns yet. It's contents
are also Dt.Loadable because they are constantly refreshing when the user scrolls.-}
type alias Model =
    { schema : Dt.Loadable Dt.Schema
    , currentTable : Dt.Loadable Dt.DataTableModel
    }


---- Update ----


type Msg
    = RefreshSchema
    | ChooseTable String
    | SchemaMessage Dt.SchemaMessage
    | DataTableMessage Dt.Msg


update : Msg -> Model -> ( Model, Cmd Msg )

update message model =
    case message of
        RefreshSchema ->
            ( { model | schema = Dt.Loading }, (Cmd.map SchemaMessage Dt.httpGetSchema) )

        DataTableMessage m -> 
            ( { model | currentTable = Dt.updateDataTable m model.currentTable} 
            , Cmd.none)

        SchemaMessage m ->
            ( { model | schema = Dt.updateSchema m }
            ,Cmd.none)

        ChooseTable entityName ->
            ( chooseTable entityName model, (Cmd.map DataTableMessage (Dt.refreshTable entityName)) )


chooseTable : String -> Model -> Model
chooseTable name model =
    case model.schema of
     Dt.Failure reason -> model
     Dt.Loading -> model
     Dt.Loaded schema -> 
      {   schema = Dt.Loaded schema
        , currentTable = Dt.Loaded (Dt.initDataTableModel name schema)
       }

---- View ----


view : Model -> Browser.Document Msg
view model =
    { title = "OData client"
    , body =
        [ El.layout [] <|
            El.column [ El.width El.fill, El.height El.fill, El.spacingXY 0 0 ]
                [ navBar
                , El.row [ El.height El.fill, El.width El.fill ]
                    [ leftPane model
                    , El.el [ El.centerX ] <| El.html <| Html.map DataTableMessage (Dt.viewDataTable model.currentTable)
                    , rightPane
                    ]
                ]
        ]
    }


borderColour : El.Color
borderColour =
    El.rgb255 80 80 80


bggray : El.Color
bggray =
    El.rgb255 230 230 230


navBar : El.Element Msg
navBar =
    El.row
        [ El.width El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
        , Border.color borderColour
        , Background.color bggray
        ]
        [ El.el [ El.centerX ] <| El.text "OData client"
        ]


leftPane : Model -> El.Element Msg
leftPane model =
    El.column
        [ El.height El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 0, right = 2 }
        , Background.color bggray
        ]
        [ El.el [] <| El.html <| viewEntities model
        ]


rightPane : El.Element Msg
rightPane =
    El.column
        [ El.height El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 2, right = 0 }
        , Background.color bggray
        ]
        [ El.el [] <| El.text "Right pane placeholder!"
        ]


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


viewEntities : Model -> Html Msg
viewEntities model =
    case model.schema of
        Dt.Failure error ->
            div []
                [ text ("Failed to load: " ++ error)
                , button [ onClick RefreshSchema ] [ text "Try Again!" ]
                ]

        Dt.Loading ->
            text "Loading..."

        Dt.Loaded data ->
            div []
                [ button [ onClick RefreshSchema, style "display" "block" ] [ text "Reload!" ]
                , viewEntityList data.entities
                ]


viewEntityList : List String -> Html Msg
viewEntityList entityList =
    ul []
        (List.map
            (\it ->
                li
                    [ onClick (ChooseTable it)
                    , style "cursor" "pointer"
                    ]
                    [ text it ]
            )
            entityList
        )
