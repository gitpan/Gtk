
# partially busted example of widget creation

package Foo;

use Data::Dumper;

init Gtk;

use Gtk;

@ISA = qw(Gtk::Button);

register_type Foo 0; # 0 means zero signals

#signal_new Foo "bloop", 'first';

add_arg_type Foo "blorp", "string";

add_arg_type Foo "Foo::bletch", "int";

#signals_add Foo;

sub new {
	return Gtk::Object::new(@_);
}

sub init {
	print "init: ";
	print Dumper([@_]);
}

sub arg {
	print "arg: ";
	print Dumper([@_]);
}

sub class_init {
	print "class_init: ";
	print Dumper([@_]);
}

package main;

use Gtk;

$w = new Gtk::Window 'toplevel';

$b = new Foo GtkButton::label => "Foo button";

$b->{bibble} = 12;

$b->signal_connect("clicked", sub { destroy $w });
#$b->signal_connect("clicked", sub { $b->signal_emit("bloop")});
#$b->signal_connect("bloop", sub {print "Bloop!\n"});

$b->set("Foo::blorp", 'fibble');
$b->set("Foo::bletch", 'fabble');

$w->add($b);

show $w;
show $b;

main Gtk;
