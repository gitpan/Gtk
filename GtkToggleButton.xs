
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


MODULE = Gtk::ToggleButton		PACKAGE = Gtk::ToggleButton		PREFIX = gtk_toggle_button_

#ifdef GTK_TOGGLE_BUTTON

Gtk::ToggleButton_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	ALIAS:
		Gtk::ToggleButton::new = 0
		Gtk::ToggleButton::new_with_label = 1
	CODE:
	if (label)
		RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new_with_label(label));
	else
		RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new());
	OUTPUT:
	RETVAL

void
gtk_toggle_button_set_state(self, state)
	Gtk::ToggleButton	self
	int	state

void
gtk_toggle_button_set_mode(self, draw_indicator)
	Gtk::ToggleButton	self
	int	draw_indicator

void
gtk_toggle_button_toggled(self)
	Gtk::ToggleButton	self

int
active(self, new_value=0)
	Gtk::ToggleButton	self
	int	new_value
	CODE:
		RETVAL = self->active;
		if (items>1)
			self->active = new_value;
	OUTPUT:
	RETVAL

int
draw_indicator(self)
	Gtk::ToggleButton	self
	CODE:
		RETVAL = self->draw_indicator;
	OUTPUT:
	RETVAL

#endif
