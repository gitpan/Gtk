#!/usr/bin/perl

foreach $file (<*.defs>) {
	open(F,"<$file");
	$_ .= join("",<F>);
	close(F);
}

$_ .= join("",<DATA>);

$_ =~ s/;.*$//gm;

%enum = ();

while (/\(define-enum\s+(\S+)((\s+\(\S+\s+\S+\))+)\)/gs) {
	my($a,$b) = ($1,$2);
	$enum{$a} = [];
	while ($b =~ /\((\S+)\s+(\S+)\)/gs) {
		push @{$enum{$a}}, [$1, $2];
	}
}

%boxed = ();

while (/\(define-boxed\s+(\S+)((\s+\S+?)+)\)/gs) {
	my($a,$b) = ($1,$2);
	$boxed{$a} = [];
	while ($b =~ /(\S+)/gs) {
		push @{$boxed{$a}}, $1;
	}
}

%flags = ();

while (/\(define-flags\s+(\S+)((\s+\(\S+\s+\S+\))+)\)/gs) {
	my($a,$b) = ($1,$2);
	$flags{$a} = [];
	while ($b =~ /\((\S+)\s+(\S+)\)/gs) {
		push @{$flags{$a}}, [$1, $2];
	}
}

%func = ();

while (/\(define-func\s+(\S+)\s+(\S+)((\s+\(\S+\s+\S+\))+)\)/gs) {
	my($a,$ret,$b) = ($1,$2,$3);
	$func{$a} = [$ret,[]];
	while ($b =~ /\((\S+)\s+(\S+)\)/gs) {
		push @{$func{$a}[1]}, [$1, $2];
	}
}

%object = ();

while (/\(define-object\s+(\S+)\s+\((\S*?)\)\)/gs) {
	my($a,$b,$c) = ($1,$1,$2);
	$b =~ s/([a-z])([A-Z])/${1}_$2/g;
	$b = uc $b;
	$object{$a} = [$b,$c];
}

sub perlize {
	local($_) = $_[0];
	s/^Gtk/Gtk::/;
	s/^Gtk::Gdk/Gtk::Gdk::/;
	s/^Gdk/Gtk::Gdk::/;
	$_;
}

sub xsize {
	local($_) = perlize($_[0]);
	s/::/__/g;
	$_;
}


# Exceptions

$boxed{GdkPixmap} = $boxed{GdkWindow};
delete $boxed{GdkWindow};
delete $boxed{GdkEvent};

open(STDOUT,">typemap.gtk");
print "TYPEMAP\n";
$i = 0;
foreach (sort keys %enum) {
	print perlize($_),"\tT_SimpleVal\n";
	$i++;
}
foreach (sort keys %flags) {
	print perlize($_),"\tT_SimpleVal\n";
	$i++;
}
foreach (sort keys %object) {
	print perlize($_),"\tT_GtkPTROBJ\n";
}
foreach (sort keys %boxed) {
	print perlize($_),"\tT_SimpleVal\n"; #MISCPTROBJ\n";
}

open(STDOUT,">GtkDefs.h");
print <<"EOT";
extern HV * pGtkType[];
extern char * pGtkTypeName[];
extern HV * pG_EnumHash;
extern HV * pG_FlagsHash;
extern AV * gtk_typecasts;
extern int type_name(char * name);

extern void add_typecast(int type, char * perlName);
extern SV * GtkGetArg(GtkArg * a);
extern void GtkSetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);
extern void GtkSetRetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);

/*extern SV * newSVOptsHash(long value, char * name, HV * hash);
extern long SvOptsHash(SV * value, char * name, HV * hash);
extern SV * newSVFlagsHash(long value, char * name, HV * hash, int);
extern long SvFlagsHash(SV * value, char * name, HV * hash);*/

