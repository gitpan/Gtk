
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

void destroy_handler(gpointer data);
void generic_handler(GtkObject * object, gpointer data, guint n_args, GtkArg * args);
void generic_handler_wo(GtkObject * object, gpointer data, guint n_args, GtkArg * args);


static void generic_perl_gtk_signal_marshaller(GtkObject * object, GtkSignalFunc func, gpointer func_data, GtkArg * args)
{
	croak("Unable to marshal C signals from Gtk class defined in Perl");
}

static void generic_perl_gtk_class_init(GtkObjectClass * klass)
{
	dSP;
	SV * perlClass;
	SV ** s = av_fetch(gtk_typecasts, klass->type, 0);

	if (s)
		perlClass = *s;
	else {
		fprintf(stderr, "Class is not registered\n");
		return;
	}
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVsv(perlClass)));
	PUTBACK;
	perl_call_method("class_init", G_DISCARD);

}

static void generic_perl_gtk_object_init(GtkObject * object)
{
	SV * s = newSVGtkObjectRef(object, 0);
	dSP;

	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(s));
	PUTBACK;
	perl_call_method("init", G_DISCARD);
	
}

static void generic_perl_gtk_arg_get_func(GtkObject * object, GtkArg * arg, guint arg_id)
{
	SV * s = newSVGtkObjectRef(object, 0);
	int count;
	dSP;

	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(s));
	XPUSHs(sv_2mortal(newSVpv(arg->name,0)));
	XPUSHs(sv_2mortal(newSViv(arg_id)));
	PUTBACK;
	count = perl_call_method("get_arg", G_SCALAR); 
	SPAGAIN;
	if (count != 1)
		croak("Big trouble\n");
	
	GtkSetArg(arg, POPs, s, object);
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
}

static void generic_perl_gtk_arg_set_func(GtkObject * object, GtkArg * arg, guint arg_id)
{
	SV * s = newSVGtkObjectRef(object, 0);
	dSP;

	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(s));
	XPUSHs(sv_2mortal(newSVpv(arg->name,0)));	
	XPUSHs(sv_2mortal(newSViv(arg_id)));
	XPUSHs(sv_2mortal(GtkGetArg(arg)));
	PUTBACK;
	perl_call_method("set_arg", G_DISCARD); 
	/* Errors are OK ! */
	
}


MODULE = Gtk::Object		PACKAGE = Gtk::Object		PREFIX = gtk_object_

#ifdef GTK_OBJECT

int
signal_connect(self, event, handler, ...)
	Gtk::Object	self
	char *	event
	SV *	handler
	ALIAS:
		signal_connect = 0
		signal_connect_after = 1
	CODE:
	{
		AV * args;
		SV * arg;
		SV ** fixup;
		int i,j;
		int type;
		/*char num[20];
		void * fixupfunc = 0;*/
		args = newAV();
		
		type = gtk_signal_lookup(event, self->klass->type);
		
		/*sprintf(num, "%d", type);

		if (fixup = hv_fetch(signal_fixups, num, strlen(num), 0)) {
			fixupfunc = (void*)SvIV(*fixup);
		}*/
		
		if (!ix)
			i = gtk_signal_connect (GTK_OBJECT (self), event,
				NULL, (void*)args);
		else
			i = gtk_signal_connect_after (GTK_OBJECT (self), event,
				NULL, (void*)args);
		
		/*i = gtk_signal_connect_interp(self, event, func, (gpointer)args, destroy_handler, ix);*/
				
		av_push(args, newRV(SvRV(ST(0))));
		/*av_push(args, newSViv(fixupfunc));*/
		av_push(args, newSVsv(ST(1)));
		av_push(args, newSViv(type));
		
		PackCallbackST(args, 2);
		
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

char *
type_name(self)
	Gtk::Object	self
	CODE:
	RETVAL = gtk_type_name(GTK_OBJECT_TYPE(self));
	OUTPUT:
	RETVAL

SV *
get_user_data(object)
	Gtk::Object	object
	CODE:
	{
		int type = (int)gtk_object_get_data(object, "user_data_type_Perl");
		gpointer data = gtk_object_get_user_data(object);
		if (!data)
			RETVAL = newSVsv(&sv_undef);
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

Gtk::Object_Sink_Up
new_from_pointer(klass, pointer)
	SV *	klass
	unsigned long	pointer
	CODE:
	RETVAL = (GtkObject*)pointer;
	OUTPUT:
	RETVAL


unsigned long
_return_pointer(self)
	Gtk::Object	self
	CODE:
	RETVAL = (unsigned long)self;
	OUTPUT:
	RETVAL

void
DESTROY(self)
	SV *	self
	CODE:
	FreeHVObject((HV*)SvRV(ST(0)));

void
set(self, name, value, ...)
	Gtk::Object	self
	SV *	name
	SV *	value
	CODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		
		for(p=1;p<items;) {
		
			if ((p+1)>=items)
				croak("too few arguments");
				
			FindArgumentType(self, ST(p), &argv[0]);

			value = ST(p+1);
		
			argc = 1;
			
			GtkSetArg(&argv[0], value, ST(0), self);

			gtk_object_setv(self, argc, argv);
			p += 1 + argc;
		}
	}


void
get(self, name, ...)
	Gtk::Object	self
	SV *	name
	PPCODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		
		for(p=1;p<items;) {
		
			FindArgumentType(self, ST(p), &argv[0]);
		
			argc = 1;
			t=argv[0].type;
			
			gtk_object_getv(self, argc, argv);
			
			EXTEND(sp,1);
			PUSHs(sv_2mortal(GtkGetArg(&argv[0])));
			
			
			if (t == GTK_TYPE_STRING)
				g_free(GTK_VALUE_STRING(argv[0]));
			
			p++;
		}
	}

