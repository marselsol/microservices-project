{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text.Lazy (Text, pack, unpack)
import Data.Text.Lazy.Encoding (decodeUtf8, encodeUtf8)
import Network.HTTP.Simple
import Control.Monad.IO.Class (liftIO)

main :: IO ()
main = scotty 8091 $ do

    get "/hello" $ do
        text "Hello from Haskell microservice!"

    post "/handshake" $ do
        bodyText <- body
        let inputText = unpack $ decodeUtf8 bodyText
        liftIO $ putStrLn $ "Input from client: " ++ inputText

        let modifiedText = inputText ++ " Hello from Haskell microservice!"
        let backendUrl = "http://host.docker.internal:8092/handshake"

        initialRequest <- parseRequest backendUrl

        let newRequest = setRequestMethod "POST"
                        $ setRequestBodyLBS (encodeUtf8 $ pack modifiedText)
                        $ initialRequest

        response <- liftIO $ httpLBS newRequest

        let responseBody = getResponseBody response
        let outputText = unpack $ decodeUtf8 responseBody

        liftIO $ putStrLn $ "Output to client: " ++ outputText

        text $ pack outputText
