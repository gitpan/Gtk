
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

MODULE = Gtk::Gnome::FileEntry		PACKAGE = Gtk::Gnome::FileEntry		PREFIX = gnome_file_entry_

#ifdef GNOME_FILE_ENTRY

Gtk::Gnome::FileEntry_Sink
new(Class, history_id, browse_dialog_title)
	SV *	Class
	char *	history_id
	char *	browse_dialog_title
	CODE:
	RETVAL = GNOME_FILE_ENTRY(gnome_file_entry(history_id, browse_dialog_title));
	OUTPUT:
	RETVAL

Gtk::Widget_Up
gnome_file_entry_gnome_entry(fentry)
	Gtk::Gnome::FileEntry	fentry

Gtk::Widget_Up
gnome_file_entry_gtk_entry(fentry)
	Gtk::Gnome::FileEntry	fentry

void
gnome_file_entry_set_title(fentry, browse_dialog_title)
	Gtk::Gnome::FileEntry	fentry
	char *	browse_dialog_title

#endif

