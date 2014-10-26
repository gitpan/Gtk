
use Gtk;
#use Data::Dumper;

sub destroy_window {
	my($widget, $windowref) = @_;
	$$windowref = undef;
}

sub button_window {
	my($widget,$button) = @_;
	if (! $button->visible) {
		show $button;
	} else {
		hide $button;
	}
}

sub create_buttons {
	my($box1, $box2, $table, @button, $separator);
	
	if (not defined $buttons_window) {
		$buttons_window = new Gtk::Window "TOPLEVEL";
		signal_connect $buttons_window "destroy", \&destroy_window, \$buttons_window;
		$buttons_window->set_title("buttons");
		$buttons_window->border_width(0);
	
		$box1 = new Gtk::VBox 0, 0;
		$buttons_window->add($box1);
		$box1->show;
		
		$table = new Gtk::Table (3,3, 0);
		$table->set_row_spacings(5);
		$table->set_col_spacings(5);
		$table->border_width(10);
		$box1->pack_start($table, 1, 1, 0);
		$table->show;
		
		for (0..8) { $button[$_] = new Gtk::Button "button".($_+1); }
		
		$button[0]->signal_connect("clicked", \&button_window, $button[1]);
		$table->attach($button[0], 0, 1, 0, 1, {EXPAND=>1,FILL=>1}, {EXPAND=>1,FILL=>1},0,0);
		$button[0]->show;

		$button[1]->signal_connect("clicked", \&button_window, $button[2]);
		$table->attach($button[1], 1, 2, 1, 2, {EXPAND=>1,FILL=>1}, {EXPAND=>1,FILL=>1},0,0);
		$button[1]->show;

		$button[2]->signal_connect("clicked", \&button_window, $button[3]);
		$table->attach($button[2], 2, 3, 2, 3, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[2]->show;

		$button[3]->signal_connect("clicked", \&button_window, $button[4]);
		$table->attach($button[3], 0, 1, 2, 3, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[3]->show;

		$button[4]->signal_connect("clicked", \&button_window, $button[5]);
		$table->attach($button[4], 2, 3, 0, 1, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[4]->show;

		$button[5]->signal_connect("clicked", \&button_window, $button[6]);
		$table->attach($button[5], 1, 2, 2, 3, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[5]->show;

		$button[6]->signal_connect("clicked", \&button_window, $button[7]);
		$table->attach($button[6], 1, 2, 0, 1, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[6]->show;

		$button[7]->signal_connect("clicked", \&button_window, $button[8]);
		$table->attach($button[7], 2, 3, 1, 2, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[7]->show;

		$button[8]->signal_connect("clicked", \&button_window, $button[8]);
		$table->attach($button[8], 0, 1, 1, 2, ["EXPAND","FILL"], ["EXPAND","FILL"],0,0);
		$button[8]->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button[0] = new Gtk::Button "close";
		$button[0]->signal_connect("clicked", sub { destroy $buttons_window});
		$box2->pack_start($button[0], 1, 1, 0);
		$button[0]->can_default(1);
		$button[0]->grab_default;
		$button[0]->show;
	}
	if (not $buttons_window->visible) {
		$buttons_window->show;
	} else {	
		destroy $buttons_window;
	}
	
}

sub create_toggle_buttons {
	my($box1, $box2, $button, $separator);
	if (not defined $tb_window) {
		$tb_window = new Gtk::Window "TOPLEVEL";
		$tb_window->signal_connect("destroy", \&destroy_window, \$tb_window);
		$tb_window->set_title("toggle buttons");
		$tb_window->border_width(0);
		
		$box1 = new Gtk::VBox(0, 0);
		$tb_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox 0, 10;
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$button = new Gtk::ToggleButton "button1";
		$box2->pack_start($button, 1, 1, 0);
		$button->show;
		
		$button = new Gtk::ToggleButton "button2";
		$box2->pack_start($button, 1, 1, 0);
		$button->show;
		
		$button = new Gtk::ToggleButton "button3";
		$box2->pack_start($button, 1, 1, 0);
		$button->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox (0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect( "clicked", sub { destroy $tb_window });
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
	}
	
	if (!$tb_window->visible) {
		$tb_window->show;
	} else {
		destroy $tb_window;
	}
}

sub create_radio_buttons {
	my($box1,$box2,$button,$separator);
	
	if (not defined $rb_window) {
		$rb_window = new Gtk::Window "TOPLEVEL";
		$rb_window->signal_connect("destroy", \&destroy_window, \$rb_window);
		$rb_window->set_title("radio buttons");
		$rb_window->border_width(0);

		$box1 = new Gtk::VBox(0,0);
		$rb_window->add($box1);
		show $box1;

		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;

		$button = new Gtk::RadioButton "button1";
		$box2->pack_start($button, 1, 1, 0);
		$button->show;
		
		$button = new Gtk::RadioButton "button2", $button;
		$button->set_state(1);
		$box2->pack_start($button, 1, 1, 0);
		$button->show;

		$button = new Gtk::RadioButton "button3", $button;
		$box2->pack_start($button, 1, 1, 0);
		$button->show;

		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect( clicked => sub { destroy $rb_window} );
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
	}
	
	if (!$rb_window->visible) {
		show $rb_window;
	} else {
		destroy $rb_window;
	}
}

sub reparent_label {
	my($widget, $new_parent) = @_;
	my($label) = ($widget->get_user_data);
	$label->reparent($new_parent);
}

sub create_reparent {
	my($box1, $box2, $box3, $frame, $button, $label, $separator);
	
	if (not defined $reparent_window) {
		$reparent_window = new Gtk::Window "TOPLEVEL";
		$reparent_window->signal_connect("destroy", \&destroy_window, \$reparent_window);
		$reparent_window->set_title("buttons");
		$reparent_window->border_width(0);
		
		$box1 = new Gtk::VBox(0, 0);
		$reparent_window->add($box1);
		show $box1;
		
		$box2 = new Gtk::HBox(0, 5);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		show $box2;
		
		$label = new Gtk::Label "Hello World";
		
		$frame = new Gtk::Frame "Frame 1";
		$box2->pack_start($frame, 1, 1, 0);
		show $frame;
		
		$box3 = new Gtk::VBox 0, 5;
		$box3->border_width(5);
		$frame->add($box3);
		show $box3;
		
		$button = new Gtk::Button "switch";
		$button->signal_connect( clicked => \&reparent_label, $box3);
		$button->set_user_data($label);
		$box3->pack_start($button, 0, 1, 0);
		$button->show;
		
		$box3->pack_start($label, 0, 1, 0);
		show $label;
		
		$frame = new Gtk::Frame "Frame 2";
		$box2->pack_start($frame, 1, 1, 0);
		show $frame;
		
		$box3 = new Gtk::VBox 0, 5;
		$box3->border_width(5);
		$frame->add($box3);
		show $box3;
		
		$button = new Gtk::Button "switch";
		$button->signal_connect( clicked => \&reparent_label, $box3);
		$button->set_user_data($label);
		$box3->pack_start($button, 0, 1, 0);
		$button->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox (0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		signal_connect $button clicked => sub {destroy $reparent_window};
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
    }

	if (!$reparent_window->visible) {
		show $reparent_window;
	} else {
		destroy $reparent_window;
	}
}

sub create_pixmap {
	my($box1,$box2,$box3,$button,$label,$separator,$pixmapwid,$pixmap,$mask,$style);
	
	if (not defined $pixmap_window) {
		$pixmap_window = new Gtk::Window "TOPLEVEL";
		signal_connect $pixmap_window "destroy", \&destroy_window, \$pixmap_window;
		$pixmap_window->set_title("pixmap");
		$pixmap_window->border_width(0);
		$pixmap_window->realize;
		
		$box1 = new Gtk::VBox(0,0);
		$pixmap_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button;
		$box2->pack_start($button, 0, 0, 0);
		$button->show;
		
		$style = $button->get_style;

		($pixmap,$mask) = Gtk::Gdk::Pixmap->create_from_xpm($pixmap_window->window, $style->bg('NORMAL'), "test.xpm");
      	$pixmapwid = new Gtk::Pixmap $pixmap, $mask;
      	
      	$label = new Gtk::Label "Pixmap test\n";
      	$box3 = new Gtk::HBox(0,0);
      	$box3->border_width(2);
      	$box3->add($pixmapwid);
      	$box3->add($label);
      	$button->add($box3);
      	$pixmapwid->show;
      	$label->show;
      	$box3->show;
      	
      	$separator = new Gtk::HSeparator;
      	$box1->pack_start($separator, 0, 1, 0);
      	$separator->show;
      	
      	$box2 = new Gtk::VBox(0,10);
      	$box2->border_width(10);
      	$box1->pack_start($box2, 0, 1, 0);
      	$box2->show;
      	
      	$button = new Gtk::Button "close";
      	$button->signal_connect("clicked", sub { destroy $pixmap_window } );
      	$box2->pack_start($button, 1, 1, 0);
      	$button->can_default(1);
      	$button->grab_default;
      	$button->show;
	}
	if (!visible $pixmap_window) {
		show $pixmap_window;
	} else {
		destroy $pixmap_window;
	}
}

sub create_tooltips {
	my($box1,$box2,$button,$separator,$tooltips);
	
	if (not defined $tt_window) {
		$tt_window = new Gtk::Window "TOPLEVEL";
		signal_connect $tt_window "destroy", \&destroy_window, \$tt_window;
		set_title $tt_window "tooltips";
		border_width $tt_window 0;
		
		$tooltips = new Gtk::Tooltips;
		
		$box1 = new Gtk::VBox(0, 0);
		$tt_window->add($box1);
		$box1->show;
		
		$box2 =  new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$button = new Gtk::ToggleButton("button1");
		$box2->pack_start($button, 1, 1, 0);
		$button->show;
		
		$tooltips->set_tips($button, "This is button 1");
		
		$button = new Gtk::ToggleButton("button2");
		$box2->pack_start($button, 1, 1, 0);
		show $button;
		
		set_tips $tooltips $button => "This is button 2";
		
		$button = new Gtk::ToggleButton("button3");
		$box2->pack_start($button, 1, 1, 0);
		show $button;
		
		$tooltips->set_tips($button, "This is button 3. This is also a really long tooltip which probably won't fit on a single line and will therefore need to be wrapped. Hopefully the wrapping will work correctly.");
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		show $separator;
		
		$box2 = new Gtk::VBox (0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub { destroy $tt_window});
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
		
		$tooltips->set_tips($button,"Push this button to close window");
    }
	if (!visible $tt_window) {
		show $tt_window;
	} else {
		$tt_window->hide;
	}
}

sub create_scrolled_windows {
	my($scrolled_window,$table,$button,$buffer,$i,$j);
	
	if (not defined $s_window) {
		$s_window = new Gtk::Dialog;
		$s_window->signal_connect("destroy", \&destroy_window, \$s_window);
		$s_window->set_title("dialog");
		$s_window->border_width(0);
		
		$scrolled_window = new Gtk::ScrolledWindow(undef,undef);
		$scrolled_window->border_width(10);
		$scrolled_window->set_policy("AUTOMATIC","AUTOMATIC");
		$s_window->vbox->pack_start($scrolled_window, 1, 1, 0);
		$scrolled_window->show;
		
		$table = new Gtk::Table(20,20,0);
		$table->set_row_spacings(10);
		$table->set_col_spacings(10);
		$scrolled_window->add($table);
		$table->show;
		
		for ($i=0;$i<20;$i++)
		{
			for($j=0;$j<20;$j++)
			{
				$button = new Gtk::Button "button ($i,$j)\n";
				$table->attach_defaults($button, $i, $i+1, $j, $j+1);
				$button->show;
			}
		}
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub {destroy $s_window});
		$button->can_default(1);
		$s_window->action_area->pack_start($button, 1, 1, 0);
		$button->grab_default;
		$button->show;
	}
	if (!visible $s_window) {
		show $s_window;
	} else {
		destroy $s_window;
	}
}

sub create_entry {
	my($box1,$box2,$entry,$button,$separator);
	
	if (not defined $entry_window) {
		$entry_window = new Gtk::Window "TOPLEVEL";
		$entry_window->signal_connect("destroy", \&destroy_window, \$entry_window);
		$entry_window->set_title("entry");
		$entry_window->border_width(0);
		
		$box1 = new Gtk::VBox(0,0);
		$entry_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$entry = new Gtk::Entry;
		#$entry->set_usize(0, 25);
		$entry->set_text("hello world");
		$box2->pack_start($entry, 1, 1, 0);
		$entry->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub {destroy $entry_window});
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
	}
	if (!visible $entry_window) {
		show $entry_window;
	} else {
		destroy $entry_window;
	}
}

sub list_add
{
	my($widget,$list) = @_;
	Gtk->print("list_add\n");
}

sub list_remove
{
	my($widget, $list) = @_;
	
	$list->remove_items($list->selection);
}

sub create_list
{
	my(@list_items) = 
	(
		"hello",
	    "world",
	    "blah",
	    "foo",
	    "bar",
	    "argh",
	    "spencer",
	    "is a",
	    "wussy",
	    "programmer",
	);
	my($box1,$box2,$scrolled_win,$list,$list_item,$button,$separator,$i);
	
	if (not defined $list_window) {
		$list_window = new Gtk::Window "TOPLEVEL";
		$list_window->signal_connect("destroy", \&destroy_window, \$list_window);
		$list_window->set_title("list");
		$list_window->border_width(0);
		
		$box1 = new Gtk::VBox(0,0);
		$list_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$scrolled_win = new Gtk::ScrolledWindow(undef, undef);
		$scrolled_win->set_policy("AUTOMATIC", "AUTOMATIC");
		$box2->pack_start($scrolled_win, 1, 1, 0);
		$scrolled_win->show;
		
		$list = new Gtk::List;
		$list->set_selection_mode("MULTIPLE");
		$list->set_selection_mode("BROWSE");
		$scrolled_win->add($list);
		$list->show;
		
		for($i=0;$i<@list_items;$i++)
		{
			$list_item = new Gtk::ListItem($list_items[$i]);
			$list->add($list_item);
			$list_item->show;
		}
		
		$button = new Gtk::Button "add";
		$button->can_focus(0);
		$button->signal_connect("clicked", \&list_add, $list);
		$box2->pack_start($button, 0, 1, 0);
		$button->show;
		
		$button = new Gtk::Button "remove";
		$button->can_focus(0);
		$button->signal_connect("clicked", \&list_remove, $list);
		$box2->pack_start($button, 0, 1, 0);
		$button->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub { destroy $list_window});
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
	}
	if (not $list_window->visible) {
		show $list_window;
	} else {
		destroy $list_window;
	}
}

sub create_menu {
	my($depth) = @_;
	my($menu,$submenu,$menuitem);
	
	if ($depth<1) {
		return undef;
	}
	
	$menu = new Gtk::Menu;
	$submenu = undef;
	$menuitem = undef;
	
	my($i,$j);
	for($i=0,$j=1;$i<5;$i++,$j++)
	{
		my($buffer) = sprintf("item %2d - %d", $depth, $j);
		$menuitem = new Gtk::RadioMenuItem($buffer, $menuitem);
		$menu->append($menuitem);
		$menuitem->show;
		if ($depth>0) {
			if (not defined $submenu) {
				$submenu = create_menu($depth-1);
				$menuitem->set_submenu($submenu);
			}
		}
	}
	
	return $menu;
}

sub create_menus {
	my($box1,$box2,$button,$menu,$menubar,$menuitem,$optionmenu,$separator);
	
	if (not defined $menu_window) {
		$menu_window = new Gtk::Window "TOPLEVEL";
		signal_connect $menu_window destroy => \&destroy_window, \$menu_window;
		$menu_window->set_title("menus");
		$menu_window->border_width(0);
		
		$box1 = new Gtk::VBox(0,0);
		$menu_window->add($box1);
		$box1->show;
		
		$menubar = new Gtk::MenuBar;
		$box1->pack_start($menubar, 0, 1, 0);
		$menubar->show;
		
		$menu = create_menu(2);
		
		$menuitem = new Gtk::MenuItem("test");
		$menuitem->set_submenu($menu);
		$menubar->append($menuitem);
		show $menuitem;

		$menuitem = new Gtk::MenuItem("foo");
		$menuitem->set_submenu($menu);
		$menubar->append($menuitem);
		show $menuitem;

		$menuitem = new Gtk::MenuItem("bar");
		$menuitem->set_submenu($menu);
		$menubar->append($menuitem);
		show $menuitem;

		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$optionmenu = new Gtk::OptionMenu;
		$optionmenu->set_menu(create_menu(1));
		$optionmenu->set_history(4);
		$box2->pack_start($optionmenu, 1, 1, 0);
		$optionmenu->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		show $separator;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		signal_connect $button clicked => sub { destroy $menu_window};
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
	}
	if (!visible $menu_window) {
		show $menu_window;
	} else {	
		destroy $menu_window;
	}
}

sub color_selection_ok {
	my($widget, $dialog) = @_;
	
	my(@color) = $dialog->colorsel->get_color;
	print "color=@color\n";
	$dialog->colorsel->set_color(@color);
}

sub color_selection_changed {
	my($widget, $dialog) = @_;

	my(@color) = $dialog->colorsel->get_color;
	print "color=@color\n";
}

sub create_color_selection {
	if (not defined $cs_window) {
		set_install_cmap Gtk::Preview 1;
		Gtk::Widget->push_visual(Gtk::Preview->get_visual);
		Gtk::Widget->push_colormap(Gtk::Preview->get_cmap);
		
		$cs_window = new Gtk::ColorSelectionDialog "color selection dialog";
		
		$cs_window->colorsel->set_opacity(1);
		$cs_window->colorsel->set_update_policy("CONTINUOUS");
		$cs_window->position("MOUSE");
		signal_connect $cs_window destroy => \&destroy_window, \$cs_window;
		$cs_window->colorsel->signal_connect("color_changed", \&color_selection_changed, $cs_window);
		$cs_window->ok_button->signal_connect("clicked", \&color_selection_ok, $cs_window);
		$cs_window->cancel_button->signal_connect("clicked", sub { destroy $cs_window });
		
		pop_colormap Gtk::Widget;
		pop_visual Gtk::Widget;
	}
	if (!visible $cs_window) {
		show $cs_window;
	} else {
		destroy $cs_window;
	}
}

sub file_selection_ok {
	my($widget, $fs) = @_;
	Gtk->print( $fs->get_filename . "\n");
	
}

sub create_file_selection {
	if (not defined $fs_window) {
		$fs_window = new Gtk::FileSelection "file selection dialog";
		$fs_window->position("MOUSE");
		$fs_window->signal_connect("destroy", \&destroy_window, \$fs_window);
		$fs_window->ok_button->signal_connect("clicked", \&file_selection_ok, $fs_window);
		$fs_window->cancel_button->signal_connect("clicked", sub { destroy $fs_window });
		
	}
	if (!visible $fs_window) {
		show $fs_window;
	} else {
		destroy $fs_window;
	}
}

sub create_range_controls {
	my($box1,$box2,$button,$scrollbar,$scale,$separator,$adjustment);
	
	if (not defined $range_window) {
		$range_window = new Gtk::Window 'TOPLEVEL';
		$range_window->signal_connect("destroy", \&destroy_window, \$range_window);
		$range_window->set_title("range controls");
		$range_window->border_width(0);
		
		$box1 = new Gtk::VBox(0,0);
		$range_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 1, 1, 0);
		$box2->show;
		
		$adjustment = new Gtk::Adjustment(0.0, 0.0, 101.0, 0.1, 1.0, 1.0);
		
		$scale = new Gtk::HScale($adjustment);
		$scale->set_usize(150,30);
		$scale->set_update_policy("DELAYED");
		$scale->set_digits(1);
		$scale->set_draw_value(1);
		$box2->pack_start($scale, 1, 1, 0);
		$scale->show;
		
		$scrollbar = new Gtk::HScrollbar $adjustment;
		$scrollbar->set_update_policy("CONTINUOUS");
		$box2->pack_start($scrollbar, 1, 1, 0);
		$scrollbar->show;
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub {destroy $range_window});
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		show $button;
	}
	if (!visible $range_window) {
		show $range_window;
	} else {
		destroy $range_window;
	}
}

sub create_rulers {
	my($table);
	
	if (not defined $ruler_window) {
		$ruler_window = new Gtk::Window "TOPLEVEL";
		$ruler_window->signal_connect("destroy", \&destroy_window, \$ruler_window);
		$ruler_window->set_title("rulers");
		$ruler_window->set_usize(300, 300);
		$ruler_window->set_events(["POINTER_MOTION", "POINTER_MOTION_HINT"]);
		$ruler_window->border_width(0);
		
		$table = new Gtk::Table(2,2,0);
		$ruler_window->add($table);
		show $table;
		
		{
		my($ruler) = new Gtk::HRuler;
		$ruler->set_range(5, 15, 0, 20);
		$ruler_window->signal_connect("motion_notify_event", 
			sub { my($widget,$event)=@_; $ruler->motion_notify_event($event) });
		$table->attach($ruler, 1, 2, 0, 1, ["EXPAND", "FILL"], ["FILL"], 0, 0);
		$ruler->show;
		}

		{
		my($ruler) = new Gtk::VRuler;
		$ruler->set_range(5, 15, 0, 20);
		$ruler_window->signal_connect("motion_notify_event", 
			sub { my($widget,$event)=@_; $ruler->motion_notify_event($event) });
		$table->attach($ruler, 0, 1, 1, 2, ["FILL"], ["EXPAND","FILL"], 0, 0);
		$ruler->show;
		}
		
	}
	if (!visible $ruler_window) {
		show $ruler_window;
	} else {
		destroy $ruler_window;
	}
}

sub create_text {
	my($box1,$box2,$button,$separator,$table,$hscrollbar,$vscrollbar,$text);
	
	if (not defined $text_window) {
		$text_window = new Gtk::Window "TOPLEVEL";
		$text_window->set_name("text window");
		$text_window->signal_connect("destroy", \&destroy_window, \$text_window);
		$text_window->set_title("test");
		$text_window->border_width(10);
		
		$box1 = new Gtk::VBox(0,0);
		$text_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2,1,1,0);
		$box2->show;
		
		$table = new Gtk::Table(2,2,0);
		$table->set_row_spacing(0,2);
		$table->set_col_spacing(0,2);
		$box2->pack_start($table,1,1,0);
		$table->show;
		
		$text = new Gtk::Text(undef,undef);
		$table->attach_defaults($text, 0,1,0,1);
		show $text;
		
		$hscrollbar = new Gtk::HScrollbar($text->hadj);
		$table->attach($hscrollbar, 0, 1,1,2,{EXPAND=>1,FILL=>1},{FILL=>1},0,0);
		$hscrollbar->show;

		$vscrollbar = new Gtk::VScrollbar($text->vadj);
		$table->attach($vscrollbar, 1, 2,0,1,{FILL=>1},{EXPAND=>1,FILL=>1},0,0);
		$vscrollbar->show;
		
		$text->freeze;
		$text->realize;
		
		$text->insert(undef,$text->style->white,undef, "spencer blah blah blah blah blah blah blah blah blah\n");
		$text->insert(undef,$text->style->white,undef, "kimball\n");
		$text->insert(undef,$text->style->white,undef, "is\n");
		$text->insert(undef,$text->style->white,undef, "a\n");
		$text->insert(undef,$text->style->white,undef, "wuss.\n");
		$text->insert(undef,$text->style->white,undef, "but\n");
		$text->insert(undef,$text->style->white,undef, "josephine\n");
		$text->insert(undef,$text->style->white,undef, "(his\n");
		$text->insert(undef,$text->style->white,undef, "girlfriend\n");
		$text->insert(undef,$text->style->white,undef, "is\n");
		$text->insert(undef,$text->style->white,undef, "not).\n");
		$text->insert(undef,$text->style->white,undef, "why?\n");
		$text->insert(undef,$text->style->white,undef, "because\n");
		$text->insert(undef,$text->style->white,undef, "spencer\n");
		$text->insert(undef,$text->style->white,undef, "puked\n");
		$text->insert(undef,$text->style->white,undef, "last\n");
		$text->insert(undef,$text->style->white,undef, "night\n");
		$text->insert(undef,$text->style->white,undef, "but\n");
		$text->insert(undef,$text->style->white,undef, "josephine\n");
		$text->insert(undef,$text->style->white,undef, "did\n");
		$text->insert(undef,$text->style->white,undef, "not");

		
		$text->thaw;

		$separator = new Gtk::HSeparator();
		$box1->pack_start($separator,0,1,0);
		$separator->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub {destroy $text_window});
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
		
	}
	if (!visible $text_window) {
		show $text_window;
	} else {
		destroy $text_window;
	}
}

sub rotate_notebook {
	my($button,$notebook) = @_;
	my(%rotate) = (TOP => "RIGHT", RIGHT => "BOTTOM", BOTTOM => "LEFT", LEFT => "TOP");
	$notebook->set_tab_pos($rotate{$notebook->tab_pos});
}

sub create_notebook {
	my($box1,$box2,$button,$separator,$notebook,$frame,$label,$i);
	if (not defined $notebook_window) {
		$notebook_window = new Gtk::Window "TOPLEVEL";
		$notebook_window->signal_connect("destroy", \&destroy_window, \$notebook_window);
		$notebook_window->set_title("notebook");
		$notebook_window->border_width(0);
		
		$box1 = new Gtk::VBox(0,0);
		$notebook_window->add($box1);
		$box1->show;
		
		$box2 = new Gtk::VBox(0,10);
		$box2->border_width(10);
		$box1->pack_start($box2,1,1,0);
		$box2->show;
		
		$notebook = new Gtk::Notebook;
		$notebook->set_tab_pos("TOP");
		$box2->pack_start($notebook, 1, 1, 0);
		$notebook->show;
		
		for($i=0;$i<5;$i++)
		{
			my($buffer) = ("Page ".($i+1));
			$frame = new Gtk::Frame($buffer);
			$frame->border_width(10);
			$frame->set_usize(200,150);
			$frame->show;
			
			$label=new Gtk::Label $buffer;
			$frame->add($label);
			$label->show;
			
			$label = new Gtk::Label($buffer);
			$notebook->append_page($frame, $label);
		}
		
		$separator = new Gtk::HSeparator;
		$box1->pack_start($separator, 0, 1, 0);
		$separator->show;
		
		$box2 = new Gtk::HBox(0, 10);
		$box2->border_width(10);
		$box1->pack_start($box2, 0, 1, 0);
		$box2->show;
		
		$button = new Gtk::Button "close";
		signal_connect $button clicked => sub {destroy $notebook_window};
		$box2->pack_start($button, 1, 1, 0);
		$button->can_default(1);
		$button->grab_default;
		$button->show;
		
		$button = new Gtk::Button "next";
		$button->signal_connect("clicked", sub {$notebook->next_page});
		$box2->pack_start($button,1,1,0);
		$button->show;

		$button = new Gtk::Button "prev";
		$button->signal_connect("clicked", sub {$notebook->prev_page});
		$box2->pack_start($button,1,1,0);
		$button->show;

		$button = new Gtk::Button "rotate";
		$button->signal_connect("clicked", \&rotate_notebook, $notebook);
		$box2->pack_start($button,1,1,0);
		$button->show;
		
	}
	if (not visible $notebook_window) {
		show $notebook_window;
	} else {
		destroy $notebook_window;
	}
}

sub create_panes {
	my($frame,$hpaned,$vpaned);
	if (not defined $paned_window) {
		$paned_window = new Gtk::Window "TOPLEVEL";
		$paned_window->signal_connect("destroy", \&destroy_window, \$paned_window);
		$paned_window->set_title("Panes");
		$paned_window->border_width(0);
		
		$vpaned = new Gtk::VPaned;
		$paned_window->add($vpaned);
		$vpaned->border_width(5);
		$vpaned->show;

		$hpaned = new Gtk::HPaned;
		$vpaned->add1($hpaned);

		$frame = new Gtk::Frame;
		$frame->set_shadow_type("IN");
		$frame->set_usize(60,60);
		$hpaned->add1($frame);
		$frame->show;

		$frame = new Gtk::Frame;
		$frame->set_shadow_type("IN");
		$frame->set_usize(80,60);
		$hpaned->add2($frame);
		$frame->show;
		
		$hpaned->show;
		
		$frame = new Gtk::Frame;
		$frame->set_shadow_type("IN");
		$frame->set_usize(60,80);
		$vpaned->add2($frame);
		$frame->show;

	}
	if (not visible $paned_window) {
		show $paned_window;
	} else {
		destroy $paned_window;
	}
}

sub progress_timeout {
	my($progressbar) = @_;
	my($new_val) = $progressbar->percentage;
	if ($new_val>=1.0) {
		$new_val = 0.0;
	}
	$new_val += 0.02;
	
	$progressbar->update($new_val);
	
	return 1;
}

sub destroy_progress {
	my($widget, $windowref) = @_;
	destroy_window($widget,$windowref);
	Gtk->timeout_remove($progress_timer);
	$progress_timer = 0;
}

sub create_progress_bar {
	my($button,$vbox,$pbar,$label);
	
	if (not defined $p_window) {
		$p_window = new Gtk::Dialog;
		signal_connect $p_window "destroy" => \&destroy_progress, \$p_window;
		$p_window->set_title("dialog");
		$p_window->border_width(0);
		
		$vbox = new Gtk::VBox(0,5);
		$vbox->border_width(10);
		$p_window->vbox->pack_start($vbox,1,1,0);
		$vbox->show;
		
		$label = new Gtk::Label "progress...";
		$label->set_alignment(0.0,0.5);
		$vbox->pack_start($label,0,1,0);
		$label->show;
		
		$pbar = new Gtk::ProgressBar;
		$pbar->set_usize(200,20);
		$vbox->pack_start($pbar,1,1,0);
		$pbar->show;
		
		$progress_timer = Gtk->timeout_add(100, \&progress_timeout, $pbar);
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub { destroy $p_window});
		$button->can_default(1);
		$p_window->action_area->pack_start($button,1,1,0);
		$button->grab_default;
		$button->show;
	}
	if (!$p_window->visible) {
		$p_window->show;
	} else {
		destroy $p_window;
	}
}