EOT
$i = 0;
foreach (sort keys %enum) {
	print "#define pGE_$_ pGtkType[$i]\n";
	print "#define pGEName_$_ pGtkTypeName[$i]\n";
	print "#define newSV$_(v) newSVOptsHash(v, pGEName_$_, pGE_$_)\n";
	print "#define Sv$_(v) SvOptsHash(v, pGEName_$_, pGE_$_)\n";
	$p = perlize($_);
	$p =~ s/:/_/g;
	print "#define $p $_\n";
	$i++;
}
foreach (sort keys %flags) {
	print "#define pGF_$_ pGtkType[$i]\n";
	print "#define pGFName_$_ pGtkTypeName[$i]\n";
	print "#define newSV$_(v) newSVFlagsHash(v, pGFName_$_, pGF_$_, 1)\n";
	print "#define Sv$_(v) SvFlagsHash(v, pGFName_$_, pGF_$_)\n";
	$p = perlize($_);
	$p =~ s/:/_/g;
	print "#define $p $_\n";
	$i++;
}
foreach (sort keys %boxed) {
	$p = perlize($_);
	$q = $p;
	$q =~ s/::/__/g;
	print "extern SV * newSV$_($_ * value);\n";
	print "extern $_ * Sv$_(SV * value);\n";
	print "typedef $_ * $q;\n";
}
foreach (sort keys %object) {
	$p = xsize($_);
#	$p =~ s/:/_/g;
#	$q = $p;
#	$q =~ s/__/_/g;
#	$q =~ s/([a-z])([A-Z])/$1_$2/g;
#	$q = uc $q;
	print "typedef $_ * $p;\n";
	print "#define Cast$p $object{$_}[0]\n";
}

open(STDOUT,">GtkTypes.pm");
print "package Gtk::Types;\n";
foreach (sort keys %object) {
	$p = perlize($_);
	$q = perlize($object{$_}[1]);
	print "\@${p}::ISA = qw($q);\n";
}
print "1;\n";

open(STDOUT,">GtkDefs.c");
print <<"EOT";
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <gtk/gtk.h>

#include "GtkTypes.h"
#include "GdkTypes.h"
#include "MiscTypes.h"
#include "GtkDefs.h"

HV * pGtkType[$i];
char * pGtkTypeName[$i];
HV * pG_EnumHash;
HV * pG_FlagsHash;

AV * gtk_typecasts = 0;
static HV * types = 0;

void add_typecast(int type, char * perlName)
{
	/*GtkObjectClass * klass = gtk_type_class(type);*/
	av_extend(gtk_typecasts, type/* klass->type*/);
	av_store(gtk_typecasts, type/*klass->type*/, newSVpv(perlName, 0));
	hv_store(types, perlName, strlen(perlName), newSViv(type), 0);
}

int type_name(char * name) {
	SV ** s = hv_fetch(types, name, strlen(name), 0);
	if (s)
		return SvIV(*s);
	else
		return 0;
}

EOT

foreach (sort keys %boxed) {
	$p = perlize($_);
	print <<"EOT";

SV * newSV$_($_ * value) {
	int n = 0;
	SV * result = newSVMiscRef(value, "$p", &n);
	if (n)
		$boxed{$_}[0](value);
	return result;
}

$_ * Sv$_(SV * value) { return ($_*)SvMiscRef(value, "$p"); }
EOT
}

print <<"EOT";

