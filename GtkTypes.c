#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997,1998, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   
#include <gtk/gtk.h>
#include "GdkTypes.h"
#include "MiscTypes.h"

static HV * ObjectCache = 0;

#define TRY_MM

void UnregisterGtkObject(HV * hv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*printf("Unregistering PO %x/%d from GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
	
	hv_delete(ObjectCache, buffer, strlen(buffer), G_DISCARD);
}

void RegisterGtkObject(HV * hv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*printf("Registering PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/

	hv_store(ObjectCache, buffer, strlen(buffer), newRV((SV*)hv_object), 0);
}

HV * RetrieveGtkObject(GtkObject * gtk_object)
{
	char buffer[40];
	SV ** s;
	HV * hv_object;
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	s = hv_fetch(ObjectCache, buffer, strlen(buffer), 0);
	
	if (s) {
		hv_object = (HV*)SvRV(*s);
		/*printf("Retrieving PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
		return hv_object;
	} else
		return 0;

}

/* Check a single PO to see whether it should be garbage collected */
int GCHVObject(HV * hv_object) {
	SV ** found;
	GtkObject * gtk_object;
	found = hv_fetch(hv_object, "_gtk", 4, 0);
	if (!found || !SvOK(*found))
		return 0;
	gtk_object = (GtkObject*)SvIV(*found);

	/*printf("Checking PO %x/%d vs GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
	if ((gtk_object->ref_count == 1) && (SvREFCNT(hv_object) == 1)) {
		/*printf("Derefing PO in GC\n");*/
		UnregisterGtkObject(hv_object, gtk_object);
		return 1;
	}
	return 0;

} 

/* Check all objects to see whether they should be collected */
int GCGtkObjects(void) {
  if (ObjectCache)
    {
      int count = 0;
      int dead = 0;
      HE *iter;
      /*printf("Starting GC\n");*/
      hv_iterinit (ObjectCache);
      while ((iter = hv_iternext (ObjectCache)))
        {
          SV * o = HeVAL(iter);
          HV * hv_object;
          SV ** found;
          GtkObject * gtk_object;
          
	if (!o || !SvOK(o) || !(hv_object=(HV*)SvRV(o)) || (SvTYPE(hv_object) != SVt_PVHV))
		continue;
	if (GCHVObject(hv_object))
		dead++;

          count++;
        }
            /*fprintf(stderr, "GC done, Count: %d; Dead %d\n", count, dead); */
	    return dead;
    }
    return 0;
}

extern AV * gtk_typecasts;

int gc_during_idle = 0;

static void GCDuringIdle(void);

static int IdleGC(gpointer data) {
	HV * hv_object = data;
	
	/*printf("IdleGC PO %p\n", hv_object);*/
	
	if (data) {
	
		/* If we are GCing a specific object, stop all GC if we
		   can't clean it up, so we don't loop forever. */
		   
		if (GCHVObject(hv_object))
			gc_during_idle = gtk_idle_add(IdleGC, 0);
		else
			gc_during_idle = 0;
		return 0;
	}
	
	/* If we can free up some objects, this will return non-zero,
	   causing the idle function to be repeated. This will cause the GC
	   to be repeated until no more objects can be freed */
	   
	if (GCGtkObjects())
		return 1;

	gc_during_idle = 0;
	return 0;
}

static int TimeoutGC(gpointer data) {

	/* GC, and if we collected anything, loop during idle to unravel
	   everything */
	
	if (GCGtkObjects())
		GCDuringIdle();
	
	return 1;
}


static void GCDuringIdle(void) {
#ifdef TRY_MM
	if (!gc_during_idle)
		gc_during_idle = gtk_idle_add(IdleGC, 0);
#endif
}

static void GCAfterTimeout(void) {
	static int gc_after_timeout=0;
#ifdef TRY_MM
	if (!gc_after_timeout)
		gc_after_timeout = gtk_timeout_add(9237, TimeoutGC, 0);
#endif
}

static void DestroyGtkObject(GtkObject * gtk_object, gpointer data)
{
#ifdef TRY_MM
	HV * hv_object = (HV*)data;
	
	/*printf("DestroyGtkObject (1) called on PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
	
	GCHVObject(hv_object);
	
	GCDuringIdle();

	/*printf("DestroyGtkObject (2) called on PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
#endif	
}

/* Called when a GTK object is being free'd. Free up its Perl object, if it
   hasn't been already. */

static void FreeGtkObject(gpointer data)
{
#ifdef TRY_MM
	HV * hv_object = (HV*)data;
	SV ** r;
	GCDuringIdle();
	/*printf("FreeGtkObject of (PO %p/%d) ", hv_object, SvREFCNT(hv_object));*/
	r = hv_fetch(hv_object, "_gtk", 4, 0);
	if (r && SvIV(*r)) {
		GtkObject * gtk_object = (GtkObject*)SvIV(*r);
		/*printf("GO %p/%d\n", gtk_object, gtk_object->ref_count);*/
		
		if (gtk_object_get_data(gtk_object,"_perl")) {
			/*printf("Unrefing PO %p/%d\n", hv_object, SvREFCNT(hv_object));*/
			gtk_object_remove_data(gtk_object, "_perl");
			UnregisterGtkObject(hv_object, gtk_object);
		} /*else
			printf("PO already unlinked\n");*/
		
	}/* else
		printf("No GO\n");*/
#endif
}

/* Called when a Perl object is being free'd. Free up its GTK object, if it
   hasn't been already. */

void FreeHVObject(HV * hv_object)
{
#ifdef TRY_MM
	SV ** r;
	r = hv_fetch(hv_object, "_gtk", 4, 0);
	GCDuringIdle();
	/*printf("FreeHVObject of PO %p/%d\n", hv_object, SvREFCNT(hv_object));*/
	if (r && SvIV(*r)) {
		GtkObject * gtk_object = (GtkObject*)SvIV(*r);
		hv_delete(hv_object, "_gtk", 4, G_DISCARD);
		
		if (gtk_object_get_data(gtk_object, "_perl")) {
			/*printf("Unrefing GO %p/%d\n", gtk_object, gtk_object->ref_count);*/
			gtk_object_unref(gtk_object);
			return;
		}
	}
	/*printf("Skipping FreeHVObject, as Gtk object is already free'd\n");*/
#endif
}


SV * newSVGtkObjectRef(GtkObject * object, char * classname)
{
	HV * previous;
	SV * result;
	if (!object)
		return newSVsv(&sv_undef);
	previous = RetrieveGtkObject(object);
	if (previous) {
		result = newRV((SV*)previous);
		/*printf("Returning previous PO %p, referencing GO %p\n", previous, object);*/
	} else {
		HV * h;
		SV * s;
		if (!classname) {
			SV ** k;
			k = av_fetch(gtk_typecasts, object->klass->type, 0);
			if (!k)
				croak("unknown Gtk type");
			classname = SvPV(*k, na);
		}
		h = newHV();
		s = newSViv((int)object);
		hv_store(h, "_gtk", 4, s, 0);
		result = newRV((SV*)h);
		RegisterGtkObject(h, object);
		gtk_object_ref(object);
		gtk_signal_connect(object, "destroy", (GtkSignalFunc)DestroyGtkObject, (gpointer)h);
		gtk_object_set_data_full(object, "_perl", h, FreeGtkObject);
		sv_bless(result, gv_stashpv(classname, FALSE));
		SvREFCNT_dec(h);
		GCAfterTimeout();
		/*printf("Creating new PO %p/%d referencing GO %p/%d\n", h, SvREFCNT(h), object, object->ref_count);*/
	}
	return result;
}

GtkObject * SvGtkObjectRef(SV * o, char * name)
{
	HV * q;
	SV ** r;
	if (!o || !SvOK(o) || !(q=(HV*)SvRV(o)) || (SvTYPE(q) != SVt_PVHV))
		return 0;
	if (name && !sv_derived_from(o, name))
		croak("variable is not of type %s", name);
	r = hv_fetch(q, "_gtk", 4, 0);
	if (!r || !SvIV(*r))
		croak("variable is damaged %s", name);
	return (GtkObject*)SvIV(*r);
}

static void menu_callback (GtkWidget *widget, gpointer user_data)
{
	SV * handler = (SV*)user_data;
	int i;
	dSP;

	PUSHMARK(sp);
	
	if (SvRV(handler) && (SvTYPE(SvRV(handler)) == SVt_PVAV)) {
		AV * args = (AV*)SvRV(handler);
		handler = *av_fetch(args, 0, 0);
		for(i=1;i<=av_len(args);i++)
			XPUSHs(sv_2mortal(newSVsv(*av_fetch(args,i,0))));
	}

	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(widget), 0)));
	PUTBACK;

	i = perl_call_sv(handler, G_DISCARD);
}

GtkMenuEntry * SvGtkMenuEntry(SV * data, GtkMenuEntry * e)
{
	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
	
	if (!e)
		e = alloc_temp(sizeof(GtkMenuEntry));

	h = (HV*)SvRV(data);
	
	if ((s=hv_fetch(h, "path", 4, 0)) && SvOK(*s))
		e->path = SvPV(*s,na);
	else
		e->path = 0;
		/*croak("menu entry must contain path");*/
	if ((s=hv_fetch(h, "accelerator", 11, 0)) && SvOK(*s))
		e->accelerator = SvPV(*s, na);
	else
		e->accelerator = 0;
		/*croak("menu entry must contain accelerator");*/
	if ((s=hv_fetch(h, "widget", 6, 0)) && SvOK(*s))
		e->widget =  (s && SvOK(*s)) ? GTK_WIDGET(SvGtkObjectRef(*s, "Gtk::Widget")) : NULL;
	else
		e->widget = 0;
		/*croak("menu entry must contain widget");*/
	if ((s=hv_fetch(h, "callback", 8, 0)) && SvOK(*s)) {
		e->callback = menu_callback;
		e->callback_data = newSVsv(*s);
	}
	else {
		e->callback = 0;
		e->callback_data = 0;
		/*croak("menu entry must contain callback");*/
	}

	return e;
}

SV * newSVGtkMenuEntry(GtkMenuEntry * e)
{
	HV * h;
	SV * r;
	
	if (!e)
		return &sv_undef;
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "path", 4, e->path ? newSVpv(e->path,0) : newSVsv(&sv_undef), 0);
	hv_store(h, "accelerator", 11, e->accelerator ? newSVpv(e->accelerator,0) : newSVsv(&sv_undef), 0);
	hv_store(h, "widget", 6, e->widget ? newSVGtkObjectRef(GTK_OBJECT(e->widget), 0) : newSVsv(&sv_undef), 0);
	hv_store(h, "callback", 11, 
		((e->callback == menu_callback) && e->callback_data) ?
		newSVsv(e->callback_data) :
		newSVsv(&sv_undef)
		, 0);
	
	return r;
}

