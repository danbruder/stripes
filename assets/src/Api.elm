module Api exposing (makeMutation, makeRequest)

import Graphql.Http
import Graphql.Operation
import Graphql.SelectionSet


makeRequest :
    (Result (Graphql.Http.Error decodesTo) decodesTo -> msg)
    -> Graphql.SelectionSet.SelectionSet decodesTo Graphql.Operation.RootQuery
    -> Cmd msg
makeRequest toMsg query =
    query
        |> Graphql.Http.queryRequest "/graphql"
        |> Graphql.Http.send toMsg


makeMutation :
    (Result (Graphql.Http.Error decodesTo) decodesTo -> msg)
    -> Graphql.SelectionSet.SelectionSet decodesTo Graphql.Operation.RootMutation
    -> Cmd msg
makeMutation toMsg query =
    query
        |> Graphql.Http.mutationRequest "/graphql"
        |> Graphql.Http.send toMsg
