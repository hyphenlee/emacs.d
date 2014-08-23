#include <stdio.h>
#include <winsock2.h>
#define SIGNEDP(x) (((x)-1)<0)
#define SIGNED_(x) (SIGNEDP(x)?"":"un")
int main(int argc, char *argv[]) {
    FILE *out;
    if (argc != 2) {
        printf("Invalid argcount!");
        return 1;
    } else
        out = fopen(argv[1], "w");
    if (!out) {
        printf("Error opening output file!");
        return 1;
    }
    fprintf (out, "(cl:in-package #:SOCKINT)\n");
    fprintf (out, "(cl:eval-when (:compile-toplevel)\n");
    fprintf (out, "  (cl:defparameter *integer-sizes* (cl:make-hash-table))\n");
    fprintf (out, "  (cl:setf (cl:gethash %d *integer-sizes*) 'sb-alien:char)\n", sizeof(char));
    fprintf (out, "  (cl:setf (cl:gethash %d *integer-sizes*) 'sb-alien:short)\n", sizeof(short));
    fprintf (out, "  (cl:setf (cl:gethash %d *integer-sizes*) 'sb-alien:long)\n", sizeof(long));
    fprintf (out, "  (cl:setf (cl:gethash %d *integer-sizes*) 'sb-alien:int)\n", sizeof(int));
    fprintf (out, ")\n");
#ifdef AF_INET
    fprintf (out, "(cl:defconstant AF-INET %d \"IP Protocol family\")\n", AF_INET);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for AF_INET (unknown to the C compiler).\")\n");
#endif
#ifdef AF_UNSPEC
    fprintf (out, "(cl:defconstant AF-UNSPEC %d \"Unspecified\")\n", AF_UNSPEC);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for AF_UNSPEC (unknown to the C compiler).\")\n");
#endif
#ifdef SOCK_STREAM
    fprintf (out, "(cl:defconstant SOCK-STREAM %d \"Sequenced, reliable, connection-based byte streams.\")\n", SOCK_STREAM);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOCK_STREAM (unknown to the C compiler).\")\n");
#endif
#ifdef SOCK_DGRAM
    fprintf (out, "(cl:defconstant SOCK-DGRAM %d \"Connectionless, unreliable datagrams of fixed maximum length.\")\n", SOCK_DGRAM);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOCK_DGRAM (unknown to the C compiler).\")\n");
#endif
#ifdef SOCK_RAW
    fprintf (out, "(cl:defconstant SOCK-RAW %d \"Raw protocol interface.\")\n", SOCK_RAW);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOCK_RAW (unknown to the C compiler).\")\n");
#endif
#ifdef SOCK_RDM
    fprintf (out, "(cl:defconstant SOCK-RDM %d \"Reliably-delivered messages.\")\n", SOCK_RDM);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOCK_RDM (unknown to the C compiler).\")\n");
#endif
#ifdef SOCK_SEQPACKET
    fprintf (out, "(cl:defconstant SOCK-SEQPACKET %d \"Sequenced, reliable, connection-based, datagrams of fixed maximum length.\")\n", SOCK_SEQPACKET);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOCK_SEQPACKET (unknown to the C compiler).\")\n");
#endif
#ifdef SOL_SOCKET
    fprintf (out, "(cl:defconstant SOL-SOCKET %d \"NIL\")\n", SOL_SOCKET);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SOL_SOCKET (unknown to the C compiler).\")\n");
#endif
#ifdef SO_DEBUG
    fprintf (out, "(cl:defconstant SO-DEBUG %d \"Enable debugging in underlying protocol modules\")\n", SO_DEBUG);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_DEBUG (unknown to the C compiler).\")\n");
#endif
#ifdef SO_REUSEADDR
    fprintf (out, "(cl:defconstant SO-REUSEADDR %d \"Enable local address reuse\")\n", SO_REUSEADDR);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_REUSEADDR (unknown to the C compiler).\")\n");
#endif
#ifdef SO_TYPE
    fprintf (out, "(cl:defconstant SO-TYPE %d \"NIL\")\n", SO_TYPE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_TYPE (unknown to the C compiler).\")\n");
