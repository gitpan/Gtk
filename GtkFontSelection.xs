
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

MODULE = Gtk::FontSelection	PACKAGE = Gtk::FontSelection	PREFIX = gtk_font_selection_

#ifdef GTK_FONT_SELECTION

Gtk::FontSelection_Sink
gtk_font_selection_new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_FONT_SELECTION(gtk_font_selection_new());
	OUTPUT:
	RETVAL

char*
gtk_font_selection_get_font_name(self)
	Gtk::FontSelection	self

Gtk::Gdk::Font
gtk_font_selection_get_font(self)
	Gtk::FontSelection	self

bool
gtk_font_selection_set_font_name(self, font_name)
	Gtk::FontSelection	self
	char*			font_name

char*
gtk_font_selection_get_preview_text(self)
	Gtk::FontSelection	self

void
gtk_font_selection_set_preview_text(self, text)
	Gtk::FontSelection	self
	char*			text

#endif

