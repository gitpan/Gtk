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

MODULE = Gtk::Toolbar		PACKAGE = Gtk::Toolbar		PREFIX = gtk_toolbar_

#ifdef GTK_TOOLBAR

Gtk::Toolbar
new(Class, orientation, style)
	SV *	Class
	Gtk::Orientation	orientation
	Gtk::ToolbarStyle	style
	CODE:
	RETVAL = GTK_TOOLBAR(gtk_toolbar_new(orientation, style));
	OUTPUT:
	RETVAL

void
gtk_toolbar_set_orientation(toolbar, orientation)
	Gtk::Toolbar	toolbar
	Gtk::Orientation	orientation

#endif
