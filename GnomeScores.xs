
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

MODULE = Gtk::Gnome::Scores		PACKAGE = Gtk::Gnome::Scores		PREFIX = gnome_scores_

#ifdef GNOME_SCORES

Gtk::Gnome::Scores_Sink
new(Class, clear, ...)
	SV *	Class
	bool	clear
	CODE:
	{
		int count = items-2;
		char ** names;
		float * scores;
		time_t * times;
		int i;
		
		names = (char**)malloc(sizeof(char*) * (count+1));
		scores = (float*)malloc(sizeof(float) * (count+1));
		times = (time_t*)malloc(sizeof(time_t) * (count+1));
		
		for(i=2;i<items;i++) {
			if (SvOK(ST(i)) && SvRV(ST(i)) && (SvTYPE(SvRV(ST(i))) == SVt_PVAV)) {
				AV * av = (AV*)SvRV(ST(i));
				names[i-2] = SvPV(*av_fetch(av, 0, 0), na);
				scores[i-2] = SvNV(*av_fetch(av, 1, 0));
				times[i-2] = SvIV(*av_fetch(av, 2, 0));
			} else {
				names[i-2] = 0;
				scores[i-2] = 0;
				times[i-2] = 0;
			}
		}

		RETVAL = GNOME_SCORES(gnome_scores_new(count, names, scores, times, clear));
		
		free(names);
		free(scores);
		free(times);
	}
	OUTPUT:
	RETVAL

void
gnome_scores_display(Class, title, app_name, level, pos)
	SV *	Class
	char *	title
	char *	app_name
	char *	level
	int	pos
	CODE:
	gnome_scores_display(title, app_name, level, pos);

void
gnome_scores_set_logo_label(gs, txt, font, color)
	Gtk::Gnome::Scores	gs
	char *	txt
	char *	font
	Gtk::Gdk::Color	color

void
gnome_scores_set_logo_pixmap(gs, logo)
	Gtk::Gnome::Scores	gs
	char *	logo

void
gnome_scores_set_logo_widget(gs, w)
	Gtk::Gnome::Scores	gs
	Gtk::Widget	w

void
gnome_scores_set_color(gs, pos, color)
	Gtk::Gnome::Scores	gs
	int	pos
	Gtk::Gdk::Color	color

void
gnome_scores_set_def_color(gs, color)
	Gtk::Gnome::Scores	gs
	Gtk::Gdk::Color	color

void
gnome_scores_set_colors(gs, color)
	Gtk::Gnome::Scores	gs
	Gtk::Gdk::Color	color

void
gnome_scores_set_logo_label_title(gs, txt)
	Gtk::Gnome::Scores	gs
	char *	txt

void
gnome_scores_set_current_player(gs, i)
	Gtk::Gnome::Scores	gs
	int	i

#endif