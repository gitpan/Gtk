
add_headers "<gtkglarea.h>";
	
$libs =~ s/-l/-lgtkgla -lMesaGL -lMesaGLU -l/; #hack hack