#endif
#ifdef SO_ERROR
    fprintf (out, "(cl:defconstant SO-ERROR %d \"NIL\")\n", SO_ERROR);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_ERROR (unknown to the C compiler).\")\n");
#endif
#ifdef SO_DONTROUTE
    fprintf (out, "(cl:defconstant SO-DONTROUTE %d \"Bypass routing facilities: instead send direct to appropriate network interface for the network portion of the destination address\")\n", SO_DONTROUTE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_DONTROUTE (unknown to the C compiler).\")\n");
#endif
#ifdef SO_BROADCAST
    fprintf (out, "(cl:defconstant SO-BROADCAST %d \"Request permission to send broadcast datagrams\")\n", SO_BROADCAST);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_BROADCAST (unknown to the C compiler).\")\n");
#endif
#ifdef SO_SNDBUF
    fprintf (out, "(cl:defconstant SO-SNDBUF %d \"NIL\")\n", SO_SNDBUF);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_SNDBUF (unknown to the C compiler).\")\n");
#endif
#ifdef SO_RCVBUF
    fprintf (out, "(cl:defconstant SO-RCVBUF %d \"NIL\")\n", SO_RCVBUF);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_RCVBUF (unknown to the C compiler).\")\n");
#endif
#ifdef SO_KEEPALIVE
    fprintf (out, "(cl:defconstant SO-KEEPALIVE %d \"Send periodic keepalives: if peer does not respond, we get SIGPIPE\")\n", SO_KEEPALIVE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_KEEPALIVE (unknown to the C compiler).\")\n");
#endif
#ifdef SO_OOBINLINE
    fprintf (out, "(cl:defconstant SO-OOBINLINE %d \"Put out-of-band data into the normal input queue when received\")\n", SO_OOBINLINE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_OOBINLINE (unknown to the C compiler).\")\n");
#endif
#ifdef SO_LINGER
    fprintf (out, "(cl:defconstant SO-LINGER %d \"For reliable streams, pause a while on closing when unsent messages are queued\")\n", SO_LINGER);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_LINGER (unknown to the C compiler).\")\n");
#endif
#ifdef SO_SNDLOWAT
    fprintf (out, "(cl:defconstant SO-SNDLOWAT %d \"NIL\")\n", SO_SNDLOWAT);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_SNDLOWAT (unknown to the C compiler).\")\n");
#endif
#ifdef SO_RCVLOWAT
    fprintf (out, "(cl:defconstant SO-RCVLOWAT %d \"NIL\")\n", SO_RCVLOWAT);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_RCVLOWAT (unknown to the C compiler).\")\n");
#endif
#ifdef SO_SNDTIMEO
    fprintf (out, "(cl:defconstant SO-SNDTIMEO %d \"NIL\")\n", SO_SNDTIMEO);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_SNDTIMEO (unknown to the C compiler).\")\n");
#endif
#ifdef SO_RCVTIMEO
    fprintf (out, "(cl:defconstant SO-RCVTIMEO %d \"NIL\")\n", SO_RCVTIMEO);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SO_RCVTIMEO (unknown to the C compiler).\")\n");
#endif
#ifdef TCP_NODELAY
    fprintf (out, "(cl:defconstant TCP-NODELAY %d \"NIL\")\n", TCP_NODELAY);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for TCP_NODELAY (unknown to the C compiler).\")\n");
#endif
#ifdef HOST_NOT_FOUND
    fprintf (out, "(cl:defconstant HOST-NOT-FOUND %d \"Authoritative Answer Host not found.\")\n", HOST_NOT_FOUND);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for HOST_NOT_FOUND (unknown to the C compiler).\")\n");
#endif
#ifdef TRY_AGAIN
    fprintf (out, "(cl:defconstant TRY-AGAIN %d \"Non-Authoritative Host not found, or SERVERFAIL.\")\n", TRY_AGAIN);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for TRY_AGAIN (unknown to the C compiler).\")\n");
#endif
#ifdef NO_RECOVERY
    fprintf (out, "(cl:defconstant NO-RECOVERY %d \"Non recoverable errors, FORMERR, REFUSED, NOTIMP.\")\n", NO_RECOVERY);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for NO_RECOVERY (unknown to the C compiler).\")\n");
