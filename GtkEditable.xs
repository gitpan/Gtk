
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

MODULE = Gtk::Editable		PACKAGE = Gtk::Editable		PREFIX = gtk_editable_

#ifdef GTK_EDITABLE

void
gtk_editable_select_region (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end

int
gtk_editable_insert_text (editable, new_text, position)
	Gtk::Editable editable
	SV*           new_text
	int           position
	CODE:
	{
		STRLEN len;
		char * c = SvPV(new_text, len);
		gtk_editable_insert_text (editable, c, len, &position);
		RETVAL = position;
	}

void
gtk_editable_delete_text (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end

void
gtk_editable_get_chars (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end
	PPCODE:
	{
		char *res = gtk_editable_get_chars (editable, start, end);
		SV *result = newSVpv(res, 0);
		g_free(res);
		EXTEND(sp, 1);
		PUSHs(sv_2mortal(result));
	}
	

#if (GTK_MAJOR_VERSION > 1) || ((GTK_MAJOR_VERSION == 1) && (GTK_MINOR_VERSION >= 1))

void
gtk_editable_cut_clipboard (editable)
	Gtk::Editable editable

void
gtk_editable_copy_clipboard (editable)
	Gtk::Editable editable

void
gtk_editable_paste_clipboard (editable)
	Gtk::Editable editable

#else

void
gtk_editable_cut_clipboard (editable, time)
	Gtk::Editable editable
	int           time

void
gtk_editable_copy_clipboard (editable, time)
	Gtk::Editable editable
	int           time

void
gtk_editable_paste_clipboard (editable, time)
	Gtk::Editable editable
	int           time

#endif

void
gtk_editable_claim_selection (editable, claim, time)
	Gtk::Editable editable
	bool          claim
	int           time

void
gtk_editable_delete_selection (editable)
	Gtk::Editable editable

void
gtk_editable_changed (editable)
	Gtk::Editable editable

#endif

