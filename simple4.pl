use Gtk;

init Gtk;

{
	my($window,$button);

$button = new Gtk::Widget	"GtkButton",
		GtkButton::label		=>	"hello world",
		GtkWidget::visible		=>	1;
}

main Gtk;

