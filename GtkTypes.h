
/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */
   
typedef GtkMenuFactory * Gtk__MenuFactory;

#define newSVGdkBitmap newSVGdkPixmap
#define newSVGdkWindow newSVGdkPixmap
#define SvGdkBitmap SvGdkPixmap
#define SvGdkWindow SvGdkPixmap

typedef GtkWidget * upGtk__Widget;

#define CastupGtk__Widget GTK_WIDGET

extern void UnregisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern void RegisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern SV * RetrieveGtkObject(GtkObject * gtk_object);

extern SV * newSVGtkObjectRef(GtkObject * object, char * classname);
extern GtkObject * SvGtkObjectRef(SV * o, char * name);
extern void disconnect_GtkObjectRef(SV * o);

extern SV * newSVGtkMenuEntry(GtkMenuEntry * o);
extern GtkMenuEntry * SvGtkMenuEntry(SV * o, GtkMenuEntry * e);

int type_name(char * name);
