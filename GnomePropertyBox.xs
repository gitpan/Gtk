
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

MODULE = Gtk::Gnome::PropertyBox		PACKAGE = Gtk::Gnome::PropertyBox		PREFIX = gnome_property_box_

#ifdef GNOME_PROPERTY_BOX

Gtk::Gnome::PropertyBox_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_PROPERTY_BOX(gnome_property_box_new());
	OUTPUT:
	RETVAL

void
gnome_property_box_changed(box)
	Gtk::Gnome::PropertyBox	box

void
gnome_property_box_append_page(box, child, tab_label)
	Gtk::Gnome::PropertyBox	box
	Gtk::Widget	child
	Gtk::Widget	tab_label

#endif

