
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

MODULE = Gtk::Entry		PACKAGE = Gtk::Entry	PREFIX = gtk_entry_

#ifdef GTK_ENTRY

Gtk::Entry
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_ENTRY(gtk_entry_new());
	OUTPUT:
	RETVAL

void
gtk_entry_set_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_append_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_prepend_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_set_position(self, position)
	Gtk::Entry	self
	int	position

char *
gtk_entry_get_text(self)
	Gtk::Entry	self

#endif
