#include "config.h"

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>
#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#if defined(Win32)
#  include <winsock2.h>
#  include <io.h>
#  define mongo_close_socket(sock) ( closesocket(sock) )
#else
#  ifdef HAVE_UNISTD_H
#    include <unistd.h>
#  endif
#  ifdef HAVE_BSD_NETWORKING
#    include <netdb.h>
#    include <sys/socket.h>
#    include <netinet/in.h>
#    define mongo_close_socket(sock) ( close(sock) )
#  endif
#endif

#include <R_ext/Error.h>

/* only need one of these */
static const int zero = 0;
static const int one = 1;

/* Initialize the socket services */
int sock_init()
{
	static int called_once;
	static int retval;
	if (called_once) return retval;
	called_once = 1;

#if defined(Win32)
    WSADATA wsaData;
    WORD wVers = MAKEWORD(1, 1);
    return retval = (WSAStartup(wVers, &wsaData) == 0);
#elif defined(MACINTOSH)
    GUSISetup(GUSIwithInternetSockets);
	return retval = 1;
#elif defined(SIGPIPE)
	retval = 1;
    struct sigaction act;
    if (sigaction(SIGPIPE, (struct sigaction *)NULL, &act) < 0)
		retval = 0;
    else if (act.sa_handler == SIG_DFL) {
		act.sa_handler = SIG_IGN;
		if (sigaction(SIGPIPE, &act, (struct sigaction *)NULL) < 0)
			retval = 0;
    }
    return retval;
#endif
}

void sock_connect(int* port, char **host)
{
    struct sockaddr_in server;
    struct hostent *hp;
    int sock;
    int retval;

    if (!sock_init() || !(hp = gethostbyname(*host)) || (sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		*port = -1;
		return;
	}

    memcpy((char*)&server.sin_addr, hp->h_addr_list[0], hp->h_length);
    server.sin_port = htons(*port);
    server.sin_family = AF_INET;

    do // loop if interrupted permaturely with a Signal before able to complete.
		retval = connect(sock, (struct sockaddr*)&server, sizeof(server));
    while (retval == -1 && errno == EINTR);
    if (retval == -1) {
		mongo_close_socket(sock);
		sock = -1;
	}
    setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (char*)&one, sizeof(one));

    *port = sock;
}

/* close a socket */
void sock_close(int *sock)
{
	if (sock_init())
		mongo_close_socket(*sock);
}