my($color_idle)=0;
my($color_count)=1;

sub color_idle_func {
	my($preview) = @_;
	my($i,$j,$k,$buf);
	for($i=0;$i<32;$i++)
	{
		for($j=0,$k=0;$j<32;$j++)
		{
			vec($buf, $k+0, 8) = $i+$color_count;
			vec($buf, $k+1, 8) = 0;
			vec($buf, $k+2, 8) = $j+$color_count;
			$k += 3;
		}
		$preview->draw_row($buf,0,$i,32);
	}
	
	$color_count +=1;
	
	$preview->draw(undef);
	
	return 1;
}

sub color_preview_destroy {
	my($widget,$windowref) = @_;
	Gtk->idle_remove($color_idle);
	$color_idle=0;
	
	destroy_window($window, $windowref);
}

sub create_color_preview {
	my($preview,$buf,$i,$j,$k);
	
	if (not defined $cp_window) {
		Gtk::Widget->push_visual(Gtk::Preview->get_visual);
		Gtk::Widget->push_colormap(Gtk::Preview->get_cmap);
		
		$cp_window = new Gtk::Window "TOPLEVEL";
		$cp_window->signal_connect("destroy", \&color_preview_destroy, \$cp_window);
		$cp_window->set_title("test");
		$cp_window->border_width(10);
		
		$preview = new Gtk::Preview("COLOR");
		$preview->size(32,32);
		$cp_window->add($preview);
		$preview->show;
		
		for($i=0;$i<32;$i++)
		{
			for($j=0,$k=0;$j<32;$j++)
			{
				vec($buf,$k+0,8) = $i;
				vec($buf,$k+1,8) = 0;
				vec($buf,$k+2,8) = $j;
				$k+=3;
			}
			$preview->draw_row($buf, 0, $i, 32);
		}
		
		$color_idle = Gtk->idle_add(\&color_idle_func, $preview);
		
		Gtk::Widget->pop_colormap;
		Gtk::Widget->pop_visual;
		
	}
	if (!visible $cp_window) {
		show $cp_window;
	} else {
		destroy $cp_window;
	}
}

