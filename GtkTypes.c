#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   
#include <gtk/gtk.h>
#include "GdkTypes.h"
#include "MiscTypes.h"

static HV * ObjectCache = 0;

void UnregisterGtkObject(SV * sv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	sv_setiv(sv_object, 0);
	
	SvREFCNT(sv_object)+=2;
	hv_delete(ObjectCache, buffer, strlen(buffer), G_DISCARD);
	SvREFCNT(sv_object)--;
}

void RegisterGtkObject(SV * sv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	hv_store(ObjectCache, buffer, strlen(buffer), sv_object, 0);
}

SV * RetrieveGtkObject(GtkObject * gtk_object)
{
	char buffer[40];
	SV ** s;
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	s = hv_fetch(ObjectCache, buffer, strlen(buffer), 0);
	if (s)
		return *s;
	else
		return 0;
}

static AV * typecasts = 0;
static HV * types = 0;

static void add_typecast(int type, char * name)
{
	GtkObjectClass * klass = gtk_type_class(type);
	av_extend(typecasts, klass->type);
	av_store(typecasts, klass->type, newSVpv(name, 0));
	hv_store(types, name, strlen(name), newSViv(type), 0);
}

int type_name(char * name) {
	SV ** s = hv_fetch(types, name, strlen(name), 0);
	if (s)
		return SvIV(*s);
	else
		return 0;
}

void init_typecasts()
{
	typecasts = newAV();

	add_typecast(gtk_adjustment_get_type(),		"Gtk::Adjustment");
	add_typecast(gtk_alignment_get_type(),		"Gtk::Alignment");
	add_typecast(gtk_aspect_frame_get_type(),	"Gtk::AspectFrame");
	add_typecast(gtk_arrow_get_type(),		"Gtk::Arrow");
	add_typecast(gtk_bin_get_type(),		"Gtk::Bin");
	add_typecast(gtk_box_get_type(),		"Gtk::Box");
	add_typecast(gtk_button_get_type(),		"Gtk::Button");
	add_typecast(gtk_check_button_get_type(),	"Gtk::CheckButton");
	add_typecast(gtk_color_selection_dialog_get_type(),	"Gtk::ColorSelectionDialog");
	add_typecast(gtk_color_selection_get_type(),	"Gtk::ColorSelection");
	add_typecast(gtk_container_get_type(),		"Gtk::Container");
	add_typecast(gtk_curve_get_type(),		"Gtk::Curve");
	add_typecast(gtk_data_get_type(),		"Gtk::Data");
	add_typecast(gtk_dialog_get_type(),		"Gtk::Dialog");
	add_typecast(gtk_drawing_area_get_type(),	"Gtk::DrawingArea");
	add_typecast(gtk_entry_get_type(),		"Gtk::Entry");
	add_typecast(gtk_file_selection_get_type(),	"Gtk::FileSelection");
	add_typecast(gtk_frame_get_type(),		"Gtk::Frame");
	add_typecast(gtk_hbox_get_type(),		"Gtk::HBox");
	add_typecast(gtk_hruler_get_type(),		"Gtk::HRuler");
	add_typecast(gtk_hscale_get_type(),		"Gtk::HScale");
	add_typecast(gtk_hscrollbar_get_type(),		"Gtk::HScrollbar");
	add_typecast(gtk_hseparator_get_type(),		"Gtk::HSeparator");
	add_typecast(gtk_image_get_type(),		"Gtk::Image");
	add_typecast(gtk_item_get_type(),		"Gtk::Item");
	add_typecast(gtk_label_get_type(),		"Gtk::Label");
	add_typecast(gtk_list_get_type(),		"Gtk::List");
	add_typecast(gtk_list_item_get_type(),		"Gtk::ListItem");
	add_typecast(gtk_menu_bar_get_type(),		"Gtk::MenuBar");
	add_typecast(gtk_menu_get_type(),		"Gtk::Menu");
	add_typecast(gtk_menu_item_get_type(),		"Gtk::MenuItem");
	add_typecast(gtk_menu_shell_get_type(),		"Gtk::MenuShell");
	add_typecast(gtk_misc_get_type(),		"Gtk::Misc");
	add_typecast(gtk_notebook_get_type(),		"Gtk::Notebook");
	add_typecast(gtk_object_get_type(),		"Gtk::Object");
	add_typecast(gtk_option_menu_get_type(),	"Gtk::OptionMenu");
	add_typecast(gtk_pixmap_get_type(),		"Gtk::Pixmap");
	add_typecast(gtk_preview_get_type(),		"Gtk::Preview");
	add_typecast(gtk_progress_bar_get_type(),	"Gtk::ProgressBar");
	add_typecast(gtk_radio_button_get_type(),	"Gtk::RadioButton");
	add_typecast(gtk_radio_menu_item_get_type(),	"Gtk::RadioMenuItem");
	add_typecast(gtk_range_get_type(),		"Gtk::Range");
	add_typecast(gtk_ruler_get_type(),		"Gtk::Ruler");
	add_typecast(gtk_scale_get_type(),		"Gtk::Scale");
	add_typecast(gtk_scrollbar_get_type(),		"Gtk::Scrollbar");
	add_typecast(gtk_scrolled_window_get_type(),	"Gtk::ScrolledWindow");
	add_typecast(gtk_separator_get_type(),		"Gtk::Separator");
	add_typecast(gtk_table_get_type(),		"Gtk::Table");
	add_typecast(gtk_text_get_type(),		"Gtk::Text");
	add_typecast(gtk_toggle_button_get_type(),	"Gtk::ToggleButton");
	add_typecast(gtk_tree_get_type(),		"Gtk::Tree");
	add_typecast(gtk_tree_item_get_type(),		"Gtk::TreeItem");
	add_typecast(gtk_vbox_get_type(),		"Gtk::VBox");
	add_typecast(gtk_viewport_get_type(),		"Gtk::Viewport");
	add_typecast(gtk_vruler_get_type(),		"Gtk::VRuler");
	add_typecast(gtk_vscale_get_type(),		"Gtk::VScale");
	add_typecast(gtk_vscrollbar_get_type(),		"Gtk::VScrollbar");
	add_typecast(gtk_vseparator_get_type(),		"Gtk::VSeparator");
	add_typecast(gtk_widget_get_type(),		"Gtk::Widget");
	add_typecast(gtk_window_get_type(),		"Gtk::Window");

}

