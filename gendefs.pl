#!/usr/bin/perl -w

# Minimal LISP lexer/parser. No quote escapes currently handled.
sub parse_lisp
{
	local($_) = @_;
	my(@result) = ();
	my($node) = \@result;
	my(@parent) = ();
	while ( m/(\()|(\))|("(.*?)")|(;.*?$)|([^\(\)\s]+)/gm) {
		if (defined($1)) {
			my($new) = [];
			push @$node, $new;
			push @parent, $node;
			$node = $new;
		} elsif (defined($2)) {
			$node = pop @parent;
		} elsif (defined($3)) {
			push @$node, $4;
		} elsif (defined($6)) {
			push @$node, $6;
		}
	}
	@result;
}

sub perlize {
	local($_) = $_[0];
	if (!/^(Gtk|Gdk)/) {
		s/^([A-Z][a-z]*)/Gtk$1::/;
	}
	s/^Gtk/Gtk::/;
	s/^Gtk::Gdk/Gtk::Gdk::/;
	s/^Gdk/Gtk::Gdk::/;
	$_;
}

sub xsize {
	local($_) = @_;
	s/::/__/g;
	$_;
}

sub typeize {
	local($_) = @_;
	s/([a-z])([A-Z])/${1}_$2/g;
	$_ = uc $_;
	s/^GTK_/GTK_TYPE_/;
	s/^GDK_/GTK_TYPE_GDK_/;
	$_;
}


#foreach $file (<*.defs>) {
#	open(F,"<$file");
#	$_ .= join("",<F>);
#	close(F);
#}

foreach $file (@ARGV) {
	open(F,"<$file") || next;
	$_ .= join("",<F>);
	close(F);
}

$_ .= join("",<DATA>);

$_ =~ s/;.*$//gm;

# Disect parsed data into separate definitions

