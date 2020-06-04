module CmdLine where

import           Data.Char
import           System.Console.GetOpt
import           System.IO
import           System.Exit
import           Text.Printf


data ProjectType
    = Autotools
    | CMake
    | Unknown
    deriving (Enum, Eq, Show)

data Options = Options
    { project   :: ProjectType
    , printHelp :: Bool
    } deriving Show

defaultOptions :: Options
defaultOptions = Options
    { project   = CMake
    , printHelp = False
    }

projectType :: String -> ProjectType
projectType s = case (map toLower s) of
    "autotools" -> Autotools
    "cmake" -> CMake
    x -> Unknown


options :: [OptDescr (Options -> Options)]
options =
    [ Option []    ["project"] (ReqArg (\ o opts -> opts { project = projectType o }) "Autotools/CMake"    ) "project type"
    , Option ['h'] ["help"] (NoArg  (\   opts -> opts { printHelp = True })                   ) "print this help message"]

compileOpts :: PrintfArg t => t -> [String] -> IO (Options, [String])
compileOpts progName argv = case getOpt Permute options argv of
    (o,n,[]  ) -> do
        let opts = foldl (flip id) defaultOptions o
        if printHelp opts
            then do hPutStr stderr (usageInfo (header progName) options)
                    exitSuccess
            else return (opts, n)
    (_,_,errs) -> ioError (userError (concat errs ++ usageInfo (header progName) options))

header :: PrintfArg t => t -> String
header = printf "Usage: %s [OPTION...] model files..."