my($gray_idle)=0;
my($gray_count)=1;

sub gray_idle_func {
	my($preview) = @_;
	my($i,$j,$k,$buf);
	for($i=0;$i<64;$i++)
	{
		for($j=0;$j<64;$j++)
		{
			vec($buf, $j, 8) = $i + $j + $gray_count;
		}
		$preview->draw_row($buf,0,$i,64);
	}
	
	$gray_count +=1;
	
	$preview->draw(undef);
	
	return 1;
}

sub gray_preview_destroy {
	my($widget,$windowref) = @_;
	Gtk->idle_remove($gray_idle);
	$gray_idle=0;
	
	destroy_window($window, $windowref);
}

sub create_gray_preview {
	my($preview,$buf,$i,$j,$k);
	
	if (not defined $gp_window) {
		Gtk::Widget->push_visual(Gtk::Preview->get_visual);
		Gtk::Widget->push_colormap(Gtk::Preview->get_cmap);
		
		$gp_window = new Gtk::Window "TOPLEVEL";
		$gp_window->signal_connect("destroy", \&gray_preview_destroy, \$gp_window);
		$gp_window->set_title("test");
		$gp_window->border_width(10);
		
		$preview = new Gtk::Preview("GRAYSCALE");
		$preview->size(64,64);
		$gp_window->add($preview);
		$preview->show;
		
		for($i=0;$i<64;$i++)
		{
			for($j=0;$j<64;$j++)
			{
				vec($buf,$j,8) = $i+$j;
			}
			$preview->draw_row($buf, 0, $i, 64);
		}
		
		$gray_idle = Gtk->idle_add(\&gray_idle_func, $preview);
		
		Gtk::Widget->pop_colormap;
		Gtk::Widget->pop_visual;
		
	}
	if (!visible $gp_window) {
		show $gp_window;
	} else {
		destroy $gp_window;
	}
}

