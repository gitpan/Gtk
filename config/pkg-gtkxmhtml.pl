


# we need to know what libraries are used by the
# gtkxmhtml lib we are going to link to....
$libs =~ s/-l/$ENV{GTKXMHTML_LIBS} -l/; # hack hack
