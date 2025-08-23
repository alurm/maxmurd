{-# LANGUAGE TemplateHaskell #-}

module Main where

import qualified Data.ByteString as BS
import Data.FileEmbed (embedFileRelative)
import Data.Text.Encoding
import Data.Text.IO as TIO

dFile :: BS.ByteString
dFile = $(embedFileRelative "README.md")

main :: IO ()
main = TIO.putStrLn $ decodeUtf8 dFile
