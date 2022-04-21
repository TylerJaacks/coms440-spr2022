
#define YES

#ifdef YES
    "GOOD1"
#endif

#ifdef NO
    "BAD"
#endif

#ifndef YES
    "BAD"
#endif

#ifndef NO
    "GOOD2"
#endif

#ifdef YES
    "GOOD3"
#else
    "BAD"
#endif

#ifdef NO
    "BAD"
#else
    "GOOD4"
#endif

#ifndef YES
    "BAD"
#else
    "GOOD5"
#endif

#ifndef NO
    "GOOD6"
#else
    "BAD"
#endif

#ifdef YES
#   ifdef NO
        "BAD"
#   else
        "GOOD7"
#   endif
#else
#   ifdef NO
        "BAD"
#   else
        "BAD"
#   endif
#endif
