
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


MODULE = Gtk::Dialog		PACKAGE = Gtk::Dialog

#ifdef GTK_DIALOG

Gtk::Dialog_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_DIALOG(gtk_dialog_new());
	OUTPUT:
	RETVAL

Gtk::Widget_Up
vbox(dialog)
	Gtk::Dialog	dialog
	CODE:
	RETVAL = dialog->vbox;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
action_area(dialog)
	Gtk::Dialog	dialog
	CODE:
	RETVAL = dialog->action_area;
	OUTPUT:
	RETVAL

#endif
