
$boxed{GdkPixmap} = { 'ref' => "gdk_window_ref", unref => "gdk_window_unref", 
						perlname => "Gtk::Gdk::Pixmap", xsname => "Gtk__Gdk__Pixmap",
						 typename => "GTK_TYPE_GDK_WINDOW"};

$boxed{GdkWindow} = { 'ref' => "gdk_window_ref", unref => "gdk_window_unref", 
                                               perlname => "Gtk::Gdk::Window", xsname => "Gtk__Gdk__Window",
                                                typename => "GTK_TYPE_GDK_WINDOW"};

$boxed{GdkBitmap} = { 'ref' => "gdk_window_ref", unref => "gdk_window_unref", 
                                               perlname => "Gtk::Gdk::Bitmap", xsname => "Gtk__Gdk__Bitmap",
                                                typename => "GTK_TYPE_GDK_WINDOW"};

#delete $boxed{GdkWindow};
$overrideboxed{GdkWindow} = 1;
$overrideboxed{GdkPixmap} = 1;
$overrideboxed{GdkBitmap} = 1;
delete $boxed{GdkEvent};
delete $boxed{GdkColor};
delete $flags{GtkWidgetFlags};

$object{GtkObject} = {perlname => "Gtk::Object", cast => "GTK_OBJECT", 
			xsname => "Gtk__Object", prefix => "gtk_object"};

if ( exists $object{GtkXmHTML} ) {
	$object{GtkXmHTML} = {perlname => "Gtk::XmHTML", cast => "GTK_XMHTML",
			xsname => "Gtk__XmHTML", prefix => "gtk_xmhtml",
			parent => 'GtkContainer'};
}
