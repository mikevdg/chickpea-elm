module Tests exposing (parseSimpleJson)

import DataTable exposing (..)
import Dict exposing (fromList)
import Expect
import MetadataXML exposing (metadata)
import Schema exposing (schemaDecoder)
import Test exposing (Test, describe, test)
import Xml.Decode as XD
import Json.Decode as JD


parseSimpleJson : Test
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
    }
  ]
}
"""
            columns =
                                [ { heading = "Field1", columnType = EdmString }
                                , { heading = "Field2", columnType = EdmString }
                                ]
        in
        test "parseSimpleJson" <| \_ ->
            json
            |> JD.decodeString (tableContentsDecoder columns)
            |> Expect.equal
                (Ok { rows = [ [ "Value1", "Value2" ] ] })
        