my($curve_count)=0;

sub create_gamma_curve {
	my($curve,@vec,$i,$max);

	if (not defined $curve_window) {
		$curve_window = new Gtk::Window "TOPLEVEL";
		$curve_window->set_title("test");
		$curve_window->border_width(10);
		
		$gamma_curve = new Gtk::GammaCurve;
		$curve_window->add($gamma_curve);
		$gamma_curve->show;
	}

	$max = 127 + ($curve_count % 2) * 128;
	$gamma_curve->curve->set_range(0, $max, 0, $max);
	
	for($i=0;$i<$max;$i++) {
		$vec[$i] = (127 / sqrt($max))*sqrt($i);
	}
	$gamma_curve->curve->set_vector(@vec);
	
	if (!visible $curve_window) {
		show $curve_window;
	} elsif ($curve_count % 4 == 3) {
		destroy $curve_window;
		$curve_window = undef;
	}
	
	$curve_count++;
}

my($timeout_count)=0;
sub timeout_test {
	my($label)=@_;
	$label->set("count: ".++$timeout_count);
	return 1;
}

sub start_timeout_test {
	my($widget, $label) = @_;
	if (!$timer) {
		$timer = Gtk->timeout_add(100, \&timeout_test, $label);
	}
}

sub stop_timeout_test {
	if (defined $timer) {
		Gtk->timeout_remove($timer);
		$timer =0 ;
	}
}

