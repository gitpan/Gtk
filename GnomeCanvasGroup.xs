
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

MODULE = Gtk::Gnome::CanvasGroup		PACKAGE = Gtk::Gnome::CanvasGroup		PREFIX = gnome_canvas_group_

#ifdef GNOME_CANVAS_GROUP

void
gnome_canvas_group_child_bounds(self, item)
	Gtk::Gnome::CanvasGroup	self
	Gtk::Gnome::CanvasItem_OrNULL	item

#endif

