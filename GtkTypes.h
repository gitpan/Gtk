\
/* Copyright (C) 1997,1998, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */

#include "inc.h"

/*extern HV * signal_fixups;*/

/*typedef GtkNotebookPage * Gtk__NotebookPage;
typedef GtkBoxChild * Gtk__BoxChild;   */
typedef GtkMenuFactory * Gtk__MenuFactory;
typedef GtkSelectionData * Gtk__SelectionData;

typedef GtkWidget * Gtk__Widget_Up;
typedef GtkWidget * Gtk__Widget_Sink_Up;
typedef GtkWidget * Gtk__Widget_OrNULL_Up;

#define CastupGtk__Widget GTK_WIDGET

typedef GtkObject * Gtk__Object_Up;
typedef GtkObject * Gtk__Object_Sink_Up;
typedef GtkObject * Gtk__Object_OrNULL_Up;

#define CastupGtk__Object GTK_OBJECT

extern void UnregisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern void RegisterGtkObject(SV * sv_object, GtkObject * gtk_object);
extern SV * RetrieveGtkObject(GtkObject * gtk_object);

extern SV * newSVGtkObjectRef(GtkObject * object, char * classname);
extern GtkObject * SvGtkObjectRef(SV * o, char * name);
extern void disconnect_GtkObjectRef(SV * o);

extern SV * newSVGtkMenuEntry(GtkMenuEntry * o);
extern GtkMenuEntry * SvGtkMenuEntry(SV * o, GtkMenuEntry * e);

extern SV * newSVGtkRequisition(GtkRequisition * o);
extern GtkRequisition * SvGtkRequisition(SV * o, GtkRequisition * e);
 
extern SV * newSVGtkSelectionDataRef(GtkSelectionData * o);
extern GtkSelectionData * SvGtkSelectionDataRef(SV * data);

/*
#define newSVGtkNotebookPage(n) newSVMiscRef(n, "Gtk::NotebookPage", 0)
#define SvGtkNotebookPage(data) ((GtkNotebookPage*)SvMiscRef(data, "Gtk::NotebookPage"))

#define newSVGtkBoxChild(n) newSVMiscRef(n, "Gtk::BoxChild", 0)
#define SvGtkBoxChild(data) ((GtkBoxChild*)SvMiscRef(data, "Gtk::BoxChild"))
*/

extern void GCGtkObjects(void);

extern void FreeHVObject(HV * hv_object);

int type_name(char * name);

extern GtkType FindArgumentType(GtkObject * object, SV * name, GtkArg * result);

#ifdef GTK_TTY

#define gtk_vtemu_ref(x) do{}while(0)
#define gtk_vtemu_unref(x) do{}while(0)

#endif