#endif
#ifdef NO_DATA
    fprintf (out, "(cl:defconstant NO-DATA %d \"Valid name, no data record of requested type.\")\n", NO_DATA);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for NO_DATA (unknown to the C compiler).\")\n");
#endif
#ifdef NO_ADDRESS
    fprintf (out, "(cl:defconstant NO-ADDRESS %d \"No address, look for MX record.\")\n", NO_ADDRESS);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for NO_ADDRESS (unknown to the C compiler).\")\n");
#endif
#ifdef MSG_OOB
    fprintf (out, "(cl:defconstant MSG-OOB %d \"NIL\")\n", MSG_OOB);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for MSG_OOB (unknown to the C compiler).\")\n");
#endif
#ifdef MSG_PEEK
    fprintf (out, "(cl:defconstant MSG-PEEK %d \"NIL\")\n", MSG_PEEK);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for MSG_PEEK (unknown to the C compiler).\")\n");
#endif
#ifdef MSG_DONTROUTE
    fprintf (out, "(cl:defconstant MSG-DONTROUTE %d \"NIL\")\n", MSG_DONTROUTE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for MSG_DONTROUTE (unknown to the C compiler).\")\n");
#endif
#ifdef SD_RECEIVE
    fprintf (out, "(cl:defconstant SHUT_RD %d \"NIL\")\n", SD_RECEIVE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SD_RECEIVE (unknown to the C compiler).\")\n");
#endif
#ifdef SD_SEND
    fprintf (out, "(cl:defconstant SHUT_WR %d \"NIL\")\n", SD_SEND);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SD_SEND (unknown to the C compiler).\")\n");
#endif
#ifdef SD_BOTH
    fprintf (out, "(cl:defconstant SHUT_RDWR %d \"NIL\")\n", SD_BOTH);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for SD_BOTH (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEADDRINUSE
    fprintf (out, "(cl:defconstant EADDRINUSE %d \"NIL\")\n", WSAEADDRINUSE);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEADDRINUSE (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEWOULDBLOCK
    fprintf (out, "(cl:defconstant EAGAIN %d \"NIL\")\n", WSAEWOULDBLOCK);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEWOULDBLOCK (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEBADF
    fprintf (out, "(cl:defconstant EBADF %d \"NIL\")\n", WSAEBADF);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEBADF (unknown to the C compiler).\")\n");
#endif
#ifdef WSAECONNREFUSED
    fprintf (out, "(cl:defconstant ECONNREFUSED %d \"NIL\")\n", WSAECONNREFUSED);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAECONNREFUSED (unknown to the C compiler).\")\n");
#endif
#ifdef WSAETIMEDOUT
    fprintf (out, "(cl:defconstant ETIMEDOUT %d \"NIL\")\n", WSAETIMEDOUT);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAETIMEDOUT (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEINTR
    fprintf (out, "(cl:defconstant EINTR %d \"NIL\")\n", WSAEINTR);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEINTR (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEINVAL
    fprintf (out, "(cl:defconstant EINVAL %d \"NIL\")\n", WSAEINVAL);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEINVAL (unknown to the C compiler).\")\n");
#endif
#ifdef WSAENOBUFS
    fprintf (out, "(cl:defconstant ENOBUFS %d \"NIL\")\n", WSAENOBUFS);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAENOBUFS (unknown to the C compiler).\")\n");
#endif
#ifdef WSAENOBUFS
    fprintf (out, "(cl:defconstant ENOMEM %d \"NIL\")\n", WSAENOBUFS);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAENOBUFS (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEOPNOTSUPP
    fprintf (out, "(cl:defconstant EOPNOTSUPP %d \"NIL\")\n", WSAEOPNOTSUPP);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEOPNOTSUPP (unknown to the C compiler).\")\n");
#endif
#ifdef WSAENETDOWN
    fprintf (out, "(cl:defconstant EPERM %d \"NIL\")\n", WSAENETDOWN);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAENETDOWN (unknown to the C compiler).\")\n");
#endif
#ifdef WSAEPROTONOSUPPORT
    fprintf (out, "(cl:defconstant EPROTONOSUPPORT %d \"NIL\")\n", WSAEPROTONOSUPPORT);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAEPROTONOSUPPORT (unknown to the C compiler).\")\n");
