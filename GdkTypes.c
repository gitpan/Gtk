#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   
#include <gdk/gdk.h>
#include <gtk/gtk.h>
#include "MiscTypes.h"
#include "GdkTypes.h"

#include "GtkDefs.h"

#if 0
static struct opts event_types[] = {
	{ GDK_NOTHING, "NOTHING"} ,
	{ GDK_DELETE, "DELETE"} ,
	{ GDK_EXPOSE, "EXPOSE"} ,
	{ GDK_MOTION_NOTIFY, "MOTION_NOTIFY"} ,
	{ GDK_BUTTON_PRESS, "BUTTON_PRESS"} ,
	{ GDK_2BUTTON_PRESS, "2BUTTON_PRESS"} ,
	{ GDK_3BUTTON_PRESS, "3BUTTON_PRESS"} ,
	{ GDK_BUTTON_RELEASE, "BUTTON_RELEASE"} ,
	{ GDK_KEY_PRESS, "KEY_PRESS"} ,
	{ GDK_KEY_RELEASE, "KEY_RELEASE"} ,
	{ GDK_ENTER_NOTIFY, "ENTER_NOTIFY"} ,
	{ GDK_LEAVE_NOTIFY, "LEAVE_NOTIFY"} ,
	{ GDK_FOCUS_CHANGE, "FOCUS_CHANGE"} ,
	{ GDK_CONFIGURE, "CONFIGURE"} ,
	{ GDK_MAP, "MAP"} ,
	{ GDK_UNMAP, "UNMAP"} ,
	{ GDK_PROPERTY_NOTIFY, "PROPERTY_NOTIFY"} ,
	{ GDK_SELECTION_CLEAR, "SELECTION_CLEAR"} ,
	{ GDK_SELECTION_REQUEST, "SELECTION_REQUEST"} ,
	{ GDK_SELECTION_NOTIFY, "SELECTION_NOTIFY"} ,
	{ GDK_PROXIMITY_IN, "GDK_PROXIMITY_IN"} ,
	{ GDK_PROXIMITY_OUT, "GDK_PROXIMITY_OUT"} ,
	{ GDK_OTHER_EVENT, "OTHER_EVENT"} ,
	{0,0}	
};

int SvGdkEventType(SV * value) { return SvOpt(value, "GdkEventType", event_types); }
SV * newSVGdkEventType(int value) { return newSVOpt(value, "GdkEventType", event_types); }

static struct opts notify_types[] = {
	{ GDK_NOTIFY_ANCESTOR, "ANCESTOR"} ,
	{ GDK_NOTIFY_VIRTUAL, "VIRTUAL"} ,
	{ GDK_NOTIFY_INFERIOR, "INFERIOR"} ,
	{ GDK_NOTIFY_NONLINEAR, "NONLINEAR"} ,
	{ GDK_NOTIFY_NONLINEAR_VIRTUAL, "NONLINEAR_VIRTUAL"} ,
	{ GDK_NOTIFY_UNKNOWN, "UNKNOWN"} ,
	{0,0}	
};

int SvGdkNotifyType(SV * value) { return SvOpt(value, "GdkNotifyType", notify_types); }
SV * newSVGdkNotifyType(int value) { return newSVOpt(value, "GdkNotifyType", notify_types); }

static struct opts input_sources[] = {
	{ GDK_SOURCE_MOUSE, "MOUSE"},
	{ GDK_SOURCE_PEN, "PEN"},
	{ GDK_SOURCE_ERASER, "ERASER"},
	{ GDK_SOURCE_CURSOR, "CURSOR"},
	{0,0}	
};

int SvGdkInputSource(SV * value) { return SvOpt(value, "GdkInputSource", input_sources); }
SV * newSVGdkInputSource(int value) { return newSVOpt(value, "GdkInputSource", input_sources); }

static struct opts input_modes[] = {
	{ GDK_MODE_DISABLED, "DISABLED"},
	{ GDK_MODE_SCREEN, "SCREEN"},
	{ GDK_MODE_WINDOW, "WINDOW"},
	{0,0}	
};

int SvGdkInputMode(SV * value) { return SvOpt(value, "GdkInputMode", input_modes); }
SV * newSVGdkInputMode(int value) { return newSVOpt(value, "GdkInputMode", input_modes); }

static struct opts axes[] = {
	{ GDK_AXIS_IGNORE, "IGNORE"},
	{ GDK_AXIS_X, "X"},
	{ GDK_AXIS_Y, "Y"},
	{ GDK_AXIS_PRESSURE, "PRESSURE"},
	{ GDK_AXIS_XTILT, "XTILT"},
	{ GDK_AXIS_YTILT, "YTILT"},
	{ GDK_AXIS_LAST, "LAST"},
	{0,0}	
};

int SvGdkAxisUse(SV * value) { return SvOpt(value, "GdkAxisUse", axes); }
SV * newSVGdkAxisUse(int value) { return newSVOpt(value, "GdkAxisUse", axes); }

static struct opts window_types[] = {
	{ GDK_WINDOW_ROOT,	"ROOT"},
	{ GDK_WINDOW_TOPLEVEL,	"TOPLEVEL"},
	{ GDK_WINDOW_CHILD,	"CHILD"},
	{ GDK_WINDOW_DIALOG,	"DIALOG"},
	{ GDK_WINDOW_TEMP,	"TEMP"},
	{ GDK_WINDOW_PIXMAP,	"PIXMAP"},
	{0,0}	
};

int SvGdkWindowType(SV * value) { return SvOpt(value, "GdkWindowType", window_types); }
SV * newSVGdkWindowType(int value) { return newSVOpt(value, "GdkWindowType", window_types); }

