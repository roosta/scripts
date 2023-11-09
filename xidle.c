#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/extensions/scrnsaver.h>

/* Report amount of X server idle time. */
/* Build with- */
/* cc xidle.c -o xidle -lX11 -lXext -lXss */
/* https://unix.stackexchange.com/questions/434625/x11-how-can-i-determine-what-is-preventing-dpms-from-suspending-my-display */

int main(int argc, char *argv[])
{
  Display *display;
  int event_base, error_base;
  XScreenSaverInfo info;
  float seconds;

  display = XOpenDisplay("");

  if (XScreenSaverQueryExtension(display, &event_base, &error_base)) {
    XScreenSaverQueryInfo(display, DefaultRootWindow(display), &info);

    seconds = (float)info.idle/1000.0f;
    printf("%f\n",seconds);
    return(0);
  }
  else {
    fprintf(stderr,"Error: XScreenSaver Extension not present\n");
    return(1);
  }
}
