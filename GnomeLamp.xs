
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

MODULE = Gtk::Gnome::Lamp		PACKAGE = Gtk::Gnome::Lamp		PREFIX = gnome_lamp_

#ifdef GNOME_LAMP

Gtk::Gnome::Lamp_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_LAMP(gnome_lamp_new());
	OUTPUT:
	RETVAL

Gtk::Gnome::Lamp_Sink
new_with_color(Class, color)
	SV *	Class
	Gtk::Gdk::Color	color
	CODE:
	RETVAL = GNOME_LAMP(gnome_lamp_new_with_color(color));
	OUTPUT:
	RETVAL

Gtk::Gnome::Lamp_Sink
new_with_type(Class, type)
	SV *	Class
	char *	type
	CODE:
	RETVAL = GNOME_LAMP(gnome_lamp_new_with_type(type));
	OUTPUT:
	RETVAL

void
gnome_lamp_set_color(lamp, color)
	Gtk::Gnome::Lamp	lamp
	Gtk::Gdk::Color	color

void
gnome_lamp_set_sequence(lamp, seq)
	Gtk::Gnome::Lamp	lamp
	char *	seq

void
gnome_lamp_set_type(lamp, type)
	Gtk::Gnome::Lamp	lamp
	char *	type

#endif