SV *
new(klass, ...)
	SV *	klass
	CODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		
		int type = type_name(SvPV(klass, na));
		
		GtkObject *	object = gtk_object_new(type, NULL);
		
		RETVAL = newSVGtkObjectRef(object, SvPV(klass, na));
		
		gtk_object_sink(object);
		
		for(p=1;p<items;) {
			char * argname;
		
			if ((p+1)>=items)
				croak("too few arguments");
			
			argname = SvPV(ST(p), na);
			
			FindArgumentType(object, ST(p), &argv[0]);

			argc = 1;
			
			GtkSetArg(&argv[0], ST(p+1), RETVAL, object);

			gtk_object_setv(object, argc, argv);
			p += 1 + argc;
		}
	}
	OUTPUT:
	RETVAL

void
add_arg_type(Class, name, type, flags, num=1)
	SV *	Class
	SV *	name
	char *	type
	int     flags
	int	num
	CODE:
	{
		SV * name2 = name;
		int typeval;
		char * typename = gtk_type_name(type_name(SvPV(Class,na)));
		if (strncmp(SvPV(name2,na), typename, strlen(typename)) != 0) {
			/* Not prefixed with typename */
			name2 = sv_2mortal(newSVpv(typename, 0));
			sv_catpv(name2, "::");
			sv_catsv(name2, name);
		}
		if (!(typeval = type_name(type))) {
			typeval = gtk_type_from_name(type);
		}
		gtk_object_add_arg_type(SvPV(name2,na), typeval, flags, num);
	}

#ifndef GTK_HAVE_SIGNAL_EMIT

void
signal_emit(self, name)
	Gtk::Object	self
	SV *	name
	ALIAS:
		signal_emit_by_name = 0
	CODE:
	{
		gtk_signal_emit_by_name(self, SvPV(name,na), NULL);
	}

#else

void
signal_emit(self, name, ...)
	Gtk::Object	self
	char *	name
	ALIAS:
		signal_emit_by_name = 0
	PPCODE:
	{
		GtkArg * args;
		guint sig = gtk_signal_lookup(name, self->klass->type);
		GtkSignalQuery * q;
		unsigned long retval;
		int params;
		int i,j;
		
		if (sig<1) {
			croak("Unknown signal %s in %s widget", name, gtk_type_name(self->klass->type));
		}
		
		q = gtk_signal_query(sig);
		
		if ((items-2) != q->nparams) {
			croak("Incorrect number of arguments for emission of signal %s in class %s, needed %d but got %d",
				name, gtk_type_name(self->klass->type), q->nparams, items-2);
		}
		
		params = q->nparams;
		
		args = calloc(params+1, sizeof(GtkArg));
		
		for(i=0,j=2;(i<params) && (j<items);i++,j++) {
			args[i].type = q->params[i];
			GtkSetArg(args+i, ST(j), 0, self);
		}
		args[params].type = q->return_val;
		GTK_VALUE_POINTER(args[params]) = &retval;
		
		g_free(q);
		
		gtk_signal_emitv(self, sig, args);
		
		EXTEND(sp,1);
		PUSHs(sv_2mortal(GtkGetRetArg(args + params)));
		
		free(args);
	}

int
signal_n_emissions(self, name)
	Gtk::Object self
	char *	name
	CODE:
	RETVAL = gtk_signal_n_emissions_by_name(self, name);
	OUTPUT:
	RETVAL

#endif

