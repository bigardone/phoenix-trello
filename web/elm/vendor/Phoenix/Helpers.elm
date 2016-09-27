module Phoenix.Helpers exposing (..)

import Json.Decode as Decode exposing (Value, (:=))
import Dict exposing (Dict)
import Task exposing (Task)


getIn : comparable -> comparable' -> Dict comparable (Dict comparable' value) -> Maybe value
getIn a b dict =
    Dict.get a dict `Maybe.andThen` (Dict.get b)


updateIn : comparable -> comparable' -> (Maybe value -> Maybe value) -> Dict comparable (Dict comparable' value) -> Dict comparable (Dict comparable' value)
updateIn a b update dict =
    let
        update' maybeDict =
            let
                dict' =
                    Dict.update b update (Maybe.withDefault Dict.empty maybeDict)
            in
                if Dict.isEmpty dict' then
                    Nothing
                else
                    Just dict'
    in
        Dict.update a update' dict


insertIn : comparable -> comparable' -> value -> Dict comparable (Dict comparable' value) -> Dict comparable (Dict comparable' value)
insertIn a b value dict =
    let
        update' maybeValue =
            case maybeValue of
                Nothing ->
                    Just (Dict.singleton b value)

                Just dict' ->
                    Just (Dict.insert b value dict')
    in
        Dict.update a update' dict


removeIn : comparable -> comparable' -> Dict comparable (Dict comparable' value) -> Dict comparable (Dict comparable' value)
removeIn a b dict =
    let
        remove maybeDict' =
            case maybeDict' of
                Nothing ->
                    Nothing

                Just dict' ->
                    let
                        newDict =
                            Dict.remove b dict'
                    in
                        if Dict.isEmpty newDict then
                            Nothing
                        else
                            Just newDict
    in
        Dict.update a remove dict


add : a -> Maybe (List a) -> Maybe (List a)
add value maybeList =
    case maybeList of
        Nothing ->
            Just [ value ]

        Just list ->
            Just (value :: list)


decodeReplyPayload : Value -> Maybe (Result Value Value)
decodeReplyPayload value =
    let
        result =
            Decode.decodeValue (("status" := Decode.string) `Decode.andThen` statusInfo)
                value
    in
        case result of
            Err err ->
                let
                    _ =
                        Debug.log err
                in
                    Nothing

            Ok payload ->
                Just payload


statusInfo : String -> Decode.Decoder (Result Value Value)
statusInfo status =
    case status of
        "ok" ->
            Decode.map Ok ("response" := Decode.value)

        "error" ->
            Decode.map Err ("response" := Decode.value)

        _ ->
            Decode.fail (status ++ " is a not supported status")


(&>) : Task b a -> Task b c -> Task b c
(&>) t1 t2 =
    Task.andThen t1 (\_ -> t2)


(<&>) : Task b a -> (a -> Task b c) -> Task b c
(<&>) x f =
    x `Task.andThen` f
