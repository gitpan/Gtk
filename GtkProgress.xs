
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

MODULE = Gtk::Progress		PACKAGE = Gtk::Progress		PREFIX = gtk_progress_

#ifdef GTK_PROGRESS

void
gtk_progress_set_show_text(self, show_text)
	Gtk::Progress	self
	gint	show_text

void
gtk_progress_set_text_alignment(self, x_align, y_align)
	Gtk::Progress	self
	gfloat	x_align
	gfloat	y_align

void
gtk_progress_set_format_string(self, format)
	Gtk::Progress	self
	char *	format

void
gtk_progress_set_adjustment(self, adjustment)
	Gtk::Progress	self
	Gtk::Adjustment	adjustment

void
gtk_progress_reconfigure(self, value, min, max)
	Gtk::Progress	self
	gfloat	value
	gfloat	min
	gfloat	max

void
gtk_progress_set_percentage(self, percentage)
	Gtk::Progress	self
	gfloat	percentage

void
gtk_progress_set_value(self, value)
	Gtk::Progress	self
	gfloat	value

gfloat
gtk_progress_get_value(self)
	Gtk::Progress	self

void
gtk_progress_set_activity_mode(self, activity_mode)
	Gtk::Progress	self
	guint	activity_mode

char *
gtk_progress_get_current_text(self)
	Gtk::Progress	self

char *
gtk_progress_get_text_from_value(self, value)
	Gtk::Progress	self
	gfloat	value

gfloat
gtk_progress_get_current_percentage(self)
	Gtk::Progress	self

void
gtk_progress_get_percentage_from_value(self, value)
	Gtk::Progress	self
	gfloat	value

#endif
