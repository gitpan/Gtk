
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

MODULE = Gtk::Layout		PACKAGE = Gtk::Layout		PREFIX = gtk_layout_

#ifdef GTK_LAYOUT

Gtk::Layout_Sink
new(Class, hadj, vadj)
	SV*	Class
	Gtk::Adjustment	hadj
	Gtk::Adjustment	vadj
	CODE:
	RETVAL=GTK_LAYOUT(gtk_layout_new(hadj, vadj));
	OUTPUT:
	RETVAL

void
gtk_layout_put(self, widget, x, y)
	Gtk::Layout	self
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_move(self, widget, x, y)
	Gtk::Layout	self
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_set_size(self, width, height)
	Gtk::Layout	self
	int		width
	int		height

Gtk::Adjustment
gtk_layout_get_hadjustment(self)
	Gtk::Layout	self

Gtk::Adjustment
gtk_layout_get_vadjustment(self)
	Gtk::Layout	self

void
gtk_layout_set_hadjustment(self, hadj)
	Gtk::Layout	self
	Gtk::Adjustment	hadj

void
gtk_layout_set_vadjustment(self, vadj)
	Gtk::Layout	self
	Gtk::Adjustment	vadj

#endif

