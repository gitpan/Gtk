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

#if 0
static struct opts shadow_types[] = {
	{ GTK_SHADOW_NONE,	"NONE" },
	{ GTK_SHADOW_IN,	"IN" },
	{ GTK_SHADOW_OUT,	"OUT" },
	{ GTK_SHADOW_ETCHED_IN,	"ETCHED_IN" },
	{ GTK_SHADOW_ETCHED_OUT,"ETCHED_OUT"},
	{0,0}	
};

int SvGtkShadowType(SV * value) { return SvOpt(value, "GtkShadowType", shadow_types); }
SV * newSVGtkShadowType(int value) { return newSVOpt(value, "GtkShadowType", shadow_types); }

static struct opts selection_modes[] = {
	{GTK_SELECTION_SINGLE,	"SINGLE"},
	{GTK_SELECTION_BROWSE,	"BROWSE"},
	{GTK_SELECTION_MULTIPLE,"MULTIPLE"},
	{GTK_SELECTION_EXTENDED,"EXTENDED"},
       	{0,0}	
};

int SvGtkSelectionMode(SV * value) { return SvOpt(value, "GtkSelectionMode", selection_modes); }
SV * newSVGtkSelectionMode(int value) { return newSVOpt(value, "GtkSelectionMode", selection_modes); }


static struct opts submenu_placements[] = {
	{GTK_TOP_BOTTOM,	"TOP_BOTTOM"},
	{GTK_LEFT_RIGHT,	"LEFT_RIGHT"},
       	{0,0}	
};

int SvGtkSubmenuPlacement(SV * value) { return SvOpt(value, "GtkSubmenuPlacement", submenu_placements); }
SV * newSVGtkSubmenuPlacement(int value) { return newSVOpt(value, "GtkSubmenuPlacement", submenu_placements); }

static struct opts curve_types[] = {
	{GTK_CURVE_TYPE_LINEAR,	"LINEAR"},
	{GTK_CURVE_TYPE_SPLINE,	"SPLINE"},
	{GTK_CURVE_TYPE_FREE,	"FREE"},
       	{0,0}	
};

int SvGtkCurveType(SV * value) { return SvOpt(value, "GtkCurveType", curve_types); }
SV * newSVGtkCurveType(int value) { return newSVOpt(value, "GtkCurveType", curve_types); }

static struct opts position_types[] = {
	{GTK_POS_LEFT,	"LEFT"},
	{GTK_POS_RIGHT,	"RIGHT"},
	{GTK_POS_TOP,	"TOP"},
	{GTK_POS_BOTTOM,"BOTTOM"},
       	{0,0}	
};

int SvGtkPositionType(SV * value) { return SvOpt(value, "GtkPositionType", position_types); }
SV * newSVGtkPositionType(int value) { return newSVOpt(value, "GtkPositionType", position_types); }

static struct opts metric_types[] = {
	{GTK_PIXELS,		"PIXELS"},
	{GTK_INCHES,		"INCHES"},
	{GTK_CENTIMETERS,	"CENTIMETERS"},
       	{0,0}	
};

int SvGtkMetricType(SV * value) { return SvOpt(value, "GtkMetricType", metric_types); }
SV * newSVGtkMetricType(int value) { return newSVOpt(value, "GtkMetricType", metric_types); }

static struct opts policy_types[] = {
	{GTK_POLICY_ALWAYS,	"ALWAYS"},
	{GTK_POLICY_AUTOMATIC,	"AUTOMATIC"},
       	{0,0}	
};

int SvGtkPolicyType(SV * value) { return SvOpt(value, "GtkPolicyType", policy_types); }
SV * newSVGtkPolicyType(int value) { return newSVOpt(value, "GtkPolicyType", policy_types); }

static struct opts state_types[] = {
	{GTK_STATE_NORMAL,	"NORMAL"},
	{GTK_STATE_ACTIVE,	"ACTIVE"},
	{GTK_STATE_PRELIGHT,	"PRELIGHT"},
	{GTK_STATE_SELECTED,	"SELECTED"},
	{GTK_STATE_INSENSITIVE,	"INSENSITIVE"},
       	{0,0}	
};

int SvGtkStateType(SV * value) { return SvOpt(value, "GtkStateType", state_types); }
SV * newSVGtkStateType(int value) { return newSVOpt(value, "GtkStateType", state_types); }

