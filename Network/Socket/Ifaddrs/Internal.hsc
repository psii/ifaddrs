#include <bindings.dsl.h>
#include <ifaddrs.h>

module Network.Socket.Ifaddrs.Internal where
#strict_import

import Network.Socket

#num AF_INET
#num AF_INET6

#starttype struct ifaddrs
#field ifa_next , Ptr <ifaddrs>
#field ifa_name , CString
#field ifa_flags , CUInt
#field ifa_addr , Ptr SockAddr
#field ifa_netmask , Ptr SockAddr
#union_field ifa_ifu.ifu_broadaddr , Ptr SockAddr
#union_field ifa_ifu.ifu_dstaddr , Ptr SockAddr
#field ifa_data , Ptr ()
#stoptype

#ccall getifaddrs , Ptr (Ptr <ifaddrs>) -> IO CInt
#ccall freeifaddrs , Ptr <ifaddrs> -> IO ()
