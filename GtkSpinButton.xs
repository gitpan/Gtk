
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

MODULE = Gtk::SpinButton		PACKAGE = Gtk::SpinButton		PREFIX = gtk_spin_button_

#ifdef GTK_SPIN_BUTTON

Gtk::SpinButton_Sink
new(Class, adjustment, climb_rate, digits)
	SV * Class
	Gtk::Adjustment adjustment
	double climb_rate
	int digits
	CODE:
	RETVAL = GTK_SPIN_BUTTON(gtk_spin_button_new(adjustment, climb_rate, digits));
	OUTPUT:
	RETVAL

void
gtk_spin_button_set_adjustment(self, adjustment)
	Gtk::SpinButton self
	Gtk::Adjustment adjustment

Gtk::Adjustment
gtk_spin_button_get_adjustment(self)
	Gtk::SpinButton self

void
gtk_spin_button_set_digits(self, digits)
	Gtk::SpinButton self
	int digits

int
gtk_spin_button_digits(self)
	Gtk::SpinButton self
	CODE:
	RETVAL = self->digits;
	OUTPUT:
	RETVAL

double
gtk_spin_button_get_value_as_float(self)
	Gtk::SpinButton self

int
gtk_spin_button_get_value_as_int(self)
	Gtk::SpinButton self

void
gtk_spin_button_set_value(self, value)
	Gtk::SpinButton self
	gfloat value

void
gtk_spin_button_set_update_policy(self, policy)
	Gtk::SpinButton self
	Gtk::SpinButtonUpdatePolicy policy

void
gtk_spin_button_set_numeric(self, numeric)
	Gtk::SpinButton self
	int numeric

void
gtk_spin_button_spin(self, direction, step)
	Gtk::SpinButton self
	int	direction
	gfloat	step

void
gtk_spin_button_set_wrap(self, wrap)
	Gtk::SpinButton self
	int	wrap

#endif

