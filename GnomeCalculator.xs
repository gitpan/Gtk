
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

MODULE = Gtk::Gnome::Calculator		PACKAGE = Gtk::Gnome::Calculator		PREFIX = gnome_calculator_

#ifdef GNOME_CALCULATOR

Gtk::Gnome::Calculator_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_CALCULATOR(gnome_calculator_new());
	OUTPUT:
	RETVAL

#endif

