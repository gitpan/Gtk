
/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   

typedef GdkWindow * Gtk__Gdk__Window;
typedef GdkPixmap * Gtk__Gdk__Pixmap;
typedef GdkBitmap * Gtk__Gdk__Bitmap;
typedef GdkVisual * Gtk__Gdk__Visual;
typedef GdkColormap * Gtk__Gdk__Colormap;
typedef GdkCursor * Gtk__Gdk__Cursor;
typedef GdkGC * Gtk__Gdk__GC;
typedef GdkFont * Gtk__Gdk__Font;
typedef GdkImage * Gtk__Gdk__Image;
typedef GdkGCValues * Gtk__Gdk__GCValues;
typedef GdkDeviceInfo * Gtk__Gdk__DeviceInfo;
typedef GdkDeviceTimeCoord * Gtk__Gdk__DeviceTimeCoord;

typedef GdkEvent * Gtk__Gdk__Event;
typedef GdkRectangle * Gtk__Gdk__Rectangle;
typedef GdkColor * Gtk__Gdk__Color;
typedef GdkImageType Gtk__Gdk__ImageType;
typedef GdkWindowType Gtk__Gdk__WindowType;
typedef GdkSubwindowMode Gtk__Gdk__SubwindowMode;
typedef GdkLineStyle Gtk__Gdk__LineStyle;
typedef GdkJoinStyle Gtk__Gdk__JoinStyle;
typedef GdkFunction Gtk__Gdk__Function;
typedef GdkFill Gtk__Gdk__Fill;
typedef GdkAtom Gtk__Gdk__Atom;
typedef GdkCapStyle Gtk__Gdk__CapStyle;
typedef GdkEventMask Gtk__Gdk__EventMask;
typedef GdkInputCondition Gtk__Gdk__InputCondition;
typedef GdkModifierType Gtk__Gdk__ModifierType;
typedef GdkGCValuesMask Gtk__Gdk__ValuesMask;
typedef GdkGCValues Gtk__Gdk__Values;
typedef GdkInputSource Gtk__Gdk__InputSource;
typedef GdkInputMode Gtk__Gdk__InputMode;
typedef GdkAxisUse Gtk__Gdk__AxisUse;

extern int SvGtkGdkEventType(SV * value);
extern SV * newSVGtkGdkEventType(int value);
extern int SvGtkGdkModifierType(SV * value);
extern SV * newSVGtkGdkModifierType(int value);
extern int SvGtkGdkGCValuesMask(SV * value);
extern SV * newSVGtkGdkGCValuesMask(int value);
extern SV * newSVGtkGdkGCValues(GdkGCValues * v);
extern GdkGCValues * SvGtkGdkGCValues(SV * data, GdkGCValues * v, GdkGCValuesMask * m);
extern int SvGtkGdkWindowType(SV * value);
extern SV * newSVGtkGdkWindowType(int value);
extern int SvGtkGdkNotifyType(SV * value);
extern SV * newSVGtkGdkNotifyType(int value);
extern int SvGtkGdkVisualType(SV * value);
extern SV * newSVGtkGdkVisualType(int value);

extern int SvGtkGdkInputMode(SV * value);
extern SV * newSVGtkGdkInputMode(int value);
extern int SvGtkGdkInputSource(SV * value);
extern SV * newSVGtkGdkInputSource(int value);
extern int SvGtkGdkAxisUse(SV * value);
extern SV * newSVGtkGdkAxisUse(int value);

extern SV * newSVGtkGdkDeviceInfo(GdkDeviceInfo * i);
extern SV * newSVGtkGdkDeviceTimeCoord(GdkDeviceTimeCoord * i);

extern int SvGtkGdkSubwindowMode(SV * value);
extern SV * newSVGtkGdkSubwindowMode(int value);
extern int SvGtkGdkLineStyle(SV * value);
extern SV * newSVGtkGdkLineStyle(int value);
extern int SvGtkGdkFunction(SV * value);
extern SV * newSVGtkGdkFunction(int value);
extern int SvGtkGdkJoinStyle(SV * value);
extern SV * newSVGtkGdkJoinStyle(int value);
extern int SvGtkGdkFill(SV * value);
extern SV * newSVGtkGdkFill(int value);
extern int SvGtkGdkCapStyle(SV * value);
extern SV * newSVGtkGdkCapStyle(int value);
extern int SvGtkGdkWindowClass(SV * value);
extern SV * newSVGtkGdkWindowClass(int value);
extern int SvGtkGdkWindowType(SV * value);
extern SV * newSVGtkGdkWindowType(int value);
extern int SvGtkGdkCursorType(SV * value);
extern SV * newSVGtkGdkCursorType(int value);
extern int SvGtkGdkEventMask(SV * value);
extern SV * newSVGtkGdkEventMask(int value);
extern int SvGtkGdkInputCondition(SV * value);
extern SV * newSVGtkGdkInputCondition(int value);
extern SV * newSVGtkGdkWindowRef(GdkWindow * w);
extern GdkWindow * SvGtkGdkWindowRef(SV * data);
extern SV * newSVGtkGdkPixmapRef(GdkPixmap * w);
extern GdkPixmap * SvGtkGdkPixmapRef(SV * data);
extern SV * newSVGtkGdkBitmapRef(GdkBitmap * w);
extern GdkBitmap * SvGtkGdkBitmapRef(SV * data);
extern SV * newSVGtkGdkColormapRef(GdkColormap * w);
extern GdkColormap * SvGtkGdkColormapRef(SV * data);
extern SV * newSVGtkGdkCursorRef(GdkCursor * w);
extern GdkCursor * SvGtkGdkCursorRef(SV * data);
extern SV * newSVGtkGdkVisualRef(GdkVisual * w);
extern GdkVisual * SvGtkGdkVisualRef(SV * data);
extern SV * newSVGtkGdkGCRef(GdkGC * g);
extern GdkGC * SvGtkGdkGCRef(SV * data);
extern SV * newSVGtkGdkFontRef(GdkFont * f);
extern GdkFont * SvGtkGdkFontRef(SV * data);
extern SV * newSVGtkGdkImageRef(GdkImage * i);
extern GdkImage * SvGtkGdkImageRef(SV * data);
extern SV * newSVGtkGdkRectangle(GdkRectangle * rect);
extern GdkRectangle * SvGtkGdkRectangle(SV * data, GdkRectangle * rect);
extern SV * newSVGtkGdkColor(GdkColor * color);
extern GdkColor * SvGtkGdkColor(SV * data, GdkColor * color);
extern SV * newSVGtkGdkAtom(GdkAtom a);
extern GdkAtom SvGtkGdkAtom(SV * data);
extern SV * newSVGtkGdkEvent(GdkEvent * e);
extern GdkEvent * SvGtkGdkEvent(SV * data, GdkEvent * e);
extern GdkWindowAttr * SvGtkGdkWindowAttr(SV * data, GdkWindowAttr * attr, gint * mask);

