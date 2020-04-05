module DataTable exposing (..)

import Html exposing (..)
import Html.Attributes exposing (placeholder, style)
import Html.Events exposing (..)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDp
import Xml.Decode
import Dict exposing (Dict)
--import Schema -- TODO

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
    { tableName : String
    , schema : Schema
    , query : Query
    , tableData : Loadable TableData

    --  , edits : Edits
    }


initDataTableModel : String -> Schema -> DataTableModel
initDataTableModel tableName schema =
    { tableName = tableName
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
    { rows : List Row }

type alias Row = List CellValue

{- I am one of the cells in a table. -}


type alias CellValue =
    String


type alias ColumnDefinition =
    { heading : String
     , columnType : ColumnType
    }

type ColumnType =
    EdmString
    | Int64
    | SubColumns (List ColumnDefinition)
    | EdmGuid
    | EdmDateTimeOffset
    | EdmDuration
    

{- Schema model. The terminology is all from OData -}

type alias Schema = {
    tables : Dict String Table
--    , functions : ...
--   , actions: ...
 }

type alias Table = {
    name : String
    , definition : String -- Name of the EntityType 
    , columns : (List ColumnDefinition)
 }


initSchema : Schema
initSchema =
    { tables = Dict.empty
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
        case columnDefinitions model.schema model.tableName of
         Nothing -> Failure ("No such table: "++model.tableName)
         Just columns -> 
            case msg of
             GotHttpTableContents result ->
              case result of
                Ok json ->
                    Loaded { model | 
                        tableData = parseTableContents json columns }
                Err error ->
                    Loaded { model | tableData = Failure (httpError error) }
       

updateSchema : SchemaMessage -> Loadable Schema
updateSchema msg =
    case msg of
        GotHttpSchema result ->
            case result of
                Ok xml ->
                    -- TODO parseSchemaXml xml
                    Loaded todoSchema

                Err error ->
                    Failure (httpError error) 

todoSchemaMarker = Debug.todo "todoSchema"
todoSchema : Schema
todoSchema = {
    tables=Dict.fromList [
        ("Example Table 1",{name="Example Table 1", definition="", columns= [ 
            { heading = "Field1", columnType = EdmString }
            , { heading = "Field2", columnType = EdmString }
            ]})
        , ("Example Table 2",{name="Example Table 2", definition="", columns=[ 
            { heading = "Field1", columnType = EdmString }
            , { heading = "Field2", columnType = EdmString }
            ]})
        , ("Example Table 3",{name="Example Table 3", definition="", columns=[ 
            { heading = "Field1", columnType = EdmString }
            , { heading = "Field2", columnType = EdmString }
            ]})
        ]
 }

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

{-
parseSchemaXml : String -> Loadable Schema
parseSchemaXml xmlString =
    let
        r = Xml.Decode.decodeString Schema.schemaDecoder xmlString
    in
    case r of
        Ok value ->
            Loaded <| toTableSchema value

        Err error ->
            Failure error

toTableSchema : Schema.Schema -> Schema
toTableSchema = Debug.todo "toTableSchema"
-}

parseTableContents : String -> (List ColumnDefinition) -> Loadable TableData
parseTableContents json columns =
         let
           r =
               JD.decodeString (tableContentsDecoder columns)  json
       in
       case r of
           Ok value ->
               Loaded value

           Err error ->
               Failure (Debug.toString error)
               
{- Example contents: 

{
    "@odata.context":"https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/$metadata#Airports",
    "value":[
        {"Name":"San Francisco International Airport"
        ,"IcaoCode":"KSFO"
        ,"IataCode":"SFO"
        ,"Location": {
            "Address":"South McDonnell Road
            , San Francisco
            , CA 94128"
            ,"Loc":{
                "type":"Point",
                "coordinates":[-122.374722222222,37.6188888888889],
                "crs":{
                    "type":"name",
                    "properties":{"name":"EPSG:4326"}
                }
            },
            "City":{
                "Name":"San Francisco",
                "CountryRegion":"United States",
                "Region":"California"
            }
        }
        }, ...etc
    ]
}

-}
tableContentsDecoder : (List ColumnDefinition) -> JD.Decoder TableData
tableContentsDecoder columns =
    JD.field "value" (
        JD.map 
            (\a -> {rows=a})
            (JD.list rowDecoder))

rowDecoder : JD.Decoder Row
rowDecoder =
    JD.map Dict.values (JD.dict JD.string) -- TODO: also support sub-columns.

{-
entityDecoder : (List ColumnDefinition) -> JD.Decoder (List CellValue)
entityDecoder columnDefs =
    case columnDefs of
        [] -> []
        head::tail -> entityColumnDecoderFor head <| entityDecoder tail
-}

entityColumnDecoderFor : ColumnDefinition -> JD.Decoder CellValue
entityColumnDecoderFor columnDefinition =
    JD.string -- TODO: support other column types.

columnDefinitions : Schema -> String -> Maybe (List ColumnDefinition)
columnDefinitions schema tableName =
    case 
        Dict.get tableName schema.tables
    of 
        Just value -> Just value.columns 
        Nothing -> Nothing



{- Views -}

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
