
#define R r
#define W w

#ifndef R
#   ifdef W
#       ifndef X
2 NOPE
#       else
3 NOPE
#       endif
#   else
#       ifdef X
1 NOPE
#       else
0 NOPE
#       endif
#   endif
#else
#   ifdef W
#       ifdef X
7 NOPE
#       else
6 CORRECT
#       endif
#   else
#       ifndef X
4 NOPE
#       else
5 NOPE
#       endif
#   endif
#endif
