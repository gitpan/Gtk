use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

#
# Options:
#
#	--with-gdkimblib
#	--with-gtkxmhtml
#	--with-gtktty
#	--with-gnome  
#

@defs = ();
@headers = ();
$libs = `gtk-config --libs`;
$libs = "-L/usr/X11R6/lib -lgtk -lgdk -lglib -lX11 -lXext" if not defined $libs;

$inc = `gtk-config --cflags`;


$object = 'Gtk.o GtkDefs.o GtkTypes.o GdkTypes.o MiscTypes.o';
$typemap = ["typemap.gtk"];
$pm = {'Gdk.pm' => '$(INST_LIBDIR)/Gtk/Gdk.pm',
	'Gtk.pm' => '$(INST_LIBDIR)/Gtk.pm',
	'GtkTypes.pm' => '$(INST_LIBDIR)/Gtk/Types.pm',
	'Atoms.pm' => '$(INST_LIBDIR)/Gtk/Atoms.pm'
};

$xfiles = {};
foreach (<*.xs>) {
	my $xs = $_;
	s/\.xs$/.c/;
	$xfiles->{$xs} = $_;
}

open (EXT, ">extension.xsh");
print EXT "BOOT:\n{\n";

if (grep {/^--with-gdkimlib/i} @ARGV) {
	$object .= ' GdkImlib.o ';
	push(@$typemap, 'typemap.gdkimlib');
	push(@defs, 'gdkimlib.defs.maybe');
	# we need to know what libraries are used by the
	# gdk_imlib lib we are going to link to....
	$libs =~ s/-l/-lgdk_imlib -lgif -ltiff -lpng -ljpeg -lz -l/; # hack hack
	push(@boot_code,"boot_Gtk__Gdk__ImlibImage");
} else {
	delete $xfiles->{'GdkImlib.xs'};
}

if (grep {/^--with-gtkxmhtml/i} @ARGV) {
	#$object .= ' GtkXmHTML.o ';
	push(@$typemap, 'typemap.gtkxmhtml');
	push(@defs, 'gtkxmhtml.defs.maybe');
	# we need to know what libraries are used by the
	# gtkxmhtml lib we are going to link to....
	$libs =~ s/-l/-lgtkxmhtml -lXpm -lpng -ljpeg -lz -l/; # hack hack
	#print EXT boot_code("boot_Gtk__XmHTML");
} else {
	delete $xfiles->{'GtkXmHTML.xs'};
}

if (grep {/^--with-gtktty/i} @ARGV) {
	#$object .= ' GtkXmHTML.o ';
	push(@$typemap, 'typemap.gtktty');
	push(@defs, 'gtktty.defs.maybe');
	push(@headers, '<gtktty/gtktty.h>');
	# we need to know what libraries are used by the
	# gtktty lib we are going to link to....
	$libs =~ s/-l/-lgtktty -l/; # hack hack
	#print EXT boot_code("boot_Gtk__XmHTML");
} else {
	foreach (qw(
		GtkLed.xs	GtkTty.xs	GtkTerm.xs	GtkVtEmu.xs
	)) {
		delete $xfiles->{$_};
	}
}

if (grep {/^--with-gnome/i} @ARGV) {
	$object .= ' Gnome.o ';
	push(@$typemap, 'typemap.gnome');
	push(@defs, 'gnome.defs.maybe');
	push(@headers, "<libgnomesupport/argp.h>", "<libgnomeui/libgnomeui.h>");
	$pm->{'Gnome.pm'} = '$(INST_LIBDIR)/Gtk/Gnome.pm';
	# use gnomeConf.sh...
	$libs =~ s/-l/-lgnome -lgnomesupport -lintl -lgnomeui -l/; #hack hack
	push(@boot_code, "boot_Gtk__Gnome");
} else {
	foreach (qw(
		GnomeAbout.xs         GnomeClient.xs        GnomeFontSelector.xs  GnomePixmap.xs	  Gnome.xs 
		GnomeApp.xs           GnomeEntry.xs         GnomeMessageBox.xs    GnomeScores.xs
		GtkTed.xs
		GtkClock.xs
	)) {
		delete $xfiles->{$_};
	}
}


foreach (@boot_code) {
	print EXT "extern void $_(CV *cv);\n";
}

foreach (@boot_code) {
	print EXT "callXS($_, cv, mark);\n";
}

print EXT "}\n";
close(EXT);

open(I, ">inc.h");
foreach (@headers) {
	print I "#include $_\n";
}
close(I);

#print "Running gendefs.pl @defs\n";

system('perl', 'gendefs.pl', @defs);
$object .= " " . (do 'Objects.xpl');


@L = (LIBS => [$libs]);

if (defined $inc) {
	@I = (INC => $inc);
} else {
	@I = (); #e.g, INC => -I/usr/other/include
}

WriteMakefile(
    'NAME'	=> 'Gtk',
    'VERSION'	=> '0.2.0',
    'PM' => $pm,
    'TYPEMAPS' => $typemap,
    'XS' => $xfiles,
    'XSOPT' => '-noversioncheck',
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'OBJECT' => $object,
	'XSPROTOARG' => '-noprototypes',
	@I,
	@L
);
