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

MODULE = Gtk::Adjustment		PACKAGE = Gtk::Adjustment		PREFIX = gtk_adjustment_

#ifdef GTK_ADJUSTMENT

Gtk::Adjustment_Sink
new(Class, value, lower, upper, step_increment, page_increment, page_size)
	SV *	Class
	double	value
	double	lower
	double	upper
	double	step_increment
	double	page_increment
	double	page_size
	CODE:
	RETVAL = GTK_ADJUSTMENT(gtk_adjustment_new(value, lower, upper, step_increment, page_increment, page_size));
	OUTPUT:
	RETVAL

void
gtk_adjustment_set_value (self, value)
	Gtk::Adjustment self
	double value

gfloat
gtk_adjustment_get_value (self)
	Gtk::Adjustment self
	CODE:
	RETVAL = self->value;
	OUTPUT:
	RETVAL

#endif
