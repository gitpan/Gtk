
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

MODULE = Gtk::CTree		PACKAGE = Gtk::CTree		PREFIX = gtk_ctree_

#ifdef GTK_CTREE

Gtk::CTree_Sink
gtk_ctree_new(Class, columns, tree_column)
	SV *	Class
	int	columns
	int	tree_column
	CODE:
	RETVAL = GTK_CTREE(gtk_ctree_new(columns, tree_column));
	OUTPUT:
	RETVAL

Gtk::CTree_Sink
gtk_ctree_new_with_titles(Class, tree_column, title, ...)
	SV *	Class
	int	tree_column
	SV *	title
	CODE:
	{
		int columns = items - 2;
		int i;
		char** titles = malloc(columns * sizeof(gchar*));
		for (i=2; i < items; ++i)
			titles[i-2] = SvPV(ST(i),na);
		RETVAL = GTK_CTREE(gtk_ctree_new_with_titles(columns, tree_column, titles));
		free(titles);
	}
	OUTPUT:
	RETVAL


void
gtk_ctree_construct(self, tree_column, title, ...)
	Gtk::CTree	self
	int		tree_column
	SV *		title
	CODE:
	{
		int columns = items - 2;
		int i;
		char** titles = malloc(columns * sizeof(gchar*));
		for (i=2; i < items; ++i)
			titles[i-2] = SvPV(ST(i),na);
		gtk_ctree_construct(self, columns, tree_column, titles);
		free(titles);
	}

Gtk::CTreeNode
gtk_ctree_insert(self, parent, sibling, titles, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded)
	Gtk::CTree	self
	Gtk::CTreeNode	parent
	Gtk::CTreeNode	sibling
	SV*		titles
	int		spacing
	Gtk::Gdk::Pixmap	pixmap_closed
	Gtk::Gdk::Bitmap	mask_closed
	Gtk::Gdk::Pixmap	pixmap_opened
	Gtk::Gdk::Bitmap	mask_opened
	bool		is_leaf
	bool		expanded
	CODE:
	{
		char** titlesa;
		AV* av;
		SV** temp;
		int i;
		if (!SvROK(titles) || (SvTYPE(SvRV(titles)) != SVt_PVAV))
			croak("titles must be a reference to an array");
		av = (AV*)SvRV(titles);
		titlesa = (char**)malloc(sizeof(char*) * (av_len(av)+2));
		for(i = 0; i <= av_len(av); ++i) {
			temp = av_fetch(av,i,0);
			titlesa[i] = temp?SvPV(*temp,na):"";
		}
		titlesa[i]=0;
		RETVAL = gtk_ctree_insert(self, parent, sibling, titlesa, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded);
		free(titlesa);
	}
	OUTPUT:
	RETVAL

void
gtk_ctree_remove(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

bool
gtk_ctree_is_visible(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

Gtk::CTreeNode
gtk_ctree_last(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

int
gtk_ctree_find(self, node, child)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	child

bool
gtk_ctree_is_ancestor(self, node, child)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	child

void
gtk_ctree_move(self, node, new_parent, new_sibling)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	new_parent
	Gtk::CTreeNode	new_sibling

void
gtk_ctree_expand(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_expand_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_expand_to_depth(self, node, depth)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int		depth

void
gtk_ctree_collapse(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_collapse_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_collapse_to_depth(self, node, depth)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int		depth


bool
gtk_ctree_is_hot_spot(self, x, y)
	Gtk::CTree	self
	int		x
	int		y


#endif