static struct opts event_masks[] = {
	{GDK_EXPOSURE_MASK,		"EXPOSURE"},
	{GDK_POINTER_MOTION_MASK,	"POINTER_MOTION"},
	{GDK_POINTER_MOTION_HINT_MASK,	"POINTER_MOTION_HINT"},
	{GDK_BUTTON_MOTION_MASK,	"BUTTON_MOTION"},
	{GDK_BUTTON1_MOTION_MASK,	"BUTTON1_MOTION"},
	{GDK_BUTTON2_MOTION_MASK,	"BUTTON2_MOTION"},
	{GDK_BUTTON3_MOTION_MASK,	"BUTTON3_MOTION"},
	{GDK_BUTTON_PRESS_MASK,		"BUTTON_PRESS"},
	{GDK_BUTTON_RELEASE_MASK,	"BUTTON_RELEASE"},
	{GDK_KEY_PRESS_MASK,		"KEY_PRESS"},
	{GDK_KEY_RELEASE_MASK,		"KEY_RELEASE"},
	{GDK_ENTER_NOTIFY_MASK,		"ENTER_NOTIFY"},
	{GDK_LEAVE_NOTIFY_MASK,		"LEAVE_NOTIFY"},
	{GDK_FOCUS_CHANGE_MASK,		"FOCUS_CHANGE"},
	{GDK_STRUCTURE_MASK,		"STRUCTURE"},
	{GDK_PROXIMITY_IN_MASK,		"PROXIMITY_IN"},
	{GDK_PROXIMITY_OUT_MASK,		"PROXIMITY_OUT"},
	{GDK_ALL_EVENTS_MASK,		"ALL_EVENTS"},
	{0,0}	
};

int SvGdkEventMask(SV * value) { return SvOptFlags(value, "GdkEventMask", event_masks); }
SV * newSVGdkEventMask(int value) { return newSVOptFlags(value, "GdkEventMask", event_masks, 1); }

static struct opts visual_types[] = {
	{ GDK_VISUAL_STATIC_GRAY, "STATIC_GRAY"} ,
	{ GDK_VISUAL_GRAYSCALE, "GRAYSCALE"} ,
	{ GDK_VISUAL_STATIC_COLOR, "STATIC_COLOR"} ,
	{ GDK_VISUAL_PSEUDO_COLOR, "PSEDUO_COLOR"} ,
	{ GDK_VISUAL_TRUE_COLOR, "TRUE_COLOR"} ,
	{ GDK_VISUAL_DIRECT_COLOR, "DIRECT_COLOR"} ,
	{0,0}	
};

int SvGdkVisualType(SV * value) { return SvOpt(value, "GdkVisualType", visual_types); }
SV * newSVGdkVisualType(int value) { return newSVOpt(value, "GdkVisualType", visual_types); }

static struct opts wclasses[] = {
	{ GDK_INPUT_OUTPUT, "INPUT_OUTPUT"} ,
	{ GDK_INPUT_ONLY, "INPUT_ONLY"},
	{0,0}	
};

int SvGdkWindowClass(SV * value) { return SvOpt(value, "GdkWindowClass", wclasses); }
SV * newSVGdkWindowClass(int value) { return newSVOpt(value, "GdkWindowClass", wclasses); }

static struct opts image_types[] = {
	{ GDK_IMAGE_NORMAL, "NORMAL"},
	{ GDK_IMAGE_SHARED, "SHARED"},
	{ GDK_IMAGE_FASTEST,"FASTEST"},
	{0,0}	
};

int SvGdkImageType(SV * value) { return SvOpt(value, "GdkImageType", image_types); }
SV * newSVGdkImageType(int value) { return newSVOpt(value, "GdkImageType", image_types); }

static struct opts input_conditions[] = {
	{GDK_INPUT_READ,		"READ"},
	{GDK_INPUT_WRITE,		"WRITE"},
	{GDK_INPUT_EXCEPTION,		"EXCEPTION"},
	{0,0}	
};

int SvGdkInputCondition(SV * value) { return SvOptFlags(value, "GdkInputCondition", input_conditions); }
SV * newSVGdkInputCondition(int value) { return newSVOptFlags(value, "GdkInputCondition", input_conditions, 1); }

static struct opts subwindow_modes[] = {
	{ GDK_CLIP_BY_CHILDREN,	"CLIP_BY_CHILDREN"},
	{ GDK_INCLUDE_INFERIORS,	"INCLUDE_INFERIORS"},
	{0,0}	
};

int SvGdkSubwindowMode(SV * value) { return SvOpt(value, "GdkSubwindowMode", subwindow_modes); }
SV * newSVGdkSubwindowMode(int value) { return newSVOpt(value, "GdkSubwindowMode", subwindow_modes); }

static struct opts line_styles[] = {
	{ GDK_LINE_SOLID,	"SOLID"},
	{ GDK_LINE_ON_OFF_DASH,	"ON_OFF_DASH"},
	{ GDK_LINE_DOUBLE_DASH,	"DOUBLE_DASH"},
	{0,0}	
};

int SvGdkLineStyle(SV * value) { return SvOpt(value, "GdkLineStyle", line_styles); }
SV * newSVGdkLineStyle(int value) { return newSVOpt(value, "GdkLineStyle", line_styles); }

static struct opts cap_styles[] = {
	{ GDK_CAP_NOT_LAST,	"NOT_LAST"},
	{ GDK_CAP_BUTT,		"BUTT"},
	{ GDK_CAP_ROUND,	"ROUND"},
	{ GDK_CAP_PROJECTING,	"PROJECTING"},
	{0,0}	
};

int SvGdkCapStyle(SV * value) { return SvOpt(value, "GdkCapStyle", cap_styles); }
SV * newSVGdkCapStyle(int value) { return newSVOpt(value, "GdkCapStyle", cap_styles); }

static struct opts join_styles[] = {
	{ GDK_JOIN_MITER,	"MITER"},
	{ GDK_JOIN_ROUND,	"ROUND"},
	{ GDK_JOIN_BEVEL,	"BEVEL"},
	{0,0}	
};

