
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

MODULE = Gtk::AccelLabel		PACKAGE = Gtk::AccelLabel		PREFIX = gtk_accel_label_

#ifdef GTK_ACCEL_LABEL

Gtk::AccelLabel_Sink
gtk_accel_label_new(Class, string)
	SV 	*Class
	char	*string
	CODE:
	RETVAL = GTK_ACCEL_LABEL(gtk_accel_label_new(string));
	OUTPUT:
	RETVAL

unsigned int
gtk_accel_label_accelerator_width(self)
	Gtk::AccelLabel	self

void
gtk_accel_label_set_accel_widget(self, accel_widget)
	Gtk::AccelLabel	self
	Gtk::Widget	accel_widget

bool
gtk_accel_label_refetch(self)
	Gtk::AccelLabel	self


#endif

