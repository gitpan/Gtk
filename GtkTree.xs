
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


MODULE = Gtk::Tree		PACKAGE = Gtk::Tree		PREFIX = gtk_tree_

#ifdef GTK_TREE

Gtk::Tree
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_TREE(gtk_tree_new());
	OUTPUT:
	RETVAL

void
gtk_tree_append(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_prepend(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_insert(self, child, position)
	Gtk::Tree	self
	Gtk::Widget	child
	int	position

#endif