int SvGdkJoinStyle(SV * value) { return SvOpt(value, "GdkJoinStyle", join_styles); }
SV * newSVGdkJoinStyle(int value) { return newSVOpt(value, "GdkJoinStyle", join_styles); }

static struct opts fill_styles[] = {
	{ GDK_SOLID,	"SOLID"},
	{ GDK_TILED,	"TILED"},
	{ GDK_STIPPLED,	"STIPPLED"},
	{0,0}	
};

int SvGdkFill(SV * value) { return SvOpt(value, "GdkFill", fill_styles); }
SV * newSVGdkFill(int value) { return newSVOpt(value, "GdkFill", fill_styles); }

static struct opts functions[] = {
	{ GDK_COPY,	"COPY"},
	{ GDK_INVERT,	"INVERT"},
	{ GDK_XOR,	"XOR"},
	{0,0}	
};

int SvGdkFunction(SV * value) { return SvOpt(value, "GdkFunction", functions); }
SV * newSVGdkFunction(int value) { return newSVOpt(value, "GdkFunction", functions); }

static struct opts modifier_types[] = {
	{ GDK_SHIFT_MASK,	"SHIFT"},
	{ GDK_LOCK_MASK,	"LOCK"},
	{ GDK_CONTROL_MASK,	"CONTROL"},
	{ GDK_MOD1_MASK,	"MOD1"},
	{ GDK_MOD2_MASK,	"MOD2"},
	{ GDK_MOD3_MASK,	"MOD3"},
	{ GDK_MOD4_MASK,	"MOD4"},
	{ GDK_MOD5_MASK,	"MOD5"},
	{ GDK_BUTTON1_MASK,	"BUTTON1"},
	{ GDK_BUTTON2_MASK,	"BUTTON2"},
	{ GDK_BUTTON3_MASK,	"BUTTON3"},
	{ GDK_BUTTON4_MASK,	"BUTTON4"},
	{ GDK_BUTTON5_MASK,	"BUTTON5"},
	{0,0}	
};

int SvGdkModifierType(SV * value) { return SvOptFlags(value, "GdkModifierType", modifier_types); }
SV * newSVGdkModifierType(int value) { return newSVOptFlags(value, "GdkModifierType", modifier_types, 1); }

static struct opts gc_values[] = {
	{GDK_GC_FOREGROUND,	"FOREGROUND"},
	{GDK_GC_BACKGROUND,	"BACKGROUND"},
	{GDK_GC_FONT,		"FONT"},
	{GDK_GC_FUNCTION,	"FUNCTION"},
	{GDK_GC_FILL,		"FILL"},
	{GDK_GC_TILE,		"TILE"},
	{GDK_GC_STIPPLE,	"STIPPLE"},
	{GDK_GC_CLIP_MASK,	"CLIP_MASK"},
	{GDK_GC_SUBWINDOW,	"SUBWINDOW"},
	{GDK_GC_TS_X_ORIGIN,	"TS_X_ORIGIN"},
	{GDK_GC_TS_Y_ORIGIN,	"TS_Y_ORIGIN"},
	{GDK_GC_CLIP_X_ORIGIN,	"CLIP_X_ORIGIN"},
	{GDK_GC_CLIP_Y_ORIGIN,	"CLIP_Y_ORIGIN"},
	{GDK_GC_EXPOSURES,	"EXPOSURES"},
	{GDK_GC_LINE_WIDTH,	"LINE_WIDTH"},
	{GDK_GC_LINE_STYLE,	"LINE_STYLE"},
	{GDK_GC_CAP_STYLE,	"CAP_STYLE"},
	{GDK_GC_JOIN_STYLE,	"JOIN_STYLE"},
	{0,0}	
};

int SvGdkGCValuesMask(SV * value) { return SvOptFlags(value, "GdkGCValuesMask", gc_values); }
SV * newSVGdkGCValuesMask(int value) { return newSVOptFlags(value, "GdkGCValuesMask", gc_values, 1); }

