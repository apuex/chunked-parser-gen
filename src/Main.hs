module Main where

import           CmdLine
import qualified Control.Monad       as M
import           System.IO
import           System.Environment
import           System.FilePath

main :: IO ()
main = do
    progName <- getProgName
    args     <- getArgs
    (opts, files) <- compileOpts progName args
    if null files
        then hPutStrLn stderr (header progName)
        else M.mapM_ (transform opts) files

transform :: Options -> String -> IO ()
transform opts inputFile = return ()
