
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <gtk/gtk.h>

#include "GtkTypes.h"
#include "GdkTypes.h"
#include "MiscTypes.h"

#include "GtkDefs.h"

#ifndef boolSV
# define boolSV(b) ((b) ? &sv_yes : &sv_no)
#endif

MODULE = Gtk::Gnome::RootWin		PACKAGE = Gtk::Gnome::RootWin		PREFIX = gnome_root_win_

#ifdef GNOME_ROOT_WIN

Gtk::Gnome::RootWin_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	RETVAL = GTK_ROOTWIN(gtk_rootwin_new());
	OUTPUT:
	RETVAL

#endif