foreach $node (parse_lisp($_)) {
	@node = @$node;

	if ( !defined($node[0]) ) {
		next;
	}
	if ($node[0] eq "define-enum") {
		@enum = ();
		my($perl) = perlize($node[1]);
		foreach (@node[2..$#node]) {
			if (not ref $_) {
				$perl = $_;
				next;
			}
			$_->[0] =~ tr/-/_/;
			push @enum, {simple => $_->[0], constant => $_->[1]};
		}
		if ( exists $enum{$node[1]} ) {
			warn "Overriding enum `$node[1]'\n";
		}
		$enum{$node[1]}->{'values'} = [@enum];
		$enum{$node[1]}->{perlname} = $perl;
		$enum{$node[1]}->{xsname} = xsize($perl);
		$enum{$node[1]}->{typename} = typeize($node[1]);
		
	} elsif ($node[0] eq "define-boxed") {
		if ( exists $boxed{$node[1]} ) {
			warn "Overriding boxed `$node[1]'\n";
		}
		$boxed{$node[1]}->{'ref'} = $node[2];
		$boxed{$node[1]}->{unref} = $node[3];
		if (defined $node[4]) {
			$boxed{$node[1]}->{size} = $node[4];
		}

		my($perl) = perlize($node[1]);
		$boxed{$node[1]}->{perlname} = $perl;
		$boxed{$node[1]}->{xsname} = xsize($perl);
		$boxed{$node[1]}->{typename} = typeize($node[1]);
		
	} elsif ($node[0] eq "define-flags") {
		@flag = ();
		my($perl) = perlize($node[1]);
		foreach (@node[2..$#node]) {
			if (not ref $_) {
				$perl = $_;
				next;
			}
			$_->[0] =~ tr/-/_/;
			push @flag, {simple => $_->[0], constant => $_->[1]};
		}
		if ( exists $flags{$node[1]} ) {
			warn "Overriding flags `$node[1]'\n";
		}
		$flags{$node[1]}->{'values'} = [@flag];
		$flags{$node[1]}->{perlname} = $perl;
		$flags{$node[1]}->{xsname} = xsize($perl);
		$flags{$node[1]}->{typename} = typeize($node[1]);

	} elsif ($node[0] eq "define-struct") {
		my($struct) = {};
		
		my($perl) = perlize($node[1]);
		$struct->{perlname} = $perl;
		$struct->{xsname} = xsize($perl);
		$struct->{typename} = typeize($node[1]);
		
		if ( exists $struct{$node[1]} ) {
			warn "Overriding struct `$node[1]'\n";
		}

		foreach $node (@node[2..$#node]) {
			my (@node) = @$node;
			if ($node[0] eq "members") {
				foreach $node (@node[1..$#node]) {
					my(@node) = @$node;
					push @{$struct->{members}}, { name => $node[0], type => $node[1] };
				}
			}
		}

		$struct{$node[1]} = $struct;
		
	} elsif ($node[0] eq "define-object") {
		my($object) = {parent => $node[2]->[0]};

		my ($cast) = $node[1];
		$cast =~ s/([a-z])([A-Z])/${1}_$2/g;
		my($perl) = perlize($node[1]);
		
		foreach $node (@node[3..$#node]) {
			my (@node) = @$node;
			if ($node[0] eq "fields") {
				my(@fields) = ();
				foreach (@node[1..$#node]) {
					push @fields, {type => $_->[0], name => $_->[1]};
				}
				$object->{fields} = [@fields];
			}
			elsif ($node[0] eq "cast") {
				$cast = $node[1];
			}
			elsif ($node[0] eq "perl") {
				$perl = $node[1];
			}
		}
		if ( exists $object{$node[1]} ) {
			warn "Overriding object `$node[1]'\n";
		}

		$object{$node[1]} = $object;
		$object{$node[1]}->{perlname} = $perl;
		$object{$node[1]}->{xsname} = xsize($perl);
		
		$object{$node[1]}->{cast} = uc $cast;
		$object{$node[1]}->{prefix} = lc $cast;
		$objectlc{lc $cast} = $node[1];
		
	} elsif ($node[0] eq "define-func") {
		my($func) = {returntype => $node[2]};
		my(@args) = ();
		foreach $arg (@{$node[3]}) {
			my (@arg) = @$arg;
			if ($arg->[0] eq "...") {
				$func->{flexargs} = 1;
				next;
			}
			my ($a) = { type => $arg[0], name => $arg[1] };
			foreach $o (@arg[2..$#arg]) {
				if ($o->[0] eq "=") {
					$a->{default} = $o->[1];
				} elsif ($o->[0] eq "null-ok") {
					$a->{nullok} = 1;
				}
			}
			#if (defined($arg[2]) and ref($arg[2]) and $arg[2]->[0] eq "=") {
			#	$a->{default} = $arg[2]->[1];
			#}
			push @args, $a;
		}
		$func->{args} = \@args;
		
		my($perl) = perlize($node[1]);
		$func->{perlname} = $perl;
		$func->{xsname} = xsize($perl);
		
		if ( exists $func{$node[1]} ) {
			warn "Overriding func `$node[1]'\n";
		}
		$func{$node[1]} = $func;


	} elsif ($node[0] eq "export-enum") {
		warn "Cannot export unknown enum `$node[1]'\n" if not exists $enum{$node[1]};
		$enum{$node[1]}->{export} = 1;
	} elsif ($node[0] eq "export-boxed") {
		warn "Cannot export unknown boxed `$node[1]'\n" if not exists $boxed{$node[1]};
		$boxed{$node[1]}->{export} = 1;
	} elsif ($node[0] eq "export-flags") {
		warn "Cannot export unknown flags `$node[1]'\n" if not exists $flags{$node[1]};
		$flags{$node[1]}->{export} = 1;
	} elsif ($node[0] eq "export-struct") {
		warn "Cannot export unknown struct `$node[1]'\n" if not exists $struct{$node[1]};
		$struct{$node[1]}->{export} = 1;
	}

}

delete $pointer{""};
#foreach (qw(CHAR BOOL INT UINT LONG ULONG FLOAT DOUBLE STRING ENUM FLAGS BOXED OBJECT POINTER)) {
#	$pointer{$_} = $_;
#}

#use Data::Dumper;
#
#print Dumper(\%enum);
#print Dumper(\%flags);
#print Dumper(\%boxed);
#print Dumper(\%object);
#print Dumper(\%func);
#print Dumper(\%struct);

foreach (@ARGV) {
	if (-f "$_.opl") {
		do "$_.opl";
	}
}
#do 'overrides.pl';

delete $object{""};
delete $func{""};
delete $boxed{""};
delete $flags{""};
delete $struct{""};

delete $objectlc{""}; # Shut up warning
delete $overridestruct{""}; # Shut up warning
delete $overrideboxed{""}; # Shut up warning

#
#foreach (keys %func) {
#	if ($_ =~ /_new/) {
#		$constructor{$_} = $func{$_};
#		delete $func{$_};
#	}
#}
#
#foreach (keys %func) {
#	if (@{$func{$_}->{args}}) {
#		my($argtype) = $func{$_}->{args}->[0]->{type};
#		print "$argtype\n";
#		if (defined $object{$argtype}) {
#			my ($n) = $_;
#			my ($o) = $object{$argtype}->{prefix} . "_";
#			$n =~ s/^$o//;
#			push @{$object{$argtype}->{method}}, {function => $func{$_}, name => $n};
#			next;
#		}
#	}
#	my($prefix) = $_;
#	my($name);
#	while ($prefix =~ /_[^_]+$/) {
#		$prefix = $`;
#		$name = $& . $name;
#		print "pref/name = $prefix/$name\n";
#		if ($objectlc{$prefix}) {
#			last;
#		}
#	}
#	print "Function $_ belongs to prefix $prefix ($objectlc{$prefix})\n";
#}
#
#foreach (keys %constructor) {
#	if ($constructor{$_}->{returntype}) {
#		my($argtype) = $constructor{$_}->{returntype};
#		my($n) = $_;
#		$n =~ /_(new.*$)/;
#		my($prefix,$name) = ($`, $1);
#		print "const: $argtype/$prefix/$name\n";
#		if (defined $objectlc{$prefix}) {
#			push @{$object{$objectlc{$prefix}}->{constructor}}, {function => $constructor{$_}, name => $name};
#		}
#	}
#}
#
#use Data::Dumper;
#print Dumper(\%func);
#print Dumper(\%constructor);
#print Dumper(\%object);
#print Dumper(\%objectlc);
#exit;

foreach (sort keys %object) {
	if (!-f "$_.xs") {
		print "Unable to find widget file $_.xs: creating from template.\n";
		open(STDOUT,">$_.xs") or die "Unable to write to $_.xs: $!";
		print <<"EOT";

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

MODULE = $object{$_}->{perlname}		PACKAGE = $object{$_}->{perlname}		PREFIX = $object{$_}->{prefix}_

#ifdef $object{$_}->{cast}

#endif

EOT
		close(STDOUT);
	}
}



open(STDOUT,">xtypemap") or die "Unable to write to xtypemap: $!";
print "\n\n# Do not edit this file, as it is automatically generated by gendefs.pl\n\n";
print "TYPEMAP\n";
$i = 0;
foreach (sort keys %enum) {
	print $enum{$_}->{perlname},"\tT_SimpleVal\n";
	$i++;
}
foreach (sort keys %flags) {
	print $flags{$_}->{perlname},"\tT_SimpleVal\n";
	#print perlize($_),"\tT_SimpleVal\n";
	$i++;
}
foreach (sort keys %object) {
	print $object{$_}->{perlname},"\tT_GtkPTROBJ\n";
	print $object{$_}->{perlname},"_Sink\tT_GtkPTROBJSink\n";
	print $object{$_}->{perlname},"_OrNULL\tT_GtkPTROBJOrNULL\n";
	#print perlize($_),"\tT_GtkPTROBJ\n";
}
foreach (sort keys %boxed) {
	print $boxed{$_}->{perlname},"\tT_SimpleVal\n";
	#print perlize($_),"\tT_SimpleVal\n"; #MISCPTROBJ\n";
}
foreach (sort keys %struct) {
	print $struct{$_}->{perlname},"\tT_SimpleVal\n";
	#print perlize($_),"\tT_SimpleVal\n"; #MISCPTROBJ\n";
}


open(STDOUT,">GtkDefs.h") or die "Unable to write to GtkDefs.h: $!";;
print <<"EOT";

/* Do not edit this file, as it is automatically generated by gendefs.pl */

extern HV * pGtkType[];
extern char * pGtkTypeName[];
extern HV * pG_EnumHash;
extern HV * pG_FlagsHash;
extern AV * gtk_typecasts;
extern int type_name(char * name);

extern void add_typecast(int type, char * perlName);
extern SV * GtkGetArg(GtkArg * a);
extern void GtkSetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);
extern SV * GtkGetRetArg(GtkArg * a);
extern void GtkSetRetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);

/*extern SV * newSVOptsHash(long value, char * name, HV * hash);
extern long SvOptsHash(SV * value, char * name, HV * hash);
extern SV * newSVFlagsHash(long value, char * name, HV * hash, int);
extern long SvFlagsHash(SV * value, char * name, HV * hash);*/

#define newSVgchar(x) newSViv(x)
#define Svgchar(x) SvIV(x)

#define newSVgshort(x) newSViv(x)
#define Svgshort(x) SvIV(x)

#define newSVglong(x) newSViv(x)
#define Svglong(x) SvIV(x)

#define newSVgint(x) newSViv(x)
#define Svgint(x) SvIV(x)

#define newSVgboolean(x) newIV(x)
#define Svgboolean(x) SvIV(x)

#define newSVgfloat(x) newSVnv(x)
#define Svgfloat(x) SvNV(x)

#define newSVgdouble(x) newSVnv(x)
#define Svgdouble(x) SvNV(x)

#define newSVguchar(x) newSViv(x)
#define Svguchar(x) SvIV(x)

#define newSVgushort(x) newSViv(x)
#define Svgushort(x) SvIV(x)

#define newSVgulong(x) newSViv(x)
#define Svgulong(x) SvIV(x)

#define newSVguint(x) newSViv(x)
#define Svguint(x) SvIV(x)

#define newSVgint8(x) newSViv(x)
#define Svgint8(x) SvIV(x)

#define newSVgint16(x) newSViv(x)
#define Svgint16(x) SvIV(x)

#define newSVgint32(x) newSViv(x)
#define Svgint32(x) SvIV(x)

#define newSVguint8(x) newSViv(x)
#define Svguint8(x) SvIV(x)

#define newSVguint16(x) newSViv(x)
#define Svguint16(x) SvIV(x)

#define newSVguint32(x) newSViv(x)
#define Svguint32(x) SvIV(x)

EOT


$i = 0;
foreach (sort keys %enum) {
	print "#define TYPE_$_\n";
	print "#define pGE_$_ pGtkType[$i]\n";
	print "#define pGEName_$_ pGtkTypeName[$i]\n";
	print "#define newSV$_(v) newSVOptsHash(v, pGEName_$_, pGE_$_)\n";
	print "#define Sv$_(v) SvOptsHash(v, pGEName_$_, pGE_$_)\n";
	print "typedef $_ $enum{$_}->{xsname};\n";
	if ($_ !~ /^Gtk/) {
		print "#define newSVGtk$_(v) newSVOptsHash(v, pGEName_$_, pGE_$_)\n";
		print "#define SvGtk$_(v) SvOptsHash(v, pGEName_$_, pGE_$_)\n";
	}
	$i++;
}
foreach (sort keys %flags) {
	print "#define TYPE_$_\n";
	print "#define pGF_$_ pGtkType[$i]\n";
	print "#define pGFName_$_ pGtkTypeName[$i]\n";
	# Generate arrays
	print "#define newSV$_(v) newSVFlagsHash(v, pGFName_$_, pGF_$_, 1)\n";
	print "#define Sv$_(v) SvFlagsHash(v, pGFName_$_, pGF_$_)\n";
	print "typedef $_ $flags{$_}->{xsname};\n";
	if ($_ !~ /^Gtk/) {
		print "#define newSVGtk$_(v) newSVFlagsHash(v, pGFName_$_, pGF_$_, 1)\n";
		print "#define SvGtk$_(v) SvFlagsHash(v, pGFName_$_, pGF_$_)\n";
	}
	$i++;
}
foreach (sort keys %boxed) {
	print "#define TYPE_$_\n";
	print "extern SV * newSV$_($_ * value);\n";
	print "extern $_ * Sv$_(SV * value);\n";
	print "typedef $_ * $boxed{$_}->{xsname};\n";
	if ($_ !~ /^Gtk/) {
		print "#define newSVGtk$_ newSV$_\n";
		print "#define SvGtk$_ Sv$_\n";
	}
}
foreach (sort keys %struct) {
	print "#define TYPE_$_\n";
	print "extern SV * newSV$_($_ * value);\n";
	print "extern $_ * SvSet$_(SV * value, $_ * dest);\n";
	print "#define Sv$_(value) SvSet$_((value), 0)\n";
	print "typedef $_ * $struct{$_}->{xsname};\n";
	if ($_ !~ /^Gtk/) {
		print "#define newSVGtk$_ newSV$_\n";
		print "#define SvGtk$_ Sv$_\n";
		print "#define SvSetGtk$_ SvSet$_\n";
	}
}
foreach (sort keys %object) {
	print "#ifdef $object{$_}->{cast}\n";
	print "#define TYPE_$_\n";
	print "typedef $_ * $object{$_}->{xsname};\n";
	print "typedef $_ * $object{$_}->{xsname}_OrNULL;\n";
	print "typedef $_ * $object{$_}->{xsname}_Sink;\n";
	print "#define Cast$object{$_}->{xsname} $object{$_}->{cast}\n";
	print "#define Cast$object{$_}->{xsname}_OrNULL $object{$_}->{cast}\n";
	print "#define Cast$object{$_}->{xsname}_Sink $object{$_}->{cast}\n";
	print "#define newSV$_(x) newSVGtkObjectRef(GTK_OBJECT(x),0)\n";
	print "#define Sv$_(x) $object{$_}->{cast}(SvGtkObjectRef((x),0))\n";
	print "#endif\n";
}

$j = 0;
print "/*extern GtkType ttype[];\n";
foreach (sort keys %pointer) {
	print "#ifndef GTK_TYPE_POINTER_$_\n";
	print "#define GTK_TYPE_POINTER_$_ ttype[$j]\n";
	print "#define need_GTK_TYPE_POINTER_$_\n";
	print "#endif\n";
	$j++;
}
foreach (sort keys %struct) {
	print "#ifndef $struct{$_}->{typename}\n";
	print "#define $struct{$_}->{typename} ttype[$j]\n";
	print "#define need_$struct{$_}->{typename}\n";
	print "#endif\n";
	$j++;
}
foreach (sort keys %boxed) {
	print "#ifndef $boxed{$_}->{typename}\n";
	print "#define $boxed{$_}->{typename} ttype[$j]\n";
	print "#define need_$boxed{$_}->{typename}\n";
	print "#endif\n";
	$j++;
}
print "*/\n";

open(STDOUT,">GtkTypes.pm") or die "Unable to write to GtkTypes.pm: $!";
print "\n\n# Do not edit this file, as it is automatically generated by gendefs.pl\n\n";

print "package Gtk::Types;\n";
foreach (sort keys %object) {
	if (defined $object{$_}->{parent}) {
		print "\@$object{$_}->{perlname}::ISA = '$object{$object{$_}->{parent}}->{perlname}';\n";
	}
}
print "1;\n";



open(STDOUT,">GtkDefs.c")  or die "Unable to write to GtkDefs.c: $!";

print <<"EOT";

/* Do not edit this file, as it is automatically generated by gendefs.pl*/

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
	next if $overrideboxed{$_};
	print <<"EOT";

SV * newSV$_($_ * value) {
	int n = 0;
	SV * result = newSVMiscRef(value, "$boxed{$_}->{perlname}", &n);
	if (n)
		$boxed{$_}->{'ref'}(value);
	return result;
}

$_ * Sv$_(SV * value) { return ($_*)SvMiscRef(value, "$boxed{$_}->{perlname}"); }
EOT
}

foreach (sort keys %struct) {
	next if $overridestruct{$_};
	print <<"EOT";

SV * newSV$_($_ * value) {
	HV * h;
	SV * r;
	
	if (!value)
	  return newSVsv(&sv_undef);

	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	sv_bless(r, gv_stashpv("$struct{$_}->{perlname}", TRUE));
	
EOT

	foreach $member (@{$struct{$_}->{members}}) {
		my($name) = $member->{name};
		my($type) = $member->{type};
		if ($struct{$type}) {
			print "	hv_store(h, \"",$name,"\", ",length($name),", newSV$member->{type}(&value->$name), 0);\n";
		} else {
			print "	hv_store(h, \"",$name,"\", ",length($name),", newSV$member->{type}(value->$name), 0);\n";
		}
	}

	print <<"EOT";
	
	return r;
}

$_ * SvSet$_(SV * value, $_ * dest) {
	SV ** s;
	HV * h;
	
	if (!SvOK(value) || !(h=(HV*)SvRV(value)) || (SvTYPE(h) != SVt_PVHV))
		return 0;
	
	if (!dest) {
		dest = alloc_temp(sizeof($_));
	}

	memset(dest, 0, sizeof($_));
	
EOT

	foreach $member (@{$struct{$_}->{members}}) {
		my($name) = $member->{name};
		my($type) = $member->{type};
		if ($struct{$type}) {
			print "	if ((s=hv_fetch(h, \"",$name,"\", ",length($name),", 0)) && SvOK(*s))\n";
			print "		SvSet$member->{type}(*s, &dest->$name);\n";
		} else {
			print "	if ((s=hv_fetch(h, \"",$name,"\", ",length($name),", 0)) && SvOK(*s))\n";
			print "		dest->$member->{name} = Sv$member->{type}(*s);\n";
		}
	}

	print <<"EOT";
	
	return dest;
}
EOT
}

print <<"EOT";

SV * GtkGetArg(GtkArg * a)
{
	SV * result;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:	result = newSViv(GTK_VALUE_CHAR(*a)); break;
		case GTK_TYPE_BOOL:	result = newSViv(GTK_VALUE_BOOL(*a)); break;
		case GTK_TYPE_INT:	result = newSViv(GTK_VALUE_INT(*a)); break;
		case GTK_TYPE_UINT:	result = newSViv(GTK_VALUE_UINT(*a)); break;
		case GTK_TYPE_LONG:	result = newSViv(GTK_VALUE_LONG(*a)); break;
		case GTK_TYPE_ULONG:	result = newSViv(GTK_VALUE_ULONG(*a)); break;
		case GTK_TYPE_FLOAT:	result = newSVnv(GTK_VALUE_FLOAT(*a)); break;	
		case GTK_TYPE_DOUBLE:	result = newSVnv(GTK_VALUE_DOUBLE(*a)); break;	
		case GTK_TYPE_STRING:	result = GTK_VALUE_STRING(*a) ? newSVpv(GTK_VALUE_STRING(*a),0) : newSVsv(&sv_undef); break;
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
			break;
		}
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	print "#ifdef $enum{$_}->{typename}\n" unless $enum{$_}->{export};
	print "			if (a->type == $enum{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_ENUM(*a));\n";
	print "			else\n";
	print "#endif\n" unless $enum{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT

foreach (sort keys %flags) {
	print "#ifdef $flags{$_}->{typename}\n" unless $flags{$_}->{export};
	print "			if (a->type == $flags{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_FLAGS(*a));\n";
	print "			else\n";
	print "#endif\n" unless $flags{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_POINTER:
#if 0
			if (a->type == GTK_TYPE_POINTER_CHAR)
				result = newSViv(*GTK_RETLOC_CHAR(*a));
			else
			if (a->type == GTK_TYPE_POINTER_BOOL)
				result = newSViv(*GTK_RETLOC_BOOL(*a));
			else
			if (a->type == GTK_TYPE_POINTER_INT)
				result = newSViv(*GTK_RETLOC_INT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_UINT)
				result = newSViv(*GTK_RETLOC_UINT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_LONG)
				result = newSViv(*GTK_RETLOC_LONG(*a));
			else
			if (a->type == GTK_TYPE_POINTER_ULONG)
				result = newSViv(*GTK_RETLOC_ULONG(*a));
			else
			if (a->type == GTK_TYPE_POINTER_FLOAT)
				result = newSVnv(*GTK_RETLOC_FLOAT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_DOUBLE)
				result = newSVnv(*GTK_RETLOC_DOUBLE(*a));
			else
			if (a->type == GTK_TYPE_POINTER_STRING)
				result = *GTK_RETLOC_STRING(*a) ? newSVpv(*GTK_RETLOC_STRING(*a), 0) : newSVsv(&sv_undef);
			else
			if (a->type == GTK_TYPE_POINTER_OBJECT)
				result = newSVGtkObjectRef(*GTK_RETLOC_OBJECT(*a));
			else
#endif
EOT
		
foreach (sort keys %struct) {
	print "#ifdef $struct{$_}->{typename}\n" unless $struct{$_}->{export};
	print "			if (a->type == $struct{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_POINTER(*a));\n";
	print "			else\n";
	print "#endif\n" unless $struct{$_}->{export};
}

print <<"EOT";
				goto d_fault;
				/* result = GTK_VALUE_POINTER(*a) ?
									 newSVpv(GTK_VALUE_POINTER(*a),0) :
									 newSVsv(&sv_undef); 
									 break;*/
									 
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				result = newSVGdkEvent(GTK_VALUE_BOXED(*a));
			else
EOT

foreach (sort keys %boxed) {
	print "#ifdef $boxed{$_}->{typename}\n" unless $boxed{$_}->{export};
	print "			if (a->type == $boxed{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_BOXED(*a));\n";
	print "			else\n";
	print "#endif\n" unless $boxed{$_}->{export};
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
		case GTK_TYPE_DOUBLE:	GTK_VALUE_DOUBLE(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	GTK_VALUE_STRING(*a) = g_strdup(SvPV(v,na)); break;
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
			av_push(args, newSViv(type));
			
			PackCallback(args, v);
			/*av_push(args, newSVsv(v));*/

			GTK_VALUE_SIGNAL(*a).f = 0;
			GTK_VALUE_SIGNAL(*a).d = args;
			break;
		}
		case GTK_TYPE_POINTER:
#if 0
			if (a->type == GTK_TYPE_POINTER_CHAR)
				*GTK_RETLOC_CHAR(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_BOOL)
				*GTK_RETLOC_BOOL(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_INT)
				*GTK_RETLOC_INT(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_UINT)
				*GTK_RETLOC_UINT(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_LONG)
				*GTK_RETLOC_LONG(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_ULONG)
				*GTK_RETLOC_ULONG(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_FLOAT)
				*GTK_RETLOC_FLOAT(*a) = SvNV(v);
			else
			if (a->type == GTK_TYPE_POINTER_DOUBLE)
				*GTK_RETLOC_DOUBLE(*a) = SvNV(v);
			else
			if (a->type == GTK_TYPE_POINTER_STRING)
				*GTK_RETLOC_STRING(*a) = SvPV(v, na);
			else
			if (a->type == GTK_TYPE_POINTER_OBJECT)
				*GTK_RETLOC_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object");
			else
#endif
EOT

foreach (sort keys %struct) {
	print "#ifdef $struct{$_}->{typename}\n" unless $struct{$_}->{export};
	print "			if (a->type == $struct{$_}->{typename})\n";
	print "				GTK_VALUE_POINTER(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $struct{$_}->{export};
}
print <<"EOT";
				goto d_fault;
				/*GTK_VALUE_POINTER(*a) = (v && SvOK(v)) ? SvPV(v,na) : 0; break;*/
			break;
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	print "#ifdef $enum{$_}->{typename}\n" unless $enum{$_}->{export};
	print "			if (a->type == $enum{$_}->{typename})\n";
	print "				GTK_VALUE_ENUM(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $enum{$_}->{export};
}
print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT
foreach (sort keys %flags) {
	print "#ifdef $flags{$_}->{typename}\n" unless $flags{$_}->{export};
	print "			if (a->type == $flags{$_}->{typename})\n";
	print "				GTK_VALUE_FLAGS(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $flags{$_}->{export};
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
	print "#ifdef $boxed{$_}->{typename}\n" unless $boxed{$_}->{export};
	print "			if (a->type == $boxed{$_}->{typename})\n";
	print "				GTK_VALUE_BOXED(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $boxed{$_}->{export};
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
		case GTK_TYPE_DOUBLE:	*GTK_RETLOC_DOUBLE(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	*GTK_RETLOC_STRING(*a) = SvPV(v,na); break;
		case GTK_TYPE_OBJECT:	*GTK_RETLOC_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object"); break;
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	print "#ifdef $enum{$_}->{typename}\n" unless $enum{$_}->{export};
	print "			if (a->type == $enum{$_}->{typename})\n";
	print "				*GTK_RETLOC_ENUM(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $enum{$_}->{export};
}
print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT
foreach (sort keys %flags) {
	print "#ifdef $flags{$_}->{typename}\n" unless $flags{$_}->{export};
	print "			if (a->type == $flags{$_}->{typename})\n";
	print "				*GTK_RETLOC_FLAGS(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $flags{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_POINTER:
EOT

foreach (sort keys %struct) {
	print "#ifdef $struct{$_}->{typename}\n" unless $struct{$_}->{export};
	print "			if (a->type == $struct{$_}->{typename})\n";
	print "				GTK_VALUE_POINTER(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $struct{$_}->{export};
}

print <<"EOT";
				goto d_fault;
				/* *GTK_RETLOC_POINTER(*a) = SvPV(v,na); break;*/
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				*GTK_RETLOC_BOXED(*a) = SvGdkEvent(v);
			else
EOT
foreach (sort keys %boxed) {
	print "#ifdef $boxed{$_}->{typename}\n" unless $boxed{$_}->{export};
	print "			if (a->type == $boxed{$_}->{typename})\n";
	print "				GTK_VALUE_BOXED(*a) = Sv$_(v);\n";
	print "			else\n";
	print "#endif\n" unless $boxed{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		d_fault:
		default:
			croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	}
}

SV * GtkGetRetArg(GtkArg * a)
{
	SV * result;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_NONE:		result = newSVsv(&sv_undef); break;
		case GTK_TYPE_CHAR:		result = newSViv(*GTK_RETLOC_CHAR(*a)); break;
		case GTK_TYPE_BOOL:		result = newSViv(*GTK_RETLOC_BOOL(*a)); break;
		case GTK_TYPE_INT:		result = newSViv(*GTK_RETLOC_INT(*a)); break;
		case GTK_TYPE_UINT:		result = newSViv(*GTK_RETLOC_UINT(*a)); break;
		case GTK_TYPE_LONG:		result = newSViv(*GTK_RETLOC_LONG(*a)); break;
		case GTK_TYPE_ULONG:	result = newSViv(*GTK_RETLOC_ULONG(*a)); break;
		case GTK_TYPE_FLOAT:	result = newSVnv(*GTK_RETLOC_FLOAT(*a)); break;	
		case GTK_TYPE_DOUBLE:	result = newSVnv(*GTK_RETLOC_DOUBLE(*a)); break;	
		case GTK_TYPE_STRING:	result = newSVpv(*GTK_RETLOC_STRING(*a),0); break;
		case GTK_TYPE_OBJECT:	result = newSVGtkObjectRef(GTK_VALUE_OBJECT(*a), 0); break;
		case GTK_TYPE_ENUM:
EOT

foreach (sort keys %enum) {
	print "#ifdef $enum{$_}->{typename}\n" unless $enum{$_}->{export};
	print "			if (a->type == $enum{$_}->{typename})\n";
	print "				result = newSV$_(*GTK_RETLOC_ENUM(*a));\n";
	print "			else\n";
	print "#endif\n" unless $enum{$_}->{export};
}
print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_FLAGS:
EOT
foreach (sort keys %flags) {
	print "#ifdef $flags{$_}->{typename}\n" unless $flags{$_}->{export};
	print "			if (a->type == $flags{$_}->{typename})\n";
	print "				result = newSV$_(*GTK_RETLOC_FLAGS(*a));\n";
	print "			else\n";
	print "#endif\n" unless $flags{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		case GTK_TYPE_POINTER:
EOT

foreach (sort keys %struct) {
	print "#ifdef $struct{$_}->{typename}\n" unless $struct{$_}->{export};
	print "			if (a->type == $struct{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_POINTER(*a));\n";
	print "			else\n";
	print "#endif\n" unless $struct{$_}->{export};
}

print <<"EOT";
				goto d_fault;
				/* *GTK_RETLOC_POINTER(*a) = SvPV(v,na); break;*/
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				result = newSVGdkEvent(*GTK_RETLOC_BOXED(*a));
			else
EOT
foreach (sort keys %boxed) {
	print "#ifdef $boxed{$_}->{typename}\n" unless $boxed{$_}->{export};
	print "			if (a->type == $boxed{$_}->{typename})\n";
	print "				result = newSV$_(GTK_VALUE_BOXED(*a));\n";
	print "			else\n";
	print "#endif\n" unless $boxed{$_}->{export};
}

print <<"EOT";
				goto d_fault;
			break;
		d_fault:
		default:
			croak("Cannot get return argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	}
	return result;
}

void initPerlGdkDefs(void) {
	int i;
	HV * h;
	pG_EnumHash = newHV();
	pG_FlagsHash = newHV();
	
EOT
$i = 0;
foreach (sort keys %enum) {
	print "\n	h = newHV();\n";
	print "	pGtkType[$i] = h;\n";
	print "	pGtkTypeName[$i] = \"$enum{$_}->{perlname}\";\n";
	foreach (@{$enum{$_}->{'values'}}) {
		print "	hv_store(h, \"$_->{simple}\", ", length($_->{simple}), ", newSViv(", $_->{constant},"), 0);\n";
	}
	print "	hv_store(pG_EnumHash, \"$enum{$_}->{perlname}\", ", length($enum{$_}->{perlname}), ", newRV((SV*)h), 0);\n";
	print " SvREFCNT_dec(h);\n";
	$i++;
}

foreach (sort keys %flags) {
	print "\n	h = newHV();\n";
	print "	pGtkType[$i] = h;\n";
	print "	pGtkTypeName[$i] = \"$flags{$_}->{perlname}\";\n";
	foreach (@{$flags{$_}->{'values'}}) {
		print "	hv_store(h, \"$_->{simple}\", ", length($_->{simple}), ", newSViv(", $_->{constant},"), 0);\n";
	}
	print "	hv_store(pG_FlagsHash, \"$flags{$_}->{perlname}\", ", length($flags{$_}->{perlname}), ", newRV((SV*)h), 0);\n";
	print " SvREFCNT_dec(h);\n";
	$i++;
}
print <<"EOT";

	/*for(i=0;i<$i;i++) {
		HV * p = perl_get_hv(pGtkTypeName[i], TRUE);
		sv_setsv((SV*)p, (SV*)pGtkType[i]);
	}*/

}

/*GtkType ttype[$j] = {};*/

void initPerlGtkDefs(void) {
	
	gtk_typecasts = newAV();
	types = newHV();

EOT
foreach (sort keys %object) {
	next if not length $object{$_}->{cast};
	print "#ifdef $object{$_}->{cast}\n";
	print "\tadd_typecast(", $object{$_}->{prefix}, "_get_type(),	\"$object{$_}->{perlname}\");\n"
		;#unless /preview/i;
	print "#endif\n";
}
$j = 0;
print "/*\n";
foreach (sort keys %pointer) {
	print "#ifdef need_GTK_TYPE_POINTER_$_\n";
	print "\tttype[$j] = gtk_type_new(GTK_TYPE_POINTER);\n";
	print "#endif\n";
	$j++;
}
foreach (sort keys %struct) {
	next if not length $struct{$_}->{typename};
	print "#ifdef need_GTK_TYPE_$struct{$_}->{typename}\n";
	print "\tttype[$j] = gtk_type_new(GTK_TYPE_POINTER);\n";
	print "#endif\n";
	$j++;
}
foreach (sort keys %boxed) {
	next if not length $boxed{$_}->{typename};
	print "#ifdef need_GTK_TYPE_$boxed{$_}->{typename}\n";
	print "\tttype[$j] = gtk_type_new(GTK_TYPE_BOXED);\n";
	print "#endif\n";
	$j++;
}
print "*/\n";

print "}\n";


open(STDOUT,">boxed.xsh") or die "Unable to write to boxed.xsh: $!";

print "\n\n# Do not edit this file, as it is automatically generated by gendefs.pl\n\n";


foreach (sort keys %boxed) {
	print <<"EOT";
	
MODULE = Gtk	PACKAGE = $boxed{$_}->{perlname}

void
DESTROY(self)
	$boxed{$_}->{perlname}	self
	CODE:
	UnregisterMisc((HV*)SvRV(ST(0)), (void*)self);
	$boxed{$_}->{unref}(self);

EOT
}

foreach (sort keys %struct) {
	print <<"EOT";
	
MODULE = Gtk	PACKAGE = $struct{$_}->{perlname}

void
DESTROY(self)
	$struct{$_}->{perlname}	self
	CODE:
	UnregisterMisc((HV*)SvRV(ST(0)), (void*)self);

EOT
}

open(STDOUT,">objects.xsh") or die "Unable to write to objects.xsh: $!";

print "\n\n# Do not edit this file, as it is automatically generated by gendefs.pl\n\n";

foreach (sort keys %object) {
	next if not length $object{$_}->{prefix};

#	$object{$_}->{perlname}	self

	print <<"EOT";
	
MODULE = Gtk	PACKAGE = $object{$_}->{perlname}		PREFIX = $object{$_}->{prefix}_

#ifdef $object{$_}->{cast}

int
$object{$_}->{prefix}_get_object_type(self)
	CODE:
	RETVAL = $object{$_}->{prefix}_get_type();
	OUTPUT:
	RETVAL

int
$object{$_}->{prefix}_get_object_size(self)
	CODE:
	RETVAL = sizeof($_);
	OUTPUT:
	RETVAL


int
$object{$_}->{prefix}_get_class_size(self)
	CODE:
	RETVAL = sizeof(${_}Class);
	OUTPUT:
	RETVAL

#endif

EOT
}

foreach (sort keys %object) {
	next if not length $object{$_}->{xsname};
	print <<"EOT";
BOOT:
{
	#ifdef $object{$_}->{cast}
                extern void boot_$object{$_}->{xsname}(CV *cv);
		callXS (boot_$object{$_}->{xsname}, cv, mark);
	#endif
}

EOT
}

open(STDOUT,">Objects.xpl") or die "Unable to write to Objects.xpl: $!";

print "\n\n# Do not edit this file, as it is automatically generated by gendefs.pl\n\n";

print "\"\n";
foreach (sort keys %object) {
	print "$_.xs\n";
}
print "\"\n;\n";


__END__;

;additions over gtk.defs from gtk+-0.99.2:

;(define-enum GtkCurveType
;  (linear GTK_CURVE_TYPE_LINEAR)
;  (spline GTK_CURVE_TYPE_SPLINE)
;  (free GTK_CURVE_TYPE_FREE))

;(define-enum GtkSelectionMode
;  (single GTK_SELECTION_SINGLE)
;  (browse GTK_SELECTION_BROWSE)
;  (multiple GTK_SELECTION_MULTIPLE)
;  (extended GTK_SELECTION_EXTENDED))

;(define-enum GdkFunction
;  (copy GDK_COPY)
;  (invert GDK_INVERT)
;  (xor GDK_XOR)) 

;(define-enum GdkFill
;  (solid GDK_SOLID)
;  (tiled GDK_TILED)
;  (stippled GDK_STIPPLED)
;  (opaque-stippled GDK_OPAQUE_STIPPLED))

;(define-enum GdkLineStyle
;  (solid GDK_LINE_SOLID)
;  (on-off-dash GDK_LINE_ON_OFF_DASH)
;  (double-dash GDK_LINE_DOUBLE_DASH))

;(define-enum GdkInputMode
;  (disabled GDK_MODE_DISABLED)
;  (screen GDK_MODE_SCREEN)
;  (window GDK_MODE_WINDOW))

;(define-enum GdkInputSource
;  (mouse GDK_SOURCE_MOUSE)
;  (pen GDK_SOURCE_PEN)
;  (eraser GDK_SOURCE_ERASER)
;  (cursor GDK_SOURCE_CURSOR))


;(define-enum GdkAxisUse
;  (ignore GDK_AXIS_IGNORE)
;  (x GDK_AXIS_X)
;  (y GDK_AXIS_Y)
;  (pressure GDK_AXIS_PRESSURE)
;  (xtilt GDK_AXIS_XTILT)
;  (ytilt GDK_AXIS_YTILT)
;  (last GDK_AXIS_LAST))

;(define-enum GtkJustification
;  (left GTK_JUSTIFY_LEFT)
;  (right GTK_JUSTIFY_RIGHT)
;  (center GTK_JUSTIFY_CENTER)
;  (fill GTK_JUSTIFY_FILL))

;(define-enum GdkDndType
;  (not-dnd GDK_DNDTYPE_NOTDND)
;  (unknown GDK_DNDTYPE_UNKNOWN)
;  (raw-data GDK_DNDTYPE_RAWDATA)
;  (file GDK_DNDTYPE_FILE)
;  (files GDK_DNDTYPE_FILES)
;  (text GDK_DNDTYPE_TEXT)
;  (dir GDK_DNDTYPE_DIR)
;  (link GDK_DNDTYPE_LINK)
;  (exe GDK_DNDTYPE_EXE)
;  (url GDK_DNDTYPE_URL)
;  (mime GDK_DNDTYPE_MIME)
;  (end GDK_DNDTYPE_END))

;(define-enum GtkUpdateType
;  (continuous GTK_UPDATE_CONTINUOUS)
;  (discontinuous GTK_UPDATE_DISCONTINUOUS)
;  (delayed GTK_UPDATE_DELAYED))

;(define-object GtkHandleBox (GtkEventBox))


;(define-object GtkAdjustment (GtkData))
;(define-object GtkAspectFrame (GtkFrame))
;(define-object GtkAlignment (GtkBin))
;(define-object GtkArrow (GtkMisc))
;(define-object GtkBin (GtkContainer))
;(define-object GtkBox (GtkContainer))
;(define-object GtkButton (GtkContainer))
;(define-object GtkCheckButton (GtkToggleButton))
;(define-object GtkColorSelection (GtkVBox))
;(define-object GtkColorSelectionDialog (GtkWindow))
;(define-object GtkContainer (GtkWidget))
;(define-object GtkCurve (GtkDrawingArea))
;(define-object GtkData (GtkObject))
;(define-object GtkDialog (GtkWindow))
;(define-object GtkDrawingArea (GtkWidget))
;(define-object GtkEntry (GtkWidget))
;(define-object GtkFileSelection (GtkWindow))
;(define-object GtkFrame (GtkBin))
;(define-object GtkGammaCurve (GtkVBox))
;(define-object GtkHBox (GtkBox))
;(define-object GtkHPaned (GtkPaned))
;(define-object GtkHRuler (GtkRuler))
;(define-object GtkHScale (GtkScale))
;(define-object GtkHScrollbar (GtkScrollbar))
;(define-object GtkHSeparator (GtkSeparator))
(define-object GtkImage (GtkMisc))
;(define-object GtkInputDialog (GtkWindow))
;(define-object GtkItem (GtkBin))
;(define-object GtkLabel (GtkMisc))
;(define-object GtkList (GtkContainer))
;(define-object GtkListItem (GtkItem))
;(define-object GtkMenu (GtkMenuShell))
;(define-object GtkMenuBar (GtkMenuShell))
;(define-object GtkMenuItem (GtkItem))
;(define-object GtkMenuShell (GtkContainer))
;(define-object GtkMisc (GtkWidget))
;(define-object GtkNotebook (GtkContainer))
;(define-object GtkObject ())
;(define-object GtkOptionMenu (GtkButton))
;(define-object GtkPaned (GtkContainer))
;(define-object GtkPixmap (GtkMisc))
;(define-object GtkPreview (GtkWidget))
;(define-object GtkProgressBar (GtkWidget))
;(define-object GtkRadioButton (GtkCheckButton))
;(define-object GtkRadioMenuItem (GtkCheckMenuItem))
;(define-object GtkRange (GtkWidget))
;(define-object GtkRuler (GtkWidget))
;(define-object GtkScale (GtkRange))
;(define-object GtkScrollbar (GtkRange))
;(define-object GtkScrolledWindow (GtkContainer))
;(define-object GtkSeparator (GtkWidget))
;(define-object GtkTable (GtkContainer))
;(define-object GtkText (GtkWidget))
;(define-object GtkToggleButton (GtkButton))
;(define-object GtkTree (GtkContainer))
;(define-object GtkTreeItem (GtkItem))
;(define-object GtkVBox (GtkBox))
;(define-object GtkViewport (GtkBin))
;(define-object GtkVPaned (GtkPaned))
;(define-object GtkVRuler (GtkRuler))
;(define-object GtkVScale (GtkScale))
;(define-object GtkVScrollbar (GtkScrollbar))
;(define-object GtkVSeparator (GtkSeparator))
;(define-object GtkWidget (GtkObject))
;(define-object GtkWindow (GtkBin))
;
;(define-object GtkCheckMenuItem (GtkMenuItem))
;(define-object GtkButtonBox (GtkBox))
;(define-object GtkEventBox (GtkBin))
;(define-object GtkFixed (GtkContainer))
;(define-object GtkHButtonBox (GtkButtonBox))
;(define-object GtkVButtonBox (GtkButtonBox))

;(define-boxed GdkFont
;  gdk_font_ref
;  gdk_font_unref)

(define-enum GtkVisibility
  (none GTK_VISIBILITY_NONE)
  (partial GTK_VISIBILITY_PARTIAL)
  (full GTK_VISIBILITY_FULL))

(define-enum GdkInputSource
  (mouse GDK_SOURCE_MOUSE)
  (pen GDK_SOURCE_PEN)
  (eraser GDK_SOURCE_ERASER)
  (cursor GDK_SOURCE_CURSOR))

(define-enum GdkInputMode
  (disabled GDK_MODE_DISABLED)
  (screen GDK_MODE_SCREEN)
  (window GDK_MODE_WINDOW))

(define-enum GdkAxisUse
  (ignore GDK_AXIS_IGNORE)
  (x GDK_AXIS_X)
  (y GDK_AXIS_Y)
  (pressure GDK_AXIS_PRESSURE)
  (x-tilt GDK_AXIS_XTILT)
  (y-tilt GDK_AXIS_YTILT)
  (last GDK_AXIS_LAST))

;(define-object GtkToolbar (GtkContainer))

;(define-boxed GtkNotebookPage
;	"(void)"
;	"(void)")

(define-boxed GtkBoxChild
	"(void)"
	"(void)")

;; Waiting for GtkPacker to be released
;(define-object GtkPacker (GtkContainer))
;
;(define-enum GtkAnchor
;	(center GTK_ANCHOR_CENTER)
;	(north GTK_ANCHOR_N)
;	(ne GTK_ANCHOR_NE)
;	(east GTK_ANCHOR_E)
;	(se GTK_ANCHOR_SE)
;	(south GTK_ANCHOR_S)
;	(sw GTK_ANCHOR_SW)
;	(west GTK_ANCHOR_W)
;	(nw GTK_ANCHOR_NW))
;
;(define-enum GtkSide
;	(top GTK_SIDE_TOP)
;	(bottom GTK_SIDE_BOTTOM)
;	(left GTK_SIDE_LEFT)
;	(right GTK_SIDE_RIGHT))
;
;(define-flags GtkPackerOptions
;	(pack-expand GTK_PACK_EXPAND)
;	(fill-x GTK_FILL_X)
;	(fill-y GTK_FILL_Y))
;
;(define-boxed GtkPackerChild
;	"(void)"
;	"(void)")

(define-boxed GdkColorContext
	"(void)"
	"(void)")

(define-struct GdkColor
	(members
		(pixel	gulong)
		(red	gushort)
		(green	gushort)
		(blue	gushort)
	)
)

(define-struct GdkEvent
)

; Speculation
;(define-struct GdkEvent
;	(temporary) ;; never retained past creation context
;	(members
;		(window	GdkWindow)
;		(send_event	gint8)
;		(type	GdkEventType)
;	)
;	(union-element type
;		(GDK_EXPOSE
;			(members
;				(area	GdkRectangle)
;				(count	gint)
;			)
;		)
;		(GDK_VISIBILITY
;			(members
;				(state	GdkVisibilityState)
;			)
;		)
;		(GDK_EVENT_MOTION
;			(members
;				(send_event		gint8)
;				(time			guint32)
;				(x				gdouble)
;				(y				gdouble)
;				(pressure		gdouble)
;				(xtilt			gdouble)
;				(ytilt			gdouble)
;				(state			guint)
;				(is_hint		gint16)
;				(source			GdkInputSource)
;				(deviceid		guint32)
;				(x_root			gdouble)
;				(y_root			gdouble)
;			)
;		)
;	)
;)

(define-struct GtkAllocation
	(members
		(x		gint16)
		(y		gint16)
		(width	gint16)
		(height	gint16)
	)
)

(define-struct GtkRequisition
	(members
		(width	gint16)
		(height	gint16)
	)
)

(define-struct GtkNotebookPage
	(temporary) ;; never retained past creation context
	(members
		(child			GtkWidget)
		(tab_label		GtkWidget)
		(menu_label		GtkWidget)
		(default_menu	guint)
		(default_tab	guint)
		(requisition	GtkRequisition)
		(allocation		GtkAllocation)
	)
)

(define-boxed GdkCursor
	"(void)"
	"(void)")


