module UI exposing (centralMessage, layout)

import Css
import Css.Global
import Dict exposing (Dict)
import Gen.Route as Route exposing (Route)
import Heroicons.Outline
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Svg.Attributes
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw exposing (..)


centralMessage : String -> Html msg
centralMessage message =
    div
        [ css
            [ px_2
            , pl_3
            , text_sm
            , flex
            , justify_center
            , h_56
            , pt_16
            , h_screen
            ]
        ]
        [ text message ]


layout : List (Html msg) -> Html msg
layout children =
    div []
        [ Css.Global.global Tw.globalStyles
        , div
            [ css
                [ max_w_7xl
                , mx_auto
                , Breakpoints.lg
                    [ px_8
                    ]
                ]
            ]
            children
        ]