static struct opts update_types[] = {
	{GTK_UPDATE_CONTINUOUS,		"CONTINUOUS"},
	{GTK_UPDATE_DISCONTINUOUS,	"DISCONTINUOUS"},
	{GTK_UPDATE_DELAYED,		"DELAYED"},
       	{0,0}	
};

int SvGtkUpdateType(SV * value) { return SvOpt(value, "GtkUpdateType", update_types); }
SV * newSVGtkUpdateType(int value) { return newSVOpt(value, "GtkUpdateType", update_types); }


static struct opts window_positions[] = {
	{GTK_WIN_POS_NONE,	"NONE"},
	{GTK_WIN_POS_CENTER,	"CENTER"},
	{GTK_WIN_POS_MOUSE,	"MOUSE"},
       	{0,0}	
};

int SvGtkWindowPosition(SV * value) { return SvOpt(value, "GtkWindowPosition", window_positions); }
SV * newSVGtkWindowPosition(int value) { return newSVOpt(value, "GtkWindowPosition", window_positions); }


static struct opts window_types[] = {
	{GTK_WINDOW_TOPLEVEL,	"TOPLEVEL"},
	{GTK_WINDOW_DIALOG,	"DIALOG"},
	{GTK_WINDOW_POPUP,	"POPUP"},
       	{0,0}	
};

int SvGtkWindowType(SV * value) { return SvOpt(value, "GtkWindowType", window_types); }
SV * newSVGtkWindowType(int value) { return newSVOpt(value, "GtkWindowType", window_types); }


static struct opts direction_types[] = {
	{GTK_DIR_TAB_FORWARD,	"TAB_FORWARD"},
	{GTK_DIR_TAB_BACKWARD,	"TAB_BACKWARD"},
	{GTK_DIR_UP,		"UP"},
	{GTK_DIR_DOWN,		"DOWN"},
	{GTK_DIR_LEFT,		"LEFT"},
	{GTK_DIR_RIGHT,		"RIGHT"},
       	{0,0}	
};

int SvGtkDirectionType(SV * value) { return SvOpt(value, "GtkDirectionType", direction_types); }
SV * newSVGtkDirectionType(int value) { return newSVOpt(value, "GtkDirectionType", direction_types); }

static struct opts attach_options[] = {
	{GTK_EXPAND,	"EXPAND"},
	{GTK_SHRINK,	"SHRINK"},
	{GTK_FILL,	"FILL"},
       	{0,0}	
};

int SvGtkAttachOptions(SV * value) { return SvOptFlags(value, "GtkAttachOptions", attach_options); }
SV * newSVGtkAttachOptions(int value) { return newSVOptFlags(value, "GtkAttachOptions", attach_options, 0); }

static struct opts arrow_types[] = {
	{GTK_ARROW_UP,	"UP"},
	{GTK_ARROW_DOWN,	"DOWN"},
	{GTK_ARROW_LEFT,	"LEFT"},
	{GTK_ARROW_RIGHT,	"RIGHT"},
       	{0,0}	
};

int SvGtkArrowType(SV * value) { return SvOpt(value, "GtkArrowType", arrow_types); }
SV * newSVGtkArrowType(int value) { return newSVOpt(value, "GtkArrowType", arrow_types); }

static struct opts menu_factory_types[] = {
	{GTK_MENU_FACTORY_MENU,	"MENU"},
	{GTK_MENU_FACTORY_MENU_BAR,	"MENU_BAR"},
	{GTK_MENU_FACTORY_OPTION_MENU,	"OPTION_MENU"},
       	{0,0}	
};

int SvGtkMenuFactoryType(SV * value) { return SvOpt(value, "GtkMenuFactoryType", menu_factory_types); }
SV * newSVGtkMenuFactoryType(int value) { return newSVOpt(value, "GtkMenuFactoryType", menu_factory_types); }

static struct opts preview_types[] = {
	{GTK_PREVIEW_COLOR,	"COLOR"},
	{GTK_PREVIEW_GRAYSCALE,	"GRAYSCALE"},
       	{0,0}	
};

int SvGtkPreviewType(SV * value) { return SvOpt(value, "GtkPreviewType", preview_types); }
SV * newSVGtkPreviewType(int value) { return newSVOpt(value, "GtkPreviewType", preview_types); }
#endif

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