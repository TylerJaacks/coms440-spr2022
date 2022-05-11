
#define R r
#define W w

#ifdef R
#   ifdef W
#       ifdef X
7 NOPE
#       else
6 CORRECT
#       endif
#   else
#       ifdef X
5 NOPE
#       else
4 NOPE
#       endif
#   endif
#else
#   ifdef W
#       ifdef X
3 NOPE
#       else
2 NOPE
#       endif
#   else
#       ifdef X
1 NOPE
#       else
0 NOPE
#       endif
#   endif
#endif
