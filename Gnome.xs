
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

void GtkInit_internal(void);

extern int did_we_init_gdk, did_we_init_gtk;
int did_we_init_gnome = 0;

MODULE = Gtk::Gnome		PACKAGE = Gtk::Gnome		PREFIX = gnome_

void
init(Class, app_id)
	SV *	Class
	char *	app_id
	CODE:
	{
		if (!did_we_init_gdk && !did_we_init_gtk && !did_we_init_gnome) {
			struct argp parser = { };
			int argc;
			char ** argv = 0;
			AV * ARGV = perl_get_av("ARGV", FALSE);
			SV * ARGV0 = perl_get_sv("0", FALSE);
			int i;
			
			printf("In Gtk::Gnome::Init\n");
			
			argc = av_len(ARGV)+2;
			if (argc) {
				argv = malloc(sizeof(char*)*argc);
				argv[0] = SvPV(ARGV0, na);
				for(i=0;i<=av_len(ARGV);i++)
					argv[i+1] = SvPV(*av_fetch(ARGV, i, 0), na);
			}
			
			i = argc;
			gnome_init(app_id, NULL /*&parser*/, argc, argv, 0, &i);

			did_we_init_gdk = 1;
			did_we_init_gtk = 1;
			did_we_init_gnome = 1;
			
			while (i--)
				av_shift(ARGV);
			
			if (argv)
				free(argv);
				
			GtkInit_internal();
		}
	}

