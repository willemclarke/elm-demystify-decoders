module Exercise10 exposing (Person, PersonDetails, Role(..), decoder)

import Json.Decode exposing (Decoder)



{- Let's try and do a complicated decoder, this time. No worries, nothing new
   here: applying the techniques you've used in the previous decoders should
   help you through this one.

   A couple of pointers:
    - try working "inside out". Write decoders for the details and role first
    - combine those decoders + the username and map them into the Person constructor
    - finally, wrap it all together to build it into a list of people


   Example input:

        [ { "username": "Phoebe"
          , "role": "regular"
          , "details":
            { "registered": "yesterday"
            , "aliases": [ "Phoebs" ]
            }
          }
        ]
-}


type alias Person =
    { username : String
    , role : Role
    , details : PersonDetails
    }


type alias PersonDetails =
    { registered : String
    , aliases : List String
    }


type Role
    = Newbie
    | Regular
    | OldFart


decoder : Decoder (List Person)
decoder =
    Json.Decode.list personDecoder


personDecoder : Decoder Person
personDecoder =
    Json.Decode.map3 Person
        (Json.Decode.field "username" Json.Decode.string)
        (Json.Decode.field "role" roleDecoder)
        (Json.Decode.field "details" personDetailsDecoder)


roleDecoder : Decoder Role
roleDecoder =
    Json.Decode.string |> Json.Decode.andThen roleFromString


roleFromString : String -> Decoder Role
roleFromString role =
    case role of
        "newbie" ->
            Json.Decode.succeed Newbie

        "regular" ->
            Json.Decode.succeed Regular

        "oldfart" ->
            Json.Decode.succeed OldFart

        _ ->
            Json.Decode.fail <| "I don't know a role named " ++ role


personDetailsDecoder : Decoder PersonDetails
personDetailsDecoder =
    Json.Decode.map2 PersonDetails
        (Json.Decode.field "registered" Json.Decode.string)
        (Json.Decode.field "aliases" (Json.Decode.list Json.Decode.string))



{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm-test tests/Exercise10`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise10`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise10`
-}
