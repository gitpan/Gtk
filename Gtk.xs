
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NDEBUG

#include <gtk/gtk.h>

#include "GtkTypes.h"
#include "GdkTypes.h"
#include "MiscTypes.h"

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

void marshal_signal (GtkObject *object, gpointer data, gint nparams, GtkArg * args, GtkArgType * arg_types, GtkArgType return_type)
{
	AV * perlargs = (AV*)data;
	SV * perlhandler = *av_fetch(perlargs, 2, 0);
	SV * sv_object = newSVGtkObjectRef(object, 0);
	char * signame;
	SV * result;
	int i;
	int encoding=0;
	dSP;
	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	i = SvIV(*av_fetch(perlargs,3, 0));
	signame = gtk_signal_name(i);
	XPUSHs(sv_2mortal(sv_object));
	for(i=4;i<=av_len(perlargs);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs, i, 0))));
	XPUSHs(sv_2mortal(newSVpv(signame, 0)));
	if (sv_derived_from(sv_object, "Gtk::List")) {
		if (strEQ(signame, "select_child")	||
			strEQ(signame, "unselect_child")) {
			encoding=12;
			XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(args[0].d.p),0)));
			goto unpacked;
		}
	}
	if (sv_derived_from(sv_object, "Gtk::Window")) {
		if (strEQ(signame, "move_resize")) {
			encoding=13;
			XPUSHs(sv_2mortal(newSViv(*(int*)args[0].d.p)));
			XPUSHs(sv_2mortal(newSViv(*(int*)args[1].d.p)));
			XPUSHs(sv_2mortal(newSViv(args[2].d.i)));
			XPUSHs(sv_2mortal(newSViv(args[3].d.i)));
			goto unpacked;
		}
	}
	if (sv_derived_from(sv_object, "Gtk::Container")) {
		if (strEQ(signame, "add")		||
			strEQ(signame, "remove")	||
			strEQ(signame, "need_resize")) {
			encoding=7;
			XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(args[0].d.p),0)));
			goto unpacked;
		} else
		if (strEQ(signame, "foreach")) {
			warn("foreach not currently supported");
			encoding=8;
			goto unpacked;
		} else
		if (strEQ(signame, "focus")) {
			encoding=9;
			XPUSHs(sv_2mortal(newSVGtkDirectionType((GtkDirectionType)args[0].d.i)));
			goto unpacked;
		}
	}
	if (sv_derived_from(sv_object, "Gtk::Entry")) {
		if (strEQ(signame, "insert_text")) {
			encoding=10;
			XPUSHs(sv_2mortal(newSVpv(args[0].d.p,0)));
			XPUSHs(sv_2mortal(newSViv(args[1].d.i)));
			XPUSHs(sv_2mortal(newSViv(*(int*)args[2].d.p)));
			goto unpacked;
		} else
		if (strEQ(signame, "delete_text")) {
			encoding=11;
			XPUSHs(sv_2mortal(newSViv(args[0].d.i)));
			XPUSHs(sv_2mortal(newSViv(args[1].d.i)));
			goto unpacked;
		}
	}
	if (sv_derived_from(sv_object, "Gtk::Widget")) {
		if (strEQ(signame, "draw")) {
			encoding=1;
			XPUSHs(sv_2mortal(newSVGtkGdkRectangle((GdkRectangle*)args[0].d.p)));
			goto unpacked;
		} else
		if (strEQ(signame, "size_request")) {
			GtkRequisition * r = (GtkRequisition*)args[0].d.p;
			encoding=2;
			XPUSHs(sv_2mortal(newSViv(r->width)));
			XPUSHs(sv_2mortal(newSViv(r->height)));
			goto unpacked;
		} else
		if (strEQ(signame, "size_allocate")) {
			GtkAllocation * a = (GtkAllocation*)args[0].d.p;
			GdkRectangle r;
			encoding=3;
			r.x = a->x;
			r.y = a->y;
			r.width = a->width;
			r.height = a->height;
			XPUSHs(sv_2mortal(newSVGtkGdkRectangle(&r)));
			goto unpacked;
		} else
		if (strEQ(signame, "install_accelerator")) {
			encoding=4;
			XPUSHs(sv_2mortal(newSVpv(args[0].d.p,0)));
			XPUSHs(sv_2mortal(newSViv(args[1].d.c)));
			XPUSHs(sv_2mortal(newSViv(args[2].d.c)));
			goto unpacked;
		} else
		if (strEQ(signame, "remove_accelerator")) {
			encoding=5;
			XPUSHs(sv_2mortal(newSVpv(args[0].d.p,0)));
			goto unpacked;
		} else
		if (strEQ(signame, "event")	||
			strEQ(signame, "button_press_event")	||
			strEQ(signame, "button_release_event")	||
			strEQ(signame, "button_notify_event")	||
			strEQ(signame, "motion_notify_event")	||
			strEQ(signame, "delete_event")	||
			strEQ(signame, "destroy_event")	||
			strEQ(signame, "expose_event")	||
			strEQ(signame, "key_press_event")	||
			strEQ(signame, "key_release_event")	||
			strEQ(signame, "enter_notify_event")	||
			strEQ(signame, "leave_notify_event")	||
			strEQ(signame, "configure_event")	||
			strEQ(signame, "focus_in_event")	||
			strEQ(signame, "focus_out_event")	||
			strEQ(signame, "map_event")	||
			strEQ(signame, "unmap_event")	||
			strEQ(signame, "property_notify_event")	||
			strEQ(signame, "selection_clear_event")	||
			strEQ(signame, "selection_request_event")	||
			strEQ(signame, "selection_notify_event")	||
			strEQ(signame, "other_event")) {
			encoding=6;
			XPUSHs(sv_2mortal(newSVGtkGdkEvent((GdkEvent*)args[0].d.p)));
			goto unpacked;
		}
	}
unpacked:
	PUTBACK ;
	i = perl_call_sv(perlhandler, G_SCALAR);
	SPAGAIN;
	if (i != 1)
		croak("Aaaarrrrggghhhh");

	result = POPs;
	switch (return_type) {
	case GTK_ARG_NONE:
		break;
	case GTK_ARG_CHAR:
		(*(char*)args[nparams].d.p) = SvOK(result) ? *SvPV(result, na) : 0;
		break;
	case GTK_ARG_SHORT:
		(*(short*)args[nparams].d.p) = SvOK(result) ? SvIV(result) : 0;
		break;
	case GTK_ARG_INT:
		(*(int*)args[nparams].d.p) = SvOK(result) ? SvIV(result) : 0;
		break;
	case GTK_ARG_LONG:
		(*(long*)args[nparams].d.p) = SvOK(result) ? SvIV(result) : 0;
		break;
	case GTK_ARG_POINTER:
		warn("Unable to return pointer from handler");
		(*(gpointer*)args[nparams].d.p) = 0;
		break;
	}
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
}

void destroy_signal (gpointer data)
{
	AV * perlargs = (AV*)data;
	SvREFCNT_dec(perlargs);
}

AV * event_handlers;

gint EventHandler(GdkEvent * e, gpointer data)
{
	int handler = (int)data;
	AV * args;
	int i;
	dSP;
	
	args = (AV*)SvRV(*av_fetch(event_handlers, handler, 0));

	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));

	XPUSHs(sv_2mortal(newSVGtkGdkEvent(e)));

	PUTBACK;
	i = perl_call_sv(*av_fetch(args, 0, 0), G_SCALAR);
	SPAGAIN;
	
	if (i!=1)
		croak("EventHandler failed");

	i = POPi;
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
	if (!i)
		SvREFCNT_dec(args);
	
	return i;
}

static AV * timeout_handlers = 0;

int timeout_handler(gpointer data) {
	AV * args = (AV*)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	for (i=2;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, 1, 0))));

	PUTBACK;
	i = perl_call_sv(handler, G_SCALAR);
	SPAGAIN;
	
	if (i!=1)
		croak("timeout_handler failed");

	i = POPi;
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
	if (!i)
		SvREFCNT_dec(args);
	
	return i;
}

static AV * idle_handlers = 0;

int idle_handler(gpointer data) {
	AV * args = (AV*)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));

	PUTBACK;
	i = perl_call_sv(handler, G_SCALAR);
	SPAGAIN;
	
	if (i!=1)
		croak("idle_handler failed");

	i = POPi;
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
	return i;
}

int init_handler(gpointer data) {
	AV * args = (AV*)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	PUSHMARK(sp);
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	PUTBACK;

	perl_call_sv(handler, G_DISCARD);
	
	SvREFCNT_dec(args);
	return 0;
}


void menu_pos_func (GtkMenu *menu, int *x, int *y, gpointer user_data)
{
	AV * args = (AV*)user_data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;
	
	ENTER;
	SAVETMPS;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(menu), 0)));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	XPUSHs(sv_2mortal(newSViv(*x)));
	XPUSHs(sv_2mortal(newSViv(*y)));
	PUTBACK;

	i = perl_call_sv(handler, G_ARRAY);
	SPAGAIN;
	
	if (i>2)
		croak("MenuPosFunc must return two or less values");
	if (i==1)
		POPs;
	else {
		*x = SvIV(POPs);
		*y = SvIV(POPs);
	}
	
	PUTBACK;
	FREETMPS;
	LEAVE;
}

void menu_callback (GtkWidget *widget, gpointer user_data)
{
	SV * handler = (SV*)user_data;
	int i;
	dSP;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(widget), 0)));
	PUTBACK;

	i = perl_call_sv(handler, G_DISCARD);
}


static int init_gtk = 0;
static int init_gdk = 0;

void GtkInit() {
	int argc;
	char ** argv;
	AV * ARGV;
	SV * ARGV0;
	int i;

	if (init_gtk)
		return;
			argv  = 0;
			ARGV = perl_get_av("ARGV", FALSE);
			ARGV0 = perl_get_sv("0", FALSE);
			
			if (init_gdk)
				croak("GTK cannot be initalized after GDK has been initialized");
			
			argc = av_len(ARGV)+2;
			if (argc) {
				argv = malloc(sizeof(char*)*argc);
				argv[0] = SvPV(ARGV0, na);
				for(i=0;i<=av_len(ARGV);i++)
					argv[i+1] = SvPV(*av_fetch(ARGV, i, 0), na);
			}
			
			i = argc;
			gtk_init(&argc, &argv);

			init_gtk = 1;
			init_gdk = 1;
			
			while(argc<i--)
				av_shift(ARGV);
			
			if (argv)
				free(argv);
				
		gtk_signal_set_funcs(marshal_signal, destroy_signal);
		
		init_typecasts();
}


void foreach_container_handler (GtkWidget *widget, gpointer data)
{
	AV * perlargs = (AV*)data;
	SV * perlhandler = *av_fetch(perlargs, 1, 0);
	SV * sv_object = newSVGtkObjectRef(GTK_OBJECT(widget), 0);
	int i;
	dSP;
	
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(sv_object));
	for(i=2;i<=av_len(perlargs);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs, i, 0))));
   	XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs, 0, 0))));
	PUTBACK ;
	
	perl_call_sv(perlhandler, G_DISCARD);
}


MODULE = Gtk		PACKAGE = Gtk

double
constant(name,arg)
	char *		name
	int		arg

void
init(Class)
	SV *	Class
	CODE:
	GtkInit();


void
main(Class)
	SV *	Class
	CODE:
	GtkInit();
	gtk_main();

void
exit(Class, status)
	SV *	Class
	int status
	CODE:
	GtkInit();
	gtk_exit(status);

void
main_quit(Class)
	SV *	Class
	CODE:
	GtkInit();
	gtk_main_quit();