void
signal_emit_stop(self, name)
	Gtk::Object	self
	SV *	name
	ALIAS:
		signal_emit_stop_by_name = 0
	CODE:
	{
		gtk_signal_emit_stop_by_name(self, SvPV(name,na));
	}
	

int
register_type(perlClass, ...)
	SV *	perlClass
	CODE:
	{
		dSP;
		int count;
		int signals;
		int parent_type;
		int i;
		long offset;
		GtkTypeInfo info;
		SV * temp;
		SV * s;
		SV *	gtkName = 0;
		SV *	parentClass = 0;
		
		if (!gtkName) {
			int i;
			char *d, *s;
			gtkName = sv_2mortal(newSVsv(perlClass));
			d = s = SvPV(gtkName,na);
			do {
				if (*s == ':')
					continue;
				*d++ = *s;
			} while(*s++);
		}
		
		if (!parentClass) {
			parentClass = perlClass;
		}
		
		info.type_name = SvPV(newSVsv(gtkName), na); /* Yes, this leaks until interpreter cleanup */
		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("get_object_type", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		parent_type = POPi;
		
		PUTBACK;
		FREETMPS;
		LEAVE;

		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("get_object_size", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		info.object_size = POPi+sizeof(SV*);

		PUTBACK;
		FREETMPS;
		LEAVE;
		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("get_class_size", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		info.class_size = POPi;
		
		PUTBACK;
		FREETMPS;
		LEAVE;




		temp = newSVsv(perlClass);
		sv_catpv(temp, "::_signals");
		
		s = perl_get_sv(SvPV(temp, na), TRUE);
		sv_setiv(s, signals);
		
		sv_setsv(temp, perlClass);
		sv_catpv(temp, "::_signal");
		
		s = perl_get_sv(SvPV(temp, na), TRUE);
		sv_setiv(s, 0);

		sv_setsv(temp, perlClass);
		sv_catpv(temp, "::_signalbase");
		
		s = perl_get_sv(SvPV(temp, na), TRUE);
		sv_setiv(s, info.class_size);
		
		SvREFCNT_dec(temp);

		signals = (items - 1) / 2;

		offset = info.class_size;

		info.class_size += sizeof(GtkSignalFunc) * signals;
		
		info.class_init_func = (GtkClassInitFunc)generic_perl_gtk_class_init;
		info.object_init_func = (GtkObjectInitFunc)generic_perl_gtk_object_init;
		info.arg_set_func = (GtkArgSetFunc)generic_perl_gtk_arg_set_func;
		info.arg_get_func = (GtkArgSetFunc)generic_perl_gtk_arg_get_func;

		RETVAL = gtk_type_unique(parent_type, &info);
		
		add_typecast(RETVAL, SvPV(perlClass,na));
		
		
		for (i=1;i<items-1;i+=2) {
			char * name = SvPV(ST(i), na);
			AV * args = (AV*)SvRV(ST(i+1));
			GtkSignalRunType run_type = SvGtkSignalRunType(*av_fetch(args, 0, 0));
			int params = av_len(args);
			GtkType * types = (GtkType*)malloc(params * sizeof(GtkType));
			int j;
			
			for(j=1;j<=params;j++) {
				types[j-1] = gtk_type_from_name(SvPV(*av_fetch(args, j, 0), na));
			}
			
			/*printf("new signal '%s' has a return type of %s, and takes %d arguments\n",
				name, gtk_type_name(types[0]), params-1);*/
			
			gtk_signal_newv(name, run_type, RETVAL, offset, generic_perl_gtk_signal_marshaller, types[0], params - 1, (params>1) ? types+1 : 0);
			/*gtk_signal_newv("bloop", GTK_RUN_FIRST, RETVAL, offset, generic_perl_gtk_signal_marshaller, GTK_TYPE_INT, 0, 0);*/
			
			offset += sizeof(GtkSignalFunc);
		}
		
	}
	OUTPUT:
	RETVAL


void
destroy(self)
	Gtk::Object	self
	CODE:
	gtk_object_destroy(self);

void
gtk_object_ref(self)
	Gtk::Object	self

void
gtk_object_unref(self)
	Gtk::Object	self

bool
gtk_object_destroyed(self)
	Gtk::Object	self
	CODE:
	RETVAL = GTK_OBJECT_DESTROYED(self);
	OUTPUT:
	RETVAL

bool
gtk_object_floating(self)
	Gtk::Object	self
	CODE:
	RETVAL = GTK_OBJECT_FLOATING(self);
	OUTPUT:
	RETVAL

bool
gtk_object_connected(self)
	Gtk::Object	self
	CODE:
	RETVAL = GTK_OBJECT_CONNECTED(self);
	OUTPUT:
	RETVAL

#endif
