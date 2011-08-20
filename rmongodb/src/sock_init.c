#include <R.h>
#include "net.h"
#include "symbols.h"



/* Initialize the socket services */
int sock_init() {
    static int called_once;
    static int retval;
    if (called_once) return retval;
    called_once = 1;

#if defined(_WIN32)
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

