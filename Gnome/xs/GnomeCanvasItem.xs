
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/*
static void handle_canvas_points(GnomeCanvasItem * item, SV* points) {
	GnomeCanvasPoints *p;
	AV *av;
	int i;

	if (!SvOK(points) || !SvROK(points) || (SvTYPE(SvRV(points)) != SVt_PVAV) )
		croak("points should be an array reference of coords");

	av = (AV*)SvRV(points);
	p = gnome_canvas_points_new((av_len(av)+1)/2);

	for (i=0; i<=av_len(av); ++i)
		p->coords[i] = SvNV(*av_fetch(av, i, 0));
	gnome_canvas_item_set(item, "points", p, NULL);
	gnome_canvas_points_free(p);
}
*/

MODULE = Gnome::CanvasItem		PACKAGE = Gnome::CanvasItem		PREFIX = gnome_canvas_item_

#ifdef X_GNOME_CANVAS_ITEM

SV*
gnome_canvas_item_new(Class, parent, type, ...)
	SV*	Class
	Gnome::CanvasGroup	parent
	SV*	type
	CODE:
	{
		GtkArg	*argv;
		int	p, argc, i;
		GtkType realtype;
		GtkObject *obj;
		SV *phack=NULL;
		realtype = type_name(SvPV(type,PL_na));
		argc = items -3;
		if ( argc % 2 )
			croak("too few arguments");
		obj = gtk_object_new(realtype, NULL);
		RETVAL = newSVGtkObjectRef(obj, SvPV(type, PL_na));
		gtk_object_sink(obj);
		argv = malloc(sizeof(GtkArg)*argc);
		/* FIXME: this allows only 1 arg value */
		i=0;
		for(p=3; p<items;++i) {
			/*g_warning("SETTING: %s -> %s\n", SvPV(ST(p), PL_na), SvPV(ST(p+1),PL_na));*/
			if ( strcmp("points", SvPV(ST(p), PL_na)) ) {
				FindArgumentType(obj, ST(p), &argv[i]);
				GtkSetArg(&argv[i], ST(p+1), RETVAL, obj);
			} else {
				phack = ST(p+1);
				--i;
			}
			p += 2;
		}
		gnome_canvas_item_constructv(GNOME_CANVAS_ITEM(obj), parent, i, argv);
		if (phack)
			handle_canvas_points(GNOME_CANVAS_ITEM(obj), phack);	
		free(argv);
	}
	OUTPUT:
	RETVAL

void
gnome_canvas_item_set (self, name, value,...)
	Gnome::CanvasItem	self
	SV*	name
	SV*	value
	CODE:
	{
		GtkArg	*argv;
		int	p, argc, i;
		GtkObject *obj;
		argc = items -1;
		if ( argc % 2 )
			croak("too few arguments");
		obj = GTK_OBJECT(self);
		argv = malloc(sizeof(GtkArg)*argc);
		/* FIXME: this allows only 1 arg value */
		i=0;
		for(p=1; p<items;++i) {
			/*g_warning("SETTING: %s -> %s\n", SvPV(ST(p), PL_na), SvPV(ST(p+1),PL_na));*/
			if ( strcmp("points", SvPV(ST(p), PL_na)) ) {
				FindArgumentType(obj, ST(p), &argv[i]);
				GtkSetArg(&argv[i], ST(p+1), ST(0), obj);
			} else 
				handle_canvas_points(GNOME_CANVAS_ITEM(obj), ST(p+1));	
			p += 2;
		}
		gnome_canvas_item_setv(self, i, argv);
		free(argv);
	}

void
gnome_canvas_item_move(self, dx, dy)
	Gnome::CanvasItem	self
	double	dx
	double	dy

void
gnome_canvas_item_raise(self, positions)
	Gnome::CanvasItem	self
	int	positions

void
gnome_canvas_item_lower(self, positions)
	Gnome::CanvasItem	self
	int	positions

void
gnome_canvas_item_raise_to_top(self)
	Gnome::CanvasItem	self

void
gnome_canvas_item_lower_to_bottom(self)
	Gnome::CanvasItem	self

int
gnome_canvas_item_grab(self, event_mask, cursor, time)
	Gnome::CanvasItem	self
	Gtk::Gdk::EventMask	event_mask
	Gtk::Gdk::Cursor	cursor
	int		time

void
gnome_canvas_item_ungrab(self, time)
	Gnome::CanvasItem	self
	int		time

void
gnome_canvas_item_w2i(self, x, y)
	Gnome::CanvasItem	self
	double	x
	double	y
	PPCODE:
	{
		gnome_canvas_item_w2i(self, &x, &y);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSVnv(x)));
		PUSHs(sv_2mortal(newSVnv(y)));
	}

void
gnome_canvas_item_i2w(self, x, y)
	Gnome::CanvasItem	self
	double	x
	double	y
	PPCODE:
	{
		gnome_canvas_item_i2w(self, &x, &y);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSVnv(x)));
		PUSHs(sv_2mortal(newSVnv(y)));
	}

#endif

