
/* Copyright (C) 1997,1998, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */

#include "inc.h"
   
typedef GtkMenuFactory * Gtk__MenuFactory;
typedef GtkSelectionData * Gtk__SelectionData;

typedef GtkWidget * Gtk__Widget_Up;
typedef GtkWidget * Gtk__Widget_Sink_Up;

#define CastupGtk__Widget GTK_WIDGET

extern void UnregisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern void RegisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern SV * RetrieveGtkObject(GtkObject * gtk_object);

extern SV * newSVGtkObjectRef(GtkObject * object, char * classname);
extern GtkObject * SvGtkObjectRef(SV * o, char * name);
extern void disconnect_GtkObjectRef(SV * o);

extern SV * newSVGtkMenuEntry(GtkMenuEntry * o);
extern GtkMenuEntry * SvGtkMenuEntry(SV * o, GtkMenuEntry * e);
 
extern SV * newSVGtkSelectionDataRef(GtkSelectionData * o);
extern GtkSelectionData * SvGtkSelectionDataRef(SV * data);

extern void GCGtkObjects(void);

extern void FreeHVObject(HV * hv_object);

int type_name(char * name);

extern void FindArgumentType(GtkObject * object, SV * name, GtkArg * result);

#ifdef GTK_TTY

#define gtk_vtemu_ref(x) do{}while(0)
#define gtk_vtemu_unref(x) do{}while(0)

#endif

