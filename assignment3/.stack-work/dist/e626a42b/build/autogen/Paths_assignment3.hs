{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_assignment3 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\bin"
libdir     = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\lib\\x86_64-windows-ghc-8.6.3\\assignment3-0.1.0.0-1DFvuy72ZJrE0fXsM2rMND"
dynlibdir  = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\lib\\x86_64-windows-ghc-8.6.3"
datadir    = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\share\\x86_64-windows-ghc-8.6.3\\assignment3-0.1.0.0"
libexecdir = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\libexec\\x86_64-windows-ghc-8.6.3\\assignment3-0.1.0.0"
sysconfdir = "C:\\Users\\Genet Atakillt\\Desktop\\A3 final\\assignment3\\.stack-work\\install\\5adf4686\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "assignment3_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "assignment3_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "assignment3_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "assignment3_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "assignment3_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "assignment3_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