int
main_iteration(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = gtk_main_iteration();
	OUTPUT:
	RETVAL

void
print(Class, text)
	SV *	Class
	char *	text
	CODE:
	GtkInit();
	g_print(text);

int
timeout_add(Class, interval, handler, ...)
	SV *	Class
	int	interval
	SV *	handler
	CODE:
	{
		AV * args;
		SV * arg;
		int i,j;
		int type;
		args = newAV();
		
		av_push(args, newSVsv(ST(2)));
		av_push(args, newSVsv(ST(1)));
		for (j=3;j<items;j++)
			av_push(args, newSVsv(ST(j)));
		
		if (!timeout_handlers)
			timeout_handlers = newAV();

		RETVAL = gtk_timeout_add(interval, timeout_handler, (gpointer)args);
		
		arg = newRV((SV*)args);
		
		av_extend(timeout_handlers, RETVAL);
		av_store(timeout_handlers, RETVAL, arg);
	}
	OUTPUT:
	RETVAL

void
timeout_remove(Class, tag)
	SV *	Class
	int	tag
	CODE:
	{
		if (!timeout_handlers)
			timeout_handlers = newAV();

		gtk_timeout_remove(tag);
		
		av_extend(timeout_handlers, tag);
		av_store(timeout_handlers, tag, newSVsv(&sv_undef));
	}

int
idle_add(Class, handler, ...)
	SV *	Class
	SV *	handler
	CODE:
	{
		AV * args;
		SV * arg;
		int i,j;
		int type;
		args = newAV();
		
		av_push(args, newSVsv(ST(1)));
		for (j=2;j<items;j++)
			av_push(args, newSVsv(ST(j)));
		
		if (!idle_handlers)
			idle_handlers = newAV();

		RETVAL = gtk_idle_add(idle_handler, (gpointer)args);
		
		arg = newRV((SV*)args);
		
		av_extend(idle_handlers, RETVAL);
		av_store(idle_handlers, RETVAL, arg);
	}
	OUTPUT:
	RETVAL

void
idle_remove(Class, tag)
	SV *	Class
	int	tag
	CODE:
	{
		if (!idle_handlers)
			idle_handlers = newAV();

		gtk_idle_remove(tag);
		
		av_extend(idle_handlers, tag);
		av_store(idle_handlers, tag, newSVsv(&sv_undef));
	}

void
init_add(Class, handler, ...)
	SV *	Class
	SV *	handler
	CODE:
	{
		AV * args;
		SV * arg;
		int i,j;
		int type;
		args = newAV();
		
		av_push(args, newSVsv(ST(1)));
		for (j=2;j<items;j++)
			av_push(args, newSVsv(ST(j)));
		
		gtk_init_add(init_handler, (gpointer)args);
	}

Gtk::Gdk::Event
get_current_event(Class=0)
	SV *	Class
	CODE:
	{
		GdkEvent e;
		gtk_get_current_event(&e);
		RETVAL = &e;
	}
	OUTPUT:
	RETVAL

upGtk::Widget
get_event_widget(Class=0, event)
	SV *	Class
	Gtk::Gdk::Event	event
	CODE:
	{
		RETVAL = gtk_get_event_widget(event);
	}
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Type

MODULE = Gtk		PACKAGE = Gtk::Adjustment

Gtk::Adjustment
new(Class, value, lower, upper, step_increment, page_increment, page_size)
	SV *	Class
	double	value
	double	lower
	double	upper
	double	step_increment
	double	page_increment
	double	page_size
	CODE:
	GtkInit();
	RETVAL = GTK_ADJUSTMENT(gtk_adjustment_new(value, lower, upper, step_increment, page_increment, page_size));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Alignment

Gtk::Alignment
new(Class, xalign, yalign, xscale, yscale)
	SV *	Class
	double	xalign
	double	yalign
	double	xscale
	double	yscale
	CODE:
	GtkInit();
	RETVAL = GTK_ALIGNMENT(gtk_alignment_new(xalign, yalign, xscale, yscale));
	OUTPUT:
	RETVAL

void
set(self, xalign, yalign, xscale, yscale)
	Gtk::Alignment	self
	double	xalign
	double	yalign
	double	xscale
	double	yscale
	CODE:
		gtk_alignment_set(self, xalign, yalign, xscale, yscale);

MODULE = Gtk		PACKAGE = Gtk::AspectFrame

Gtk::AspectFrame
new(Class, label, xalign, yalign, ratio, obey_child)
	SV *	Class
	char *	label
	double	xalign
	double	yalign
	double	ratio
	bool	obey_child
	CODE:
	GtkInit();
	RETVAL = GTK_ASPECT_FRAME(gtk_aspect_frame_new(label, xalign, yalign, ratio, obey_child));
	OUTPUT:
	RETVAL

void
set(self, xalign, yalign, ratio, obey_child)
	Gtk::AspectFrame	self
	double	xalign
	double	yalign
	double	ratio
	bool	obey_child
	CODE:
		gtk_aspect_frame_set(self, xalign, yalign, ratio, obey_child);

MODULE = Gtk		PACKAGE = Gtk::Bin

MODULE = Gtk		PACKAGE = Gtk::Box	PREFIX = gtk_box_

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

MODULE = Gtk		PACKAGE = Gtk::Button

Gtk::Button
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
		if (!label)
			RETVAL = GTK_BUTTON(gtk_button_new());
		else
			RETVAL = GTK_BUTTON(gtk_button_new_with_label(label));
	OUTPUT:
	RETVAL

void
pressed(button)
	Gtk::Button	button
	CODE:
	gtk_button_pressed(button);

void
released(button)
	Gtk::Button	button
	CODE:
	gtk_button_released(button);

void
clicked(button)
	Gtk::Button	button
	CODE:
	gtk_button_clicked(button);

void
enter(button)
	Gtk::Button	button
	CODE:
	gtk_button_enter(button);

void
leave(button)
	Gtk::Button	button
	CODE:
	gtk_button_leave(button);

MODULE = Gtk		PACKAGE = Gtk::CheckButton

Gtk::CheckButton
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
		if (!label)
			RETVAL = GTK_CHECK_BUTTON(gtk_check_button_new());
		else
			RETVAL = GTK_CHECK_BUTTON(gtk_check_button_new_with_label(label));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::ColorSelection	PREFIX = gtk_color_selection_

Gtk::ColorSelection
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_COLOR_SELECTION(gtk_color_selection_new());
	OUTPUT:
	RETVAL

void
gtk_color_selection_set_opacity(self, use_opacity)
	Gtk::ColorSelection	self
	bool	use_opacity

void
gtk_color_selection_set_update_policy(self, policy)
	Gtk::ColorSelection	self
	Gtk::UpdateType	policy

void
set_color(self, red, green, blue, opacity=0)
	Gtk::ColorSelection	self
	double	red
	double	green
	double	blue
	double	opacity
	CODE:
	{
		double c[4];
		c[0] = red;
		c[1] = green;
		c[2] = blue;
		c[3] = opacity;
		gtk_color_selection_set_color(self, c);
	}

void
get_color(self)
	Gtk::ColorSelection	self
	PPCODE:
	{
		double c[4];
		gtk_color_selection_get_color(self, c);
		EXTEND(sp,3);
		PUSHs(sv_2mortal(newSVnv(c[0])));
		PUSHs(sv_2mortal(newSVnv(c[1])));
		PUSHs(sv_2mortal(newSVnv(c[2])));
		if (self->use_opacity) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVnv(c[3])));
		}
	}


MODULE = Gtk		PACKAGE = Gtk::ColorSelectionDialog

Gtk::ColorSelectionDialog
new(Class, title)
	SV *	Class
	char *	title
	CODE:
	GtkInit();
	RETVAL = GTK_COLOR_SELECTION_DIALOG(gtk_color_selection_dialog_new(title));
	OUTPUT:
	RETVAL

Gtk::ColorSelection
colorsel(csdialog)
	Gtk::ColorSelectionDialog	csdialog
	CODE:
	RETVAL = GTK_COLOR_SELECTION(csdialog->colorsel);
	OUTPUT:
	RETVAL

Gtk::Widget
ok_button(csdialog)
	Gtk::ColorSelectionDialog	csdialog
	CODE:
	RETVAL = csdialog->ok_button;
	OUTPUT:
	RETVAL

Gtk::Widget
cancel_button(csdialog)
	Gtk::ColorSelectionDialog	csdialog
	CODE:
	RETVAL = csdialog->cancel_button;
	OUTPUT:
	RETVAL

Gtk::Widget
help_button(csdialog)
	Gtk::ColorSelectionDialog	csdialog
	CODE:
	RETVAL = csdialog->help_button;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Container

void
border_width(self, width)
	Gtk::Container	self
	int	width
	CODE:
		gtk_container_border_width(self, width);

SV *
add(self, widget)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
		gtk_container_add(self, widget);
		RETVAL = newSVsv(ST(1));
	OUTPUT:
	RETVAL

Gtk::Widget
remove(self, widget)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
		gtk_container_remove(self, widget);
		RETVAL = widget;
	OUTPUT:
	RETVAL

bool
need_resize(self, widget=0)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
	RETVAL = gtk_container_need_resize(self, widget);
	OUTPUT:
	RETVAL

void
check_resize(self, widget=0)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
	gtk_container_remove(self, widget);

void
disable_resize(self)
	Gtk::Container	self
	CODE:
	gtk_container_disable_resize(self);

void
enable_resize(self)
	Gtk::Container	self
	CODE:
	gtk_container_enable_resize(self);

void
block_resize(self)
	Gtk::Container	self
	CODE:
	gtk_container_block_resize(self);


void
unblock_resize(self)
	Gtk::Container	self
	CODE:
	gtk_container_unblock_resize(self);

void
children(self)
	Gtk::Container	self
	PPCODE:
	{
		GList * c = gtk_container_children(self);
		GList * start = c;
		while(c) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT((GtkWidget*)c->data), 0)));
			c = c->next;
		}
		if (start)
			g_list_free(start);
	}

void
foreach(self, code, ...)
	Gtk::Container	self
	SV *	code
	PPCODE:
	{
		AV * args;
		SV * arg;
		int i;
		int type;
		args = newAV();
		
		av_push(args, newRV(SvRV(ST(0))));
		av_push(args, newSVsv(ST(1)));
		for (i=2;i<items;i++)
			av_push(args, newSVsv(ST(i)));

		gtk_container_foreach(self, foreach_container_handler, args);
		
		SvREFCNT_dec(args);
	}

MODULE = Gtk		PACKAGE = Gtk::Curve

Gtk::Curve
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = GTK_CURVE(gtk_curve_new());
	OUTPUT:
	RETVAL

void
reset(self)
	Gtk::Curve	self
	CODE:
	gtk_curve_reset(self);

void
set_range(self, min_x, max_x, min_y, max_y)
	Gtk::Curve	self
	double	min_x
	double	max_x
	double	min_y
	double	max_y
	CODE:
	gtk_curve_set_range(self, min_x, max_x, min_y, max_y);

void
set_vector(self, value, ...)
	Gtk::Curve	self
	CODE:
	{
		gfloat * vec = malloc((items-1) * sizeof(gfloat));
		int i;
		for(i=1;i<items;i++)
			vec[i-1] = SvNV(ST(i));
		gtk_curve_set_vector(self, items-1, vec);
		free(vec);
	}

void
get_vector(self, points=32)
	Gtk::Curve	self
	int	points
	PPCODE:
	{
		gfloat * vec;
		int i;
		if (points<=0)
			croak("points must be positive integer");
		vec = malloc(points * sizeof(gfloat));
		gtk_curve_get_vector(self, points, vec);
		EXTEND(sp, points);
		for(i=0;i<points;i++)
			PUSHs(sv_2mortal(newSVnv(vec[i])));
		free(vec);
	}

MODULE = Gtk		PACKAGE = Gtk::Dialog

Gtk::Dialog
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = GTK_DIALOG(gtk_dialog_new());
	OUTPUT:
	RETVAL

upGtk::Widget
vbox(dialog)
	Gtk::Dialog	dialog
	CODE:
	RETVAL = dialog->vbox;
	OUTPUT:
	RETVAL

upGtk::Widget
action_area(dialog)
	Gtk::Dialog	dialog
	CODE:
	RETVAL = dialog->action_area;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::DrawingArea		PREFIX = gtk_drawing_area_

Gtk::DrawingArea
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = GTK_DRAWING_AREA(gtk_drawing_area_new());
	OUTPUT:
	RETVAL

void
gtk_drawing_area_size(self, width, height)
	Gtk::DrawingArea	self
	int	width
	int	height

MODULE = Gtk		PACKAGE = Gtk::Entry	PREFIX = gtk_entry_

Gtk::Entry
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = GTK_ENTRY(gtk_entry_new());
	OUTPUT:
	RETVAL

void
gtk_entry_set_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_append_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_prepend_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_set_position(self, position)
	Gtk::Entry	self
	int	position

char *
gtk_entry_get_text(self)
	Gtk::Entry	self

MODULE = Gtk		PACKAGE = Gtk::FileSelection	PREFIX = gtk_file_selection_

Gtk::FileSelection
new(Class, title)
	SV *	Class
	char *	title
	CODE:
	GtkInit();
		RETVAL = GTK_FILE_SELECTION(gtk_file_selection_new(title));
	OUTPUT:
	RETVAL

void
gtk_file_selection_set_filename(self, filename)
	Gtk::FileSelection	self
	char *	filename

char *
gtk_file_selection_get_filename(self)
	Gtk::FileSelection	self

upGtk::Widget
ok_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->ok_button;
	OUTPUT:
	RETVAL

upGtk::Widget
cancel_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->cancel_button;
	OUTPUT:
	RETVAL