#endif
#ifdef WSAESOCKTNOSUPPORT
    fprintf (out, "(cl:defconstant ESOCKTNOSUPPORT %d \"NIL\")\n", WSAESOCKTNOSUPPORT);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAESOCKTNOSUPPORT (unknown to the C compiler).\")\n");
#endif
#ifdef WSAENETUNREACH
    fprintf (out, "(cl:defconstant ENETUNREACH %d \"NIL\")\n", WSAENETUNREACH);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAENETUNREACH (unknown to the C compiler).\")\n");
#endif
#ifdef WSAENOTCONN
    fprintf (out, "(cl:defconstant ENOTCONN %d \"NIL\")\n", WSAENOTCONN);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for WSAENOTCONN (unknown to the C compiler).\")\n");
#endif
#ifdef INADDR_ANY
    fprintf (out, "(cl:defconstant INADDR-ANY %d \"NIL\")\n", INADDR_ANY);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for INADDR_ANY (unknown to the C compiler).\")\n");
#endif
#ifdef FIONBIO
    fprintf (out, "(cl:defconstant FIONBIO %d \"NIL\")\n", FIONBIO);
#else
    fprintf (out, "(sb-int:style-warn \"Couldn't grovel for FIONBIO (unknown to the C compiler).\")\n");
#endif
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-alien:define-alien-type SOCKLEN-T (sb-alien:%ssigned %d)))\n", SIGNED_(int), (8*sizeof(int)));
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-alien:define-alien-type SIZE-T (sb-alien:%ssigned %d)))\n", SIGNED_(size_t), (8*sizeof(size_t)));
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-alien:define-alien-type SSIZE-T (sb-alien:%ssigned %d)))\n", SIGNED_(ssize_t), (8*sizeof(ssize_t)));
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-grovel::define-c-struct IN-ADDR %d\n", sizeof(struct in_addr));
    fprintf (out, " (ADDR (ARRAY (UNSIGNED 8)) \"u_int32_t\"\n");
{ struct in_addr t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.s_addr)) - ((unsigned long)&(t)));
}
{ struct in_addr t;
    fprintf (out, "  %d)\n", sizeof(t.s_addr));
}
    fprintf (out, "))\n");
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-grovel::define-c-struct SOCKADDR-IN %d\n", sizeof(struct sockaddr_in));
    fprintf (out, " (FAMILY INTEGER \"sa_family_t\"\n");
{ struct sockaddr_in t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.sin_family)) - ((unsigned long)&(t)));
}
{ struct sockaddr_in t;
    fprintf (out, "  %d)\n", sizeof(t.sin_family));
}
    fprintf (out, " (PORT (ARRAY (UNSIGNED 8)) \"u_int16_t\"\n");
{ struct sockaddr_in t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.sin_port)) - ((unsigned long)&(t)));
}
{ struct sockaddr_in t;
    fprintf (out, "  %d)\n", sizeof(t.sin_port));
}
    fprintf (out, " (ADDR (ARRAY (UNSIGNED 8)) \"struct in_addr\"\n");
{ struct sockaddr_in t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.sin_addr)) - ((unsigned long)&(t)));
}
{ struct sockaddr_in t;
    fprintf (out, "  %d)\n", sizeof(t.sin_addr));
}
    fprintf (out, "))\n");
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-grovel::define-c-struct HOSTENT %d\n", sizeof(struct hostent));
    fprintf (out, " (NAME C-STRING-POINTER \"char *\"\n");
{ struct hostent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.h_name)) - ((unsigned long)&(t)));
}
{ struct hostent t;
    fprintf (out, "  %d)\n", sizeof(t.h_name));
}
    fprintf (out, " (ALIASES (* C-STRING) \"char **\"\n");
{ struct hostent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.h_aliases)) - ((unsigned long)&(t)));
}
{ struct hostent t;
    fprintf (out, "  %d)\n", sizeof(t.h_aliases));
}
    fprintf (out, " (TYPE INTEGER \"int\"\n");
{ struct hostent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.h_addrtype)) - ((unsigned long)&(t)));
}
{ struct hostent t;
    fprintf (out, "  %d)\n", sizeof(t.h_addrtype));
}
    fprintf (out, " (LENGTH INTEGER \"int\"\n");
{ struct hostent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.h_length)) - ((unsigned long)&(t)));
}
{ struct hostent t;
    fprintf (out, "  %d)\n", sizeof(t.h_length));
}
    fprintf (out, " (ADDRESSES (* (* (UNSIGNED 8))) \"char **\"\n");
{ struct hostent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.h_addr_list)) - ((unsigned long)&(t)));
}
{ struct hostent t;
    fprintf (out, "  %d)\n", sizeof(t.h_addr_list));
}
    fprintf (out, "))\n");
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-grovel::define-c-struct PROTOENT %d\n", sizeof(struct protoent));
    fprintf (out, " (NAME C-STRING-POINTER \"char *\"\n");
{ struct protoent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.p_name)) - ((unsigned long)&(t)));
}
{ struct protoent t;
    fprintf (out, "  %d)\n", sizeof(t.p_name));
}
    fprintf (out, " (ALIASES (* (* T)) \"char **\"\n");
{ struct protoent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.p_aliases)) - ((unsigned long)&(t)));
}
{ struct protoent t;
    fprintf (out, "  %d)\n", sizeof(t.p_aliases));
}
    fprintf (out, " (PROTO INTEGER \"int\"\n");
{ struct protoent t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.p_proto)) - ((unsigned long)&(t)));
}
{ struct protoent t;
    fprintf (out, "  %d)\n", sizeof(t.p_proto));
}
    fprintf (out, "))\n");
    fprintf (out, "(cl:declaim (cl:inline GETPROTOBYNAME))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"getprotobyname\" GETPROTOBYNAME)\n");
    fprintf (out, "  (* PROTOENT)\n  (NAME C-STRING))\n");
    fprintf (out, "(cl:declaim (cl:inline GETPROTOBYNUMBER))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"getprotobynumber\" GETPROTOBYNUMBER)\n");
    fprintf (out, "  (* PROTOENT)\n  (PROTO INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-BIND))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"bind\" WIN32-BIND)\n");
    fprintf (out, "  INT\n  (SOCKFD INT)\n  (MY-ADDR (* T))\n  (ADDRLEN SOCKLEN-T))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-LISTEN))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"listen\" WIN32-LISTEN)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (BACKLOG INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-ACCEPT))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"accept\" WIN32-ACCEPT)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (MY-ADDR (* T))\n  (ADDRLEN INT :IN-OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-GETPEERNAME))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"getpeername\" WIN32-GETPEERNAME)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (HER-ADDR (* T))\n  (ADDRLEN SOCKLEN-T :IN-OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-GETSOCKNAME))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"getsockname\" WIN32-GETSOCKNAME)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (MY-ADDR (* T))\n  (ADDRLEN SOCKLEN-T :IN-OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-CONNECT))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"connect\" WIN32-CONNECT)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (HIS-ADDR (* T))\n  (ADDRLEN SOCKLEN-T))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-CLOSE))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"closesocket\" WIN32-CLOSE)\n");
    fprintf (out, "  INT\n  (FD INT))\n");
    fprintf (out, "(cl:declaim (cl:inline SHUTDOWN))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"shutdown\" SHUTDOWN)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (HOW INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-RECVFROM))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"recvfrom\" WIN32-RECVFROM)\n");
    fprintf (out, "  SSIZE-T\n  (SOCKET INT)\n  (BUF (* T))\n  (LEN INTEGER)\n  (FLAGS INT)\n  (SOCKADDR (* T))\n  (SOCKLEN (* SOCKLEN-T)))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-RECV))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"recv\" WIN32-RECV)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (BUF (* T))\n  (LEN INTEGER)\n  (FLAGS INTEGER))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-SEND))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"send\" WIN32-SEND)\n");
    fprintf (out, "  SSIZE-T\n  (SOCKET INT)\n  (BUF (* T))\n  (LEN SIZE-T)\n  (FLAGS INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-SENDTO))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"sendto\" WIN32-SENDTO)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (BUF (* T))\n  (LEN SIZE-T)\n  (FLAGS INT)\n  (SOCKADDR (* T))\n  (SOCKLEN SOCKLEN-T))\n");
    fprintf (out, "(cl:declaim (cl:inline GETHOSTBYNAME))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"gethostbyname\" GETHOSTBYNAME)\n");
    fprintf (out, "  (* HOSTENT)\n  (NAME C-STRING))\n");
    fprintf (out, "(cl:declaim (cl:inline GETHOSTBYADDR))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"gethostbyaddr\" GETHOSTBYADDR)\n");
    fprintf (out, "  (* HOSTENT)\n  (ADDR (* T))\n  (LEN INT)\n  (AF INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-SETSOCKOPT))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"setsockopt\" WIN32-SETSOCKOPT)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (LEVEL INT)\n  (OPTNAME INT)\n  (OPTVAL (* T))\n  (OPTLEN INT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-GETSOCKOPT))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"getsockopt\" WIN32-GETSOCKOPT)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (LEVEL INT)\n  (OPTNAME INT)\n  (OPTVAL (* T))\n  (OPTLEN INT :IN-OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WIN32-IOCTL))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"ioctlsocket\" WIN32-IOCTL)\n");
    fprintf (out, "  INT\n  (SOCKET INT)\n  (CMD INT)\n  (ARGP (UNSIGNED 32) :IN-OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WSA-SOCKET))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"WSASocketA\" WSA-SOCKET)\n");
    fprintf (out, "  INT\n  (AF INT)\n  (TYPE INT)\n  (PROTOCOL INT)\n  (LPPROTOCOLINFO (* T))\n  (G INT)\n  (FLAGS INT))\n");
    fprintf (out, "(cl:declaim (cl:inline FD->HANDLE))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"_get_osfhandle\" FD->HANDLE)\n");
    fprintf (out, "  INT\n  (FD INT))\n");
    fprintf (out, "(cl:declaim (cl:inline HANDLE->FD))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"_open_osfhandle\" HANDLE->FD)\n");
    fprintf (out, "  INT\n  (OSFHANDLE INT)\n  (FLAGS INT))\n");
    fprintf (out, "(cl:eval-when (:compile-toplevel :load-toplevel :execute) (sb-grovel::define-c-struct WSA-DATA %d\n", sizeof(struct WSAData));
    fprintf (out, " (VERSION INTEGER \"u_int16_t\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.wVersion)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.wVersion));
}
    fprintf (out, " (HIGH-VERSION INTEGER \"u_int16_t\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.wHighVersion)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.wHighVersion));
}
    fprintf (out, " (DESCRIPTION C-STRING \"char\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.szDescription)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.szDescription));
}
    fprintf (out, " (SYSTEM-STATUS C-STRING \"char\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.szSystemStatus)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.szSystemStatus));
}
    fprintf (out, " (MAX-SOCKETS INTEGER \"unsigned short\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.iMaxSockets)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.iMaxSockets));
}
    fprintf (out, " (MAX-UDP-DG INTEGER \"unsigned short\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.iMaxUdpDg)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.iMaxUdpDg));
}
    fprintf (out, " (VENDOR-INFO C-STRING-POINTER \"char *\"\n");
{ struct WSAData t;
    fprintf (out, "  %d\n", ((unsigned long)&(t.lpVendorInfo)) - ((unsigned long)&(t)));
}
{ struct WSAData t;
    fprintf (out, "  %d)\n", sizeof(t.lpVendorInfo));
}
    fprintf (out, "))\n");
    fprintf (out, "(cl:declaim (cl:inline WSA-STARTUP))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"WSAStartup\" WSA-STARTUP)\n");
    fprintf (out, "  INT\n  (WVERSIONREQUESTED (UNSIGNED 16))\n  (LPWSADATA WSA-DATA :OUT))\n");
    fprintf (out, "(cl:declaim (cl:inline WSA-GET-LAST-ERROR))\n");
    fprintf (out, "(sb-grovel::define-foreign-routine (\"WSAGetLastError\" WSA-GET-LAST-ERROR)\n");
    fprintf (out, "  INT)\n");
return 0;
}
