
# partially busted example of widget creation

package Foo;

use Data::Dumper;

init Gtk;

use Gtk;

@ISA = qw(Gtk::Button);

register_type Foo bloop => ['first', 'none'];

add_arg_type Foo "blorp", "string", 3;

add_arg_type Foo "Foo::bletch", "int", 3;

sub new {
	return Gtk::Object::new(@_);
}

sub init {
	print "init: ";
	print Dumper([@_]);
}

sub set_arg {
	print "set_arg: ";
	print Dumper([@_]);
}

sub get_arg {
	print "get_arg: ";
	print Dumper([@_]);
	return "$_[1]-result";
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

#$b->signal_connect("clicked", sub { destroy $w });
#$b->signal_connect("clicked", sub { $b->signal_emit("bloop")});


# Demonstration of emit
#use Data::Dumper;
#$b->signal_connect("install_accelerator", sub { 
#	print Dumper(\@_);
#	return 3;
#});
#$b->signal_connect("clicked", sub { print "ia: ",$b->signal_emit("install_accelerator", "signal", 64, 129),"\n";});


# This line breaks, and I'm not sure why
#$b->signal_connect("bloop", sub {print "Bloop!\n"});

$b->set("Foo::blorp", 'fibble');
$b->set("Foo::bletch", 'fabble');
print "|",$b->get("Foo::blorp"),"|\n";

$w->add($b);

show $w;
show $b;

main Gtk;