sub destroy_timeout_test {
	my($widget,$windowref)=@_;
	destroy_window($widget,$windowref);
	stop_timeout_test(undef,undef);
}

sub create_timeout_test {
	my($button,$label);
	if (not defined $timeout_window) {
		$timeout_window = new Gtk::Dialog;
		$timeout_window->signal_connect("destroy", \&destroy_timeout_test, \$timeout_window);
		$timeout_window->set_title("Timeout Test");
		$timeout_window->border_width(0);
		
		$label = new Gtk::Label("count: 0");
		$label->set_padding(10,10);
		$timeout_window->vbox->pack_start($label,1,1,0);
		$label->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub { destroy $timeout_window});
		$button->can_default(1);
		$timeout_window->action_area->pack_start($button,1,1,0);
		$button->grab_default;
		$button->show;
		
		$button = new Gtk::Button "start";
		$button->signal_connect("clicked", \&start_timeout_test, $label);
		$button->can_default(1);
		$timeout_window->action_area->pack_start($button,1,1,0);
		$button->show;
		
		$button = new Gtk::Button "stop";
		$button->signal_connect("clicked", \&stop_timeout_test);
		$button->can_default(1);
		$timeout_window->action_area->pack_start($button, 1,1,0);
		$button->show;
		
	}
	
	if (!visible $timeout_window) {
		show $timeout_window;
	} else {
		destroy $timeout_window;
	}
}

