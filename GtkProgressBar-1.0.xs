
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



MODULE = Gtk::ProgressBar10		PACKAGE = Gtk::ProgressBar		PREFIX = gtk_progress_bar_

#ifdef GTK_PROGRESS_BAR

double
percentage(self)
	Gtk::ProgressBar	self
	CODE:
	RETVAL = self->percentage;
	OUTPUT:
	RETVAL

#endif
