{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Model
  ( update
  , Ticks
  , initial
  ) where

import           Data.Aeson
import           Data.Text.Lazy (Text)
import           GHC.Generics

data Ticks = Ticks
  { tickCount :: Int
  , channels  :: [Text]
  } deriving (Generic, ToJSON, FromJSON)

update :: Ticks -> Int -> Text -> Ticks
update current inc channel =
  Ticks
  { tickCount = tickCount current + inc
  , channels = take 10 $ channel : channels current
  }

initial :: Ticks
initial = Ticks {tickCount = 0, channels = ["initial"]}
