use Gtk;


init Gtk;

                 
{
	my($window,$vbox,$hbox,$tty,$nled,$cled,$sled);

$window = new Gtk::Widget	"GtkWindow",
		user_data		=>	undef,
		type			=>	-toplevel,
		title		=>	"hello world",
		allow_grow		=>	0,
		allow_shrink		=>	0,
		border_width	=>	10;

$vbox = new Gtk::VBox 0, 1;
show $vbox;
$window->add($vbox);

$tty = new Gtk::Tty	80, 24, 100;

show $tty;

$tty->put_out("Hello, world!");

$tty->test_exec;

$vbox->pack_start($tty, 1, 1, 1);

$hbox = new Gtk::HBox 0, 1;
$vbox->pack_start($hbox, 1, 1, 1);
show $hbox;

$nled = new Gtk::Led;
$hbox->pack_start($nled, 1, 1, 1);
show $nled;

$cled = new Gtk::Led;
$hbox->pack_start($cled, 1, 1, 1);
show $cled;

$sled = new Gtk::Led;
$hbox->pack_start($sled, 1, 1, 1);
show $sled;

add_update_led $tty $nled, 'num-lock';
add_update_led $tty $cled, 'caps-lock';
add_update_led $tty $sled, 'scroll-lock';

show $window;
}

main Gtk;