GtkRequisition * SvGtkRequisition(SV * data, GtkRequisition * e)
{
	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
	
	if (!e)
		e = alloc_temp(sizeof(GtkRequisition));

	h = (HV*)SvRV(data);
	
	if ((s=hv_fetch(h, "width", 5, 0)) && SvOK(*s))
		e->width = SvIV(*s);
	else
		croak("requisition must contain x");
	if ((s=hv_fetch(h, "height", 6, 0)) && SvOK(*s))
		e->height = SvIV(*s);
	else
		croak("requisition must contain x");

	return e;
}

SV * newSVGtkRequisition(GtkRequisition * e)
{
	HV * h;
	SV * r;
	
	if (!e)
		return &sv_undef;
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "width", 5, e->width, 0);
	hv_store(h, "height", 6, e->height, 0);
	
	return r;
}

SV * newSVGtkSelectionDataRef(GdkWindow * w) { return newSVMiscRef(w, "Gtk::SelectionData",0); }
GdkWindow * SvGtkSelectionDataRef(SV * data) { return SvMiscRef(data, "Gtk::SelectionData"); }


/*SV * newSVGtkMenuPath(GtkMenuPath * e)
{
	HV * h;
	SV * r;
	
	if (!e)
		return &sv_undef;
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "path", 4, newSVpv(e->path), 0);
	hv_store(h, "widget", 6, newSVGtkObjectRef(e->widget, 0), 0);
	return r;
}
*/

