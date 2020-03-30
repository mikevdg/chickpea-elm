module DataTable exposing (..)

import Html exposing (..)
import Html.Attributes exposing (placeholder, style)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Xml.Decode exposing (..)
import Debug exposing (todo)

---- Progress markers ----


todoSpinner =
    Debug.todo "Make a spinner when it's loading data. "


todoReadSchema =
    Debug.todo "Read the OData schema."


todoReadTable =
    Debug.todo "Read the OData table data"


todoScrollBar =
    Debug.todo "Make the scrollbar scroll"


todoSearchBar =
    Debug.todo "Search bar functionality."


todoColumnSort =
    Debug.todo "Click column headings to sort them."


todoColumnRearrange =
    Debug.todo "Drag and drop headings to rearrange columns."


todoHideColumn =
    Debug.todo "Context menu to hide and show columns"


todoEditTable =
    Debug.todo "Edit cells"



---- Model ----
type SchemaMessage =
    GotHttpSchema (Result Http.Error String)

type Msg = 
    GotHttpTableContents (Result Http.Error String)

type Loadable a
    = Failure String
    | Loading
    | Loaded a



{- I am a model for the on-page table -}


type alias DataTableModel =
    { entityName : String
    , schema : Schema
    , query : Query
    , tableData : Loadable TableData

    --  , edits : Edits
    }


initDataTableModel : String -> Schema -> DataTableModel
initDataTableModel entityName schema =
    { entityName = entityName
    , schema = schema
    , query = initQuery
    , tableData = Loading
    }



{- I am the "filter" and the "columns" of an on-page table. -}


type alias Query =
    { scrollSkip : Int
    , scrollTop : Int
    , visibleColumns : List ColumnDefinition

    --    , filter : Filter
    }


initQuery : Query
initQuery =
    { scrollSkip = 100
    , scrollTop = 0
    , visibleColumns = []
    }



{- I am the cell values of an on-page table. -}


type alias TableData =
    { rows : List CellValue }



{- I am one of the cells in a table. -}


type alias CellValue =
    String


type alias ColumnDefinition =
    { heading : String

    -- , type : ColumnType
    }


type alias Schema =
    { endpoints : List String
    }


initSchema : Schema
initSchema =
    { endpoints = []
    }


-- Update --


updateDataTable : Msg -> Loadable DataTableModel -> Loadable DataTableModel
updateDataTable msg loading =
    case loading of
       Failure foo -> 
        Failure foo
       Loading -> 
           Loading
       Loaded model -> 
            case msg of
             GotHttpTableContents result ->
              case result of
                Ok json ->
                    Loaded { model | tableData = parseTableContents json }

                Err error ->
                    Loaded { model | tableData = Failure (httpError error) }
       

updateSchema : SchemaMessage -> Loadable Schema
updateSchema msg =
    case msg of
        GotHttpSchema result ->
            case result of
                Ok xml ->
                 parseSchemaXml xml

                Err error ->
                    Failure (httpError error) 


httpGetSchema : Cmd SchemaMessage
httpGetSchema =
    Http.get
        { url = "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/$metadata"
        , expect = Http.expectString GotHttpSchema
        }


refreshTable :
    String
    -> Cmd Msg -- Needs a Query.
refreshTable tableName =
    Http.get
        { url = "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/" ++ tableName ++ "?$format=json"
        , expect = Http.expectString GotHttpTableContents
        }


metadataDecoder : Xml.Decode.Decoder Schema
metadataDecoder =
    Xml.Decode.map Schema
        (path [ "edmx:DataServices", "Schema", "EntityContainer", "EntitySet" ]
            (Xml.Decode.list
                (stringAttr "Name")
            )
        )


parseSchemaXml : String -> Loadable Schema
parseSchemaXml xmlString =
    let
        r =
            Xml.Decode.decodeString metadataDecoder xmlString
    in
    case r of
        Ok value ->
            Loaded value

        Err error ->
            Failure error

parseTableContents : String -> Loadable TableData
parseTableContents json =
         let
           r =
               Json.Decode.decodeString tableContentsDecoder json
       in
       case r of
           Ok value ->
               Loaded value

           Err error ->
               Failure (Debug.toString error)
               

tableContentsDecoder : Json.Decode.Decoder todo

tableContentsDecoder = Debug.todo "tableContentsDecoder"

viewDataTable : Loadable DataTableModel -> Html Msg
viewDataTable model =
    Html.div
        []
        [ filterDiv
        , Html.div
            [ style "display" "grid"
            , style "height" "300px"
            , style "width" "300px"
            ]
            [ scrollDiv
            , contentsDiv
            ]
        ]


todoMarginTop =
    Debug.todo "Need DOM access for margin-top and margin-bottom here (and margin-right later). Otherwise it isn't aligned."


scrollDiv : Html Msg
scrollDiv =
    Html.div
        [ style "overflow-y" "scroll"
        , style "grid-column" "1"
        , style "grid-row" "1"
        , style "z-index" "2"
        , style "pointer-events" "none"
        , style "margin-top" "47px"
        , style "margin-bottom" "12px"
        ]
        [ Html.div
            [ style "height" "10000px"
            , style "width" "100%"
            ]
            []
        ]


contentsDiv : Html Msg
contentsDiv =
    Html.div
        [ style "overflow-x" "auto"

        --, style "overflow-y" ""
        , style "grid-column" "1"
        , style "grid-row" "1"
        , style "z-index" "1"
        , style "margin-right" "12px"
        ]
        [ dataTableContents
        ]


filterDiv : Html Msg
filterDiv =
    Html.div [ style "background" "gray" ]
        [ Html.input [ Html.Attributes.placeholder "Search..." ] [] ]


cellStyle : Html.Attribute msg
cellStyle =
    style "border" "1px solid gray"


exampleData : Html msg
exampleData =
    tr []
        [ td [ cellStyle ] [ Html.text "Cell A2" ]
        , td [ cellStyle ] [ Html.text "Cell B1" ]
        , td [ cellStyle ] [ Html.text "Cell B2" ]
        ]


dataTableContents : Html Msg
dataTableContents =
    Html.table
        [ style "border" "1px solid grey"
        , style "border-collapse" "collapse"
        ]
        [ thead [ style "background-color" "darkgrey" ]
            [ tr []
                [ th
                    [ cellStyle
                    , Html.Attributes.rowspan 2
                    ]
                    [ Html.text "Column A" ]
                , th
                    [ cellStyle
                    , Html.Attributes.colspan 2
                    ]
                    [ Html.text "Column B" ]
                ]
            , tr []
                [ th [ cellStyle ]
                    [ Html.text "Column B1" ]
                , th [ cellStyle ]
                    [ Html.text "Column B2" ]
                ]
            ]
        , tbody []
            [ exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            ]
        ]



httpError : Http.Error -> String
httpError httpE =
    case httpE of
        Http.BadUrl string ->
            "BadURL: " ++ string

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody body ->
            "Bad body: " ++ body