static struct opts cursor_types[] = {
	{GDK_NUM_GLYPHS, "NUM_GLYPHS"},
	{GDK_X_CURSOR, "X_CURSOR"},
	{GDK_ARROW, "ARROW"},
	{GDK_BASED_ARROW_DOWN, "BASED_ARROW_DOWN"},
	{GDK_BASED_ARROW_UP, "BASED_ARROW_UP"},
	{GDK_BOAT, "BOAT"},
	{GDK_BOGOSITY, "BOGOSITY"},
	{GDK_BOTTOM_LEFT_CORNER, "BOTTOM_LEFT_CORNER"},
	{GDK_BOTTOM_RIGHT_CORNER, "BOTTOM_RIGHT_CORNER"},
	{GDK_BOTTOM_SIDE, "BOTTOM_SIDE"},
	{GDK_BOTTOM_TEE, "BOTTOM_TEE"},
	{GDK_BOX_SPIRAL, "BOX_SPIRAL"},
	{GDK_CENTER_PTR, "CENTER_PTR"},
	{GDK_CIRCLE, "CIRCLE"},
	{GDK_CLOCK, "CLOCK"},
	{GDK_COFFEE_MUG, "COFFEE_MUG"},
	{GDK_CROSS, "CROSS"},
	{GDK_CROSS_REVERSE, "CROSS_REVERSE"},
	{GDK_CROSSHAIR, "CROSSHAIR"},
	{GDK_DIAMOND_CROSS, "DIAMOND_CROSS"},
	{GDK_DOT, "DOT"},
	{GDK_DOTBOX, "DOTBOX"},
	{GDK_DOUBLE_ARROW, "DOUBLE_ARROW"},
	{GDK_DRAFT_LARGE, "DRAFT_LARGE"},
	{GDK_DRAFT_SMALL, "DRAFT_SMALL"},
	{GDK_DRAPED_BOX, "DRAPED_BOX"},
	{GDK_EXCHANGE, "EXCHANGE"},
	{GDK_FLEUR, "FLEUR"},
	{GDK_GOBBLER, "GOBBLER"},
	{GDK_GUMBY, "GUMBY"},
	{GDK_HAND1, "HAND1"},
	{GDK_HAND2, "HAND2"},
	{GDK_HEART, "HEART"},
	{GDK_ICON, "ICON"},
	{GDK_IRON_CROSS, "IRON_CROSS"},
	{GDK_LEFT_PTR, "LEFT_PTR"},
	{GDK_LEFT_SIDE, "LEFT_SIDE"},
	{GDK_LEFT_TEE, "LEFT_TEE"},
	{GDK_LEFTBUTTON, "LEFTBUTTON"},
	{GDK_LL_ANGLE, "LL_ANGLE"},
	{GDK_LR_ANGLE, "LR_ANGLE"},
	{GDK_MAN, "MAN"},
	{GDK_MIDDLEBUTTON, "MIDDLEBUTTON"},
	{GDK_MOUSE, "MOUSE"},
	{GDK_PENCIL, "PENCIL"},
	{GDK_PIRATE, "PIRATE"},
	{GDK_PLUS, "PLUS"},
	{GDK_QUESTION_ARROW, "QUESTION_ARROW"},
	{GDK_RIGHT_PTR, "RIGHT_PTR"},
	{GDK_RIGHT_SIDE, "RIGHT_SIDE"},
	{GDK_RIGHT_TEE, "RIGHT_TEE"},
	{GDK_RIGHTBUTTON, "RIGHTBUTTON"},
	{GDK_RTL_LOGO, "RTL_LOGO"},
	{GDK_SAILBOAT, "SAILBOAT"},
	{GDK_SB_DOWN_ARROW, "SB_DOWN_ARROW"},
	{GDK_SB_H_DOUBLE_ARROW, "SB_H_DOUBLE_ARROW"},
	{GDK_SB_LEFT_ARROW, "SB_LEFT_ARROW"},
	{GDK_SB_RIGHT_ARROW, "SB_RIGHT_ARROW"},
	{GDK_SB_UP_ARROW, "SB_UP_ARROW"},
	{GDK_SB_V_DOUBLE_ARROW, "SB_V_DOUBLE_ARROW"},
	{GDK_SHUTTLE, "SHUTTLE"},
	{GDK_SIZING, "SIZING"},
	{GDK_SPIDER, "SPIDER"},
	{GDK_SPRAYCAN, "SPRAYCAN"},
	{GDK_STAR, "STAR"},
	{GDK_TARGET, "TARGET"},
	{GDK_TCROSS, "TCROSS"},
	{GDK_TOP_LEFT_ARROW, "TOP_LEFT_ARROW"},
	{GDK_TOP_LEFT_CORNER, "TOP_LEFT_CORNER"},
	{GDK_TOP_RIGHT_CORNER, "TOP_RIGHT_CORNER"},
	{GDK_TOP_SIDE, "TOP_SIDE"},
	{GDK_TOP_TEE, "TOP_TEE"},
	{GDK_TREK, "TREK"},
	{GDK_UL_ANGLE, "UL_ANGLE"},
	{GDK_UMBRELLA, "UMBRELLA"},
	{GDK_UR_ANGLE, "UR_ANGLE"},
	{GDK_WATCH, "WATCH"},
	{GDK_XTERM, "XTERM"},
	{0,0}	
};

int SvGdkCursorType(SV * value) { return SvOpt(value, "GdkCursorType", cursor_types); }
SV * newSVGdkCursorType(int value) { return newSVOpt(value, "GdkCursorType", cursor_types); }
#endif

SV * newSVGdkWindowRef(GdkWindow * w) { return newSVMiscRef(w, "Gtk::Gdk::Window",0); }
GdkWindow * SvGdkWindowRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Window"); }

SV * newSVGdkPixmapRef(GdkPixmap * w) { return newSVMiscRef(w, "Gtk::Gdk::Pixmap",0); }
GdkPixmap * SvGdkPixmapRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Pixmap"); }

SV * newSVGdkBitmapRef(GdkBitmap * w) { return newSVMiscRef(w, "Gtk::Gdk::Bitmap",0); }
GdkBitmap * SvGdkBitmapRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Bitmap"); }

SV * newSVGdkColormapRef(GdkColormap * w) { return newSVMiscRef(w, "Gtk::Gdk::Colormap",0); }
GdkColormap * SvGdkColormapRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Colormap"); }

SV * newSVGdkColorRef(GdkColor * c) { return newSVMiscRef(c, "Gtk::Gdk::Color",0); }
GdkColor * SvGdkColorRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Color"); }

SV * newSVGdkCursorRef(GdkCursor * w) { return newSVMiscRef(w, "Gtk::Gdk::Cursor",0); }
GdkCursor * SvGdkCursorRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Cursor"); }

SV * newSVGdkVisualRef(GdkVisual * w) { return newSVMiscRef(w, "Gtk::Gdk::Visual",0); }
GdkVisual * SvGdkVisualRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Visual"); }

SV * newSVGdkGCRef(GdkGC * g) { return newSVMiscRef(g, "Gtk::Gdk::GC",0); }
GdkGC * SvGdkGCRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::GC"); }

SV * newSVGdkFontRef(GdkFont * f) { return newSVMiscRef(f, "Gtk::Gdk::Font",0); }
GdkFont * SvGdkFontRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Font"); }

SV * newSVGdkImageRef(GdkImage * i) { return newSVMiscRef(i, "Gtk::Gdk::Image",0); }
GdkImage * SvGdkImageRef(SV * data) { return SvMiscRef(data, "Gtk::Gdk::Image"); }

SV * newSVGdkRectangle(GdkRectangle * rect)
{
	AV * a;
	SV * r;
	
	if (!rect)
		return newSVsv(&sv_undef);
		
	a = newAV();
	r = newRV((SV*)a);
	SvREFCNT_dec(a);
	
	av_push(a, newSViv(rect->x));
	av_push(a, newSViv(rect->y));
	av_push(a, newSViv(rect->width));
	av_push(a, newSViv(rect->height));
	
	return r;
}

