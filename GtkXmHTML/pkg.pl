
print "XmHTML...\n";

add_c 'GXHTypes.c';

add_pm 'GtkXmHTML.pm' => '$(INST_LIBDIR)/Gtk/XmHTML.pm';

add_defs 'pkg.defs';
add_typemap 'pkg.typemap';

add_headers (qw( <gtk-xmhtml/gtk-xmhtml.h> "GXHTypes.h"));

# we need to know what libraries are used by the
# gtkxmhtml lib we are going to link to....
$libs =~ s/-l/$ENV{GTKXMHTML_LIBS} -l/; # hack hack
