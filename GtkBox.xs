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

MODULE = Gtk::Box		PACKAGE = Gtk::Box	PREFIX = gtk_box_

#ifdef GTK_BOX

void
gtk_box_pack_start(box, child, expand, fill, padding)
	Gtk::Box	box
	Gtk::Widget	child
	int	expand
	int	fill
	int	padding

void
gtk_box_pack_end(box, child, expand, fill, padding)
	Gtk::Box	box
	Gtk::Widget	child
	int	expand
	int	fill
	int	padding

void
gtk_box_pack_start_defaults(box, child)
	Gtk::Box	box
	Gtk::Widget	child

void
gtk_box_pack_end_defaults(box, child)
	Gtk::Box	box
	Gtk::Widget	child

void
gtk_box_set_homogeneous(box, homogeneous)
	Gtk::Box	box
	int	homogeneous

void
gtk_box_set_spacing(box, spacing)
	Gtk::Box	box
	int	spacing

#endif
