
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



MODULE = Gtk::ProgressBar11		PACKAGE = Gtk::ProgressBar		PREFIX = gtk_progress_bar_

#ifdef GTK_PROGRESS_BAR

Gtk::ProgressBar_Sink
new_with_adjustment(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	RETVAL = GTK_PROGRESS_BAR(gtk_progress_bar_new_with_adjustment(adjustment));
	OUTPUT:
	RETVAL

void
gtk_progress_bar_set_bar_style(self, style)
	Gtk::ProgressBar	self
	Gtk::ProgressBarStyle	style

void
gtk_progress_bar_set_discrete_blocks(self, blocks)
	Gtk::ProgressBar	self
	int	blocks

void
gtk_progress_bar_set_activity_step(self, step)
	Gtk::ProgressBar	self
	int	step

void
gtk_progress_bar_set_activity_blocks(self, blocks)
	Gtk::ProgressBar	self
	int	blocks

void
gtk_progress_bar_set_orientation(self, orientation)
	Gtk::ProgressBar	self
	Gtk::ProgressBarOrientation	orientation

#endif