void FindArgumentType(GtkObject * object, SV * name, GtkArg * result) {
	char * argname = SvPV(name, na);
	GtkType t;

	/* Strip the ticklish dash */
	if (argname[0] == '-')
		argname++;

	/* Convert Perl naming convention to Gtk style */
	if (strncmp(argname, "Gtk::", 5) == 0) {
		SV * work = sv_2mortal(newSVpv("Gtk", 3)); 
		sv_catpv(work, argname+5);
		argname = SvPV(work, na);
	}
	
	/* Fix something that's hard to deal with, otherwise */
	if (strncmp(argname, "signal::", 8) ==0) {
		SV * work = sv_2mortal(newSVpv("GtkObject::", 11)); 
		sv_catpv(work, argname);
		argname = SvPV(work, na);
	}
	
	if (!strchr(argname, ':') || ((t = gtk_object_get_arg_type(argname)) == GTK_TYPE_INVALID)) {
		SV * work = sv_2mortal(newSVsv(&sv_undef)); 
		GtkType pt;
		/* Try appending the arg name to the class name */
		for(pt = object->klass->type;pt;pt = gtk_type_parent(pt)) {
			sv_setpv(work, gtk_type_name(pt));
			sv_catpv(work, "::");
			sv_catpv(work, argname);
			if ((t = gtk_object_get_arg_type(SvPV(work, na))) != GTK_TYPE_INVALID) {
				argname = SvPV(work, na);
				break;
			}
			/* And if that didn't work, try the parent class */
		}
	}
	
	
	if (t == GTK_TYPE_INVALID) {
		SV * work = sv_2mortal(newSVpv("GtkObject::signal::", 0));
		/* Last resort, try it as a signal name */
		sv_catpv(work, argname);
		argname = SvPV(work, na);
		t = gtk_object_get_arg_type(argname);
	}
	
	if (t == GTK_TYPE_INVALID)
		croak("Unknown argument %s", argname);
	
	result->name = argname;
	result->type = t;
}
