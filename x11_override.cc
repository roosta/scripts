#include <X11/Xlib.h>
XSetWindowAttributes attrs = { ParentRelative, 0L, 0, 0L, 0, 0,
  Always, 0L, 0L, False, StructureNotifyMask | ExposureMask, 0L,
  True, 0, 0 };