GdkRectangle * SvGdkRectangle(SV * data, GdkRectangle * rect)
{
	AV * a;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVAV))
		return 0;
		
	a = (AV*)SvRV(data);

	if (av_len(a) != 3)
		croak("rectangle must have four elements");

	if (!rect)
		rect = alloc_temp(sizeof(GdkRectangle));
	
	rect->x = SvIV(*av_fetch(a, 0, 0));
	rect->y = SvIV(*av_fetch(a, 1, 0));
	rect->width = SvIV(*av_fetch(a, 2, 0));
	rect->height = SvIV(*av_fetch(a, 3, 0));
	
	return rect;
}

SV * newSVGdkGCValues(GdkGCValues * v)
{
	HV * h;
	SV * r;
	
	if (!v)
		return newSVsv(&sv_undef);
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	hv_store(h, "foreground", 10, newSVMiscRef(&v->foreground, "Gtk::Gdk::Color",0), 0);
	hv_store(h, "background", 10, newSVMiscRef(&v->background, "Gtk::Gdk::Color",0), 0);
	hv_store(h, "font", 4, newSVMiscRef(v->font, "Gtk::Gdk::Font",0), 0);
	hv_store(h, "function", 8, newSVGdkFunction(v->function), 0);
	hv_store(h, "fill", 4, newSVGdkFill(v->fill), 0);
	hv_store(h, "tile", 4, newSVMiscRef(v->tile, "Gtk::Gdk::Pixmap",0), 0);
	hv_store(h, "stipple", 7, newSVMiscRef(v->stipple, "Gtk::Gdk::Pixmap",0), 0);
	hv_store(h, "clip_mask", 9, newSVMiscRef(v->clip_mask, "Gtk::Gdk::Pixmap",0), 0);
	hv_store(h, "subwindow_mode", 14, newSVGdkSubwindowMode(v->subwindow_mode), 0);
	hv_store(h, "ts_x_origin", 11, newSViv(v->ts_x_origin), 0);
	hv_store(h, "ts_y_origin", 11, newSViv(v->ts_y_origin), 0);
	hv_store(h, "clip_x_origin", 13, newSViv(v->clip_x_origin), 0);
	hv_store(h, "clip_x_origin", 13, newSViv(v->clip_y_origin), 0);
	hv_store(h, "graphics_exposures", 18, newSViv(v->graphics_exposures), 0);
	hv_store(h, "line_width", 10, newSViv(v->line_width), 0);
	hv_store(h, "line_style", 10, newSVGdkLineStyle(v->line_style), 0);
	hv_store(h, "cap_style", 9, newSVGdkCapStyle(v->cap_style), 0);
	hv_store(h, "join_style", 10, newSVGdkJoinStyle(v->join_style), 0);
	
	return r;
}

GdkGCValues * SvGdkGCValues(SV * data, GdkGCValues * v, GdkGCValuesMask * m)
{
	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
		
	h = (HV*)SvRV(data);

	if (!v)
		v = alloc_temp(sizeof(GdkGCValues));
	
	memset(v,0,sizeof(GdkGCValues));

	if ((s=hv_fetch(h, "foreground", 10, 0)) && SvOK(*s)) {
		GdkColor * c = SvMiscRef(*s, "Gtk::Gdk::Color");
		if (c) {
			v->foreground = *c;
			*m |= GDK_GC_FOREGROUND;
		}
	}
	if ((s=hv_fetch(h, "background", 10, 0)) && SvOK(*s)) {
		GdkColor * c = SvMiscRef(*s, "Gtk::Gdk::Color");
		if (c) {
			v->background = *c;
			*m |= GDK_GC_BACKGROUND;
		}
	}
	if ((s=hv_fetch(h, "font", 4, 0)) && SvOK(*s)) {
		v->font = SvMiscRef(*s, "Gtk::Gdk::Font");
		*m |= GDK_GC_FONT;
	}
	if ((s=hv_fetch(h, "function", 8, 0)) && SvOK(*s)) {
		v->function = SvGdkFunction(*s);
		*m |= GDK_GC_FUNCTION;
	}
	if ((s=hv_fetch(h, "fill", 4, 0)) && SvOK(*s)) {
		v->function = SvGdkFill(*s);
		*m |= GDK_GC_FILL;
	}
	if ((s=hv_fetch(h, "tile", 4, 0)) && SvOK(*s)) {
		v->tile = SvMiscRef(*s, "Gtk::Gdk::Pixmap");
		*m |= GDK_GC_TILE;
	}
	if ((s=hv_fetch(h, "stipple", 7, 0)) && SvOK(*s)) {
		v->stipple = SvMiscRef(*s, "Gtk::Gdk::Pixmap");
		*m |= GDK_GC_STIPPLE;
	}
	if ((s=hv_fetch(h, "clip_mask", 9, 0)) && SvOK(*s)) {
		v->clip_mask = SvMiscRef(*s, "Gtk::Gdk::Pixmap");
		*m |= GDK_GC_CLIP_MASK;
	}
	if ((s=hv_fetch(h, "subwindow_mode", 14, 0)) && SvOK(*s)) {
		v->subwindow_mode = SvGdkSubwindowMode(*s);
		*m |= GDK_GC_SUBWINDOW;
	}
	if ((s=hv_fetch(h, "ts_x_origin", 11, 0)) && SvOK(*s)) {
		v->ts_x_origin = SvIV(*s);
		*m |= GDK_GC_TS_X_ORIGIN;
	}
	if ((s=hv_fetch(h, "ts_y_origin", 11, 0)) && SvOK(*s)) {
		v->ts_y_origin = SvIV(*s);
		*m |= GDK_GC_TS_Y_ORIGIN;
	}
	if ((s=hv_fetch(h, "clip_x_origin", 13, 0)) && SvOK(*s)) {
		v->clip_x_origin = SvIV(*s);
		*m |= GDK_GC_CLIP_X_ORIGIN;
	}
	if ((s=hv_fetch(h, "clip_y_origin", 13, 0)) && SvOK(*s)) {
		v->clip_y_origin = SvIV(*s);
		*m |= GDK_GC_CLIP_Y_ORIGIN;
	}
	if ((s=hv_fetch(h, "graphics_exposures", 18, 0)) && SvOK(*s)) {
		v->graphics_exposures = SvIV(*s);
		*m |= GDK_GC_EXPOSURES;
	}
	if ((s=hv_fetch(h, "line_width", 10, 0)) && SvOK(*s)) {
		v->line_width= SvIV(*s);
		*m |= GDK_GC_LINE_WIDTH;
	}
	if ((s=hv_fetch(h, "line_style", 10, 0)) && SvOK(*s)) {
		v->line_style= SvGdkLineStyle(*s);
		*m |= GDK_GC_LINE_STYLE;
	}
	if ((s=hv_fetch(h, "cap_style", 9, 0)) && SvOK(*s)) {
		v->cap_style = SvGdkCapStyle(*s);
		*m |= GDK_GC_CAP_STYLE;
	}
	if ((s=hv_fetch(h, "join_style", 10, 0)) && SvOK(*s)) {
		v->join_style = SvGdkJoinStyle(*s);
		*m |= GDK_GC_JOIN_STYLE;
	}
	return v;
}

