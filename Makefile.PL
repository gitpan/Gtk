use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Gtk',
    'VERSION'	=> '0.1.5',
    'LIBS'	=> ['-L/usr/X11/lib -lgtk -lgdk -lglib -lX11 -lXext'],   # e.g., '-lm' 
    'PM' => {'Gdk.pm' => '$(INST_LIBDIR)/Gtk/Gdk.pm',
    		'Gtk.pm' => '$(INST_LIBDIR)/Gtk.pm'},
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'OBJECT' => 'Gtk.o GtkTypes.o GdkTypes.o MiscTypes.o',
);
