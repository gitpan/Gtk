
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

MODULE = Gtk::Gnome::MessageBox		PACKAGE = Gtk::Gnome::MessageBox		PREFIX = gnome_messagebox_

#ifdef GNOME_MESSAGEBOX

Gtk::Gnome::MessageBox_Sink
new(Class, message, messagebox_type, button1=0, button2=0, button3=0, button4=0, button5=0, button6=0)
	SV *	Class
	char *	message
	char *	messagebox_type
	char *	button1
	char *	button2
	char *	button3
	char *	button4
	char *	button5
	char *	button6
	CODE:
	RETVAL = GNOME_MESSAGEBOX(gnome_messagebox_new(message,messagebox_type,button1,button2,button3,button4,button5,button6,NULL));
	OUTPUT:
	RETVAL

void
gnome_messagebox_set_modal(messagebox)
	Gtk::Gnome::MessageBox	messagebox

void
gnome_messagebox_set_default(messagebox, button)
	Gtk::Gnome::MessageBox	messagebox
	int	button

#endif