SV * newSVGdkDeviceInfo(GdkDeviceInfo * v)
{
	HV * h;
	SV * r;
	
	if (!v)
		return newSVsv(&sv_undef);
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	hv_store(h, "deviceid", 8, newSViv(v->deviceid), 0);
	hv_store(h, "name", 4, newSVpv(v->name, 0), 0);
	hv_store(h, "source", 6, newSVGdkInputSource(v->source), 0);
	hv_store(h, "mode", 4, newSVGdkInputMode(v->mode), 0);
	hv_store(h, "has_cursor", 10, newSViv(v->has_cursor), 0);
	hv_store(h, "num_axes", 8, newSViv(v->num_axes), 0);
	if (v->axes) {
		int i;
		AV * a = newAV();
		for(i=0;i<v->num_axes;i++) {
			av_push(a, newSVGdkAxisUse(v->axes[i]));
		}
		hv_store(h, "axes", 4, newRV((SV*)a), 0);
		SvREFCNT_dec(a);
	}

	return r;
}

SV * newSVGdkTimeCoord(GdkTimeCoord * v)
{
	HV * h;
	SV * r;
	
	if (!v)
		return newSVsv(&sv_undef);
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	hv_store(h, "time", 4, newSViv(v->time), 0);
	hv_store(h, "x", 1, newSVnv(v->x), 0);
	hv_store(h, "y", 1, newSVnv(v->y), 0);
	hv_store(h, "pressure", 8, newSVnv(v->pressure), 0);
	hv_store(h, "xtilt", 5, newSVnv(v->xtilt), 0);
	hv_store(h, "ytilt", 5, newSVnv(v->ytilt), 0);

	return r;
}

SV * newSVGdkAtom(GdkAtom a)
{
	return newSViv(a);
}

GdkAtom SvGdkAtom(SV * data)
{
	return SvIV(data);
}

