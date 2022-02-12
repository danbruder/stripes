module Pages.Home_ exposing (Model, Msg, page)

import Api
import Effect exposing (Effect)
import Gen.Params.Home_ exposing (Params)
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (with)
import Html.Styled as Html exposing (..)
import Juniper.Object
import Juniper.Object.Item as Item
import Juniper.Query as Query
import Page
import Request
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { items : List Item }


init : ( Model, Effect Msg )
init =
    ( { items = []
      }
    , loadItems |> Effect.fromCmd
    )


loadItems =
    Query.items
        (SelectionSet.succeed Item
            |> with Item.id
            |> with Item.title
            |> with Item.complete
        )
        |> Api.makeRequest GotItems


type alias Item =
    { id : String
    , title : String
    , complete : Bool
    }



-- UPDATE


type Msg
    = GotItems (Result (Graphql.Http.Error (List Item)) (List Item))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotItems response ->
            case response of
                Ok items ->
                    ( { model | items = items }, Effect.none )

                _ ->
                    ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Home"
    , body = [ Html.toUnstyled <| UI.layout [ viewBody model ] ]
    }


viewBody : Model -> Html Msg
viewBody model =
    let
        viewItem item =
            ul [] [ text item.title ]
    in
    ul [] <|
        List.map viewItem model.items
