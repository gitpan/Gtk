#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   
#include <gtk/gtk.h>
#include "GdkTypes.h"
#include "MiscTypes.h"

static HV * ObjectCache = 0;

void UnregisterGtkObject(HV * hv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*sv_setiv(sv_object, 0);*/
	
	/*printf("Destroying %d from '%s'\n", hv_object, buffer);*/
	
	/*SvREFCNT(sv_object)+=2;*/
	hv_delete(ObjectCache, buffer, strlen(buffer), G_DISCARD);
	/*SvREFCNT(sv_object)--;*/
}

void RegisterGtkObject(HV * hv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*printf("Recording %d as '%s'\n", hv_object, buffer);*/

	hv_store(ObjectCache, buffer, strlen(buffer), newSViv((int)hv_object), 0);
}

HV * RetrieveGtkObject(GtkObject * gtk_object)
{
	char buffer[40];
	SV ** s;
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	s = hv_fetch(ObjectCache, buffer, strlen(buffer), 0);

	/*printf("Retrieving '%s' as %d\n", buffer, (s ? (int)*s : 0));*/

	if (s)
		return (HV*)SvIV(*s);
	else
		return 0;
}

extern AV * gtk_typecasts;

SV * newSVGtkObjectRef(GtkObject * object, char * classname)
{
	HV * previous = RetrieveGtkObject(object);
	SV * result;
	if (previous) {
		result = newRV((SV*)previous);
		/*printf("Returning previous ref %d as %d (%d)\n", object, previous, result);*/
		//SvREFCNT_dec(SvRV(result));
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
		sv_bless(result, gv_stashpv(classname, FALSE));
		SvREFCNT_dec(h);
		/*gtk_object_ref(object);*/
		/*printf("Returning new ref %d as %d\n", object, result);*/
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

void disconnect_GtkObjectRef(SV * o)
{
	HV * q;
	SV ** r;
	/*printf("Trying to delete GtkObject %d\n", o);*/
	if (!o || !SvOK(o) || !(q=(HV*)SvRV(o)) || (SvTYPE(q) != SVt_PVHV))
		return;
	r = hv_fetch(q, "_gtk", 4, 0);
	if (!r || !SvIV(*r))
		return;
	UnregisterGtkObject(q, (GtkObject*)SvIV(*r));
	hv_delete(q, "_gtk", 4, G_DISCARD);
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
	
	if (s=hv_fetch(h, "path", 4, 0))
		e->path = SvPV(*s,na);
	else
		croak("menu entry must contain path");
	if (s=hv_fetch(h, "accelerator", 11, 0))
		e->accelerator = SvPV(*s, na);
	else
		croak("menu entry must contain accelerator");
	if (s=hv_fetch(h, "widget", 6, 0))
		e->widget = GTK_WIDGET(SvGtkObjectRef(*s, "Gtk::Widget"));
	else
		croak("menu entry must contain widget");
	if (s=hv_fetch(h, "callback", 8, 0))
		e->callback_data = newSVsv(*s);
	else
		croak("menu entry must contain callback");

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
	
	hv_store(h, "path", 4, newSVpv(e->path,0), 0);
	hv_store(h, "accelerator", 11, newSVpv(e->accelerator,0), 0);
	hv_store(h, "widget", 6, newSVGtkObjectRef(GTK_OBJECT(e->widget), 0), 0);
	hv_store(h, "callback", 11, newSVsv(e->callback_data ? e->callback_data : &sv_undef), 0);
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