SV * newSVGdkEvent(GdkEvent * e)
{
	HV * h;
	SV * r;
	
	if (!e)
		return newSVsv(&sv_undef);
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "type", 4, newSVGdkEventType(e->type), 0);
	hv_store(h, "window", 6, newSVGdkWindowRef(e->any.window), 0);
	switch (e->type) {
	case GDK_EXPOSE:
		hv_store(h, "area", 4, newSVGdkRectangle(&e->expose.area), 0);
		hv_store(h, "count", 5, newSViv(e->expose.count), 0);
		break;
	case GDK_MOTION_NOTIFY:
		hv_store(h, "x", 1, newSVnv(e->motion.x), 0);
		hv_store(h, "y", 1, newSVnv(e->motion.y), 0);
		hv_store(h, "pressure", 8, newSVnv(e->motion.pressure), 0);
		hv_store(h, "xtilt", 5, newSVnv(e->motion.xtilt), 0);
		hv_store(h, "ytilt", 5, newSVnv(e->motion.ytilt), 0);
		hv_store(h, "time", 4, newSViv(e->motion.time), 0);
		hv_store(h, "state", 5, newSViv(e->motion.state), 0);
		hv_store(h, "is_hint", 7, newSViv(e->motion.is_hint), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
	case GDK_BUTTON_PRESS:
	case GDK_2BUTTON_PRESS:
	case GDK_3BUTTON_PRESS:
	case GDK_BUTTON_RELEASE:
		hv_store(h, "x", 1, newSViv(e->button.x), 0);
		hv_store(h, "y", 1, newSViv(e->button.y), 0);
		hv_store(h, "time", 4, newSViv(e->button.time), 0);
		hv_store(h, "pressure", 8, newSVnv(e->motion.pressure), 0);
		hv_store(h, "xtilt", 5, newSVnv(e->motion.xtilt), 0);
		hv_store(h, "ytilt", 5, newSVnv(e->motion.ytilt), 0);
		hv_store(h, "state", 5, newSViv(e->button.state), 0);
		hv_store(h, "button", 6, newSViv(e->button.button), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
	case GDK_KEY_PRESS:
	case GDK_KEY_RELEASE:
		hv_store(h, "time", 4, newSViv(e->key.time), 0);
		hv_store(h, "state", 5, newSViv(e->key.state), 0);
		hv_store(h, "keyval", 6, newSViv(e->key.keyval), 0);
		break;
	case GDK_FOCUS_CHANGE:
		hv_store(h, "in", 2, newSViv(e->focus_change.in), 0);
		break;
	case GDK_ENTER_NOTIFY:
	case GDK_LEAVE_NOTIFY:
		hv_store(h, "window", 6, newSVGdkWindowRef(e->crossing.window), 0);
		hv_store(h, "subwindow", 9, newSVGdkWindowRef(e->crossing.subwindow), 0);
		hv_store(h, "detail", 6, newSVGdkNotifyType(e->crossing.detail), 0);
		break;
	case GDK_CONFIGURE:
		hv_store(h, "x", 1, newSViv(e->configure.x), 0);
		hv_store(h, "y", 1, newSViv(e->configure.y), 0);
		hv_store(h, "width", 5, newSViv(e->configure.width), 0);
		hv_store(h, "height", 6, newSViv(e->configure.height), 0);
		break;
	case GDK_PROPERTY_NOTIFY:
		hv_store(h, "time", 4, newSViv(e->property.time), 0);
		hv_store(h, "state", 5, newSViv(e->property.state), 0);
		hv_store(h, "atom", 4, newSVGdkAtom(e->property.atom), 0);
		break;
	case GDK_SELECTION_CLEAR:
	case GDK_SELECTION_REQUEST:
	case GDK_SELECTION_NOTIFY:
		hv_store(h, "requestor", 9, newSViv(e->selection.requestor), 0);
		hv_store(h, "time", 4, newSViv(e->selection.time), 0);
		hv_store(h, "selection", 9, newSVGdkAtom(e->selection.selection), 0);
		hv_store(h, "property", 8, newSVGdkAtom(e->selection.property), 0);
		break;
	case GDK_PROXIMITY_IN:
	case GDK_PROXIMITY_OUT:
		hv_store(h, "time", 4, newSViv(e->proximity.time), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
		
	}
	
	return r;
}

GdkEvent * SvGdkEvent(SV * data, GdkEvent * e)
{
	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
	
	if (!e)
		e = alloc_temp(sizeof(GdkEvent));

	h = (HV*)SvRV(data);
	
	if (s=hv_fetch(h, "type", 4, 0))
		e->type = SvGdkEventType(*s);
	else
		croak("event must contain type");
	if (s=hv_fetch(h, "window", 6, 0))
		e->any.window = SvGdkWindowRef(*s);
	else
		croak("event must contain window");
	
	switch (e->type) {
	case GDK_EXPOSE:
		if (s=hv_fetch(h, "area", 4, 0))
			SvGdkRectangle(*s, &e->expose.area);
		else
			croak("event must contain area");
		if (s=hv_fetch(h, "count", 5, 0))
			e->expose.count = SvIV(*s);
		else
			croak("event must contain count");
		break;
	case GDK_MOTION_NOTIFY:
		if (s=hv_fetch(h, "x", 1, 0))
			e->motion.x = SvNV(*s);
		else
			croak("event must contain x ordinate");
		if (s=hv_fetch(h, "y", 1, 0))
			e->motion.y = SvNV(*s);
		else
			croak("event must contain y ordinate");
		if (s=hv_fetch(h, "pressure", 8, 0))
			e->button.button = SvNV(*s);
		else
			e->button.pressure = 0;
		if (s=hv_fetch(h, "xtilt", 5, 0))
			e->button.xtilt = SvNV(*s);
		else
			e->button.xtilt = 0;
		if (s=hv_fetch(h, "ytilt", 5, 0))
			e->button.ytilt = SvNV(*s);
		else
			e->button.ytilt = 0;
		break;
		if (s=hv_fetch(h, "ytilt", 5, 0))
			e->button.ytilt = SvNV(*s);
		else
			e->button.ytilt = 0;
		break;
		if (s=hv_fetch(h, "time", 4, 0))
			e->motion.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "state", 5, 0))
			e->motion.state = SvIV(*s);
		else
			croak("event must contain state");
		if (s=hv_fetch(h, "is_hint", 7, 0))
			e->motion.is_hint = SvIV(*s);
		else
			croak("event must contain is_hint");
		break;
		if (s=hv_fetch(h, "source", 6, 0))
			e->button.source = SvGdkInputSource(*s);
		else
			e->button.source = 0;
		break;
		if ((s=hv_fetch(h, "deviceid", 8, 0)) && SvOK(*s))
			e->button.deviceid = SvIV(*s);
		else
			e->button.deviceid = GDK_CORE_POINTER;
		break;
	case GDK_BUTTON_PRESS:
	case GDK_2BUTTON_PRESS:
	case GDK_3BUTTON_PRESS:
	case GDK_BUTTON_RELEASE:
		if (s=hv_fetch(h, "x", 1, 0))
			e->button.x = SvNV(*s);
		else
			croak("event must contain x ordinate");
		if (s=hv_fetch(h, "y", 1, 0))
			e->button.y = SvNV(*s);
		else
			croak("event must contain y ordinate");
		if (s=hv_fetch(h, "pressure", 8, 0))
			e->button.button = SvNV(*s);
		else
			e->button.pressure = 0;
		if (s=hv_fetch(h, "xtilt", 5, 0))
			e->button.xtilt = SvNV(*s);
		else
			e->button.xtilt = 0;
		if (s=hv_fetch(h, "ytilt", 5, 0))
			e->button.ytilt = SvNV(*s);
		else
			e->button.ytilt = 0;
		break;
		if (s=hv_fetch(h, "ytilt", 5, 0))
			e->button.ytilt = SvNV(*s);
		else
			e->button.ytilt = 0;
		break;
		if (s=hv_fetch(h, "time", 4, 0))
			e->button.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "state", 5, 0))
			e->button.state = SvIV(*s);
		else
			croak("event must contain state");
		if (s=hv_fetch(h, "button", 6, 0))
			e->button.button = SvIV(*s);
		else
			croak("event must contain state");
		break;
		if (s=hv_fetch(h, "source", 6, 0))
			e->button.source = SvGdkInputSource(*s);
		else
			e->button.source = 0;
		break;
		if ((s=hv_fetch(h, "deviceid", 8, 0)) && SvOK(*s))
			e->button.deviceid = SvIV(*s);
		else
			e->button.deviceid = GDK_CORE_POINTER;
		break;
	case GDK_KEY_PRESS:
	case GDK_KEY_RELEASE:
		if (s=hv_fetch(h, "time", 4, 0))
			e->key.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "state", 5, 0))
			e->key.state = SvIV(*s);
		else
			croak("event must contain state");
		if (s=hv_fetch(h, "keyval", 6, 0))
			e->key.keyval = SvIV(*s);
		else
			croak("event must contain keyval");
	case GDK_FOCUS_CHANGE:
		if (s=hv_fetch(h, "in", 2, 0))
			e->focus_change.in = SvIV(*s);
		else
			croak("event must contain in");
		break;
	case GDK_ENTER_NOTIFY:
	case GDK_LEAVE_NOTIFY:
		if (s=hv_fetch(h, "window", 6, 0))
			e->crossing.window = SvGdkWindowRef(*s);
		else
			croak("event must contain window");
		if (s=hv_fetch(h, "subwindow", 9, 0))
			e->crossing.subwindow = SvGdkWindowRef(*s);
		else
			croak("event must contain subwindow");
		if (s=hv_fetch(h, "detail", 6, 0))
			e->crossing.detail = SvGdkNotifyType(*s);
		else
			croak("event must contain detail");
		break;
	case GDK_CONFIGURE:
		if (s=hv_fetch(h, "x", 1, 0))
			e->configure.x = SvIV(*s);
		else
			croak("event must contain x ordinate");
		if (s=hv_fetch(h, "y", 1, 0))
			e->configure.y = SvIV(*s);
		else
			croak("event must contain y ordinate");
		if (s=hv_fetch(h, "width", 5, 0))
			e->configure.width = SvIV(*s);
		else
			croak("event must contain width");
		if (s=hv_fetch(h, "height", 6, 0))
			e->configure.height = SvIV(*s);
		else
			croak("event must contain height");
		break;
	case GDK_PROPERTY_NOTIFY:
		if (s=hv_fetch(h, "time", 4, 0))
			e->property.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "state", 5, 0))
			e->property.state = SvIV(*s);
		else
			croak("event must contain state");
		if (s=hv_fetch(h, "atom", 4, 0))
			e->property.atom = SvGdkAtom(*s);
		else
			croak("event must contain atom");
		break;
	case GDK_SELECTION_CLEAR:
	case GDK_SELECTION_REQUEST:
	case GDK_SELECTION_NOTIFY:
		if (s=hv_fetch(h, "requestor", 9, 0))
			e->selection.requestor = SvIV(*s);
		else
			croak("event must contain requestor");
		if (s=hv_fetch(h, "time", 4, 0))
			e->selection.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "selection", 9, 0))
			e->selection.selection = SvGdkAtom(*s);
		else
			croak("event must contain selection");
		if (s=hv_fetch(h, "property", 8, 0))
			e->selection.property = SvGdkAtom(*s);
		else
			croak("event must contain property");
		break;
	case GDK_PROXIMITY_IN:
	case GDK_PROXIMITY_OUT:
		if (s=hv_fetch(h, "time", 4, 0))
			e->proximity.time = SvIV(*s);
		else
			croak("event must contain time");
		if (s=hv_fetch(h, "deviceid", 8, 0))
			e->proximity.deviceid = SvIV(*s);
		else
			croak("event must contain deviceid");
		break;
	}
	
	return e;
}

