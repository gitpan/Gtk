	
MODULE = Gtk	PACKAGE = Gtk::Adjustment		PREFIX = gtk_adjustment_

int
gtk_adjustment_get_type(self)
	Gtk::Adjustment	self
	CODE:
	RETVAL = gtk_adjustment_get_type();
	OUTPUT:
	RETVAL

int
gtk_adjustment_get_size(self)
	Gtk::Adjustment	self
	CODE:
	RETVAL = sizeof(GtkAdjustment);
	OUTPUT:
	RETVAL


int
gtk_adjustment_get_class_size(self)
	Gtk::Adjustment	self
	CODE:
	RETVAL = sizeof(GtkAdjustmentClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Alignment		PREFIX = gtk_alignment_

int
gtk_alignment_get_type(self)
	Gtk::Alignment	self
	CODE:
	RETVAL = gtk_alignment_get_type();
	OUTPUT:
	RETVAL

int
gtk_alignment_get_size(self)
	Gtk::Alignment	self
	CODE:
	RETVAL = sizeof(GtkAlignment);
	OUTPUT:
	RETVAL


int
gtk_alignment_get_class_size(self)
	Gtk::Alignment	self
	CODE:
	RETVAL = sizeof(GtkAlignmentClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Arrow		PREFIX = gtk_arrow_

int
gtk_arrow_get_type(self)
	Gtk::Arrow	self
	CODE:
	RETVAL = gtk_arrow_get_type();
	OUTPUT:
	RETVAL

int
gtk_arrow_get_size(self)
	Gtk::Arrow	self
	CODE:
	RETVAL = sizeof(GtkArrow);
	OUTPUT:
	RETVAL


int
gtk_arrow_get_class_size(self)
	Gtk::Arrow	self
	CODE:
	RETVAL = sizeof(GtkArrowClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::AspectFrame		PREFIX = gtk_aspect_frame_

int
gtk_aspect_frame_get_type(self)
	Gtk::AspectFrame	self
	CODE:
	RETVAL = gtk_aspect_frame_get_type();
	OUTPUT:
	RETVAL

int
gtk_aspect_frame_get_size(self)
	Gtk::AspectFrame	self
	CODE:
	RETVAL = sizeof(GtkAspectFrame);
	OUTPUT:
	RETVAL


int
gtk_aspect_frame_get_class_size(self)
	Gtk::AspectFrame	self
	CODE:
	RETVAL = sizeof(GtkAspectFrameClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Bin		PREFIX = gtk_bin_

int
gtk_bin_get_type(self)
	Gtk::Bin	self
	CODE:
	RETVAL = gtk_bin_get_type();
	OUTPUT:
	RETVAL

int
gtk_bin_get_size(self)
	Gtk::Bin	self
	CODE:
	RETVAL = sizeof(GtkBin);
	OUTPUT:
	RETVAL


int
gtk_bin_get_class_size(self)
	Gtk::Bin	self
	CODE:
	RETVAL = sizeof(GtkBinClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Box		PREFIX = gtk_box_

int
gtk_box_get_type(self)
	Gtk::Box	self
	CODE:
	RETVAL = gtk_box_get_type();
	OUTPUT:
	RETVAL

int
gtk_box_get_size(self)
	Gtk::Box	self
	CODE:
	RETVAL = sizeof(GtkBox);
	OUTPUT:
	RETVAL


int
gtk_box_get_class_size(self)
	Gtk::Box	self
	CODE:
	RETVAL = sizeof(GtkBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Button		PREFIX = gtk_button_

int
gtk_button_get_type(self)
	Gtk::Button	self
	CODE:
	RETVAL = gtk_button_get_type();
	OUTPUT:
	RETVAL

int
gtk_button_get_size(self)
	Gtk::Button	self
	CODE:
	RETVAL = sizeof(GtkButton);
	OUTPUT:
	RETVAL


int
gtk_button_get_class_size(self)
	Gtk::Button	self
	CODE:
	RETVAL = sizeof(GtkButtonClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ButtonBox		PREFIX = gtk_button_box_

int
gtk_button_box_get_type(self)
	Gtk::ButtonBox	self
	CODE:
	RETVAL = gtk_button_box_get_type();
	OUTPUT:
	RETVAL

int
gtk_button_box_get_size(self)
	Gtk::ButtonBox	self
	CODE:
	RETVAL = sizeof(GtkButtonBox);
	OUTPUT:
	RETVAL


int
gtk_button_box_get_class_size(self)
	Gtk::ButtonBox	self
	CODE:
	RETVAL = sizeof(GtkButtonBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::CheckButton		PREFIX = gtk_check_button_

int
gtk_check_button_get_type(self)
	Gtk::CheckButton	self
	CODE:
	RETVAL = gtk_check_button_get_type();
	OUTPUT:
	RETVAL

int
gtk_check_button_get_size(self)
	Gtk::CheckButton	self
	CODE:
	RETVAL = sizeof(GtkCheckButton);
	OUTPUT:
	RETVAL


int
gtk_check_button_get_class_size(self)
	Gtk::CheckButton	self
	CODE:
	RETVAL = sizeof(GtkCheckButtonClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::CheckMenuItem		PREFIX = gtk_check_menu_item_

int
gtk_check_menu_item_get_type(self)
	Gtk::CheckMenuItem	self
	CODE:
	RETVAL = gtk_check_menu_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_check_menu_item_get_size(self)
	Gtk::CheckMenuItem	self
	CODE:
	RETVAL = sizeof(GtkCheckMenuItem);
	OUTPUT:
	RETVAL


int
gtk_check_menu_item_get_class_size(self)
	Gtk::CheckMenuItem	self
	CODE:
	RETVAL = sizeof(GtkCheckMenuItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ColorSelection		PREFIX = gtk_color_selection_

int
gtk_color_selection_get_type(self)
	Gtk::ColorSelection	self
	CODE:
	RETVAL = gtk_color_selection_get_type();
	OUTPUT:
	RETVAL

int
gtk_color_selection_get_size(self)
	Gtk::ColorSelection	self
	CODE:
	RETVAL = sizeof(GtkColorSelection);
	OUTPUT:
	RETVAL


int
gtk_color_selection_get_class_size(self)
	Gtk::ColorSelection	self
	CODE:
	RETVAL = sizeof(GtkColorSelectionClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ColorSelectionDialog		PREFIX = gtk_color_selection_dialog_

int
gtk_color_selection_dialog_get_type(self)
	Gtk::ColorSelectionDialog	self
	CODE:
	RETVAL = gtk_color_selection_dialog_get_type();
	OUTPUT:
	RETVAL

int
gtk_color_selection_dialog_get_size(self)
	Gtk::ColorSelectionDialog	self
	CODE:
	RETVAL = sizeof(GtkColorSelectionDialog);
	OUTPUT:
	RETVAL


int
gtk_color_selection_dialog_get_class_size(self)
	Gtk::ColorSelectionDialog	self
	CODE:
	RETVAL = sizeof(GtkColorSelectionDialogClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Container		PREFIX = gtk_container_

int
gtk_container_get_type(self)
	Gtk::Container	self
	CODE:
	RETVAL = gtk_container_get_type();
	OUTPUT:
	RETVAL

int
gtk_container_get_size(self)
	Gtk::Container	self
	CODE:
	RETVAL = sizeof(GtkContainer);
	OUTPUT:
	RETVAL


int
gtk_container_get_class_size(self)
	Gtk::Container	self
	CODE:
	RETVAL = sizeof(GtkContainerClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Curve		PREFIX = gtk_curve_

int
gtk_curve_get_type(self)
	Gtk::Curve	self
	CODE:
	RETVAL = gtk_curve_get_type();
	OUTPUT:
	RETVAL

int
gtk_curve_get_size(self)
	Gtk::Curve	self
	CODE:
	RETVAL = sizeof(GtkCurve);
	OUTPUT:
	RETVAL


int
gtk_curve_get_class_size(self)
	Gtk::Curve	self
	CODE:
	RETVAL = sizeof(GtkCurveClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Data		PREFIX = gtk_data_

int
gtk_data_get_type(self)
	Gtk::Data	self
	CODE:
	RETVAL = gtk_data_get_type();
	OUTPUT:
	RETVAL

int
gtk_data_get_size(self)
	Gtk::Data	self
	CODE:
	RETVAL = sizeof(GtkData);
	OUTPUT:
	RETVAL


int
gtk_data_get_class_size(self)
	Gtk::Data	self
	CODE:
	RETVAL = sizeof(GtkDataClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Dialog		PREFIX = gtk_dialog_

int
gtk_dialog_get_type(self)
	Gtk::Dialog	self
	CODE:
	RETVAL = gtk_dialog_get_type();
	OUTPUT:
	RETVAL

int
gtk_dialog_get_size(self)
	Gtk::Dialog	self
	CODE:
	RETVAL = sizeof(GtkDialog);
	OUTPUT:
	RETVAL


int
gtk_dialog_get_class_size(self)
	Gtk::Dialog	self
	CODE:
	RETVAL = sizeof(GtkDialogClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::DrawingArea		PREFIX = gtk_drawing_area_

int
gtk_drawing_area_get_type(self)
	Gtk::DrawingArea	self
	CODE:
	RETVAL = gtk_drawing_area_get_type();
	OUTPUT:
	RETVAL

int
gtk_drawing_area_get_size(self)
	Gtk::DrawingArea	self
	CODE:
	RETVAL = sizeof(GtkDrawingArea);
	OUTPUT:
	RETVAL


int
gtk_drawing_area_get_class_size(self)
	Gtk::DrawingArea	self
	CODE:
	RETVAL = sizeof(GtkDrawingAreaClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Entry		PREFIX = gtk_entry_

int
gtk_entry_get_type(self)
	Gtk::Entry	self
	CODE:
	RETVAL = gtk_entry_get_type();
	OUTPUT:
	RETVAL

int
gtk_entry_get_size(self)
	Gtk::Entry	self
	CODE:
	RETVAL = sizeof(GtkEntry);
	OUTPUT:
	RETVAL


int
gtk_entry_get_class_size(self)
	Gtk::Entry	self
	CODE:
	RETVAL = sizeof(GtkEntryClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::EventBox		PREFIX = gtk_event_box_

int
gtk_event_box_get_type(self)
	Gtk::EventBox	self
	CODE:
	RETVAL = gtk_event_box_get_type();
	OUTPUT:
	RETVAL

int
gtk_event_box_get_size(self)
	Gtk::EventBox	self
	CODE:
	RETVAL = sizeof(GtkEventBox);
	OUTPUT:
	RETVAL


int
gtk_event_box_get_class_size(self)
	Gtk::EventBox	self
	CODE:
	RETVAL = sizeof(GtkEventBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::FileSelection		PREFIX = gtk_file_selection_

int
gtk_file_selection_get_type(self)
	Gtk::FileSelection	self
	CODE:
	RETVAL = gtk_file_selection_get_type();
	OUTPUT:
	RETVAL

int
gtk_file_selection_get_size(self)
	Gtk::FileSelection	self
	CODE:
	RETVAL = sizeof(GtkFileSelection);
	OUTPUT:
	RETVAL


int
gtk_file_selection_get_class_size(self)
	Gtk::FileSelection	self
	CODE:
	RETVAL = sizeof(GtkFileSelectionClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Fixed		PREFIX = gtk_fixed_

int
gtk_fixed_get_type(self)
	Gtk::Fixed	self
	CODE:
	RETVAL = gtk_fixed_get_type();
	OUTPUT:
	RETVAL

int
gtk_fixed_get_size(self)
	Gtk::Fixed	self
	CODE:
	RETVAL = sizeof(GtkFixed);
	OUTPUT:
	RETVAL


int
gtk_fixed_get_class_size(self)
	Gtk::Fixed	self
	CODE:
	RETVAL = sizeof(GtkFixedClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Frame		PREFIX = gtk_frame_

int
gtk_frame_get_type(self)
	Gtk::Frame	self
	CODE:
	RETVAL = gtk_frame_get_type();
	OUTPUT:
	RETVAL

int
gtk_frame_get_size(self)
	Gtk::Frame	self
	CODE:
	RETVAL = sizeof(GtkFrame);
	OUTPUT:
	RETVAL


int
gtk_frame_get_class_size(self)
	Gtk::Frame	self
	CODE:
	RETVAL = sizeof(GtkFrameClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::GammaCurve		PREFIX = gtk_gamma_curve_

int
gtk_gamma_curve_get_type(self)
	Gtk::GammaCurve	self
	CODE:
	RETVAL = gtk_gamma_curve_get_type();
	OUTPUT:
	RETVAL

int
gtk_gamma_curve_get_size(self)
	Gtk::GammaCurve	self
	CODE:
	RETVAL = sizeof(GtkGammaCurve);
	OUTPUT:
	RETVAL


int
gtk_gamma_curve_get_class_size(self)
	Gtk::GammaCurve	self
	CODE:
	RETVAL = sizeof(GtkGammaCurveClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HBox		PREFIX = gtk_hbox_

int
gtk_hbox_get_type(self)
	Gtk::HBox	self
	CODE:
	RETVAL = gtk_hbox_get_type();
	OUTPUT:
	RETVAL

int
gtk_hbox_get_size(self)
	Gtk::HBox	self
	CODE:
	RETVAL = sizeof(GtkHBox);
	OUTPUT:
	RETVAL


int
gtk_hbox_get_class_size(self)
	Gtk::HBox	self
	CODE:
	RETVAL = sizeof(GtkHBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HButtonBox		PREFIX = gtk_hbutton_box_

int
gtk_hbutton_box_get_type(self)
	Gtk::HButtonBox	self
	CODE:
	RETVAL = gtk_hbutton_box_get_type();
	OUTPUT:
	RETVAL

int
gtk_hbutton_box_get_size(self)
	Gtk::HButtonBox	self
	CODE:
	RETVAL = sizeof(GtkHButtonBox);
	OUTPUT:
	RETVAL


int
gtk_hbutton_box_get_class_size(self)
	Gtk::HButtonBox	self
	CODE:
	RETVAL = sizeof(GtkHButtonBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HPaned		PREFIX = gtk_hpaned_

int
gtk_hpaned_get_type(self)
	Gtk::HPaned	self
	CODE:
	RETVAL = gtk_hpaned_get_type();
	OUTPUT:
	RETVAL

int
gtk_hpaned_get_size(self)
	Gtk::HPaned	self
	CODE:
	RETVAL = sizeof(GtkHPaned);
	OUTPUT:
	RETVAL


int
gtk_hpaned_get_class_size(self)
	Gtk::HPaned	self
	CODE:
	RETVAL = sizeof(GtkHPanedClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HRuler		PREFIX = gtk_hruler_

int
gtk_hruler_get_type(self)
	Gtk::HRuler	self
	CODE:
	RETVAL = gtk_hruler_get_type();
	OUTPUT:
	RETVAL

int
gtk_hruler_get_size(self)
	Gtk::HRuler	self
	CODE:
	RETVAL = sizeof(GtkHRuler);
	OUTPUT:
	RETVAL


int
gtk_hruler_get_class_size(self)
	Gtk::HRuler	self
	CODE:
	RETVAL = sizeof(GtkHRulerClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HScale		PREFIX = gtk_hscale_

int
gtk_hscale_get_type(self)
	Gtk::HScale	self
	CODE:
	RETVAL = gtk_hscale_get_type();
	OUTPUT:
	RETVAL

int
gtk_hscale_get_size(self)
	Gtk::HScale	self
	CODE:
	RETVAL = sizeof(GtkHScale);
	OUTPUT:
	RETVAL


int
gtk_hscale_get_class_size(self)
	Gtk::HScale	self
	CODE:
	RETVAL = sizeof(GtkHScaleClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HScrollbar		PREFIX = gtk_hscrollbar_

int
gtk_hscrollbar_get_type(self)
	Gtk::HScrollbar	self
	CODE:
	RETVAL = gtk_hscrollbar_get_type();
	OUTPUT:
	RETVAL

int
gtk_hscrollbar_get_size(self)
	Gtk::HScrollbar	self
	CODE:
	RETVAL = sizeof(GtkHScrollbar);
	OUTPUT:
	RETVAL


int
gtk_hscrollbar_get_class_size(self)
	Gtk::HScrollbar	self
	CODE:
	RETVAL = sizeof(GtkHScrollbarClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::HSeparator		PREFIX = gtk_hseparator_

int
gtk_hseparator_get_type(self)
	Gtk::HSeparator	self
	CODE:
	RETVAL = gtk_hseparator_get_type();
	OUTPUT:
	RETVAL

int
gtk_hseparator_get_size(self)
	Gtk::HSeparator	self
	CODE:
	RETVAL = sizeof(GtkHSeparator);
	OUTPUT:
	RETVAL


int
gtk_hseparator_get_class_size(self)
	Gtk::HSeparator	self
	CODE:
	RETVAL = sizeof(GtkHSeparatorClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Image		PREFIX = gtk_image_

int
gtk_image_get_type(self)
	Gtk::Image	self
	CODE:
	RETVAL = gtk_image_get_type();
	OUTPUT:
	RETVAL

int
gtk_image_get_size(self)
	Gtk::Image	self
	CODE:
	RETVAL = sizeof(GtkImage);
	OUTPUT:
	RETVAL


int
gtk_image_get_class_size(self)
	Gtk::Image	self
	CODE:
	RETVAL = sizeof(GtkImageClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::InputDialog		PREFIX = gtk_input_dialog_

int
gtk_input_dialog_get_type(self)
	Gtk::InputDialog	self
	CODE:
	RETVAL = gtk_input_dialog_get_type();
	OUTPUT:
	RETVAL

int
gtk_input_dialog_get_size(self)
	Gtk::InputDialog	self
	CODE:
	RETVAL = sizeof(GtkInputDialog);
	OUTPUT:
	RETVAL


int
gtk_input_dialog_get_class_size(self)
	Gtk::InputDialog	self
	CODE:
	RETVAL = sizeof(GtkInputDialogClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Item		PREFIX = gtk_item_

int
gtk_item_get_type(self)
	Gtk::Item	self
	CODE:
	RETVAL = gtk_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_item_get_size(self)
	Gtk::Item	self
	CODE:
	RETVAL = sizeof(GtkItem);
	OUTPUT:
	RETVAL


int
gtk_item_get_class_size(self)
	Gtk::Item	self
	CODE:
	RETVAL = sizeof(GtkItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Label		PREFIX = gtk_label_

int
gtk_label_get_type(self)
	Gtk::Label	self
	CODE:
	RETVAL = gtk_label_get_type();
	OUTPUT:
	RETVAL

int
gtk_label_get_size(self)
	Gtk::Label	self
	CODE:
	RETVAL = sizeof(GtkLabel);
	OUTPUT:
	RETVAL


int
gtk_label_get_class_size(self)
	Gtk::Label	self
	CODE:
	RETVAL = sizeof(GtkLabelClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::List		PREFIX = gtk_list_

int
gtk_list_get_type(self)
	Gtk::List	self
	CODE:
	RETVAL = gtk_list_get_type();
	OUTPUT:
	RETVAL

int
gtk_list_get_size(self)
	Gtk::List	self
	CODE:
	RETVAL = sizeof(GtkList);
	OUTPUT:
	RETVAL


int
gtk_list_get_class_size(self)
	Gtk::List	self
	CODE:
	RETVAL = sizeof(GtkListClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ListItem		PREFIX = gtk_list_item_

int
gtk_list_item_get_type(self)
	Gtk::ListItem	self
	CODE:
	RETVAL = gtk_list_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_list_item_get_size(self)
	Gtk::ListItem	self
	CODE:
	RETVAL = sizeof(GtkListItem);
	OUTPUT:
	RETVAL


int
gtk_list_item_get_class_size(self)
	Gtk::ListItem	self
	CODE:
	RETVAL = sizeof(GtkListItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Menu		PREFIX = gtk_menu_

int
gtk_menu_get_type(self)
	Gtk::Menu	self
	CODE:
	RETVAL = gtk_menu_get_type();
	OUTPUT:
	RETVAL

int
gtk_menu_get_size(self)
	Gtk::Menu	self
	CODE:
	RETVAL = sizeof(GtkMenu);
	OUTPUT:
	RETVAL


int
gtk_menu_get_class_size(self)
	Gtk::Menu	self
	CODE:
	RETVAL = sizeof(GtkMenuClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::MenuBar		PREFIX = gtk_menu_bar_

int
gtk_menu_bar_get_type(self)
	Gtk::MenuBar	self
	CODE:
	RETVAL = gtk_menu_bar_get_type();
	OUTPUT:
	RETVAL

int
gtk_menu_bar_get_size(self)
	Gtk::MenuBar	self
	CODE:
	RETVAL = sizeof(GtkMenuBar);
	OUTPUT:
	RETVAL


int
gtk_menu_bar_get_class_size(self)
	Gtk::MenuBar	self
	CODE:
	RETVAL = sizeof(GtkMenuBarClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::MenuItem		PREFIX = gtk_menu_item_

int
gtk_menu_item_get_type(self)
	Gtk::MenuItem	self
	CODE:
	RETVAL = gtk_menu_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_menu_item_get_size(self)
	Gtk::MenuItem	self
	CODE:
	RETVAL = sizeof(GtkMenuItem);
	OUTPUT:
	RETVAL


int
gtk_menu_item_get_class_size(self)
	Gtk::MenuItem	self
	CODE:
	RETVAL = sizeof(GtkMenuItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::MenuShell		PREFIX = gtk_menu_shell_

int
gtk_menu_shell_get_type(self)
	Gtk::MenuShell	self
	CODE:
	RETVAL = gtk_menu_shell_get_type();
	OUTPUT:
	RETVAL

int
gtk_menu_shell_get_size(self)
	Gtk::MenuShell	self
	CODE:
	RETVAL = sizeof(GtkMenuShell);
	OUTPUT:
	RETVAL


int
gtk_menu_shell_get_class_size(self)
	Gtk::MenuShell	self
	CODE:
	RETVAL = sizeof(GtkMenuShellClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Misc		PREFIX = gtk_misc_

int
gtk_misc_get_type(self)
	Gtk::Misc	self
	CODE:
	RETVAL = gtk_misc_get_type();
	OUTPUT:
	RETVAL

int
gtk_misc_get_size(self)
	Gtk::Misc	self
	CODE:
	RETVAL = sizeof(GtkMisc);
	OUTPUT:
	RETVAL


int
gtk_misc_get_class_size(self)
	Gtk::Misc	self
	CODE:
	RETVAL = sizeof(GtkMiscClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Notebook		PREFIX = gtk_notebook_

int
gtk_notebook_get_type(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = gtk_notebook_get_type();
	OUTPUT:
	RETVAL

int
gtk_notebook_get_size(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = sizeof(GtkNotebook);
	OUTPUT:
	RETVAL


int
gtk_notebook_get_class_size(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = sizeof(GtkNotebookClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Object		PREFIX = gtk_object_

int
gtk_object_get_type(self)
	Gtk::Object	self
	CODE:
	RETVAL = gtk_object_get_type();
	OUTPUT:
	RETVAL

int
gtk_object_get_size(self)
	Gtk::Object	self
	CODE:
	RETVAL = sizeof(GtkObject);
	OUTPUT:
	RETVAL


int
gtk_object_get_class_size(self)
	Gtk::Object	self
	CODE:
	RETVAL = sizeof(GtkObjectClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::OptionMenu		PREFIX = gtk_option_menu_

int
gtk_option_menu_get_type(self)
	Gtk::OptionMenu	self
	CODE:
	RETVAL = gtk_option_menu_get_type();
	OUTPUT:
	RETVAL

int
gtk_option_menu_get_size(self)
	Gtk::OptionMenu	self
	CODE:
	RETVAL = sizeof(GtkOptionMenu);
	OUTPUT:
	RETVAL


int
gtk_option_menu_get_class_size(self)
	Gtk::OptionMenu	self
	CODE:
	RETVAL = sizeof(GtkOptionMenuClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Paned		PREFIX = gtk_paned_

int
gtk_paned_get_type(self)
	Gtk::Paned	self
	CODE:
	RETVAL = gtk_paned_get_type();
	OUTPUT:
	RETVAL

int
gtk_paned_get_size(self)
	Gtk::Paned	self
	CODE:
	RETVAL = sizeof(GtkPaned);
	OUTPUT:
	RETVAL


int
gtk_paned_get_class_size(self)
	Gtk::Paned	self
	CODE:
	RETVAL = sizeof(GtkPanedClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Pixmap		PREFIX = gtk_pixmap_

int
gtk_pixmap_get_type(self)
	Gtk::Pixmap	self
	CODE:
	RETVAL = gtk_pixmap_get_type();
	OUTPUT:
	RETVAL

int
gtk_pixmap_get_size(self)
	Gtk::Pixmap	self
	CODE:
	RETVAL = sizeof(GtkPixmap);
	OUTPUT:
	RETVAL


int
gtk_pixmap_get_class_size(self)
	Gtk::Pixmap	self
	CODE:
	RETVAL = sizeof(GtkPixmapClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Preview		PREFIX = gtk_preview_

int
gtk_preview_get_type(self)
	Gtk::Preview	self
	CODE:
	RETVAL = gtk_preview_get_type();
	OUTPUT:
	RETVAL

int
gtk_preview_get_size(self)
	Gtk::Preview	self
	CODE:
	RETVAL = sizeof(GtkPreview);
	OUTPUT:
	RETVAL


int
gtk_preview_get_class_size(self)
	Gtk::Preview	self
	CODE:
	RETVAL = sizeof(GtkPreviewClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ProgressBar		PREFIX = gtk_progress_bar_

int
gtk_progress_bar_get_type(self)
	Gtk::ProgressBar	self
	CODE:
	RETVAL = gtk_progress_bar_get_type();
	OUTPUT:
	RETVAL

int
gtk_progress_bar_get_size(self)
	Gtk::ProgressBar	self
	CODE:
	RETVAL = sizeof(GtkProgressBar);
	OUTPUT:
	RETVAL


int
gtk_progress_bar_get_class_size(self)
	Gtk::ProgressBar	self
	CODE:
	RETVAL = sizeof(GtkProgressBarClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::RadioButton		PREFIX = gtk_radio_button_

int
gtk_radio_button_get_type(self)
	Gtk::RadioButton	self
	CODE:
	RETVAL = gtk_radio_button_get_type();
	OUTPUT:
	RETVAL

int
gtk_radio_button_get_size(self)
	Gtk::RadioButton	self
	CODE:
	RETVAL = sizeof(GtkRadioButton);
	OUTPUT:
	RETVAL


int
gtk_radio_button_get_class_size(self)
	Gtk::RadioButton	self
	CODE:
	RETVAL = sizeof(GtkRadioButtonClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::RadioMenuItem		PREFIX = gtk_radio_menu_item_

int
gtk_radio_menu_item_get_type(self)
	Gtk::RadioMenuItem	self
	CODE:
	RETVAL = gtk_radio_menu_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_radio_menu_item_get_size(self)
	Gtk::RadioMenuItem	self
	CODE:
	RETVAL = sizeof(GtkRadioMenuItem);
	OUTPUT:
	RETVAL


int
gtk_radio_menu_item_get_class_size(self)
	Gtk::RadioMenuItem	self
	CODE:
	RETVAL = sizeof(GtkRadioMenuItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Range		PREFIX = gtk_range_

int
gtk_range_get_type(self)
	Gtk::Range	self
	CODE:
	RETVAL = gtk_range_get_type();
	OUTPUT:
	RETVAL

int
gtk_range_get_size(self)
	Gtk::Range	self
	CODE:
	RETVAL = sizeof(GtkRange);
	OUTPUT:
	RETVAL


int
gtk_range_get_class_size(self)
	Gtk::Range	self
	CODE:
	RETVAL = sizeof(GtkRangeClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Ruler		PREFIX = gtk_ruler_

int
gtk_ruler_get_type(self)
	Gtk::Ruler	self
	CODE:
	RETVAL = gtk_ruler_get_type();
	OUTPUT:
	RETVAL

int
gtk_ruler_get_size(self)
	Gtk::Ruler	self
	CODE:
	RETVAL = sizeof(GtkRuler);
	OUTPUT:
	RETVAL


int
gtk_ruler_get_class_size(self)
	Gtk::Ruler	self
	CODE:
	RETVAL = sizeof(GtkRulerClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Scale		PREFIX = gtk_scale_

int
gtk_scale_get_type(self)
	Gtk::Scale	self
	CODE:
	RETVAL = gtk_scale_get_type();
	OUTPUT:
	RETVAL

int
gtk_scale_get_size(self)
	Gtk::Scale	self
	CODE:
	RETVAL = sizeof(GtkScale);
	OUTPUT:
	RETVAL


int
gtk_scale_get_class_size(self)
	Gtk::Scale	self
	CODE:
	RETVAL = sizeof(GtkScaleClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Scrollbar		PREFIX = gtk_scrollbar_

int
gtk_scrollbar_get_type(self)
	Gtk::Scrollbar	self
	CODE:
	RETVAL = gtk_scrollbar_get_type();
	OUTPUT:
	RETVAL

int
gtk_scrollbar_get_size(self)
	Gtk::Scrollbar	self
	CODE:
	RETVAL = sizeof(GtkScrollbar);
	OUTPUT:
	RETVAL


int
gtk_scrollbar_get_class_size(self)
	Gtk::Scrollbar	self
	CODE:
	RETVAL = sizeof(GtkScrollbarClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ScrolledWindow		PREFIX = gtk_scrolled_window_

int
gtk_scrolled_window_get_type(self)
	Gtk::ScrolledWindow	self
	CODE:
	RETVAL = gtk_scrolled_window_get_type();
	OUTPUT:
	RETVAL

int
gtk_scrolled_window_get_size(self)
	Gtk::ScrolledWindow	self
	CODE:
	RETVAL = sizeof(GtkScrolledWindow);
	OUTPUT:
	RETVAL


int
gtk_scrolled_window_get_class_size(self)
	Gtk::ScrolledWindow	self
	CODE:
	RETVAL = sizeof(GtkScrolledWindowClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Separator		PREFIX = gtk_separator_

int
gtk_separator_get_type(self)
	Gtk::Separator	self
	CODE:
	RETVAL = gtk_separator_get_type();
	OUTPUT:
	RETVAL

int
gtk_separator_get_size(self)
	Gtk::Separator	self
	CODE:
	RETVAL = sizeof(GtkSeparator);
	OUTPUT:
	RETVAL


int
gtk_separator_get_class_size(self)
	Gtk::Separator	self
	CODE:
	RETVAL = sizeof(GtkSeparatorClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Table		PREFIX = gtk_table_

int
gtk_table_get_type(self)
	Gtk::Table	self
	CODE:
	RETVAL = gtk_table_get_type();
	OUTPUT:
	RETVAL

int
gtk_table_get_size(self)
	Gtk::Table	self
	CODE:
	RETVAL = sizeof(GtkTable);
	OUTPUT:
	RETVAL


int
gtk_table_get_class_size(self)
	Gtk::Table	self
	CODE:
	RETVAL = sizeof(GtkTableClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Text		PREFIX = gtk_text_

int
gtk_text_get_type(self)
	Gtk::Text	self
	CODE:
	RETVAL = gtk_text_get_type();
	OUTPUT:
	RETVAL

int
gtk_text_get_size(self)
	Gtk::Text	self
	CODE:
	RETVAL = sizeof(GtkText);
	OUTPUT:
	RETVAL


int
gtk_text_get_class_size(self)
	Gtk::Text	self
	CODE:
	RETVAL = sizeof(GtkTextClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::ToggleButton		PREFIX = gtk_toggle_button_

int
gtk_toggle_button_get_type(self)
	Gtk::ToggleButton	self
	CODE:
	RETVAL = gtk_toggle_button_get_type();
	OUTPUT:
	RETVAL

int
gtk_toggle_button_get_size(self)
	Gtk::ToggleButton	self
	CODE:
	RETVAL = sizeof(GtkToggleButton);
	OUTPUT:
	RETVAL


int
gtk_toggle_button_get_class_size(self)
	Gtk::ToggleButton	self
	CODE:
	RETVAL = sizeof(GtkToggleButtonClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Tree		PREFIX = gtk_tree_

int
gtk_tree_get_type(self)
	Gtk::Tree	self
	CODE:
	RETVAL = gtk_tree_get_type();
	OUTPUT:
	RETVAL

int
gtk_tree_get_size(self)
	Gtk::Tree	self
	CODE:
	RETVAL = sizeof(GtkTree);
	OUTPUT:
	RETVAL


int
gtk_tree_get_class_size(self)
	Gtk::Tree	self
	CODE:
	RETVAL = sizeof(GtkTreeClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::TreeItem		PREFIX = gtk_tree_item_

int
gtk_tree_item_get_type(self)
	Gtk::TreeItem	self
	CODE:
	RETVAL = gtk_tree_item_get_type();
	OUTPUT:
	RETVAL

int
gtk_tree_item_get_size(self)
	Gtk::TreeItem	self
	CODE:
	RETVAL = sizeof(GtkTreeItem);
	OUTPUT:
	RETVAL


int
gtk_tree_item_get_class_size(self)
	Gtk::TreeItem	self
	CODE:
	RETVAL = sizeof(GtkTreeItemClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VBox		PREFIX = gtk_vbox_

int
gtk_vbox_get_type(self)
	Gtk::VBox	self
	CODE:
	RETVAL = gtk_vbox_get_type();
	OUTPUT:
	RETVAL

int
gtk_vbox_get_size(self)
	Gtk::VBox	self
	CODE:
	RETVAL = sizeof(GtkVBox);
	OUTPUT:
	RETVAL


int
gtk_vbox_get_class_size(self)
	Gtk::VBox	self
	CODE:
	RETVAL = sizeof(GtkVBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VButtonBox		PREFIX = gtk_vbutton_box_

int
gtk_vbutton_box_get_type(self)
	Gtk::VButtonBox	self
	CODE:
	RETVAL = gtk_vbutton_box_get_type();
	OUTPUT:
	RETVAL

int
gtk_vbutton_box_get_size(self)
	Gtk::VButtonBox	self
	CODE:
	RETVAL = sizeof(GtkVButtonBox);
	OUTPUT:
	RETVAL


int
gtk_vbutton_box_get_class_size(self)
	Gtk::VButtonBox	self
	CODE:
	RETVAL = sizeof(GtkVButtonBoxClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VPaned		PREFIX = gtk_vpaned_

int
gtk_vpaned_get_type(self)
	Gtk::VPaned	self
	CODE:
	RETVAL = gtk_vpaned_get_type();
	OUTPUT:
	RETVAL

int
gtk_vpaned_get_size(self)
	Gtk::VPaned	self
	CODE:
	RETVAL = sizeof(GtkVPaned);
	OUTPUT:
	RETVAL


int
gtk_vpaned_get_class_size(self)
	Gtk::VPaned	self
	CODE:
	RETVAL = sizeof(GtkVPanedClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VRuler		PREFIX = gtk_vruler_

int
gtk_vruler_get_type(self)
	Gtk::VRuler	self
	CODE:
	RETVAL = gtk_vruler_get_type();
	OUTPUT:
	RETVAL

int
gtk_vruler_get_size(self)
	Gtk::VRuler	self
	CODE:
	RETVAL = sizeof(GtkVRuler);
	OUTPUT:
	RETVAL


int
gtk_vruler_get_class_size(self)
	Gtk::VRuler	self
	CODE:
	RETVAL = sizeof(GtkVRulerClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VScale		PREFIX = gtk_vscale_

int
gtk_vscale_get_type(self)
	Gtk::VScale	self
	CODE:
	RETVAL = gtk_vscale_get_type();
	OUTPUT:
	RETVAL

int
gtk_vscale_get_size(self)
	Gtk::VScale	self
	CODE:
	RETVAL = sizeof(GtkVScale);
	OUTPUT:
	RETVAL


int
gtk_vscale_get_class_size(self)
	Gtk::VScale	self
	CODE:
	RETVAL = sizeof(GtkVScaleClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VScrollbar		PREFIX = gtk_vscrollbar_

int
gtk_vscrollbar_get_type(self)
	Gtk::VScrollbar	self
	CODE:
	RETVAL = gtk_vscrollbar_get_type();
	OUTPUT:
	RETVAL

int
gtk_vscrollbar_get_size(self)
	Gtk::VScrollbar	self
	CODE:
	RETVAL = sizeof(GtkVScrollbar);
	OUTPUT:
	RETVAL


int
gtk_vscrollbar_get_class_size(self)
	Gtk::VScrollbar	self
	CODE:
	RETVAL = sizeof(GtkVScrollbarClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::VSeparator		PREFIX = gtk_vseparator_

int
gtk_vseparator_get_type(self)
	Gtk::VSeparator	self
	CODE:
	RETVAL = gtk_vseparator_get_type();
	OUTPUT:
	RETVAL

int
gtk_vseparator_get_size(self)
	Gtk::VSeparator	self
	CODE:
	RETVAL = sizeof(GtkVSeparator);
	OUTPUT:
	RETVAL


int
gtk_vseparator_get_class_size(self)
	Gtk::VSeparator	self
	CODE:
	RETVAL = sizeof(GtkVSeparatorClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Viewport		PREFIX = gtk_viewport_

int
gtk_viewport_get_type(self)
	Gtk::Viewport	self
	CODE:
	RETVAL = gtk_viewport_get_type();
	OUTPUT:
	RETVAL

int
gtk_viewport_get_size(self)
	Gtk::Viewport	self
	CODE:
	RETVAL = sizeof(GtkViewport);
	OUTPUT:
	RETVAL


int
gtk_viewport_get_class_size(self)
	Gtk::Viewport	self
	CODE:
	RETVAL = sizeof(GtkViewportClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Widget		PREFIX = gtk_widget_

int
gtk_widget_get_type(self)
	Gtk::Widget	self
	CODE:
	RETVAL = gtk_widget_get_type();
	OUTPUT:
	RETVAL

int
gtk_widget_get_size(self)
	Gtk::Widget	self
	CODE:
	RETVAL = sizeof(GtkWidget);
	OUTPUT:
	RETVAL


int
gtk_widget_get_class_size(self)
	Gtk::Widget	self
	CODE:
	RETVAL = sizeof(GtkWidgetClass);
	OUTPUT:
	RETVAL

	
MODULE = Gtk	PACKAGE = Gtk::Window		PREFIX = gtk_window_

int
gtk_window_get_type(self)
	Gtk::Window	self
	CODE:
	RETVAL = gtk_window_get_type();
	OUTPUT:
	RETVAL

int
gtk_window_get_size(self)
	Gtk::Window	self
	CODE:
	RETVAL = sizeof(GtkWindow);
	OUTPUT:
	RETVAL


int
gtk_window_get_class_size(self)
	Gtk::Window	self
	CODE:
	RETVAL = sizeof(GtkWindowClass);
	OUTPUT:
	RETVAL

