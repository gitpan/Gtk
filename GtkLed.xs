
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

MODULE = Gtk::Led		PACKAGE = Gtk::Led		PREFIX = gtk_led_

#ifdef GTK_LED

Gtk::Led_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_LED(gtk_led_new());
	OUTPUT:
	RETVAL

void
gtk_led_set_state(led, widget_state, on_off)
	Gtk::Led	led
	Gtk::StateType	widget_state
	gboolean	on_off

void
gtk_led_switch(led, on_off)
	Gtk::Led	led
	gboolean	on_off

gboolean
gtk_led_is_on(led)
	Gtk::Led	led

#endif

