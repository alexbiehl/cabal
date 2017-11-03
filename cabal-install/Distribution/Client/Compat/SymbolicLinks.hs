{-# LANGUAGE CPP #-}
module Distribution.Client.Compat.SymbolicLinks (
    isSymbolicLinkFile
  , removeSymbolicLink
  , createSymbolicLink
  ) where

#ifdef mingw32_HOST_OS

import qualified System.Win32.File
import qualified System.Win32.SymbolicLink
import Data.Bits ((.&.))

removeSymbolicLink :: FilePath -> IO ()
removeSymbolicLink = System.Win32.File.deleteFile

createSymbolicLink :: FilePath -> FilePath -> IO ()
createSymbolicLink from to =
  System.Win32.SymbolicLink.createSymbolicLinkFile to from

isSymbolicLinkFile :: FilePath -> IO Bool
isSymbolicLinkFile file = do
  attributes <- System.Win32.File.getFileAttributes file
  return ((attributes .&. System.Win32.File.fILE_ATTRIBUTE_REPARSE_POINT) /= 0)

#else

import qualified System.Posix.Files

removeSymbolicLink :: FilePath -> IO ()
removeSymbolicLink = System.Posix.Files.removeLink

createSymbolicLink :: FilePath -> FilePath -> IO ()
createSymbolicLink = System.Posix.Files.createSymbolicLink

isSymbolicLinkFile :: FilePath -> IO Bool
isSymbolicLinkFile path = do
  status <- System.Posix.Files.getSymbolicLinkStatus path
  return (System.Posix.Files.isSymbolicLink status)

#endif