upGtk::Widget
dir_list(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->dir_list;
	OUTPUT:
	RETVAL

upGtk::Widget
file_list(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->file_list;
	OUTPUT:
	RETVAL

upGtk::Widget
selection_entry(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->selection_entry;
	OUTPUT:
	RETVAL

upGtk::Widget
selection_text(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->selection_text;
	OUTPUT:
	RETVAL

upGtk::Widget
main_vbox(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->main_vbox;
	OUTPUT:
	RETVAL

upGtk::Widget
help_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->help_button;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Frame		PREFIX = gtk_frame_

Gtk::Frame
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
		RETVAL = GTK_FRAME(gtk_frame_new(label));
	OUTPUT:
	RETVAL

void
gtk_frame_set_label(self, label)
	Gtk::Frame	self
	char *	label

void
gtk_frame_set_label_align(self, xalign, yalign)
	Gtk::Frame	self
	double	xalign
	double	yalign

void
gtk_frame_set_shadow_type(self, shadow)
	Gtk::Frame	self
	Gtk::ShadowType	shadow

MODULE = Gtk		PACKAGE = Gtk::HBox

Gtk::HBox
new(Class, homogeneous, spacing)
	SV *	Class
	bool	homogeneous
	int	spacing
	CODE:
	GtkInit();
		RETVAL = GTK_HBOX(gtk_hbox_new(homogeneous, spacing));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::HRuler

Gtk::HRuler
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = GTK_HRULER(gtk_hruler_new());
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::HScale

Gtk::HScale
new(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	GtkInit();
		RETVAL = GTK_HSCALE(gtk_hscale_new(adjustment));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::HScrollbar

Gtk::HScrollbar
new(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	GtkInit();
		RETVAL = GTK_HSCROLLBAR(gtk_hscrollbar_new(adjustment));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::HSeparator

Gtk::HSeparator
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_HSEPARATOR(gtk_hseparator_new());
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Item

void
select(item)	
	Gtk::Item	item
	CODE:
	gtk_item_select(item);

void
deselect(item)	
	Gtk::Item	item
	CODE:
	gtk_item_deselect(item);

void
toggle(item)	
	Gtk::Item	item
	CODE:
	gtk_item_toggle(item);

MODULE = Gtk		PACKAGE = Gtk::Label		PREFIX = gtk_label_

Gtk::Label
new(Class, string)
	SV *	Class
	char *	string
	CODE:
	GtkInit();
	RETVAL = GTK_LABEL(gtk_label_new(string));
	OUTPUT:
	RETVAL

void
gtk_label_set(self, string)
	Gtk::Label	self
	char *	string

char *
gtk_label_get(self)
	Gtk::Label	self
	CODE:
	{
		gtk_label_get(self, &RETVAL);
	}

MODULE = Gtk		PACKAGE = Gtk::List

Gtk::List
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_LIST(gtk_list_new());
	OUTPUT:
	RETVAL

void
insert_items(self, position, ...)
	Gtk::List	self
	int	position
	CODE:
	{
		GList * list = 0;
		int i;
		for(i=2;i<items;i++)
			list = g_list_prepend(list, SvGtkObjectRef(ST(i),"Gtk::ListItem"));
		g_list_reverse(list);
		gtk_list_insert_items(self, list, position);
		g_list_free(list);
	}

void
append_items(self, ...)
	Gtk::List	self
	CODE:
	{
		GList * list = 0;
		int i;
		for(i=1;i<items;i++) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			list = g_list_prepend(list, GTK_LIST_ITEM(o));
		}
		gtk_list_append_items(self, list);
		g_list_free(list);
	}

void
prepend_items(self, ...)
	Gtk::List	self
	CODE:
	{
		GList * list = 0;
		int i;
		for(i=1;i<items;i++)
			list = g_list_prepend(list, SvGtkObjectRef(ST(i),"Gtk::ListItem"));
		g_list_reverse(list);
		gtk_list_prepend_items(self, list);
		g_list_free(list);
	}

void
remove_items(self, ...)
	Gtk::List	self
	CODE:
	{
		GList * list = 0;
		int i;
		for(i=1;i<items;i++)
			list = g_list_prepend(list, SvGtkObjectRef(ST(i),"Gtk::ListItem"));
		g_list_reverse(list);
		gtk_list_remove_items(self, list);
		g_list_free(list);
	}

void
clear_items(self, start, end)
	Gtk::List	self
	int	start
	int	end
	CODE:
	gtk_list_clear_items(self, start, end);

void
select_item(self, the_item)
	Gtk::List	self
	int	the_item
	CODE:
	gtk_list_select_item(self, the_item);

void
unselect_item(self, the_item)
	Gtk::List	self
	int	the_item
	CODE:
	gtk_list_unselect_item(self, the_item);

void
select_child(self, widget)
	Gtk::List	self
	Gtk::Widget	widget
	CODE:
	gtk_list_select_child(self, widget);

void
unselect_child(self, widget)
	Gtk::List	self
	Gtk::Widget	widget
	CODE:
	gtk_list_unselect_child(self, widget);

int
child_position(self, widget)
	Gtk::List	self
	Gtk::Widget	widget
	CODE:
	RETVAL = gtk_list_child_position(self, widget);
	OUTPUT:
	RETVAL

void
set_selection_mode(self, mode)
	Gtk::List	self
	Gtk::SelectionMode	mode
	CODE:
	gtk_list_set_selection_mode(self, mode);

void
selection(list)
	Gtk::List	list
	PPCODE:
	{
		GList * selection = list->selection;
		while(selection) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(selection->data),0)));
			selection=selection->next;
		}
	}

MODULE = Gtk		PACKAGE = Gtk::ListItem

Gtk::ListItem
new(Class, string=0)
	SV *	Class
	char *	string
	CODE:
	GtkInit();
	if (!string)
		RETVAL = GTK_LIST_ITEM(gtk_list_item_new());
	else
		RETVAL = GTK_LIST_ITEM(gtk_list_item_new_with_label(string));
	OUTPUT:
	RETVAL

void
select(self)
	Gtk::ListItem	self
	CODE:
	gtk_list_item_select(self);

void
deselect(self)
	Gtk::ListItem	self
	CODE:
	gtk_list_item_deselect(self);

MODULE = Gtk		PACKAGE = Gtk::Misc

void
set_alignment(self, xalign, yalign)
	Gtk::Misc	self
	double	xalign
	double	yalign
	CODE:
		gtk_misc_set_alignment(self, xalign, yalign);

void
set_padding(self, xpad, ypad)
	Gtk::Misc	self
	double	xpad
	double	ypad
	CODE:
		gtk_misc_set_padding(self, xpad, ypad);

MODULE = Gtk		PACKAGE = Gtk::Menu		PREFIX = gtk_menu_

Gtk::Menu
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_MENU(gtk_menu_new());
	OUTPUT:
	RETVAL

void
gtk_menu_append(self, child)
	Gtk::Menu	self
	Gtk::Widget	child

void
gtk_menu_prepend(self, child)
	Gtk::Menu	self
	Gtk::Widget	child

void
gtk_menu_insert(self, child, position)
	Gtk::Menu	self
	Gtk::Widget	child
	int	position

void
gtk_menu_popup(menu, parent_menu_shell, parent_menu_item, button, activate_time, func, ...)
	Gtk::Menu	menu
	Gtk::Widget	parent_menu_shell
	Gtk::Widget	parent_menu_item
	int	button
	int	activate_time
	SV *	func
	CODE:
	{
		AV * args = newAV();
		int i;
		for(i=5;i<items;i++)
			av_push(args,newSVsv(ST(i)));
		gtk_menu_popup(menu, parent_menu_shell, parent_menu_item, menu_pos_func,
			 (void*)args, button, activate_time);
	}

void
gtk_menu_popdown(self)
	Gtk::Menu	self

Gtk::Widget
gtk_menu_get_active(self)
	Gtk::Menu	self

void
gtk_menu_set_active(self, index)
	Gtk::Menu	self
	int	index

void
gtk_menu_set_accelerator_table(self, table)
	Gtk::Menu	self
	Gtk::AcceleratorTable	table

MODULE = Gtk		PACKAGE = Gtk::MenuBar

Gtk::MenuBar
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_MENU_BAR(gtk_menu_bar_new());
	OUTPUT:
	RETVAL

void
append(self, child)
	Gtk::MenuBar	self
	Gtk::Widget	child
	CODE:
	gtk_menu_bar_append(self, child);

void
prepend(self, child)
	Gtk::MenuBar	self
	Gtk::Widget	child
	CODE:
	gtk_menu_bar_prepend(self, child);

void
insert(self, child, position)
	Gtk::MenuBar	self
	Gtk::Widget	child
	int	position
	CODE:
	gtk_menu_bar_insert(self, child, position);

MODULE = Gtk		PACKAGE = Gtk::MenuFactory	PREFIX = gtk_menu_factory_

Gtk::MenuFactory
new(Class, type)
	SV *	Class
	Gtk::MenuFactoryType	type
	CODE:
	GtkInit();
	RETVAL = gtk_menu_factory_new(type);
	OUTPUT:
	RETVAL

void
gtk_menu_factory_add_entries(factory, entry, ...)
	Gtk::MenuFactory	factory
	SV *	entry
	CODE:
	{
		GtkMenuEntry * entries = malloc(sizeof(GtkMenuEntry)*(items-1));
		int i;
		for(i=1;i<items;i++) {
			SvGtkMenuEntry(ST(i), &entries[i-1]);
			entries[i-1].callback = menu_callback;
		}
		gtk_menu_factory_add_entries(factory, entries, items-1);
		free(entries);
	}

void
gtk_menu_factory_add_subfactory(factory, subfactory, path)
	Gtk::MenuFactory	factory
	Gtk::MenuFactory	subfactory
	char *	path

void
gtk_menu_factory_remove_paths(factory, path, ...)
	Gtk::MenuFactory	factory
	SV *	path
	CODE:
	{
		char ** paths = malloc(sizeof(char*)*(items-1));
		int i;
		for(i=1;i<items;i++)
			paths[i-1] = SvPV(ST(i),na);
		gtk_menu_factory_remove_paths(factory, paths, items-1);
		free(paths);
	}

void
gtk_menu_factory_remove_entries(factory, entry, ...)
	Gtk::MenuFactory	factory
	SV *	entry
	CODE:
	{
		GtkMenuEntry * entries = malloc(sizeof(GtkMenuEntry)*(items-1));
		int i;
		for(i=1;i<items;i++) {
			SvGtkMenuEntry(ST(i), &entries[i-1]);
			entries[i-1].callback = menu_callback;
		}
		gtk_menu_factory_remove_entries(factory, entries, items-1);
		free(entries);
	}

void
gtk_menu_factory_remove_subfactory(factory, subfactory, path)
	Gtk::MenuFactory	factory
	Gtk::MenuFactory	subfactory
	char *	path

void
gtk_menu_factory_find(factory, path)
	Gtk::MenuFactory	factory
	char *	path
	PPCODE:
	{
		GtkMenuPath * p = gtk_menu_factory_find(factory, path);
		if (p) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(p->widget), 0)));
			if (GIMME == G_ARRAY) {
				EXTEND(sp,1);
				PUSHs(sv_2mortal(newSVpv(p->path, 0)));
			}
		}
	}

void
gtk_menu_factory_destroy(factory)
	Gtk::MenuFactory	factory

void
DESTROY(factory)
	Gtk::MenuFactory	factory
	CODE:
	UnregisterMisc(SvRV(ST(0)), factory);

MODULE = Gtk		PACKAGE = Gtk::MenuItem

Gtk::MenuItem
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
	if (label)
		RETVAL = GTK_MENU_ITEM(gtk_menu_item_new_with_label(label));
	else
		RETVAL = GTK_MENU_ITEM(gtk_menu_item_new());
	OUTPUT:
	RETVAL

void
set_submenu(self, child)
	Gtk::MenuItem	self
	Gtk::Widget	child
	CODE:
	gtk_menu_item_set_submenu(self, child);

void
set_placement(self, placement)
	Gtk::MenuItem	self
	Gtk::SubmenuPlacement	placement
	CODE:
	gtk_menu_item_set_placement(self, placement);

void
accelerator_size(self)
	Gtk::MenuItem	self
	CODE:
	gtk_menu_item_accelerator_size(self);

void
accelerator_text(self, buffer)
	Gtk::MenuItem	self
	char *	buffer
	CODE:
	gtk_menu_item_accelerator_text(self, buffer);

void
configure(self, show_toggle, show_submenu)
	Gtk::MenuItem	self
	bool	show_toggle
	bool	show_submenu
	CODE:
	gtk_menu_item_configure(self, show_toggle, show_submenu);

void
select(self)
	Gtk::MenuItem	self
	CODE:
	gtk_menu_item_select(self);

void
deselect(self)
	Gtk::MenuItem	self
	CODE:
	gtk_menu_item_deselect(self);

void
activate(self)
	Gtk::MenuItem	self
	CODE:
	gtk_menu_item_activate(self);

MODULE = Gtk		PACKAGE = Gtk::MenuShell	PREFIX = gtk_menu_shell_

void
gtk_menu_shell_append(self, child)
	Gtk::MenuShell	self
	Gtk::Widget	child

void
gtk_menu_shell_prepend(self, child)
	Gtk::MenuShell	self
	Gtk::Widget	child

void
gtk_menu_shell_insert(self, child, position)
	Gtk::MenuShell	self
	Gtk::Widget	child
	int	position

void
gtk_menu_shell_deactivate(self)
	Gtk::MenuShell	self

MODULE = Gtk		PACKAGE = Gtk::Notebook		PREFIX = gtk_notebook_

Gtk::Notebook
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_NOTEBOOK(gtk_notebook_new());
	OUTPUT:
	RETVAL

