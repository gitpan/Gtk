package Gtk;

require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;

$VERSION = '0.3';

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    # NOTE: THIS AUTOLOAD FUNCTION IS FLAWED (but is the best we can do for now).
    # Avoid old-style ``&CONST'' usage. Either remove the ``&'' or add ``()''.
    if (@_ > 0) {
	$AutoLoader::AUTOLOAD = $AUTOLOAD;
	goto &AutoLoader::AUTOLOAD;
    }
    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    ($pack,$file,$line) = caller;
	    die "Your vendor has not defined Gtk macro $constname, used at $file line $line.
";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Gtk;

# Preloaded methods go here.

require Gtk::Types;

@Gtk::Gdk::Bitmap::ISA = qw(Gtk::Gdk::Pixmap);
@Gtk::Gdk::Window::ISA = qw(Gtk::Gdk::Pixmap);

$Gtk::_init_package = "Gtk" if not defined $Gtk::_init_package;

if ((defined $Gtk::_init_package) && ($Gtk::_init_package ne "none")) {
	$Gtk::_init_package->init;
}

package Gtk::Object;

use Carp;

sub AUTOLOAD {
    # This AUTOLOAD is used to automatically perform accessor/mutator functions
    # for Gtk object data members, in lieu of defined functions.
    
    my($result);
   
    eval {
	    if (@_ == 2) {
	    	$_[0]->set($AUTOLOAD, $_[1]);
	    } elsif (@_ == 1) {
	    	$result = $_[0]->get($AUTOLOAD);
	    } else {
	    	die;
	    }
	    
	    # Set up real method, to speed subsequent access
	    eval <<"EOT";
	    
	    sub $AUTOLOAD {
	    	if (\@_ == 2) {
	    		\$_[0]->set('$AUTOLOAD', \$_[1]);
	    	} elsif (\@_ == 1) {
	    		\$_[0]->get('$AUTOLOAD');
	    	} else {
	    		die "Usage: $AUTOLOAD (Object [, new_value])";
	    	}
	    }
EOT
	    
	};
	if ($@) {
		if (ref $_[0]) {
			$AUTOLOAD =~ s/^.*:://;
			croak "Can't locate object method \"$AUTOLOAD\" via package \"" . ref($_[0]) . "\"";
		} else {
			croak "Undefined subroutine \&$AUTOLOAD called";
		}
	}
	$result;
}

package Gtk;

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
