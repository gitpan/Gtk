use Gtk;

init Gtk::Gnome "App_id";

$app = new Gtk::Gnome::App "appname", "title";

$button = new Gtk::Button "button";

$button->signal_connect (clicked => sub {
	my($w) = new Gtk::Gnome::MessageBox "message", "messagebox_type", "button1", "button2";
	$w->signal_connect(clicked => sub {
		print "Button $_[1] clicked\n";
	});
	#$w->set_modal;
	show $w;
});

$app->set_contents($button);

show $app;

main Gtk;