void
gtk_notebook_append_page(self, child, tab_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label

void
gtk_notebook_prepend_page(self, child, tab_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label

void
gtk_notebook_insert_page(self, child, tab_label, position)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label
	int	position

void
gtk_notebook_remove_page(self, page_num)
	Gtk::Notebook	self
	int	page_num

void
gtk_notebook_next_page(self)
	Gtk::Notebook	self

void
gtk_notebook_prev_page(self)
	Gtk::Notebook	self

void
gtk_notebook_set_tab_pos(self, pos)
	Gtk::Notebook	self
	Gtk::PositionType	pos

Gtk::PositionType
gtk_notebook_tab_pos(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = self->tab_pos;
	OUTPUT:
	RETVAL

void
gtk_notebook_set_show_tabs(self, show_tabs)
	Gtk::Notebook self
	bool	show_tabs

void
gtk_notebook_set_show_border(self, show_border)
	Gtk::Notebook	self
	bool	show_border

MODULE = Gtk		PACKAGE = Gtk::Object

int
signal_connect(self, event, handler, ...)
	Gtk::Object	self
	char *	event
	SV *	handler
	CODE:
	{
		AV * args;
		SV * arg;
		int i,j;
		int type;
		args = newAV();
		
		type = gtk_signal_lookup(event, self->klass->type);
		
		i = gtk_signal_connect (GTK_OBJECT (self), event,
				NULL, (void*)args);
				
		av_push(args, newRV(SvRV(ST(0))));
		av_push(args, newSVsv(ST(1)));
		av_push(args, newSVsv(ST(2)));
		av_push(args, newSViv(type));
		for (j=3;j<items;j++)
			av_push(args, newSVsv(ST(j)));
		
		RETVAL = i;
	}
	OUTPUT:
	RETVAL

int
signal_connect_after(self, event, handler, ...)
	Gtk::Object	self
	char *	event
	SV *	handler
	CODE:
	{
		AV * args;
		SV * arg;
		int i,j;
		int type;
		args = newAV();
		
		type = gtk_signal_lookup(event, self->klass->type);
		
		i = gtk_signal_connect_after (GTK_OBJECT (self), event,
				NULL, (void*)args);
				
		av_push(args, newRV(SvRV(ST(0))));
		av_push(args, newSVsv(ST(1)));
		av_push(args, newSVsv(ST(2)));
		av_push(args, newSViv(type));
		for (j=3;j<items;j++)
			av_push(args, newSVsv(ST(j)));
		
		RETVAL = i;
	}
	OUTPUT:
	RETVAL

void
signal_disconnect(self, id)
	Gtk::Object	self
	int	id
	CODE:
	gtk_signal_disconnect(self, id);

void
signal_handlers_destroy(self)
	Gtk::Object	self
	CODE:
	gtk_signal_handlers_destroy(self);

SV *
get_user_data(object)
	Gtk::Object	object
	CODE:
	{
		int type = (int)gtk_object_get_data(object, "user_data_type_Perl");
		gpointer data = gtk_object_get_user_data(object);
		if (!data)
			RETVAL = &sv_undef;
		else {
			if (!type)
				croak("Unable to retrieve arbitrary user data");
			switch(type) {
			case 1:
				RETVAL = newSVGtkObjectRef((GtkObject*)data,0);
				break;
			default:
				croak("Unknown user data type");
			}
		}
	}
	OUTPUT:
	RETVAL

void
set_user_data(object, data)
	Gtk::Object	object
	SV *	data
	CODE:
	{
		if (!data || !SvOK(data)) {
			gtk_object_set_user_data(object, 0);
			gtk_object_set_data(object, "user_data_type_Perl", 0);
		} else {
			int type=0;
			gpointer ptr=0;
			if (SvRV(data)) {
				if (sv_derived_from(data, "Gtk::Object")) {
					type = 1;
					ptr = SvGtkObjectRef(data, 0);
				}
			}
			if (!type)
				croak("Unable to store user data of that type");
			gtk_object_set_user_data(object, ptr);
			gtk_object_set_data(object, "user_data_type_Perl", (gpointer)type);
		}
	}

void
DESTROY(self)
	Gtk::Object	self
	CODE:
		if (self)
			UnregisterGtkObject(SvRV(ST(0)), GTK_OBJECT(self));

SV *
set(self, name, value, ...)
	Gtk::Object	self
	SV *	name
	SV *	value
	CODE:
	{
		GtkArgType t;
		GtkArg	argv[3];
		int p;
		int argc;
		RETVAL = newSVsv(ST(0));
		
		for(p=1;p<items;) {
		
			if ((p+1)>=items)
				croak("too few arguments");

			argv[0].name = SvPV(ST(p),na);
			t = gtk_object_get_arg_type(argv[0].name);
			argv[0].type = t;
			value = ST(p+1);
		
			argc = 1;
			
			switch(t) {
			case GTK_ARG_CHAR:
				argv[0].d.c = SvIV(value);
				break;
			case GTK_ARG_SHORT:
				argv[0].d.s = SvIV(value);
				break;
			case GTK_ARG_INT:
				argv[0].d.i = SvIV(value);
				break;
			case GTK_ARG_LONG:
				argv[0].d.l = SvIV(value);
				break;
			case GTK_ARG_POINTER:
				argv[0].d.p = SvOK(value) ? SvPV(value,na) : 0;
				break;
			case GTK_ARG_OBJECT:
				argv[0].d.o = SvGtkObjectRef(value,"Gtk::Object");
				break;
			case GTK_ARG_SIGNAL:
			{
				AV * args;
				int i,j;
				int type;
				char * c = strchr(argv[0].name, ':');
				c+=2;
				c = strchr(c, ':');
				c += 2;
				args = newAV();
				
				type = gtk_signal_lookup(c, self->klass->type);
				
				av_push(args, newSVsv(ST(0)));
				av_push(args, newSVpv(c, 0));
				av_push(args, newSVsv(value));
				av_push(args, newSViv(type));

				argv[0].d.signal.f = 0;
				argv[0].d.signal.d = args;

				argc=1;
				break;
			}
			toomany:
				croak("Too many arguments");
				break;
			case GTK_ARG_INVALID:
				croak("Unknown setting");
				argc=0;
				break;
			default:
				croak("Unable to modify setting");
				argc=0;
				break;
			}
			gtk_object_setv(self, argc, argv);
			p += 1 + argc;
		}
	}
	OUTPUT:
	RETVAL


void
destroy(self)
	Gtk::Object	self
	CODE:
	gtk_object_destroy(self);
	UnregisterGtkObject(SvRV(ST(0)), GTK_OBJECT(self));
	SvIVX(SvRV(ST(0))) = 0;

MODULE = Gtk		PACKAGE = Gtk::OptionMenu		PREFIX = gtk_option_menu_

Gtk::OptionMenu
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_OPTION_MENU(gtk_option_menu_new());
	OUTPUT:
	RETVAL

void
gtk_option_menu_get_menu(self)
	Gtk::OptionMenu	self

void
gtk_option_menu_set_menu(self, menu)
	Gtk::OptionMenu	self
	Gtk::Widget	menu

void
gtk_option_menu_remove_menu(self)
	Gtk::OptionMenu	self

void
gtk_option_menu_set_history(self, index)
	Gtk::OptionMenu	self
	int	index

MODULE = Gtk		PACKAGE = Gtk::Pixmap		PREFIX = gtk_pixmap_

Gtk::Pixmap
new(Class, pixmap, mask)
	SV *	Class
	Gtk::Gdk::Pixmap	pixmap
	Gtk::Gdk::Bitmap	mask
	CODE:
	GtkInit();
	RETVAL = GTK_PIXMAP(gtk_pixmap_new(pixmap,mask));
	OUTPUT:
	RETVAL

void
gtk_pixmap_set(pixmap, val, mask )
	Gtk::Pixmap	pixmap
	Gtk::Gdk::Pixmap	val
	Gtk::Gdk::Bitmap	mask

void
gtk_pixmap_get(pixmap)
	Gtk::Pixmap	pixmap
	PPCODE:
	{
		GdkPixmap * result = 0;
		GdkBitmap * mask = 0;
		gtk_pixmap_get(pixmap, &result, (GIMME == G_ARRAY) ? &mask : 0);
		if (result) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkPixmapRef(result)));
		}
		if (mask) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkBitmapRef(mask)));
		}
	}

MODULE = Gtk		PACKAGE = Gtk::Preview		PREFIX = gtk_preview_

Gtk::Preview
new(Class, type)
	SV *	Class
	Gtk::PreviewType	type
	CODE:
	GtkInit();
	RETVAL = GTK_PREVIEW(gtk_preview_new(type));
	OUTPUT:
	RETVAL

void
gtk_preview_size(preview, width, height)
	Gtk::Preview	preview
	int	width
	int	height

void
gtk_preview_put(preview, window, gc, srcx, srcy, destx, desty, width, height)
	Gtk::Preview	preview
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	int	srcx
	int	srcy
	int	destx
	int	desty
	int	width
	int	height

void
gtk_preview_put_row(preview, src, dest, x, y, w)
	Gtk::Preview	preview
	char *	src
	char *	dest
	int	x
	int	y
	int	w


void
gtk_preview_draw_row(preview, data, x, y, w)
	Gtk::Preview	preview
	char *	data
	int	x
	int	y
	int	w

void
gtk_preview_set_expand(preview, expand)
	Gtk::Preview	preview
	int	expand

void
gtk_preview_set_gamma(Class, gamma)
	SV *	Class
	double	gamma
	CODE:
	gtk_preview_set_gamma(gamma);

void
gtk_preview_set_color_cube(Class, nred_shades, ngreen_shades, nblue_shades, ngray_shades)
	SV *	Class
	int	nred_shades
	int	ngreen_shades
	int	nblue_shades
	int	ngray_shades
	CODE:
	gtk_preview_set_color_cube(nred_shades,ngreen_shades,nblue_shades,ngray_shades);

void
gtk_preview_set_install_cmap(Class, install_cmap)
	SV *	Class
	int	install_cmap
	CODE:
	gtk_preview_set_install_cmap(install_cmap);

void
gtk_preview_set_reserved(Class, reserved)
	SV *	Class
	int	reserved
	CODE:
	gtk_preview_set_reserved(reserved);

Gtk::Gdk::Visual
gtk_preview_get_visual(Class)
	SV *	Class
	CODE:
	RETVAL = gtk_preview_get_visual();
	OUTPUT:
	RETVAL

Gtk::Gdk::Colormap
gtk_preview_get_cmap(Class)
	SV *	Class
	CODE:
	RETVAL = gtk_preview_get_cmap();
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::ProgressBar		PREFIX = gtk_progress_bar_

Gtk::ProgressBar
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_PROGRESS_BAR(gtk_progress_bar_new());
	OUTPUT:
	RETVAL

void
gtk_progress_bar_update(self, percentage)
	Gtk::ProgressBar	self
	double	percentage

double
percentage(self)
	Gtk::ProgressBar	self
	CODE:
	RETVAL = self->percentage;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::RadioButton		PREFIX = gtk_radio_button_

Gtk::RadioButton
new(Class, label=0, previous=0)
	SV *	Class
	SV *	label
	Gtk::RadioButton	previous
	CODE:
	{
		GSList * group = 0;
		GtkInit();
		
		if (previous)
			group = gtk_radio_button_group(previous);
			
		if (label && SvOK(label) )
			RETVAL = GTK_RADIO_BUTTON(gtk_radio_button_new_with_label(group, SvPV(label,na)));
		else
			RETVAL = GTK_RADIO_BUTTON(gtk_radio_button_new(group));
	}
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::RadioMenuItem		PREFIX = gtk_menu_item_

Gtk::RadioMenuItem
new(Class, label=0, previous=0)
	SV *	Class
	SV *	label
	Gtk::RadioMenuItem	previous
	CODE:
	{
		GSList * group = 0;
		GtkInit();
		if (previous)	
			group = gtk_radio_menu_item_group(previous);
		if (label && SvOK(label))
			RETVAL = GTK_RADIO_MENU_ITEM(gtk_radio_menu_item_new_with_label(group, SvPV(label,na)));
		else
			RETVAL = GTK_RADIO_MENU_ITEM(gtk_radio_menu_item_new(group));
	}
	OUTPUT:
	RETVAL


MODULE = Gtk		PACKAGE = Gtk::Range	PREFIX = gtk_range_

Gtk::Adjustment
gtk_range_get_adjustment(self)
	Gtk::Range	self

void
gtk_range_set_update_policy(self, policy)
	Gtk::Range	self
	Gtk::UpdateType	policy

void
gtk_range_set_adjustment(self, adjustment)
	Gtk::Range	self
	Gtk::Adjustment	adjustment

void
gtk_range_draw_background(self)
	Gtk::Range	self

void
gtk_range_draw_trough(self)
	Gtk::Range	self

void
gtk_range_draw_slider(self)
	Gtk::Range	self

void
gtk_range_draw_step_forw(self)
	Gtk::Range	self

void
gtk_range_draw_step_back(self)
	Gtk::Range	self

void
gtk_range_slider_update(self)
	Gtk::Range	self

void
gtk_range_trough_click(self, x, y)
	Gtk::Range	self
	int	x
	int y

void
gtk_range_default_hslider_update(self)
	Gtk::Range	self

void
gtk_range_default_vslider_update(self)
	Gtk::Range	self

void
gtk_range_default_htrough_click(self, x, y)
	Gtk::Range	self
	int	x
	int	y

void
gtk_range_default_vtrough_click(self, x, y)
	Gtk::Range	self
	int	x
	int	y

void
gtk_range_default_hmotion(self, xdelta, ydelta)
	Gtk::Range	self
	int	xdelta
	int	ydelta

void
gtk_range_default_vmotion(self, xdelta, ydelta)
	Gtk::Range	self
	int	xdelta
	int	ydelta

double
gtk_range_calc_value(self, position)
	Gtk::Range	self
	int	position

MODULE = Gtk		PACKAGE = Gtk::Rc	PREFIX = gtk_rc_

void
gtk_rc_parse(Class, filename)
	char *	filename
	CODE:
	GtkInit();
	gtk_rc_parse(filename);

MODULE = Gtk		PACKAGE = Gtk::Ruler	PREFIX = gtk_ruler_

void
gtk_ruler_set_metric(self, metric)
	Gtk::Ruler	self
	Gtk::MetricType	metric

void
gtk_ruler_set_range(self, lower, upper, position, max_size)
	Gtk::Ruler	self
	double	lower
	double	upper
	double	position
	double	max_size

void
gtk_ruler_draw_ticks(self)
	Gtk::Ruler	self

void
gtk_ruler_draw_pos(self)
	Gtk::Ruler	self

MODULE = Gtk		PACKAGE = Gtk::Scale	PREFIX = gtk_scale_

void
gtk_scale_set_digits(self, digits)
	Gtk::Scale	self
	int	digits

void
gtk_scale_set_draw_value(self, draw_value)
	Gtk::Scale	self
	int	draw_value

void
gtk_scale_set_value_pos(self, pos)
	Gtk::Scale	self
	Gtk::PositionType	pos

int
gtk_scale_value_width(self)
	Gtk::Scale	self

void
gtk_scale_draw_value(self)
	Gtk::Scale	self

MODULE = Gtk		PACKAGE = Gtk::Scrollbar

MODULE = Gtk		PACKAGE = Gtk::ScrolledWindow	PREFIX = gtk_scrolled_window_

Gtk::ScrolledWindow
new(Class, hadj, vadj)
	SV *	Class
	Gtk::Adjustment	hadj
	Gtk::Adjustment	vadj
	CODE:
	GtkInit();
	RETVAL = GTK_SCROLLED_WINDOW(gtk_scrolled_window_new(hadj, vadj));
	OUTPUT:
	RETVAL

Gtk::Adjustment
gtk_scrolled_window_get_hadjustment(self)
	Gtk::ScrolledWindow	self

Gtk::Adjustment
gtk_scrolled_window_get_vadjustment(self)
	Gtk::ScrolledWindow	self

void
gtk_scrolled_window_set_policy(self, hscrollbar_policy, vscrollbar_policy)
	Gtk::ScrolledWindow	self
	Gtk::PolicyType	hscrollbar_policy
	Gtk::PolicyType	vscrollbar_policy

MODULE = Gtk		PACKAGE = Gtk::Separator

MODULE = Gtk		PACKAGE = Gtk::Style	PREFIX = gtk_style_

Gtk::Style
new(Class=0)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = gtk_style_new();
	OUTPUT:
	RETVAL

Gtk::Style
gtk_style_attach(self, window)
	Gtk::Style	self
	Gtk::Gdk::Window	window

void
gtk_style_detach(self)
	Gtk::Style	self

void
gtk_style_ref(self)
	Gtk::Style	self

void
gtk_style_unref(self)
	Gtk::Style	self

void
gtk_style_set_background(self, window, state_type)
	Gtk::Style	self
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type

