module ScratchParseJson exposing (parseSimpleJson)

import DataTable exposing (Row, TableData)
import Json.Decode as JD
import Json.Decode.Pipeline as JDp
import Dict exposing (Dict)

parseSimpleJson : Result JD.Error TableData
parseSimpleJson =
    let
        json =
            """
{
  "@odata.context": "...",
  "value": [
    {
      "Field1": "Value1",
      "Field2": "Value2"
    },
    {
      "Field1": "Value3",
      "Field2": "Value4"
    }
  ]
}
"""
    in
    JD.decodeString decoder json


decoder : JD.Decoder TableData
decoder =
    JD.field "value"
        (JD.map (\a -> { rows = a })
            (JD.list rowDecoder)
        )


rowDecoder : JD.Decoder Row
rowDecoder =
    JD.map toRow
      (JD.dict JD.string)

toRow : (Dict String String) -> Row
toRow dict = Dict.values dict