GdkWindowAttr * SvGdkWindowAttr(SV * data, GdkWindowAttr * attr, gint * mask)
{
	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
	
	if (!attr)
		attr = alloc_temp(sizeof(GdkWindowAttr));
	
	memset(attr, 0, sizeof(GdkWindowAttr));
	
	*mask = 0;

	h = (HV*)SvRV(data);
	
	if (s=hv_fetch(h, "title", 5, 0)) {
		attr->title = SvPV(*s,na);
		*mask |= GDK_WA_TITLE;
	}
	
	if (s=hv_fetch(h, "x", 1, 0)) {
		attr->x = SvIV(*s);
		*mask |= GDK_WA_X;
	}
	
	if (s=hv_fetch(h, "y", 1, 0)) {
		attr->y = SvIV(*s);
		*mask |= GDK_WA_Y;
	}
	
	if (s=hv_fetch(h, "cursor", 6, 0)) {
		attr->cursor = SvGdkCursorRef(*s);
		*mask |= GDK_WA_CURSOR;
	}
	
	if (s=hv_fetch(h, "colormap", 8, 0)) {
		attr->colormap = SvGdkColormapRef(*s);
		*mask |= GDK_WA_COLORMAP;
	}
	
	if (s=hv_fetch(h, "visual", 6, 0)) {
		attr->visual = SvGdkVisualRef(*s);
		*mask |= GDK_WA_VISUAL;
	}

	if (s=hv_fetch(h, "window_type",11, 0))
		attr->window_type = SvGdkWindowType(*s);
	else
		croak("window attribute must have window_type");
	if (s=hv_fetch(h, "event_mask",10, 0))
		attr->event_mask = SvGdkEventMask(*s);
	else
		croak("window attribute must have event_mask");
	if (s=hv_fetch(h, "width",5, 0))
		attr->width = SvIV(*s);
	else
		croak("window attribute must have width");
	if (s=hv_fetch(h, "height",6, 0))
		attr->height = SvIV(*s);
	else
		croak("window attribute must have height");
	if (s=hv_fetch(h, "wclass",6, 0))
		attr->wclass = SvGdkWindowClass(*s);
	else
		attr->wclass = GDK_INPUT_OUTPUT;

	return attr;
}