Gtk::Gdk::Color
fg(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->fg[state];
	if (items>2) style->fg[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
bg(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->bg[state];
	if (items>2) style->bg[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
light(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->light[state];
	if (items>2) style->light[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
dark(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->dark[state];
	if (items>2) style->dark[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
mid(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->mid[state];
	if (items>2) style->mid[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
text(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->text[state];
	if (items>2) style->text[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
base(style, state, new_color=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->base[state];
	if (items>2) style->base[state] = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
black(style, new_color=0)
	Gtk::Style	style
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->black;
	if (items>1) style->black = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Color
white(style, new_color=0)
	Gtk::Style	style
	Gtk::Gdk::Color	new_color
	CODE:
	RETVAL = &style->white;
	if (items>1) style->white = *new_color;
	OUTPUT:
	RETVAL

Gtk::Gdk::Font
font(style, new_font=0)
	Gtk::Style	style
	Gtk::Gdk::Font	new_font
	CODE:
	RETVAL = style->font;
	if (items>1) style->font = new_font;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
fg_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->fg_gc[state];
	if (items>2) style->fg_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
bg_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->bg_gc[state];
	if (items>2) style->bg_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
light_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->light_gc[state];
	if (items>2) style->light_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
dark_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->dark_gc[state];
	if (items>2) style->dark_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
mid_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->mid_gc[state];
	if (items>2) style->mid_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
text_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->text_gc[state];
	if (items>2) style->text_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
base_gc(style, state, new_gc=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->base_gc[state];
	if (items>2) style->base_gc[state] = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
black_gc(style, new_gc=0)
	Gtk::Style	style
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->black_gc;
	if (items>1) style->black_gc = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::GC
white_gc(style, new_gc=0)
	Gtk::Style	style
	Gtk::Gdk::GC	new_gc
	CODE:
	RETVAL = style->white_gc;
	if (items>1) style->white_gc = new_gc;
	OUTPUT:
	RETVAL

Gtk::Gdk::Pixmap
bg_pixmap(style, state, new_pixmap=0)
	Gtk::Style	style
	Gtk::StateType	state
	Gtk::Gdk::Pixmap	new_pixmap
	CODE:
	RETVAL = style->bg_pixmap[state];
	if (items>2) style->bg_pixmap[state] = new_pixmap;
	OUTPUT:
	RETVAL

int
depth(style, new_depth=0)
	Gtk::Style	style
	int	new_depth
	CODE:
	RETVAL = style->depth;
	if (items>1) style->depth = new_depth;
	OUTPUT:
	RETVAL

Gtk::Gdk::Colormap
colormap(style, new_colormap=0)
	Gtk::Style	style
	Gtk::Gdk::Colormap	new_colormap
	CODE:
	RETVAL = style->colormap;
	if (items>2) style->colormap = new_colormap;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Style	PREFIX = gtk_

void
gtk_draw_hline(style, window, state_type, x1, x2, y)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	int	x1
	int	x2
	int	y

void
gtk_draw_vline(style, window, state_type, y1, y2, x)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	int	y1
	int	y2
	int	x

void
gtk_draw_shadow(style, window, state_type, shadow_type, x, y, width, height)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	Gtk::ShadowType	shadow_type
	int	x
	int	y
	int	width
	int	height

void
gtk_draw_polygon(style, window, state_type, shadow_type, fill, x, y, ...)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	Gtk::ShadowType	shadow_type
	bool fill
	int	x
	int	y
	CODE:
	{
		int npoints = (items-5)/2;
		GdkPoint * points = malloc(sizeof(GdkPoint)*npoints);
		int i,j;
		for(i=0,j=5;i<npoints;i++,j+=2) {
			points[i].x = SvIV(ST(j));
			points[i].y = SvIV(ST(j+1));
		}
		gtk_draw_polygon(style,window,state_type,shadow_type, points, npoints,fill);
		free(points);
	}

void
gtk_draw_arrow(style, window, state_type, shadow_type, arrow_type, fill, x, y, width, height)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	Gtk::ShadowType	shadow_type
	Gtk::ArrowType	arrow_type
	bool	fill
	int	x
	int	y
	int	width
	int	height

void
gtk_draw_diamond(style, window, state_type, shadow_type, x, y, width, height)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	Gtk::ShadowType	shadow_type
	int	x
	int	y
	int	width
	int	height

void
gtk_draw_oval(style, window, state_type, shadow_type, x, y, width, height)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	Gtk::ShadowType	shadow_type
	int	x
	int	y
	int	width
	int	height

void
gtk_draw_string(style, window, state_type, x, y, string)
	Gtk::Style	style
	Gtk::Gdk::Window	window
	Gtk::StateType	state_type
	int	x
	int	y
	char *	string

void
DESTROY(self)
	Gtk::Style	self
	CODE:
	UnregisterMisc(SvRV(ST(0)), self);
	/*gtk_style_unref(self);*/

MODULE = Gtk		PACKAGE = Gtk::Table	PREFIX = gtk_table_

Gtk::Table
new(Class, rows, cols, homogeneous)
	SV *	Class
	int	rows
	int	cols
	int homogeneous
	CODE:
	GtkInit();
	RETVAL = GTK_TABLE(gtk_table_new(rows, cols, homogeneous));
	OUTPUT:
	RETVAL

void
gtk_table_attach(table, child, left_attach, right_attach, top_attach, bottom_attach, xoptions, yoptions, xpadding, ypadding)
	Gtk::Table	table
	Gtk::Widget	child
	int	left_attach
	int	right_attach
	int	top_attach
	int	bottom_attach
	Gtk::AttachOptions	xoptions
	Gtk::AttachOptions	yoptions
	int	xpadding
	int	ypadding

void
gtk_table_attach_defaults(table, child, left_attach, right_attach, top_attach, bottom_attach)
	Gtk::Table	table
	Gtk::Widget	child
	int	left_attach
	int	right_attach
	int	top_attach
	int	bottom_attach

void
gtk_table_set_row_spacing(table, row, spacing)
	Gtk::Table	table
	int	row
	int	spacing

void
gtk_table_set_col_spacing(table, col, spacing)
	Gtk::Table	table
	int	col
	int	spacing

void
gtk_table_set_row_spacings(table, spacing)
	Gtk::Table	table
	int	spacing

void
gtk_table_set_col_spacings(table, spacing)
	Gtk::Table	table
	int	spacing

MODULE = Gtk		PACKAGE = Gtk::Text		PREFIX = gtk_text_


Gtk::Text
new(Class, hadjustment, vadjustment)
	SV *	Class
	Gtk::Adjustment	hadjustment
	Gtk::Adjustment	vadjustment
	CODE:
	GtkInit();
	RETVAL = GTK_TEXT(gtk_text_new(hadjustment, vadjustment));
	OUTPUT:
	RETVAL

void
gtk_text_set_editable(text, editable)
	Gtk::Text	text
	int	editable

void
gtk_text_set_adjustments(text, hadjustment, vadjustment)
	Gtk::Text	text
	Gtk::Adjustment	hadjustment
	Gtk::Adjustment	vadjustment

void
gtk_text_set_point(text, index)
	Gtk::Text	text
	int	index

int
gtk_text_get_point(text)
	Gtk::Text	text

int
gtk_text_get_length(text)
	Gtk::Text	text

void
gtk_text_freeze(text)
	Gtk::Text	text

void
gtk_text_thaw(text)
	Gtk::Text	text

void
gtk_text_backward_delete(text, nchars)
	Gtk::Text	text
	int	nchars

void
gtk_text_foreward_delete(text, nchars)
	Gtk::Text	text
	int	nchars

void
gtk_text_insert(text, font, fg, bg, string)
	Gtk::Text	text
	Gtk::Gdk::Font	font
	Gtk::Gdk::Color	fg
	Gtk::Gdk::Color	bg
	SV *	string
	CODE:
	{
		int len;
		SvPV(string,len);
		gtk_text_insert(text, font, fg, bg, SvPV(string,na), len);
	}

Gtk::Adjustment
hadj(text)
	Gtk::Text	text
	CODE:
	RETVAL = text->hadj;
	OUTPUT:
	RETVAL

Gtk::Adjustment
vadj(text)
	Gtk::Text	text
	CODE:
	RETVAL = text->vadj;
	OUTPUT:
	RETVAL


MODULE = Gtk		PACKAGE = Gtk::ToggleButton		PREFIX = gtk_toggle_button_

Gtk::ToggleButton
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
		if (label)
			RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new_with_label(label));
		else
			RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new());
	OUTPUT:
	RETVAL

void
gtk_toggle_button_set_state(self, state)
	Gtk::ToggleButton	self
	int	state

void
gtk_toggle_button_set_mode(self, draw_indicator)
	Gtk::ToggleButton	self
	int	draw_indicator

void
gtk_toggle_button_toggled(self)
	Gtk::ToggleButton	self

int
active(self)
	Gtk::ToggleButton	self
	CODE:
		RETVAL = self->active;
	OUTPUT:
	RETVAL

int
draw_indicator(self)
	Gtk::ToggleButton	self
	CODE:
		RETVAL = self->draw_indicator;
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Tooltips

Gtk::Tooltips
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = gtk_tooltips_new();
	OUTPUT:
	RETVAL

void
set_tips(self, widget, text)
	Gtk::Tooltips	self
	Gtk::Widget	widget
	char *	text
	CODE:
	gtk_tooltips_set_tips(self, widget, text);

void
destroy(self)
	Gtk::Tooltips	self
	CODE:
	gtk_tooltips_destroy(self);
	SvIVX(SvRV(ST(0))) = 0;

void
DESTROY(self)
	Gtk::Tooltips	self
	CODE:
	/*if (self)
		gtk_tooltips_destroy(self);*/

MODULE = Gtk		PACKAGE = Gtk::Tree		PREFIX = gtk_tree_

Gtk::Tree
new(Class)
	SV *	Class
	CODE:
	GtkInit();
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

MODULE = Gtk		PACKAGE = Gtk::TreeItem		PREFIX = gtk_tree_item_

Gtk::TreeItem
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	GtkInit();
	if (label)
		RETVAL = GTK_TREE_ITEM(gtk_tree_item_new_with_label(label));
	else
		RETVAL = GTK_TREE_ITEM(gtk_tree_item_new());
	OUTPUT:
	RETVAL

void
gtk_tree_item_set_subtree(tree_item, subtree)
	Gtk::TreeItem	tree_item
	Gtk::Widget	subtree

void
gtk_tree_item_select(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_deselect(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_expand(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_collapse(tree_item)
	Gtk::TreeItem	tree_item

MODULE = Gtk		PACKAGE = Gtk::VBox

Gtk::VBox
new(Class, homogeneous, spacing)
	SV *	Class
	bool	homogeneous
	int	spacing
	CODE:
	GtkInit();
		RETVAL = GTK_VBOX(gtk_vbox_new(homogeneous, spacing));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Viewport		PREFIX = gtk_viewport_

Gtk::Viewport
new(Class, hadjustment, vadjustment)
	SV *	Class
	Gtk::Adjustment	hadjustment
	Gtk::Adjustment	vadjustment
	CODE:
	GtkInit();
		RETVAL = GTK_VIEWPORT(gtk_viewport_new(hadjustment, vadjustment));
	OUTPUT:
	RETVAL

Gtk::Adjustment
gtk_viewport_get_hadjustment(viewport)
	Gtk::Viewport	viewport

Gtk::Adjustment
gtk_viewport_get_vadjustment(viewport)
	Gtk::Viewport	viewport

void
gtk_viewport_set_hadjustment(viewport, adjustment)
	Gtk::Viewport	viewport
	Gtk::Adjustment	adjustment

void
gtk_viewport_set_vadjustment(viewport, adjustment)
	Gtk::Viewport	viewport
	Gtk::Adjustment	adjustment

void
gtk_viewport_set_shadow_type(viewport, shadow_type)
	Gtk::Viewport	viewport
	Gtk::ShadowType	shadow_type

MODULE = Gtk		PACKAGE = Gtk::VRuler

Gtk::VRuler
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_VRULER(gtk_vruler_new());
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::VScale

Gtk::VScale
new(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	GtkInit();
	RETVAL = GTK_VSCALE(gtk_vscale_new(adjustment));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::VScrollbar

Gtk::VScrollbar
new(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	GtkInit();
	RETVAL = GTK_VSCROLLBAR(gtk_vscrollbar_new(adjustment));
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::VSeparator

Gtk::VSeparator
new(Class)
	SV *	Class
	CODE:
	GtkInit();
	RETVAL = GTK_VSEPARATOR(gtk_vseparator_new());
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Widget		PREFIX = gtk_widget_

Gtk::Style
style(widget)
	Gtk::Widget	widget
	CODE:
	RETVAL = widget->style;
	OUTPUT:
	RETVAL

void
gtk_widget_destroy(widget)
	Gtk::Widget	widget

void
gtk_widget_unparent(widget)
	Gtk::Widget	widget

void
gtk_widget_show(widget)
	Gtk::Widget	widget

void
gtk_widget_hide(widget)
	Gtk::Widget	widget

void
gtk_widget_map(widget)
	Gtk::Widget	widget
	
void
gtk_widget_unmap(widget)
	Gtk::Widget	widget

void
gtk_widget_realize(widget)
	Gtk::Widget	widget

void
gtk_widget_unrealize(widget)
	Gtk::Widget	widget

void
gtk_widget_draw(widget, area)
	Gtk::Widget	widget
	Gtk::Gdk::Rectangle	area

void
gtk_widget_draw_focus(widget)
	Gtk::Widget	widget

void
gtk_widget_draw_default(widget)
	Gtk::Widget	widget

void
gtk_widget_draw_children(widget)
	Gtk::Widget	widget

void
gtk_widget_install_accelerator(widget, table, signal_name, key, modifiers)
	Gtk::Widget	widget
	Gtk::AcceleratorTable	table
	char *	signal_name
	int	key
	int	modifiers

void
gtk_widget_remove_accelerator(widget, table, signal_name)
	Gtk::Widget	widget
	Gtk::AcceleratorTable	table
	char *	signal_name

int
gtk_widget_event(widget, event)
	Gtk::Widget	widget
	Gtk::Gdk::Event	event

void
gtk_widget_activate(widget)
	Gtk::Widget	widget

void
gtk_widget_reparent(widget, reparent)
	Gtk::Widget	widget
	Gtk::Widget	reparent

void
gtk_widget_popup(widget, x, y)
	Gtk::Widget	widget
	int	x
	int	y

SV *
gtk_widget_intersect(widget, area)
	Gtk::Widget	widget
	Gtk::Gdk::Rectangle	area
	CODE:
	{
		GdkRectangle intersection;
		int result = gtk_widget_intersect(widget, area, &intersection);
		if (result)
			RETVAL = newSVGtkGdkRectangle(&intersection);
		else
			RETVAL = &sv_undef;
	}
	OUTPUT:
	RETVAL

void
gtk_widget_basic(widget)
	Gtk::Widget	widget

void
gtk_widget_grab_focus(widget)
	Gtk::Widget	widget

void
gtk_widget_grab_default(widget)
	Gtk::Widget	widget

void
gtk_widget_restore_state(widget)
	Gtk::Widget	widget

void
gtk_widget_set_name(widget, name)
	Gtk::Widget	widget
	char *	name

char *
gtk_widget_get_name(widget)
	Gtk::Widget	widget

void
gtk_widget_set_state(widget, state)
	Gtk::Widget	widget
	Gtk::StateType	state

void
gtk_widget_set_sensitive(widget, sensitive)
	Gtk::Widget	widget
	int	sensitive

void
gtk_widget_set_parent(widget, parent)
	Gtk::Widget	widget
	Gtk::Widget	parent

void
gtk_widget_set_style(widget, style)
	Gtk::Widget	widget
	Gtk::Style	style

void
gtk_widget_set_uposition(widget, x, y)
	Gtk::Widget	widget
	int	x
	int	y

void
gtk_widget_set_usize(widget, width, height)
	Gtk::Widget	widget
	int	width
	int	height

void
gtk_widget_set_events(widget, events)
	Gtk::Widget	widget
	Gtk::Gdk::EventMask	events

upGtk::Widget
gtk_widget_get_toplevel(widget)
	Gtk::Widget	widget

upGtk::Widget
gtk_widget_get_ancestor(widget, type_name)
	Gtk::Widget	widget
	char *	type_name
	CODE:
	{
		int t = gtk_type_from_name(type_name);
		RETVAL = gtk_widget_get_ancestor(widget, t);
	}
	OUTPUT:
	RETVAL

Gtk::Gdk::Colormap
gtk_widget_get_colormap(widget)
	Gtk::Widget	widget

Gtk::Gdk::Visual
gtk_widget_get_visual(widget)
	Gtk::Widget	widget

Gtk::Style
gtk_widget_get_style(widget)
	Gtk::Widget	widget

int
gtk_widget_get_events(widget)
	Gtk::Widget	widget

void
gtk_widget_get_pointer(widget)
	Gtk::Widget	widget
	PPCODE:
	{
		int x,y;
		gtk_widget_get_pointer(widget, &x, &y);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gtk_widget_push_colormap(Class, colormap)
	SV *	Class
	Gtk::Gdk::Colormap	colormap
	CODE:
	gtk_widget_push_colormap(colormap);

void
gtk_widget_push_visual(Class, visual)
	SV *	Class
	Gtk::Gdk::Visual	visual
	CODE:
	gtk_widget_push_visual(visual);

void
gtk_widget_push_style(Class, style)
	SV *	Class
	Gtk::Style	style
	CODE:
	gtk_widget_push_style(style);

void
gtk_widget_pop_colormap(Class)
	SV *	Class
	CODE:
	gtk_widget_pop_colormap();

void
gtk_widget_pop_visual(Class)
	SV *	Class
	CODE:
	gtk_widget_pop_visual();

void
gtk_widget_pop_style(Class)
	SV *	Class
	CODE:
	gtk_widget_pop_style();

void
gtk_widget_set_default_colormap(Class, colormap)
	SV *	Class
	Gtk::Gdk::Colormap	colormap
	CODE:
	gtk_widget_set_default_colormap(colormap);

void
gtk_widget_set_default_visual(Class, visual)
	SV *	Class
	Gtk::Gdk::Visual	visual
	CODE:
	gtk_widget_set_default_visual(visual);

void
gtk_widget_set_default_style(Class, style)
	SV *	Class
	Gtk::Style	style
	CODE:
	gtk_widget_set_default_style(style);

Gtk::Gdk::Colormap
gtk_widget_get_default_colormap(Class)
	SV *	Class
	CODE:
	RETVAL = gtk_widget_get_default_colormap();
	OUTPUT:
	RETVAL

Gtk::Gdk::Visual
gtk_widget_get_default_visual(Class)
	SV *	Class
	CODE:
	RETVAL = gtk_widget_get_default_visual();
	OUTPUT:
	RETVAL

Gtk::Style
gtk_widget_get_default_style(Class)
	SV *	Class
	CODE:
	RETVAL = gtk_widget_get_default_style();
	OUTPUT:
	RETVAL

Gtk::StateType
gtk_widget_state(widget, newvalue=0)
	Gtk::Widget	widget
	Gtk::StateType	newvalue
	CODE:
	RETVAL = GTK_WIDGET_STATE(widget);
	if (items>1)
		GTK_WIDGET_STATE(widget) = newvalue;
	OUTPUT:
	RETVAL


Gtk::StateType
gtk_widget_saved_state(widget, newvalue=0)
	Gtk::Widget	widget
	Gtk::StateType	newvalue
	CODE:
	RETVAL = GTK_WIDGET_SAVED_STATE(widget);
	if (items>1)
		GTK_WIDGET_SAVED_STATE(widget) = newvalue;
	OUTPUT:
	RETVAL

int
gtk_widget_visible(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_VISIBLE(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_VISIBLE);
	OUTPUT:
	RETVAL

int
gtk_widget_mapped(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_MAPPED(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_MAPPED);
	OUTPUT:
	RETVAL

int
gtk_widget_unmapped(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_UNMAPPED(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_UNMAPPED);
	OUTPUT:
	RETVAL

int
gtk_widget_realized(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_REALIZED(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_REALIZED);
	OUTPUT:
	RETVAL

int
gtk_widget_sensitive(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_SENSITIVE(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_SENSITIVE);
	OUTPUT:
	RETVAL

int
gtk_widget_parent_sensitive(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_PARENT_SENSITIVE(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_PARENT_SENSITIVE);
	OUTPUT:
	RETVAL

int
gtk_widget_is_sensitive(widget)
	Gtk::Widget	widget
	CODE:
	RETVAL = GTK_WIDGET_IS_SENSITIVE(widget);
	OUTPUT:
	RETVAL

int
gtk_widget_no_window(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_NO_WINDOW(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_NO_WINDOW);
	OUTPUT:
	RETVAL

int
gtk_widget_has_focus(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_HAS_FOCUS(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_HAS_FOCUS);
	OUTPUT:
	RETVAL


int
gtk_widget_can_focus(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_CAN_FOCUS(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_CAN_FOCUS);
	OUTPUT:
	RETVAL

int
gtk_widget_has_default(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_HAS_DEFAULT(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_HAS_DEFAULT);
	OUTPUT:
	RETVAL


int
gtk_widget_can_default(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_CAN_DEFAULT(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_CAN_DEFAULT);
	OUTPUT:
	RETVAL


int
gtk_widget_propagate_state(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_PROPAGATE_STATE(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_PROPAGATE_STATE);
	OUTPUT:
	RETVAL


int
gtk_widget_drawable(widget)
	Gtk::Widget	widget
	CODE:
	RETVAL = GTK_WIDGET_DRAWABLE(widget);
	OUTPUT:
	RETVAL


int
gtk_widget_anchored(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_ANCHORED(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_ANCHORED);
	OUTPUT:
	RETVAL

int
gtk_widget_BASIC(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_BASIC(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_BASIC);
	OUTPUT:
	RETVAL

int
gtk_widget_user_style(widget, newvalue=0)
	Gtk::Widget	widget
	int	newvalue
	CODE:
	RETVAL = GTK_WIDGET_USER_STYLE(widget);
	if (items>1)
		GTK_WIDGET_SET_FLAGS(widget, GTK_USER_STYLE);
	OUTPUT:
	RETVAL


upGtk::Widget
parent(self)
	Gtk::Widget	self
	CODE:
		RETVAL = self->parent;
	OUTPUT:
	RETVAL

Gtk::Gdk::Window
window(self)
	Gtk::Widget	self
	CODE:
		RETVAL = self->window;
	OUTPUT:
	RETVAL

int
motion_notify_event(widget, event)
	Gtk::Widget	widget
	Gtk::Gdk::Event	event
	CODE:
		RETVAL = GTK_WIDGET_CLASS(GTK_OBJECT(widget)->klass)->motion_notify_event(widget, (GdkEventMotion*)event);
	OUTPUT:
	RETVAL


void
grab_add(self)
	Gtk::Widget	self
	CODE:
	gtk_grab_add(self);

void
grab_remove(self)
	Gtk::Widget	self
	CODE:
	gtk_grab_remove(self);

upGtk::Widget
new(Class, widget_class, ...)
	SV *	Class
	char *	widget_class
	CODE:
	{
		GtkArgType t;
		GtkArg	argv[3];
		int p;
		int argc;
		int widget_type;
		GtkObject * o;
		SV *	value;
		
		GtkInit();
		
		widget_type = gtk_type_from_name(widget_class);
		o = GTK_OBJECT(gtk_widget_new(widget_type, NULL));
		RETVAL = GTK_WIDGET(o);
		
		for(p=2;p<items;) {
		
			if ((p+1)>=items)
				croak("too few arguments");

			argv[0].name = SvPV(ST(p),na);
			t = gtk_object_get_arg_type(argv[0].name);
			argv[0].type = t;
			value = ST(p+1);
		
			argc = 1;
			
			switch(t) {
			case GTK_ARG_CHAR:
				argv[0].d.c = SvIV(value);
				break;
			case GTK_ARG_SHORT:
				argv[0].d.s = SvIV(value);
				break;
			case GTK_ARG_INT:
				argv[0].d.i = SvIV(value);
				break;
			case GTK_ARG_LONG:
				argv[0].d.l = SvIV(value);
				break;
			case GTK_ARG_POINTER:
				argv[0].d.p = SvOK(value) ? SvPV(value,na) : 0;
				break;
			case GTK_ARG_OBJECT:
				argv[0].d.o = SvGtkObjectRef(value,"Gtk::Object");
				break;
			case GTK_ARG_SIGNAL:
			{
				AV * args;
				int i,j;
				int type;
				char * c = strchr(argv[0].name, ':');
				c+=2;
				c = strchr(c, ':');
				c += 2;
				args = newAV();
				
				type = gtk_signal_lookup(c, o->klass->type);
				
				av_push(args, newSVsv(ST(0)));
				av_push(args, newSVpv(c, 0));
				av_push(args, newSVsv(value));
				av_push(args, newSViv(type));
				
				argv[0].d.signal.f = 0;
				argv[0].d.signal.d = args;

				argc=1;
				break;
			}
			toomany:
				croak("Too many arguments");
				break;
			case GTK_ARG_INVALID:
				croak("Unknown setting");
				argc=0;
				break;
			default:
				croak("Unable to modify setting");
				argc=0;
				break;
			}
			gtk_object_setv(o, argc, argv);
			p += 1 + argc;
		}
	}
	OUTPUT:
	RETVAL


MODULE = Gtk		PACKAGE = Gtk::Window		PREFIX = gtk_window_

Gtk::Window
new(Class, type=0)
	SV *	Class
	Gtk::WindowType	type
	CODE:
	GtkInit();
	RETVAL = GTK_WINDOW(gtk_window_new(type));
	OUTPUT:
	RETVAL

void
set_title(self, title)
	Gtk::Window	self
	char *	title
	CODE:
	gtk_window_set_title(self, title);

void
gtk_window_set_focus(window, focus)
	Gtk::Window	window
	Gtk::Widget	focus

void
gtk_window_set_default(window, defaultw)
	Gtk::Window	window
	Gtk::Widget	defaultw

void
gtk_window_set_policy(window, allow_shrink, allow_grow, auto_shrink)
	Gtk::Window	window
	int	allow_shrink
	int	allow_grow
	int	auto_shrink

void
gtk_window_add_accelerator_table(window, table)
	Gtk::Window	window
	Gtk::AcceleratorTable	table

void
gtk_window_remove_accelerator_table(window, table)
	Gtk::Window	window
	Gtk::AcceleratorTable	table

void
gtk_window_position(window, position)
	Gtk::Window	window
	Gtk::WindowPosition	position
	

MODULE = Gtk		PACKAGE = Gtk::AcceleratorTable

Gtk::AcceleratorTable
new(Class)
	SV *	Class
	CODE:
	GtkInit();
		RETVAL = gtk_accelerator_table_new();
	OUTPUT:
	RETVAL

Gtk::AcceleratorTable
find(object, signal_name, key, mods)
	Gtk::Object	object
	char *	signal_name
	char	key
	int	mods
	CODE:
		RETVAL = gtk_accelerator_table_find(object, signal_name, key, mods);
	OUTPUT:
	RETVAL

void
DESTROY(self)
	Gtk::AcceleratorTable	self
	CODE:
	UnregisterMisc(SvRV(ST(0)), (void*)self);
	gtk_accelerator_table_unref(self);

void
install(self, object, signal_name, accelerator_key, accelerator_mods)
	Gtk::AcceleratorTable	self
	Gtk::Object	object
	char *	signal_name
	char	accelerator_key
	int	accelerator_mods
	CODE:
		gtk_accelerator_table_install(self,object,signal_name,accelerator_key,accelerator_mods);

void
remove(self, object, signal_name)
	Gtk::AcceleratorTable	self
	Gtk::Object	object
	char *	signal_name
	CODE:
		gtk_accelerator_table_remove(self,object,signal_name);

int
check(self, accelerator_key, accelerator_mods)
	Gtk::AcceleratorTable	self
	char	accelerator_key
	int	accelerator_mods
	CODE:
		RETVAL = gtk_accelerator_table_check(self,accelerator_key, accelerator_mods);
	OUTPUT:
	RETVAL


MODULE = Gtk		PACKAGE = Gtk::Gdk		PREFIX = gdk_

double
constant(name,arg)
	char *	name
	int	arg

void
init(Class)
	SV *	Class
	CODE:
	{
		if (!init_gdk) {
			int argc;
			char ** argv = 0;
			AV * ARGV = perl_get_av("ARGV", FALSE);
			SV * ARGV0 = perl_get_sv("0", FALSE);
			int i;
			
			argc = av_len(ARGV)+2;
			if (argc) {
				argv = malloc(sizeof(char*)*argc);
				argv[0] = SvPV(ARGV0, na);
				for(i=0;i<=av_len(ARGV);i++)
					argv[i+1] = SvPV(*av_fetch(ARGV, i, 0), na);
			}
			
			i = argc;
			gdk_init(&argc, &argv);

			init_gdk = 1;
			
			while(argc<i--)
				av_shift(ARGV);
			
			if (argv)
				free(argv);
		}
	}

void
exit(Class, code)
	SV *	Class
	int	code
	CODE:
	gdk_exit(code);

int
events_pending(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_events_pending();
	OUTPUT:
	RETVAL

void
event_get(Class, predicate=0, ...)
	SV *	Class
	SV *	predicate
	PPCODE:
	{
		GdkEvent e;
		HV * hash;
		GV * stash;
		int i, dohandle=0;

		if (predicate && SvOK(predicate)) {
			AV * args = newAV();
			dohandle = 1;
			av_push(args, SvREFCNT_inc(predicate));
			for(i=1;i<items;i++)
				av_push(args, SvREFCNT_inc(ST(i)));
			av_push(event_handlers, newRV((SV*)args));
			SvREFCNT_dec(args);
		}

		if (gdk_event_get(&e, dohandle ? EventHandler : 0, (void*) (dohandle ? av_len(event_handlers) : 0))) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkEvent(&e)));
		} 

		if (dohandle)
			SvREFCNT_dec(av_pop(event_handlers));
	}

void
gdk_event_put(Class, event)
	SV *	Class
	SV *	event
	CODE:
	gdk_event_put(SvGtkGdkEvent(event, 0));

void
gdk_set_debug_level(Class, level)
	SV *	Class
	int	level
	CODE:
	gdk_set_debug_level(level);

void
gdk_set_show_events(Class, show_events)
	SV *	Class
	bool	show_events
	CODE:
	gdk_set_show_events(show_events);

void
gdk_set_use_xshm(Class, use_xshm)
	SV *	Class
	bool	use_xshm
	CODE:
	gdk_set_use_xshm(use_xshm);

int
gdk_get_debug_level(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_get_debug_level();
	OUTPUT:
	RETVAL

int
gdk_get_show_events(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_get_show_events();
	OUTPUT:
	RETVAL

int
gdk_get_use_xshm(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_get_use_xshm();
	OUTPUT:
	RETVAL


int
gdk_time_get(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_time_get();
	OUTPUT:
	RETVAL

int
gdk_timer_get(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_timer_get();
	OUTPUT:
	RETVAL


void
gdk_timer_set(Class, value)
	SV *	Class
	int value
	CODE:
	gdk_timer_set(value);


void
gdk_timer_enable(Class)
	SV *	Class
	CODE:
	gdk_timer_enable();

void
gdk_timer_disable(Class)
	SV *	Class
	CODE:
	gdk_timer_disable();

int
gdk_pointer_grab(Class, window, owner_events, event_mask, confine_to, cursor, time)
	SV *	Class
	Gtk::Gdk::Window	window
	int	owner_events
	Gtk::Gdk::EventMask	event_mask
	Gtk::Gdk::Window	confine_to
	Gtk::Gdk::Cursor	cursor
	int	time
	CODE:
	RETVAL = gdk_pointer_grab(window, owner_events, event_mask, confine_to, cursor, time);
	OUTPUT:
	RETVAL

void
gdk_pointer_ungrab(Class, value)
	SV *	Class
	int value
	CODE:
	gdk_pointer_ungrab(value);

int
gdk_keyboard_grab(window, owner_events, time)
	Gtk::Gdk::Window	window
	int	owner_events
	int	time

void
gdk_keyboard_ungrab(time)
	int	time

int
gdk_screen_width(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_screen_width();
	OUTPUT:
	RETVAL

int
gdk_screen_height(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_screen_height();
	OUTPUT:
	RETVAL

void
gdk_flush(Class)
	SV *	Class
	CODE:
	gdk_flush();

void
gdk_beep(Class)
	SV *	Class
	CODE:
	gdk_beep();

void
gdk_key_repeat_disable(Class)
	SV *	Class
	CODE:
	gdk_key_repeat_disable();

void
gdk_key_repeat_restore(Class)
	SV *	Class
	CODE:
	gdk_key_repeat_restore();


MODULE = Gtk		PACKAGE = Gtk::Gdk::Window

Gtk::Gdk::Window
new(Self, attr)
	SV *	Self
	SV *	attr
	CODE:
	{
		GdkWindow * parent = 0;
		GdkWindowAttr a;
		gint mask;
		if (Self && SvOK(Self) && SvRV(Self))
			parent = SvGtkGdkWindowRef(Self);

		SvGtkGdkWindowAttr(attr, &a, &mask);
		
		RETVAL = gdk_window_new(parent, &a, mask);
		if (!RETVAL)
			croak("gdk_window_new failed");
	}
	OUTPUT:
	RETVAL

void
gdk_window_destroy(window)
	Gtk::Gdk::Window	window

void
gdk_window_show(window)
	Gtk::Gdk::Window	window

void
gdk_window_hide(window)
	Gtk::Gdk::Window	window


void
gdk_window_move(window, x, y)
	Gtk::Gdk::Window	window
	int	x
	int	y


void
gdk_window_resize(window, width, height)
	Gtk::Gdk::Window	window
	int	width
	int	height


void
gdk_window_move_resize(window, x, y, width, height)
	Gtk::Gdk::Window	window
	int	x
	int	y
	int	width
	int	height

void
gdk_window_reparent(window, new_parent, x, y)
	Gtk::Gdk::Window	window
	Gtk::Gdk::Window	new_parent
	int	x
	int	y

void
gdk_window_clear(window)
	Gtk::Gdk::Window	window

void
gdk_window_clear_area(window, x, y, width, height)
	Gtk::Gdk::Window	window
	int	x
	int	y
	int	width
	int	height

void
gdk_window_raise(window)
	Gtk::Gdk::Window	window

void
gdk_window_lower(window)
	Gtk::Gdk::Window	window

void
gdk_window_set_hints(window, x, y, min_width, min_height, max_width, max_height, flags)
	Gtk::Gdk::Window	window
	int	x
	int	y
	int min_width
	int	min_height
	int	max_width
	int	max_height
	int	flags

void
gdk_window_set_title(window, title)
	Gtk::Gdk::Window	window
	char *	title

void
gdk_window_set_background(window, color)
	Gtk::Gdk::Window	window
	Gtk::Gdk::Color	color

void
gdk_window_set_back_pixmap(window, pixmap, parent_relative)
	Gtk::Gdk::Window	window
	Gtk::Gdk::Pixmap	pixmap
	int	parent_relative

void
gdk_window_get_geometry(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		int x,y,width,height,depth;
		gdk_window_get_geometry(window,&x,&y,&width,&height,&depth);
		if (GIMME != G_ARRAY)
			croak("must accept array");
		EXTEND(sp,5);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
		PUSHs(sv_2mortal(newSViv(width)));
		PUSHs(sv_2mortal(newSViv(height)));
		PUSHs(sv_2mortal(newSViv(depth)));
	}

void
gdk_window_get_position(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		int x,y;
		gdk_window_get_position(window,&x,&y);
		if (GIMME != G_ARRAY)
			croak("must accept array");
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gdk_window_get_size(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		int width,height;
		gdk_window_get_size(window,&width,&height);
		if (GIMME != G_ARRAY)
			croak("must accept array");
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSViv(height)));
		PUSHs(sv_2mortal(newSViv(width)));
	}

Gtk::Gdk::Visual
gdk_window_get_visual(window)
	Gtk::Gdk::Window	window

Gtk::Gdk::Colormap
gdk_window_get_colormap(window)
	Gtk::Gdk::Window	window

Gtk::Gdk::WindowType
gdk_window_get_type(window)
	Gtk::Gdk::Window	window

void
gdk_window_get_origin(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		int x,y;
		gdk_window_get_origin(window,&x,&y);
		if (GIMME != G_ARRAY)
			croak("must accept array");
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gdk_window_get_pointer(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		int x,y;
		GdkModifierType mask;
		GdkWindow * w = gdk_window_get_pointer(window,&x,&y,&mask);
		if (GIMME != G_ARRAY)
			croak("must accept array");
		EXTEND(sp,4);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
		PUSHs(sv_2mortal(newSVGtkGdkWindowRef(w)));
		PUSHs(sv_2mortal(newSVGtkGdkModifierType(mask)));
	}

void
gdk_window_set_cursor(Self, Cursor)
	Gtk::Gdk::Window	Self
	Gtk::Gdk::Cursor	Cursor

Gtk::Gdk::Window
gdk_window_get_parent(window)
	Gtk::Gdk::Window	window

Gtk::Gdk::Window
gdk_window_get_toplevel(window)
	Gtk::Gdk::Window	window

void
gdk_window_get_children(window)
	Gtk::Gdk::Window	window
	PPCODE:
	{
		GList * l = gdk_window_get_children(window);
		while(l) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkWindowRef((GdkWindow*)l->data)));
			l=l->next;
		}
	}


MODULE = Gtk		PACKAGE = Gtk::Gdk::Window	PREFIX = gdk_

void
gdk_draw_line(window, gc, x1, y1, x2, y2)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	int	x1
	int y1
	int	x2
	int	y2

void
gdk_draw_rectangle(window, gc, filled, x, y, width, height)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	bool	filled
	int	x
	int y
	int	width
	int	height

void
gdk_draw_arc(window, gc, filled, x, y, width, height, angle1, angle2)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	bool	filled
	int	x
	int y
	int	width
	int	height
	int	angle1
	int	angle2

void
gtk_draw_polygon(window, gc, filled, x, y, ...)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	bool filled
	int	x
	int	y
	CODE:
	{
		int npoints = (items-3)/2;
		GdkPoint * points = malloc(sizeof(GdkPoint)*npoints);
		int i,j;
		for(i=0,j=3;i<npoints;i++,j+=2) {
			points[i].x = SvIV(ST(j));
			points[i].y = SvIV(ST(j+1));
		}
		gdk_draw_polygon(window, gc, filled, points, npoints);
		free(points);
	}

void
gdk_draw_string(window, gc, x, y, string)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	int	x
	int y
	char *	string

void
gdk_draw_pixmap(window, gc, src, xsrc, ysrc, xdest, ydest, width, height)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Window	src
	int	xsrc
	int	ysrc
	int	xdest
	int	ydest
	int	width
	int	height

void
gdk_draw_image(window, gc, image, xsrc, ysrc, xdest, ydest, width, height)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Image	image
	int	xsrc
	int	ysrc
	int	xdest
	int	ydest
	int	width
	int	height

void
gtk_draw_points(window, gc, x, y, ...)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	int	x
	int	y
	CODE:
	{
		int npoints = (items-2)/2;
		GdkPoint * points = malloc(sizeof(GdkPoint)*npoints);
		int i,j;
		for(i=0,j=2;i<npoints;i++,j+=2) {
			points[i].x = SvIV(ST(j));
			points[i].y = SvIV(ST(j+1));
		}
		gdk_draw_points(window, gc, points, npoints);
		free(points);
	}

void
gtk_draw_segments(window, gc, x1, y1, x2, y2, ...)
	Gtk::Gdk::Window	window
	Gtk::Gdk::GC	gc
	int	x1
	int	y1
	int	x2
	int	y2
	CODE:
	{
		int npoints = (items-2)/4;
		GdkSegment * points = malloc(sizeof(GdkSegment)*npoints);
		int i,j;
		for(i=0,j=2;i<npoints;i++,j+=4) {
			points[i].x1 = SvIV(ST(j));
			points[i].y1 = SvIV(ST(j+1));
			points[i].x2 = SvIV(ST(j+2));
			points[i].y2 = SvIV(ST(j+3));
		}
		gdk_draw_segments(window, gc, points, npoints);
		free(points);
	}

void
DESTROY(self)
	Gtk::Gdk::Window	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Colormap	PREFIX = gdk_colormap_

Gtk::Gdk::Colormap
new(Class, visual, allocate)
	SV *	Class
	Gtk::Gdk::Visual	visual
	int	allocate
	CODE:
	RETVAL = gdk_colormap_new(visual, allocate);
	OUTPUT:
	RETVAL

Gtk::Gdk::Colormap
get_system(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_colormap_get_system();
	OUTPUT:
	RETVAL

int
get_system_size(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_colormap_get_system_size();
	OUTPUT:
	RETVAL

void
gdk_colormap_change(colormap, ncolors)
	Gtk::Gdk::Colormap	colormap
	int	ncolors


void
destroy(colormap)
	Gtk::Gdk::Colormap	colormap
	CODE:
	UnregisterMisc(SvRV(ST(0)),colormap);
	gdk_colormap_destroy(colormap);


void
DESTROY(self)
	Gtk::Gdk::Colormap	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

Gtk::Gdk::Color
color(colormap, idx)
	Gtk::Gdk::Colormap	colormap
	int	idx
	CODE:
	RETVAL = &colormap->colors[idx];
	OUTPUT:
	RETVAL

MODULE = Gtk		PACKAGE = Gtk::Gdk::Colormap	PREFIX = gdk_colors_

MODULE = Gtk		PACKAGE = Gtk::Gdk::Color

int
red(color, new_value=0)
	Gtk::Gdk::Color	color
	int	new_value
	CODE:
	RETVAL=color->red;
	if (items>1)	color->red = new_value;
	OUTPUT:
	RETVAL
		
int
green(color, new_value=0)
	Gtk::Gdk::Color	color
	int	new_value
	CODE:
	RETVAL=color->green;
	if (items>1)	color->green = new_value;
	OUTPUT:
	RETVAL

int
blue(color, new_value=0)
	Gtk::Gdk::Color	color
	int	new_value
	CODE:
	RETVAL=color->blue;
	if (items>1)	color->blue = new_value;
	OUTPUT:
	RETVAL

int
pixel(color, new_value=0)
	Gtk::Gdk::Color	color
	int	new_value
	CODE:
	RETVAL=color->pixel;
	if (items>1)	color->pixel = new_value;
	OUTPUT:
	RETVAL

void
DESTROY(self)
	Gtk::Gdk::Color	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Cursor

Gtk::Gdk::Cursor
new(Class, type)
	SV *	Class
	SV *	type
	CODE:
	RETVAL = gdk_cursor_new(SvGtkGdkCursorType(type));
	OUTPUT:
	RETVAL

void
destroy(self)
	Gtk::Gdk::Cursor	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);
	gdk_cursor_destroy(self);

void
DESTROY(self)
	Gtk::Gdk::Cursor	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Pixmap	PREFIX = gdk_pixmap_

Gtk::Gdk::Pixmap
new(Class, window, width, height, depth)
	SV *	Class
	Gtk::Gdk::Window	window
	int	width
	int	height
	int	depth
	CODE:
	RETVAL = gdk_pixmap_new(window, width, height, depth);
	OUTPUT:
	RETVAL

Gtk::Gdk::Pixmap
create_from_data(Class, window, data, width, height, depth, fg, bg)
	SV *	Class
	Gtk::Gdk::Window	window
	SV *	data
	int	width
	int	height
	int	depth
	Gtk::Gdk::Color	fg
	Gtk::Gdk::Color	bg
	CODE:
	RETVAL = gdk_pixmap_create_from_data(window, SvPV(data,na), width, height, depth, fg, bg);
	OUTPUT:
	RETVAL

void
create_from_xpm(Class, window, transparent_color, filename)
	SV *	Class
	Gtk::Gdk::Window	window
	Gtk::Gdk::Color	transparent_color
	char *	filename
	PPCODE:
	{
		GdkPixmap * result = 0;
		GdkBitmap * mask = 0;
		result = gdk_pixmap_create_from_xpm(window, (GIMME == G_ARRAY) ? &mask : 0,
			transparent_color, filename); 
		if (result) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkPixmapRef(result)));
		}
		if (mask) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkBitmapRef(mask)));
		}
	}

void
create_from_xpm_d(Class, window, transparent_color, data, ...)
	SV *	Class
	Gtk::Gdk::Window	window
	Gtk::Gdk::Color	transparent_color
	SV *	data
	PPCODE:
	{
		GdkPixmap * result = 0;
		GdkBitmap * mask = 0;
		char ** lines = (char**)malloc(sizeof(char*)*(items-3));
		int i;
		for(i=3;i<items;i++)
			lines[i-3] = SvPV(ST(i),na);
		result = gdk_pixmap_create_from_xpm_d(window, (GIMME == G_ARRAY) ? &mask : 0,
			transparent_color, lines); 
		if (result) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkPixmapRef(result)));
		}
		if (mask) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkBitmapRef(mask)));
		}
	}

void
destroy(pixmap)
	Gtk::Gdk::Pixmap	pixmap
	CODE:
	gdk_pixmap_destroy(pixmap);

void
DESTROY(self)
	Gtk::Gdk::Pixmap	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);
	gdk_pixmap_destroy(self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Image	PREFIX = gdk_image_

Gtk::Gdk::Image
new(Class, type, visual, width, height)
	SV *	Class
	Gtk::Gdk::ImageType	type
	Gtk::Gdk::Visual	visual
	int	width
	int	height
	CODE:
	RETVAL = gdk_image_new(type, visual, width, height);
	OUTPUT:
	RETVAL

Gtk::Gdk::Image
get(Class, window, x, y, width, height)
	SV *	Class
	Gtk::Gdk::Window	window
	int	x
	int	y
	int	width
	int	height
	CODE:
	RETVAL = gdk_image_get(window, x, y, width, height);
	OUTPUT:
	RETVAL

void
destroy(image)
	Gtk::Gdk::Image	image
	CODE:
	gdk_image_destroy(image);

void
gdk_image_put_pixel(image, x, y, pixel)
	Gtk::Gdk::Image	image
	int	x
	int	y
	int	pixel

int
gdk_image_get_pixel(image, x, y)
	Gtk::Gdk::Image	image
	int	x
	int	y

void
DESTROY(self)
	Gtk::Gdk::Pixmap	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Bitmap	PREFIX = gdk_bitmap_

Gtk::Gdk::Bitmap
create_from_data(Class, window, data, width, height)
	SV *	Class
	Gtk::Gdk::Window	window
	SV *	data
	int	width
	int	height
	CODE:
	RETVAL = gdk_bitmap_create_from_data(window, SvPV(data,na), width, height);
	OUTPUT:
	RETVAL

void
DESTROY(self)
	Gtk::Gdk::Pixmap	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);
	gdk_pixmap_destroy(self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::GC	PREFIX = gdk_gc_

Gtk::Gdk::GC
new(Class, window, values=0)
	SV *	Class
	Gtk::Gdk::Window	window
	SV *	values
	CODE:
	if (items>2) {
		GdkGCValuesMask m;
		GdkGCValues * v = SvGtkGdkGCValues(values, 0, &m);
		RETVAL = gdk_gc_new_with_values(window, v, m);
	}
	else
		RETVAL = gdk_gc_new(window);
	OUTPUT:
	RETVAL

Gtk::Gdk::GCValues
gdk_gc_get_values(self)
	Gtk::Gdk::GC	self
	CODE:
	{
		GdkGCValues values;
		gdk_gc_get_values(self, &values);
		RETVAL = &values;
	}

void
gdk_gc_set_foreground(gc, color)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Color	color

void
gdk_gc_set_background(gc, color)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Color	color

void
gdk_gc_set_font(gc, font)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Font	font

void
gdk_gc_set_function(gc, function)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Function	function

void
gdk_gc_set_fill(gc, fill)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Fill	fill

void
gdk_gc_set_tile(gc, tile)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Pixmap	tile

void
gdk_gc_set_stipple(gc, stipple)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Pixmap	stipple

void
gdk_gc_set_ts_origin(gc, x, y)
	Gtk::Gdk::GC	gc
	int	x
	int	y

void
gdk_gc_set_clip_origin(gc, x, y)
	Gtk::Gdk::GC	gc
	int	x
	int	y

void
gdk_gc_set_clip_mask(gc, mask)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::Bitmap	mask

void
gdk_gc_set_subwindow(gc, mode)
	Gtk::Gdk::GC	gc
	Gtk::Gdk::SubwindowMode	mode

void
gdk_gc_set_exposures(gc, exposures)
	Gtk::Gdk::GC	gc
	int	exposures

void
gdk_gc_set_line_attributes(gc, line_width, line_style, cap_style, join_style)
	Gtk::Gdk::GC	gc
	int	line_width
	Gtk::Gdk::LineStyle	line_style
	Gtk::Gdk::CapStyle	cap_style
	Gtk::Gdk::JoinStyle	join_style

void
destroy(self)
	Gtk::Gdk::GC	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);
	gdk_gc_destroy(self);

void
DESTROY(self)
	Gtk::Gdk::GC	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Visual

Gtk::Gdk::Visual
system(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_visual_get_system();
	OUTPUT:
	RETVAL

int
best_depth(Class)
	SV *	Class
	CODE:
	RETVAL = gdk_visual_get_best_depth();
	OUTPUT:
	RETVAL

SV *
best_type(Class)
	SV *	Class
	CODE:
	RETVAL = newSVGtkGdkVisualType(gdk_visual_get_best_type());
	OUTPUT:
	RETVAL

Gtk::Gdk::Visual
best(Class, depth=0, type=0)
	SV *	Class
	SV *	depth
	SV *	type
	CODE:
	{
		gint d;
		GdkVisualType t;

		if (depth && SvOK(depth))
			d = SvIV(depth);
		else
			depth = 0;

		if (type && SvOK(type))
			t = SvGtkGdkVisualType(type);
		else
			type = 0;

		if (type) 
			if (depth)
				RETVAL = gdk_visual_get_best_with_both(d, t);
			else
				RETVAL = gdk_visual_get_best_with_type(t);
		else
			if (depth)
				RETVAL = gdk_visual_get_best_with_depth(d);
			else
				RETVAL = gdk_visual_get_best();
	}
	OUTPUT:
	RETVAL

void
DESTROY(self)
	Gtk::Gdk::Visual	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

void
depths(Class)
	SV *	Class
	PPCODE:
	{
		gint *depths;
		gint count;
		int i;
		gdk_query_depths(&depths, &count);
		for(i=0;i<count;i++) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSViv(depths[i])));
		}
	}

void
visual_types(Class)
	SV *	Class
	PPCODE:
	{
		GdkVisualType *types;
		gint count;
		int i;
		gdk_query_visual_types(&types, &count);
		for(i=0;i<count;i++) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkVisualType(types[i])));
		}
	}

void
visuals(Class)
	SV *	Class
	PPCODE:
	{
		GdkVisual *visuals;
		gint count;
		int i;
		gdk_query_visuals(&visuals, &count);
		for(i=0;i<count;i++) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkVisualRef(&visuals[i])));
		}
	}

MODULE = Gtk		PACKAGE = Gtk::Gdk::Font	PREFIX = gdk_font_

Gtk::Gdk::Font
load(Class, font_name)
	SV *	Class
	char *	font_name
	CODE:
	RETVAL = gdk_font_load(font_name);
	OUTPUT:
	RETVAL

void
gdk_font_free(font)
	Gtk::Gdk::Font	font

int
gdk_font_id(font)
	Gtk::Gdk::Font	font

void
gdk_font_ref(font)
	Gtk::Gdk::Font	font

bool
gdk_font_equal(fonta, fontb)
	Gtk::Gdk::Font	fonta
	Gtk::Gdk::Font	fontb

MODULE = Gtk		PACKAGE = Gtk::Gdk::Property	PREFIX = gdk_property_

Gtk::Gdk::Atom
atom_intern(Class, atom_name, only_if_exists)
	SV *	Class
	char *	atom_name
	int	only_if_exists
	CODE:
	RETVAL = gdk_atom_intern(atom_name, only_if_exists);
	OUTPUT:
	RETVAL

void
gdk_property_get(Class, window, property, type, offset, length, pdelete)
	SV *	Class
	Gtk::Gdk::Window	window
	Gtk::Gdk::Atom	property
	Gtk::Gdk::Atom	type
	int	offset
	int	length
	int	pdelete
	PPCODE:
	{
		guchar * data;
		GdkAtom actual_type;
		int actual_format;
		int result = gdk_property_get(window, property, type, offset, length, pdelete, &actual_type, &actual_format, &data);
		if (result) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVpv(data,0)));
			if (GIMME == G_ARRAY) {
				EXTEND(sp,2);
				PUSHs(sv_2mortal(newSVGtkGdkAtom(actual_type)));
				PUSHs(sv_2mortal(newSViv(actual_format)));
			}
			g_free(data);
		}
	}

void
gdk_property_delete(Class, window, property)
	SV *	Class
	Gtk::Gdk::Window	window
	Gtk::Gdk::Atom	property
	CODE:
	gdk_property_delete(window, property);

MODULE = Gtk		PACKAGE = Gtk::Gdk::Rectangle	PREFIX = gdk_rectangle_

MODULE = Gtk		PACKAGE = Gtk::Gdk::Selection	PREFIX = gdk_selection_

int
gdk_selection_owner_set(Class, owner, selection, time, send_event)
	SV *	Class
	Gtk::Gdk::Window	owner
	Gtk::Gdk::Atom	selection
	int	time
	int	send_event
	CODE:
	RETVAL = gdk_selection_owner_set(owner, selection, time, send_event);
	OUTPUT:
	RETVAL

Gtk::Gdk::Window
gdk_selection_owner_get(Class, selection)
	SV *	Class
	Gtk::Gdk::Atom	selection
	CODE:
	RETVAL = gdk_selection_owner_get(selection);
	OUTPUT:
	RETVAL

Gtk::Gdk::Window
gdk_selection_convert(Class, requestor, selection, time)
	SV *	Class
	Gtk::Gdk::Window	requestor
	Gtk::Gdk::Atom	selection
	int	time
	CODE:
	gdk_selection_convert(requestor,selection,time);

void
gdk_selection_set(Class, requestor, selection, property, time, data)
	SV *	Class
	int	requestor
	Gtk::Gdk::Atom	selection
	Gtk::Gdk::Atom	property
	int	time
	SV *	data
	CODE:
	int len; SvPV(data,len);
	gdk_selection_set(requestor, selection, property, time, SvPV(data,na), len);

void
gdk_selection_get(Class, requestor)
	SV *	Class
	Gtk::Gdk::Window	requestor
	PPCODE:
	{
		guchar * data;
		gdk_selection_get(requestor,&data);
		if (data) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVpv(data,0)));
		}
	}

void
gdk_rectangle_intersect(Class, src1, src2)
	SV *	Class
	Gtk::Gdk::Rectangle	src1
	Gtk::Gdk::Rectangle	src2
	PPCODE:
	{
		GdkRectangle dest;
		int result = gdk_rectangle_intersect(src1,src2,&dest);
		if (result) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkGdkRectangle(&dest)));
		}
	}

MODULE = Gtk		PACKAGE = Gtk::Gdk::Font	PREFIX = gdk_

int
gdk_string_width(font, string)
	Gtk::Gdk::Font	font
	char *	string

int
gdk_text_width(font, text, text_length)
	Gtk::Gdk::Font	font
	char *	text
	int	text_length

int
gdk_char_width(font, character)
	Gtk::Gdk::Font	font
	int	character

int
gdk_string_measure(font, string)
	Gtk::Gdk::Font	font
	char *	string

int
gdk_text_measure(font, text, text_length)
	Gtk::Gdk::Font	font
	char *	text
	int	text_length

int
gdk_char_measure(font, character)
	Gtk::Gdk::Font	font
	int	character

int
ascent(font)
	Gtk::Gdk::Font	font
	CODE:
	RETVAL = font->ascent;
	OUTPUT:
	RETVAL

int
descent(font)
	Gtk::Gdk::Font	font
	CODE:
	RETVAL = font->descent;
	OUTPUT:
	RETVAL

void
DESTROY(self)
	Gtk::Gdk::Font	self
	CODE:
	UnregisterMisc(SvRV(ST(0)),self);

BOOT:
{
	event_handlers = newAV();
}