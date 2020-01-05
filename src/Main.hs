{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}

-- Original structure based on https://github.com/scotty-web/scotty/blob/master/examples/globalstate.hs
module Main
  ( main
  ) where

import           Control.Concurrent.STM
import           Control.Concurrent.Suspend           (msDelay)
import           Control.Concurrent.Timer             (repeatedTimer)
import           Control.Monad.Reader
import           Data.Aeson.Text
import           Data.Default.Class
import           Data.Text.Lazy                       (Text)
import           Model                                (Ticks, initial, update)
import           Network.Wai.Middleware.RequestLogger
import           Prelude                              ()
import           Prelude.Compat
import           Web.Scotty.Trans

newtype AppState = AppState
  { ticks :: Ticks
  }

instance Default AppState where
  def = AppState initial

newtype WebM a = WebM
  { runWebM :: ReaderT (TVar AppState) IO a
  } deriving (Applicative, Functor, Monad, MonadIO, MonadReader (TVar AppState))

webM :: MonadTrans t => WebM a -> t WebM a
webM = lift

gets :: (AppState -> b) -> WebM b
gets f = ask >>= liftIO . readTVarIO >>= return . f

modify :: (AppState -> AppState) -> WebM ()
modify f = ask >>= liftIO . atomically . flip modifyTVar' f

updateState :: AppState -> Int -> Text -> AppState
updateState state inc channel = AppState $ update (ticks state) inc channel

main :: IO ()
main = do
  sync <- newTVarIO def
  _ <-
    flip repeatedTimer (msDelay 5000) $ -- background tick every 5s
    atomically $ do
      s <- readTVar sync
      writeTVar sync $ updateState s 3 "timer"
  let runActionToIO m = runReaderT (runWebM m) sync
  scottyT 3000 runActionToIO app

app :: ScottyT Text WebM ()
app = do
  middleware logStdoutDev
  get "/" $ do
    c <- webM $ gets ticks
    text $ encodeToLazyText c -- deliver app state as JSON
  get "/plusone" $ do
    webM $ modify $ \st -> updateState st 1 "plusone"
    redirect "/"
  get "/plustwo" $ do
    webM $ modify $ \st -> updateState st 2 "plustwo"
    redirect "/"
