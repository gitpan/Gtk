
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

MODULE = Gtk::Gnome::Entry		PACKAGE = Gtk::Gnome::Entry		PREFIX = gnome_entry_

#ifdef GNOME_ENTRY

Gtk::Gnome::Entry_Sink
new(Class, history_id)
	SV *	Class
	char *	history_id
	CODE:
	RETVAL = GNOME_ENTRY(gnome_entry_new(history_id));
	OUTPUT:
	RETVAL

Gtk::Widget_Up
gnome_entry_gtk_entry(entry)
	Gtk::Gnome::Entry	entry

void
gnome_entry_set_history_id(entry, history_id)
	Gtk::Gnome::Entry	entry
	char *	history_id

void
gnome_entry_prepend_history(entry, save, text)
	Gtk::Gnome::Entry	entry
	int	save
	char *	text

void
gnome_entry_append_history(entry, save, text)
	Gtk::Gnome::Entry	entry
	int	save
	char *	text

void
gnome_entry_save_history(entry)
	Gtk::Gnome::Entry	entry

void
gnome_entry_load_history(entry)
	Gtk::Gnome::Entry	entry

#endif

