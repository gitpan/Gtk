
add_defs 'pkg.defs';
add_typemap 'pkg.typemap';

add_xs qw( GdkImlib.xs );

# we need to know what libraries are used by the
# gdk_imlib lib we are going to link to....
$libs =~ s/-l/-lgdk_imlib -lgif -ltiff -lpng -ljpeg -lz -l/; # hack hack

add_boot "Gtk::Gdk::ImlibImage";
