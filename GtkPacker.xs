
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

MODULE = Gtk::Packer		PACKAGE = Gtk::Packer		PREFIX = gtk_packer_

#ifdef GTK_PACKER

Gtk::Packer_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	RETVAL = GTK_PACKER(gtk_packer_new());
	OUTPUT:
	RETVAL

void
gtk_packer_add_defaults(packer, child, side, anchor, options)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::Side	side
	Gtk::Anchor	anchor
	Gtk::PackerOptions	options

void
gtk_packer_add(packer, child, side, anchor, options, border_width, padX, padY, ipadX, ipadY)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::Side	side
	Gtk::Anchor	anchor
	Gtk::PackerOptions	options
	int	border_width
	int	padX
	int	padY
	int	ipadX
	int	ipadY

void
gtk_packer_configure(packer, child, side, anchor, options, border_width, padX, padY, ipadX, ipadY)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::Side	side
	Gtk::Anchor	anchor
	Gtk::PackerOptions	options
	int	border_width
	int	padX
	int	padY
	int	ipadX
	int	ipadY

void
gtk_packer_set_spacing(packer, spacing)
	Gtk::Packer	packer
	int	spacing

void
gtk_packer_set_default_border_width(packer, border)
	Gtk::Packer	packer
	int	border

void
gtk_packer_set_default_pad(packer, padX, padY)
	Gtk::Packer	packer
	int	padX
	int padY

void
gtk_packer_set_default_ipad(packer, ipadX, ipadY)
	Gtk::Packer	packer
	int	ipadX
	int ipadY

void
children(packer)
	Gtk::Packer	packer
	PPCODE:
	{
		GList * list;
		list = g_list_first(packer->children);
		while (list) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkPackerChild((GtkPackerChild*)(list->data))));
			list = g_list_next(list);
		}
	}

#endif

MODULE = Gtk::Packer		PACKAGE = Gtk::PackerChild	

#ifdef GTK_PACKER

Gtk::Widget_Up
widget(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->widget;
	OUTPUT:
	RETVAL

Gtk::Anchor
anchor(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->anchor;
	OUTPUT:
	RETVAL

Gtk::Side
side(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->side;
	OUTPUT:
	RETVAL

Gtk::PackerOptions
options(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->options;
	OUTPUT:
	RETVAL

int
use_default(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->use_default;
	OUTPUT:
	RETVAL

int
border_width(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->border_width;
	OUTPUT:
	RETVAL

int
padX(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->padX;
	OUTPUT:
	RETVAL

int
padY(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->padY;
	OUTPUT:
	RETVAL

int
iPadX(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->iPadX;
	OUTPUT:
	RETVAL

int
iPadY(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->iPadY;
	OUTPUT:
	RETVAL

#endif

