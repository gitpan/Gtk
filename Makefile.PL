use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Gtk',
    'VERSION'	=> '0.1.11',
    'LIBS'	=> ['-L/usr/X11R6/lib -lgtk -lgdk -lglib -lX11 -lXext'],   # e.g., '-lm' 
    'PM' => {'Gdk.pm' => '$(INST_LIBDIR)/Gtk/Gdk.pm',
    		'Gtk.pm' => '$(INST_LIBDIR)/Gtk.pm',
    		'GtkTypes.pm' => '$(INST_LIBDIR)/Gtk/Types.pm',
			'Atoms.pm' => '$(INST_LIBDIR)/Gtk/Atoms.pm'},
    'TYPEMAPS' => ["typemap.gtk"],
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'OBJECT' => 'Gtk.o GtkDefs.o GtkTypes.o GdkTypes.o MiscTypes.o',
);