sub label_toggle {
	my($widget,$widgetref) = @_;
	if (not defined $$widgetref) {
		$$widgetref = new Gtk::Label "Dialog Test";
		$$widgetref->set_padding(10, 10);
		$dialog_window->vbox->pack_start($$widgetref, 1, 1, 0);
		$$widgetref->show;
	} else {
		$$widgetref->destroy;
		$$widgetref = undef;
	}
}

sub create_dialog {
	my($label, $button);
	
	if (not defined $dialog_window) {
		$dialog_window = new Gtk::Dialog;
		$dialog_window->signal_connect("destroy", \&destroy_window, \$dialog_window);
		$dialog_window->set_title("dialog");
		$dialog_window->border_width(0);
		
		$button = new Gtk::Button "OK";
		$button->can_default(1);
		$dialog_window->action_area->pack_start($button, 1, 1, 0);
		$button->grab_default;
		$button->show;
		
		$button = new Gtk::Button "Toggle";
		$button->signal_connect("clicked", \&label_toggle, \$label);
		$button->can_default(1);
		$dialog_window->action_area->pack_start($button, 1, 1, 0);
		$button->show;
		
		$label = undef;
	}
	if (!$dialog_window->visible) {
		$dialog_window->show;
	} else {
		$dialog_window->destroy;
	}	
}

