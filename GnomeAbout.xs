
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

MODULE = Gtk::Gnome::About		PACKAGE = Gtk::Gnome::About		PREFIX = gnome_about_

#ifdef GNOME_ABOUT

Gtk::Gnome::About_Sink
new(Class, title=0, version=0, copyright=0, authors=0, comments=0, logo=0)
	SV *	Class
	char *	title
	char *	version
	char *	copyright
	SV *	authors
	char *	comments
	char *	logo
	CODE:
	{
		char ** a = 0;
		if (SvOK(authors)) {
			if (SvRV(authors) && (SvTYPE(SvRV(authors)) == SVt_PVAV)) {
				AV * av = (AV*)SvRV(authors);
				int i;
				a = (char**)malloc(sizeof(char*) * (av_len(av)+2));
				for(i=0;i<=av_len(av);i++) {
					a[i] = SvPV(*av_fetch(av, i, 0), na);
				}
				a[i] = 0;
			} else {
				a = (char**)malloc(sizeof(char*) * 2);
				a[0] = SvPV(authors, na);
				a[1] = 0;
			}
		}
		RETVAL = GNOME_ABOUT(gnome_about_new(title, version, copyright, a, comments, logo));
		if (a)
			free(a);
	}
	OUTPUT:
	RETVAL

#endif

