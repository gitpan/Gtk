
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

MODULE = Gtk::GLArea		PACKAGE = Gtk::GLArea		PREFIX = gtk_gl_area_

#ifdef GTK_GL_AREA

Gtk::GLArea_Sink
new(Class,...)
	SV * Class
	CODE:
	{
		int * attr = malloc(sizeof(int)*(items-1));
		int i;
		for (i=0; i < items -1; ++i)
			attr[i] = SvIV(ST(i+1));
		RETVAL = GTK_GL_AREA(gtk_gl_area_new(attr));
	}
	OUTPUT:
	RETVAL

int
gtk_gl_area_begingl(self)
	Gtk::GLArea self

void
gtk_gl_area_endgl(self)
	Gtk::GLArea self

void
gtk_gl_area_swapbuffers(self)
	Gtk::GLArea self

#endif