sub idle_test {
	my($label) = @_;
	my($buffer) = "count: ".++$idle_count;
	$label->set($buffer);
	
	return 1;
}

sub start_idle_test {
	my($widget, $label) = @_;
	if (!$idle) {
		$idle = Gtk->idle_add(\&idle_test, $label);
	}
}

sub stop_idle_test {
	if ($idle) {
		Gtk->idle_remove($idle);
		$idle = 0;
	}
}

sub destroy_idle_test {
	destroy_window(@_);
	stop_idle_test(undef, undef);
}

sub create_idle_test {
	my ($button, $label);
	if (not defined $idle_window) {
		$idle_window = new Gtk::Dialog;
		signal_connect $idle_window destroy => \&destroy_idle_test, \$idle_window;
		$idle_window->set_title("Idle Test");
		$idle_window->border_width(0);

		$label = new Gtk::Label "count: 0";
		$label->set_padding(10, 10);
		$idle_window->vbox->pack_start($label, 1, 1, 0);
		$label->show;
		
		$button = new Gtk::Button "close";
		$button->signal_connect("clicked", sub { $idle_window->destroy });
		$button->can_default(1);
		$idle_window->action_area->pack_start($button, 1, 1, 0);
		$button->grab_default();
		$button->show;
		
		$button = new Gtk::Button "start";
		signal_connect $button "clicked", \&start_idle_test, $label;
		$button->can_default(1);
		$idle_window->action_area->pack_start($button, 1, 1, 0);
		$button->show;
		
		$button = new Gtk::Button "stop";
		signal_connect $button "clicked", \&stop_idle_test;
		$button->can_default(1);
		$idle_window->action_area->pack_start($button, 1, 1, 0);
		$button->show;
	}
	if (!$idle_window->visible) {
		show $idle_window;
	} else {
		destroy $idle_window;
	}
}

