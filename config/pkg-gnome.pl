

add_xs qw( Gnome.xs );
add_headers "<argp.h>", "<libgnomeui/libgnomeui.h>";
	
$pm->{'Gnome.pm'} = '$(INST_LIBDIR)/Gtk/Gnome.pm';
	
# use gnomeConf.sh...
$inc = $ENV{GNOME_INCLUDEDIR} . " " . $inc;
$libs =~ s/-l/$ENV{GNOMEUI_LIBS} -l/; #hack hack

add_boot "Gtk::Gnome";