SV * GtkGetArg(GtkArg * a)
{
	SV * result;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_BOOL:	result = newSViv(GTK_VALUE_BOOL(*a)); break;
		case GTK_TYPE_CHAR:	result = newSViv(GTK_VALUE_CHAR(*a)); break;
		case GTK_TYPE_INT:	result = newSViv(GTK_VALUE_INT(*a)); break;
		case GTK_TYPE_LONG:	result = newSViv(GTK_VALUE_LONG(*a)); break;
		case GTK_TYPE_UINT:	result = newSViv(GTK_VALUE_UINT(*a)); break;
		case GTK_TYPE_ULONG:	result = newSViv(GTK_VALUE_ULONG(*a)); break;
		case GTK_TYPE_FLOAT:	result = newSVnv(GTK_VALUE_FLOAT(*a)); break;	
		case GTK_TYPE_STRING:	result = newSVpv(GTK_VALUE_STRING(*a),0); break;
		case GTK_TYPE_POINTER:	result = newSVpv(GTK_VALUE_POINTER(*a),0); break;
		case GTK_TYPE_OBJECT:	result = newSVGtkObjectRef(GTK_VALUE_OBJECT(*a), 0); break;
		case GTK_TYPE_SIGNAL:
		{
			AV * args = (AV*)GTK_VALUE_SIGNAL(*a).d;
			SV ** s;
			if ((GTK_VALUE_SIGNAL(*a).f != 0) ||
				(!args) ||
				(SvTYPE(args) != SVt_PVAV) ||
				(av_len(args) < 3) ||
				!(s = av_fetch(args, 2, 0))
				)
				croak("Unable to return a foreign signal type to Perl");

			result = newSVsv(*s);
			return;
		}
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				result = newSV$_(GTK_VALUE_ENUM(*a));\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT

foreach (sort keys %flags) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				result = newSV$_(GTK_VALUE_FLAGS(*a));\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				result = newSVGdkEvent(GTK_VALUE_BOXED(*a));
			else
EOT

foreach (sort keys %boxed) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				result = newSV$_(GTK_VALUE_BOXED(*a));\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		d_fault:
		default:
			croak("Cannot get argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	}
	return result;
}

void GtkSetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object)
{
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:		GTK_VALUE_CHAR(*a) = SvIV(v); break;
		case GTK_TYPE_BOOL:		GTK_VALUE_BOOL(*a) = SvIV(v); break;
		case GTK_TYPE_INT:		GTK_VALUE_INT(*a) = SvIV(v); break;
		case GTK_TYPE_UINT:		GTK_VALUE_UINT(*a) = SvIV(v); break;
		case GTK_TYPE_LONG:		GTK_VALUE_LONG(*a) = SvIV(v); break;
		case GTK_TYPE_ULONG:	GTK_VALUE_ULONG(*a) = SvIV(v); break;
		case GTK_TYPE_FLOAT:	GTK_VALUE_FLOAT(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	GTK_VALUE_STRING(*a) = SvPV(v,na); break;
		case GTK_TYPE_POINTER:	GTK_VALUE_POINTER(*a) = SvPV(v,na); break;
		case GTK_TYPE_OBJECT:	GTK_VALUE_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object"); break;
		case GTK_TYPE_SIGNAL:
		{
			AV * args;
			int i,j;
			int type;
			char * c = strchr(a->name, ':');
			c+=2;
			c = strchr(c, ':');
			c += 2;
			args = newAV();

			type = gtk_signal_lookup(c, Object->klass->type);

			av_push(args, newSVsv(Class));
			av_push(args, newSVpv(c, 0));
			av_push(args, newSVsv(v));
			av_push(args, newSViv(type));

			GTK_VALUE_SIGNAL(*a).f = 0;
			GTK_VALUE_SIGNAL(*a).d = args;
			return;
		}
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				GTK_VALUE_ENUM(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}
print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT
foreach (sort keys %flags) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				GTK_VALUE_FLAGS(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				GTK_VALUE_BOXED(*a) = SvGdkEvent(v);
			else
EOT
foreach (sort keys %boxed) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				GTK_VALUE_BOXED(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		d_fault:
		default:
			croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	}
}

void GtkSetRetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object)
{
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:		*GTK_RETLOC_CHAR(*a) = SvIV(v); break;
		case GTK_TYPE_BOOL:		*GTK_RETLOC_BOOL(*a) = SvIV(v); break;
		case GTK_TYPE_INT:		*GTK_RETLOC_INT(*a) = SvIV(v); break;
		case GTK_TYPE_UINT:		*GTK_RETLOC_UINT(*a) = SvIV(v); break;
		case GTK_TYPE_LONG:		*GTK_RETLOC_LONG(*a) = SvIV(v); break;
		case GTK_TYPE_ULONG:	*GTK_RETLOC_ULONG(*a) = SvIV(v); break;
		case GTK_TYPE_FLOAT:	*GTK_RETLOC_FLOAT(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	*GTK_RETLOC_STRING(*a) = SvPV(v,na); break;
		case GTK_TYPE_POINTER:	*GTK_RETLOC_POINTER(*a) = SvPV(v,na); break;
		case GTK_TYPE_OBJECT:	*GTK_RETLOC_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object"); break;
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				*GTK_RETLOC_ENUM(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}
print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT
foreach (sort keys %flags) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				*GTK_RETLOC_FLAGS(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				*GTK_RETLOC_BOXED(*a) = SvGdkEvent(v);
			else
EOT
foreach (sort keys %boxed) {
	$p = $_;
	$p =~ s/^Gtk//;
	$p =~ s/([a-z])([A-Z])/$1_$2/g;
	$p = "GTK_TYPE_" . uc $p;
	print "#ifdef $p\n";
	print "			if (a->type == $p)\n";
	print "				GTK_VALUE_BOXED(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n";
}

print <<"EOT";
				goto d_fault;
			break;
		d_fault:
		default:
			croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	}
}

void initPerlGtkDefs(void) {
	int i;
	HV * h;
	pG_EnumHash = newHV();
	pG_FlagsHash = newHV();
	
EOT
$i = 0;
foreach (sort keys %enum) {
	$p = perlize($_);
	print "\n	h = newHV();\n";
	print "	pGtkType[$i] = h;\n";
	print "	pGtkTypeName[$i] = \"$p\";\n";
	for ($j=0;$j<@{$enum{$_}};$j++) {
		$p = $enum{$_}[$j][0];
		print "	hv_store(h, \"$p\", ", length($p), ", newSViv(", $enum{$_}[$j][1],"), 0);\n";
	}
	$p = perlize($_);
	print "	hv_store(pG_EnumHash, \"$p\", ", length($p), ", newRV((SV*)h), 0);\n";
	print " SvREFCNT_dec(h);\n";
	$i++;
}

foreach (sort keys %flags) {
	$p = perlize($_);
	print "\n	h = newHV();\n";
	print "	pGtkType[$i] = h;\n";
	print "	pGtkTypeName[$i] = \"$p\";\n";
	for ($j=0;$j<@{$flags{$_}};$j++) {
		$p = $flags{$_}[$j][0];
		print "	hv_store(h, \"$p\", ", length($p), ", newSViv(", $flags{$_}[$j][1],"), 0);\n";
	}
	$p = perlize($_);
	print "	hv_store(pG_FlagsHash, \"$p\", ", length($p), ", newRV((SV*)h), 0);\n";
	print " SvREFCNT_dec(h);\n";
	$i++;
}
print <<"EOT";

	/*for(i=0;i<$i;i++) {
		HV * p = perl_get_hv(pGtkTypeName[i], TRUE);
		sv_setsv((SV*)p, (SV*)pGtkType[i]);
	}*/

	gtk_typecasts = newAV();
	types = newHV();

EOT
foreach (sort keys %object) {
	$p = perlize($_);
	print "\tadd_typecast(", lc $object{$_}[0], "_get_type(),	\"$p\");\n"
		;#unless /preview/i;
}


print "}\n";


open(STDOUT,">boxed.xsh");

foreach (sort keys %boxed) {
	$p = perlize($_);
	print <<"EOT";
	
MODULE = Gtk	PACKAGE = $p

void
DESTROY(self)
	$p	self
	CODE:
	UnregisterMisc((HV*)SvRV(ST(0)), (void*)self);
	$boxed{$_}[1](self);

EOT
}

open(STDOUT,">objects.xsh");

foreach (sort keys %object) {
	$p = perlize($_);
	$c = lc $object{$_}->[0];
	print <<"EOT";
	
MODULE = Gtk	PACKAGE = $p		PREFIX = ${c}_

int
${c}_get_type(self)
	$p	self
	CODE:
	RETVAL = ${c}_get_type();
	OUTPUT:
	RETVAL

int
${c}_get_size(self)
	$p	self
	CODE:
	RETVAL = sizeof($_);
	OUTPUT:
	RETVAL


int
${c}_get_class_size(self)
	$p	self
	CODE:
	RETVAL = sizeof(${_}Class);
	OUTPUT:
	RETVAL

EOT
}

pos = 0;

__END__;

additions over gtk.defs from gtk+970925:

(define-enum GtkCurveType
  (linear GTK_CURVE_TYPE_LINEAR)
  (spline GTK_CURVE_TYPE_SPLINE)
  (free GTK_CURVE_TYPE_FREE))

(define-enum GtkSelectionMode
  (single GTK_SELECTION_SINGLE)
  (browse GTK_SELECTION_BROWSE)
  (multiple GTK_SELECTION_MULTIPLE)
  (extended GTK_SELECTION_EXTENDED))

(define-enum GdkFunction
  (copy GDK_COPY)
  (invert GDK_INVERT)
  (xor GDK_XOR)) 

(define-enum GdkFill
  (solid GDK_SOLID)
  (tiled GDK_TILED)
  (stippled GDK_STIPPLED)
  (opaque-stippled GDK_OPAQUE_STIPPLED))

(define-enum GdkLineStyle
  (solid GDK_LINE_SOLID)
  (on-off-dash GDK_LINE_ON_OFF_DASH)
  (double-dash GDK_LINE_DOUBLE_DASH))

(define-enum GdkInputMode
  (disabled GDK_MODE_DISABLED)
  (screen GDK_MODE_SCREEN)
  (window GDK_MODE_WINDOW))

(define-enum GdkInputSource
  (mouse GDK_SOURCE_MOUSE)
  (pen GDK_SOURCE_PEN)
  (eraser GDK_SOURCE_ERASER)
  (cursor GDK_SOURCE_CURSOR))


(define-enum GdkAxisUse
  (ignore GDK_AXIS_IGNORE)
  (x GDK_AXIS_X)
  (y GDK_AXIS_Y)
  (pressure GDK_AXIS_PRESSURE)
  (xtilt GDK_AXIS_XTILT)
  (ytilt GDK_AXIS_YTILT)
  (last GDK_AXIS_LAST))

(define-enum GtkJustification
  (left GTK_JUSTIFY_LEFT)
  (right GTK_JUSTIFY_RIGHT)
  (center GTK_JUSTIFY_CENTER)
  (fill GTK_JUSTIFY_FILL))

(define-enum GdkDndType
  (not-dnd GDK_DNDTYPE_NOTDND)
  (unknown GDK_DNDTYPE_UNKNOWN)
  (raw-data GDK_DNDTYPE_RAWDATA)
  (file GDK_DNDTYPE_FILE)
  (files GDK_DNDTYPE_FILES)
  (text GDK_DNDTYPE_TEXT)
  (dir GDK_DNDTYPE_DIR)
  (link GDK_DNDTYPE_LINK)
  (exe GDK_DNDTYPE_EXE)
  (url GDK_DNDTYPE_URL)
  (mime GDK_DNDTYPE_MIME)
  (end GDK_DNDTYPE_END))

(define-boxed GtkTooltips
  gtk_tooltips_ref
  gtk_tooltips_unref)

(define-enum GtkUpdateType
  (continuous GTK_UPDATE_CONTINUOUS)
  (discontinuous GTK_UPDATE_DISCONTINUOUS)
  (delayed GTK_UPDATE_DELAYED))

(define-object GtkAdjustment (GtkData))
(define-object GtkAspectFrame (GtkFrame))
(define-object GtkAlignment (GtkBin))
(define-object GtkArrow (GtkMisc))
(define-object GtkBin (GtkContainer))
(define-object GtkBox (GtkContainer))
(define-object GtkButton (GtkContainer))
(define-object GtkCheckButton (GtkToggleButton))
(define-object GtkColorSelection (GtkVBox))
(define-object GtkColorSelectionDialog (GtkWindow))
(define-object GtkContainer (GtkWidget))
(define-object GtkCurve (GtkDrawingArea))
(define-object GtkData (GtkObject))
(define-object GtkDialog (GtkWindow))
(define-object GtkDrawingArea (GtkWidget))
(define-object GtkEntry (GtkWidget))
(define-object GtkFileSelection (GtkWindow))
(define-object GtkFrame (GtkBin))
(define-object GtkGammaCurve (GtkVBox))
(define-object GtkHBox (GtkBox))
(define-object GtkHPaned (GtkPaned))
(define-object GtkHRuler (GtkRuler))
(define-object GtkHScale (GtkScale))
(define-object GtkHScrollbar (GtkScrollbar))
(define-object GtkHSeparator (GtkSeparator))
(define-object GtkImage (GtkMisc))
(define-object GtkInputDialog (GtkWindow))
(define-object GtkItem (GtkBin))
(define-object GtkLabel (GtkMisc))
(define-object GtkList (GtkContainer))
(define-object GtkListItem (GtkItem))
(define-object GtkMenu (GtkMenuShell))
(define-object GtkMenuBar (GtkMenuShell))
(define-object GtkMenuItem (GtkItem))
(define-object GtkMenuShell (GtkContainer))
(define-object GtkMisc (GtkWidget))
(define-object GtkNotebook (GtkContainer))
(define-object GtkObject ())
(define-object GtkOptionMenu (GtkButton))
(define-object GtkPaned (GtkContainer))
(define-object GtkPixmap (GtkMisc))
(define-object GtkPreview (GtkWidget))
(define-object GtkProgressBar (GtkWidget))
(define-object GtkRadioButton (GtkCheckButton))
(define-object GtkRadioMenuItem (GtkCheckMenuItem))
(define-object GtkRange (GtkWidget))
(define-object GtkRuler (GtkWidget))
(define-object GtkScale (GtkRange))
(define-object GtkScrollbar (GtkRange))
(define-object GtkScrolledWindow (GtkContainer))
(define-object GtkSeparator (GtkWidget))
(define-object GtkTable (GtkContainer))
(define-object GtkText (GtkWidget))
(define-object GtkToggleButton (GtkButton))
(define-object GtkTree (GtkContainer))
(define-object GtkTreeItem (GtkItem))
(define-object GtkVBox (GtkBox))
(define-object GtkViewport (GtkBin))
(define-object GtkVPaned (GtkPaned))
(define-object GtkVRuler (GtkRuler))
(define-object GtkVScale (GtkScale))
(define-object GtkVScrollbar (GtkScrollbar))
(define-object GtkVSeparator (GtkSeparator))
(define-object GtkWidget (GtkObject))
(define-object GtkWindow (GtkBin))

(define-object GtkCheckMenuItem (GtkMenuItem))
(define-object GtkButtonBox (GtkBox))
(define-object GtkEventBox (GtkBin))
(define-object GtkFixed (GtkContainer))
(define-object GtkHButtonBox (GtkButtonBox))
(define-object GtkVButtonBox (GtkButtonBox))
