
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

MODULE = Gtk::Gnome::FontSelector		PACKAGE = Gtk::Gnome::FontSelector		PREFIX = gnome_font_selector_

#ifdef GNOME_FONT_SELECTOR

Gtk::Gnome::FontSelector_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_FONT_SELECTOR(gnome_font_selector_new());
	OUTPUT:
	RETVAL

SV *
gnome_font_selector_get_selected(text_tool)
	Gtk::Gnome::FontSelector	text_tool
	CODE:
	{
		char * c = gnome_font_selector_get_selected(text_tool);
		RETVAL = newSVpv(c, 0);
		if (c)
			free(c);
	}
	OUTPUT:
	RETVAL

SV *
gnome_font_selector_select(Class)
	SV *	Class
	CODE:
	{
		char * c = gnome_font_select();
		RETVAL = newSVpv(c, 0);
		if (c)
			free(c);
	}
	OUTPUT:
	RETVAL

#endif