sub test_destroy {
	my($widget, $windowref) = @_;
	destroy_window($widget, $windowref);
	Gtk->main_quit;
}

sub create_test {
	if (not defined $test_window) {
		$test_window = new Gtk::Window("TOPLEVEL");
		$test_window->signal_connect("destroy" => \&test_destroy, \$test_window);
		$test_window->set_title("test");
		$test_window->border_width(0);
	}
	if (!$test_window->visible) {
		$test_window->show;
		Gtk->print("create_test: start\n");
		Gtk->main;
		Gtk->print("create_test: done\n");
	} else {
		$test_window->destroy;
	}
}

sub do_exit {
	Gtk->exit(0);
}

sub create_main_window {
	my(@buttons,$window,$box1,$box2,$button,$separator);
	@buttons = (
		"buttons",	\&create_buttons,
		"toggle buttons", \&create_toggle_buttons,
		"radio buttons", \&create_radio_buttons,
		"reparent", \&create_reparent,
		"pixmap", \&create_pixmap,
		"create tooltips", \&create_tooltips,
		"menus", \&create_menus,
		"create scrolled windows", \&create_scrolled_windows,
		"drawing areas", undef,
		"entry", \&create_entry,
		"list", \&create_list,
		"color selection", \&create_color_selection,
      	"file selection", \&create_file_selection,
      	"range controls", \&create_range_controls,
      	"rulers", \&create_rulers,
		"text", \&create_text,
      	"notebook", \&create_notebook,
      	"panes", \&create_panes,
      	"progress bar", \&create_progress_bar,
      	"color preview", \&create_color_preview,
      	"gray preview", \&create_gray_preview,
		"dialog",	\&create_dialog,
      	"gamma curve", \&create_gamma_curve,
		"test timeout", \&create_timeout_test,
		"create idle test", \&create_idle_test,
		"create test",	\&create_test,
	);
	
	$window = new Gtk::Window("TOPLEVEL");
	$window->set_name("main window");
	$window->set_uposition(20, 20);
	
	$box1 = new Gtk::VBox(0, 0);
	$window->add($box1);
	$box1->show;
	
	$box2 = new Gtk::VBox(0, 0);
	#border_width $box2 10;
	$box1->pack_start($box2, 1, 1, 0);
	$box2->show;
	
	for($i=0;$i<@buttons;$i+=2) {
		$button = new Gtk::Button($buttons[$i]);
		if (defined $buttons[$i+1]) {
			$button->signal_connect(clicked => $buttons[$i+1]);
		} else {
			$button->set_sensitive(0);
		}
		$box2->pack_start($button, 1, 1, 0);
		show $button;
	}
	
	$separator = new Gtk::HSeparator;
	$box1->pack_start($separator, 0, 1, 0);
	$separator->show;
	
	$box2 = new Gtk::VBox(0, 10);
	$box2->border_width(10);
	$box1->pack_start($box2, 0, 1, 0);
	$box2->show();
	
	$button = new Gtk::Button "close";
	signal_connect $button "clicked", \&do_exit;
	$box2->pack_start($button, 1, 1, 0);
	$button->can_default(1);
	$button->grab_default();
	$button->show;
	
	$window->show;
}

parse Gtk::Rc "testgtkrc";

create_main_window;

main Gtk;
