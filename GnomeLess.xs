
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

MODULE = Gtk::Gnome::Less		PACKAGE = Gtk::Gnome::Less		PREFIX = gnome_less_

#ifdef GNOME_LESS

Gtk::Gnome::Less_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_LESS(gnome_less_new());
	OUTPUT:
	RETVAL

void
gnome_less_show_file(gl, path)
	Gtk::Gnome::Less	gl
	char *	path

void
gnome_less_show_command(gl, command)
	Gtk::Gnome::Less	gl
	char *	command

void
gnome_less_show_string(gl, string)
	Gtk::Gnome::Less	gl
	char *	string

void
gnome_less_show_filestream(gl, stream)
	Gtk::Gnome::Less	gl
	FILE *	stream

void
gnome_less_fixed_font(gl)
	Gtk::Gnome::Less	gl

#endif

