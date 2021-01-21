#
# This file is processed by automake (produces file Makefile.in)
#
ACLOCAL_AMFLAGS = -I autoconf

bin_PROGRAMS = convert.exe

# Additional files to be cleaned with 'make clean'
CLEANFILES = *.o *.mod 
# Compiler flags
  FC =$(NC_FC)
  AM_FCFLAGS  = $(NC_INC)
  AM_FCFLAGS += $(NC_LIB)

TESTSUITE = $(srcdir)/testsuite
     

convert_exe_SOURCES = module_var_nei.F90 lee_NEI.F90 lee_wrfinput.F90 guarda.F90 convierte.F90

SUBDIRS = . testsuite

EXTRA_DIST = README.md assets _config.yml Doc/Makefile Doc/doxygen_nei.conf 
EXTRA_DIST += $(TESTSUITE) 

.PHONY: $(EXTRA_DIST)
$(EXTRA_DIST):

