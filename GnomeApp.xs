
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

MODULE = Gtk::Gnome::App		PACKAGE = Gtk::Gnome::App		PREFIX = gnome_app_

#ifdef GNOME_APP

Gtk::Gnome::App_Sink
new(Class, appname, title)
	SV *	Class
	char *	appname
	char *	title
	CODE:
	RETVAL = GNOME_APP(gnome_app_new(appname, title));
	OUTPUT:
	RETVAL

void
gnome_app_set_menus(app, menubar)
	Gtk::Gnome::App	app
	Gtk::MenuBar	menubar

void
gnome_app_set_toolbar(app, toolbar)
	Gtk::Gnome::App	app
	Gtk::Toolbar	toolbar

void
gnome_app_set_contents(app, contents)
	Gtk::Gnome::App	app
	Gtk::Widget	contents

void
gnome_app_toolbar_set_position(app, pos_toolbar)
	Gtk::Gnome::App	app
	Gtk::Gnome::AppWidgetPositionType	pos_toolbar

void
gnome_app_menu_set_position(app, pos_menu)
	Gtk::Gnome::App	app
	Gtk::Gnome::AppWidgetPositionType	pos_menu

#endif

