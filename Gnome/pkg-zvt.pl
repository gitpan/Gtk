
add_defs 'pkg-zvt.defs';
add_typemap 'pkg-zvt.typemap';

add_headers (qw( <zvt/zvtterm.h> ));

$libs = "-lzvt $libs";
