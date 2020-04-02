module Schema exposing (schemaDecoder)

import Xml.Decode exposing (..)

{- Parsing the schema -}
{- All the terminology here is OData terminology. -} 

schemaDecoder : Xml.Decode.Decoder Schema
schemaDecoder =
    path [ "edmx:DataServices", "Schema" ]
        ( Xml.Decode.list decodeSchemaEntry )
    

decodeSchemaEntry : Decoder SchemaEntry
decodeSchemaEntry =
    oneOf [
        decodeEntityType
        , decodeComplexType
    ]

decodeEntityType : Decoder SchemaEntry
decodeEntityType = 
    map2 EntityType
        (path ["EntityType"] (single (stringAttr "name")))
        (path ["EntityType"] (list decodeEntityTypeEntry))

{-
map2 : (a -> b -> value) -> Decoder a -> Decoder b -> Decoder value
asEntityType : String -> List EntityTypeEntry -> SchemaEntry
path: List String -> ListDecoder a -> Decoder a

-}

decodeComplexType : Decoder SchemaEntry
decodeComplexType = 
    map2 ComplexType
        (path ["ComplexType"] (single (stringAttr "name")))
        (path ["ComplexType"] (list decodeEntityTypeEntry))

decodeEntityTypeEntry : Decoder EntityTypeEntry
decodeEntityTypeEntry = oneOf [
    decodeProperty
    , decodeNavigationProperty
 ]

decodeProperty : Decoder EntityTypeEntry
decodeProperty = path ["Property"]
    ( Debug.todo "decodeProperty")

decodeNavigationProperty : Decoder EntityTypeEntry
decodeNavigationProperty = path ["NavigationProperty"] 
    (Debug.todo "decodeNavigationProperty")

type alias Schema = List SchemaEntry

type SchemaEntry = 
    EntityType String (List EntityTypeEntry)
    | ComplexType String (List EntityTypeEntry)
    | EnumType -- TODO
    | Function
    | Action
    | EntityContainer String (List EntityContainerEntry)

type EntityTypeEntry =
    Key (List PropertyDetails)
    | Property PropertyDetails
    | NavigationProperty PropertyDetails

type alias PropertyDetails = {
    name : String
    , entityType : String -- "type=..."
    , nullable : Bool
 }

type alias NavigationPropertyDetails = {
    name : String
    , entityType : String
 }

type EntityContainerEntry =
    EntitySet EntitySetDetails
    | Singleton -- TODO
    | FunctionImport -- TODO
    | ActionImport -- TODO

type alias EntitySetDetails = {
    name : String
    , entityType : String
 }