{-# LANGUAGE BangPatterns #-}
module Network.Socket.Ifaddrs (getIfaddrs, IfaddrData(..)) where

import Network.Socket.Internal
import Network.Socket.Ifaddrs.Internal
import Foreign.Marshal.Alloc
import Foreign.C.String
import Foreign.C
import Foreign

data IfaddrData = IfaddrData
                  { ifName :: String
                  , ifAddr :: SockAddr
                  } deriving (Show, Eq)

getIfaddrs :: IO [IfaddrData]
getIfaddrs = do
  p <- malloc
  r <- c'getifaddrs p
  !res <- 
    if r /= 0 
      then
        return [] 
      else 
        let next = c'ifaddrs'ifa_next
            construct s acc 
              | s == nullPtr = return acc
              | otherwise = do 
                  s' <- peek s
                  fa <- peekByteOff (c'ifaddrs'ifa_addr s') 0 :: IO CUShort
                  if (fa == c'AF_INET) || (fa == c'AF_INET6)
                    then do
                      name <- peekCString (c'ifaddrs'ifa_name s')
                      sa <- peekSockAddr (c'ifaddrs'ifa_addr s')
                      construct (next s') (IfaddrData name sa : acc)
                    else
                      construct (next s') acc
        in peek p >>= \p' -> construct p' []
  c'freeifaddrs =<< peek p
  free p
  return res
