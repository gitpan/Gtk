package Gtk;

require Exporter;
require DynaLoader;
require AutoLoader;

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

@Gtk::Data::ISA = qw(Gtk::Object);
@Gtk::Adjustment::ISA = qw(Gtk::Data);
@Gtk::Widget::ISA = qw(Gtk::Object);
@Gtk::Container::ISA = qw(Gtk::Widget);
@Gtk::Bin::ISA = qw(Gtk::Container);
@Gtk::Alignment::ISA = qw(Gtk::Bin);
@Gtk::Frame::ISA = qw(Gtk::Bin);
@Gtk::AspectFrame::ISA = qw(Gtk::Frame);
@Gtk::Item::ISA = qw(Gtk::Bin);
@Gtk::ListItem::ISA = qw(Gtk::Item);
@Gtk::MenuItem::ISA = qw(Gtk::Item);
@Gtk::CheckMenuItem::ISA = qw(Gtk::MenuItem);
@Gtk::RadioMenuItem::ISA = qw(Gtk::CheckMenuItem);
@Gtk::TreeItem::ISA = qw(Gtk::Item);
@Gtk::Viewport::ISA = qw(Gtk::Bin);
@Gtk::Window::ISA = qw(Gtk::Bin);
@Gtk::Dialog::ISA = qw(Gtk::Window);
@Gtk::FileSelection::ISA = qw(Gtk::Window);
@Gtk::Box::ISA = qw(Gtk::Container);
@Gtk::HBox::ISA = qw(Gtk::Box);
@Gtk::VBox::ISA = qw(Gtk::Box);
@Gtk::ColorSelection::ISA = qw(Gtk::VBox);
@Gtk::Curve::ISA = qw(Gtk::VBox);
@Gtk::Button::ISA = qw(Gtk::Container);
@Gtk::OptionMenu::ISA = qw(Gtk::Button);
@Gtk::ToggleButton::ISA = qw(Gtk::Button);
@Gtk::CheckButton::ISA = qw(Gtk::ToggleButton);
@Gtk::RadioButton::ISA = qw(Gtk::CheckButton);
@Gtk::List::ISA = qw(Gtk::Container);
@Gtk::MenuShell::ISA = qw(Gtk::Container);
@Gtk::Menu::ISA = qw(Gtk::MenuShell);
@Gtk::MenuBar::ISA = qw(Gtk::MenuShell);
@Gtk::Notebook::ISA = qw(Gtk::Container);
@Gtk::ScrolledWindow::ISA = qw(Gtk::Container);
@Gtk::Table::ISA = qw(Gtk::Container);
@Gtk::Tree::ISA = qw(Gtk::Container);
@Gtk::DrawingArea::ISA = qw(Gtk::Widget);
@Gtk::Entry::ISA = qw(Gtk::Widget);
@Gtk::Misc::ISA = qw(Gtk::Widget);
@Gtk::Arrow::ISA = qw(Gtk::Misc);
@Gtk::Image::ISA = qw(Gtk::Misc);
@Gtk::Label::ISA = qw(Gtk::Misc);
@Gtk::Pixmap::ISA = qw(Gtk::Misc);
@Gtk::Preview::ISA = qw(Gtk::Widget);
@Gtk::ProgressBar::ISA = qw(Gtk::Widget);
@Gtk::Range::ISA = qw(Gtk::Widget);
@Gtk::Scale::ISA = qw(Gtk::Range);
@Gtk::HScale::ISA = qw(Gtk::Scale);
@Gtk::VScale::ISA = qw(Gtk::Scale);
@Gtk::Scrollbar::ISA = qw(Gtk::Range);
@Gtk::HScrollbar::ISA = qw(Gtk::Scrollbar);
@Gtk::VScrollbar::ISA = qw(Gtk::Scrollbar);
@Gtk::Ruler::ISA = qw(Gtk::Widget);
@Gtk::HRuler::ISA = qw(Gtk::Ruler);
@Gtk::VRuler::ISA = qw(Gtk::Ruler);
@Gtk::Separator::ISA = qw(Gtk::Widget);
@Gtk::HSeparator::ISA = qw(Gtk::Separator);
@Gtk::VSeparator::ISA = qw(Gtk::Separator);
@Gtk::ColorSelectionDialog::ISA = qw(Gtk::Window);
@Gtk::Text::ISA = qw(Gtk::Widget);

@Gtk::Gdk::Bitmap::ISA = qw(Gtk::Gdk::Pixmap);
@Gtk::Gdk::Window::ISA = qw(Gtk::Gdk::Pixmap);

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
