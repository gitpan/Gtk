
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

MODULE = Gtk::Gnome::DateEdit		PACKAGE = Gtk::Gnome::DateEdit		PREFIX = gnome_date_edit_

#ifdef GNOME_DATE_EDIT

Gtk::Gnome::DateEdit_Sink
new(Class, the_time, show_time, use_24_format)
	SV *	Class
	time_t	the_time
	bool	show_time
	bool	use_24_format
	CODE:
	RETVAL = GNOME_DATE_EDIT(gnome_date_edit_new(the_time, show_time, use_24_format));
	OUTPUT:
	RETVAL

void
gnome_date_edit_set_time(gde, the_time)
	Gtk::Gnome::DateEdit	gde
	time_t	the_time

void
gnome_date_edit_set_popup_range(gde, low_hour, up_hour)
	Gtk::Gnome::DateEdit	gde
	int	low_hour
	int	up_hour

time_t
gnome_date_edit_get_date(gde)
	Gtk::Gnome::DateEdit	gde

#endif