SV * newSVGtkObjectRef(GtkObject * object, char * classname)
{
	SV * result = RetrieveGtkObject(object);
	if (result) {
		result = newRV(result);
		//SvREFCNT_dec(SvRV(result));
	} else {
		if (!classname) {
			SV ** k;
			if (!typecasts)
				init_typecasts();
			k = av_fetch(typecasts, object->klass->type, 0);
			if (!k)
				croak("unknown Gdk type");
			classname = SvPV(*k, na);
		}
		result = newRV(newSViv((int)object));
		RegisterGtkObject(SvRV(result), object);
		sv_bless(result, gv_stashpv(classname, FALSE));
		SvREFCNT_dec(SvRV(result));
		/*gtk_object_ref(object);*/
	}
	return result;
}

GtkObject * SvGtkObjectRef(SV * o, char * name)
{
	if (!o || !SvOK(o))
		return 0;
	if (name && !sv_derived_from(o, name))
		croak("variable is not of type %s", name);
	return (GtkObject*)SvIV((SV*)SvRV(o));
}

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

int SvGtkArrowType(SV * value) { return SvOptFlags(value, "GtkArrowType", arrow_types); }
SV * newSVGtkArrowType(int value) { return newSVOptFlags(value, "GtkArrowType", arrow_types, 0); }

static struct opts menu_factory_types[] = {
	{GTK_MENU_FACTORY_MENU,	"MENU"},
	{GTK_MENU_FACTORY_MENU_BAR,	"MENU_BAR"},
	{GTK_MENU_FACTORY_OPTION_MENU,	"OPTION_MENU"},
       	{0,0}	
};

int SvGtkMenuFactoryType(SV * value) { return SvOptFlags(value, "GtkMenuFactoryType", menu_factory_types); }
SV * newSVGtkMenuFactoryType(int value) { return newSVOptFlags(value, "GtkMenuFactoryType", menu_factory_types, 0); }

static struct opts preview_types[] = {
	{GTK_PREVIEW_COLOR,	"COLOR"},
	{GTK_PREVIEW_GRAYSCALE,	"GRAYSCALE"},
       	{0,0}	
};

int SvGtkPreviewType(SV * value) { return SvOptFlags(value, "GtkPreviewType", preview_types); }
SV * newSVGtkPreviewType(int value) { return newSVOptFlags(value, "GtkPreviewType", preview_types, 0); }

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