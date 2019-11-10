#
#   Generador de programa convert.exe
#
#    Builds convert.exe
#
.SUFFIXES: 
.SUFFIXES:              .F .f .i .o .mod
objetcs = module_var_nei.o lee_NEI.o lee_wrfinput.o guarda.o convierte.o
DEPS = module_var_nei.o
CD      =       cd
LN      =       ln -s
MAKE    =       make -i -f Makefile
RM      =       /bin/rm -f
RM_LIST =       *.mod *.o core .tmpfile *.exe
# Makefile
default:
	uname -a > .tmpfile
	grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux" ;               \
	( $(MAKE) all                               \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = DEC"          \
	"MAKE           = $(MAKE)"      "CPP            = /lib/cpp"     \
	"CPPFLAGS       = -I. -C -traditional"  \
	"FC             = ifort"   "CFLAGS         = -I."       \
	"LDOPTIONS      = -O2 -axAVX  -align commons  -lnetcdff -L$(NETCDF)/lib "          \
	"FCFLAGS        = -O2 -axAVX  -align commons -I$(NETCDF)/include " \
	"LOCAL_LIBRARIES= " ) ; \
	else \
	grep Darwin .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Darwin" ;              \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = DEC"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
	"CPPFLAGS       = -I. -C "      \
	"FC             = ifort"        "CFLAGS         = -I." \
	"LDOPTIONS      = -fast -axAVX  -align commons  -lnetcdff -L$(NETCDF)/lib  " \
	"FCFLAGS        = -fast -axAVX  -align commons -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else echo "Do not know how to compile for the `cat .tmpfile` machine." \
	fi ; \
	fi ; \
	fi ; \

pgi:
	uname -a >  .tmpfile
	grep Linux .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Linux PGI" ;               \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = PGI"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
 	"CPPFLAGS       = -I.  "      \
	"FC             = pgf90"        "FCFLAGS        = -O3 -fastsse -Mfree" \
	"LDOPTIONS      = -O3 -fastsse -Mfree -lnetcdff -L$(NETCDF)/lib" \
	"FCFLAGS        = -O3 -fastsse -Mfree -lnetcdff -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else \
	grep Darwin .tmpfile ; \
	if [ $$? = 0 ]; then echo "Compiling for Darwin PGI" ;              \
	( $(MAKE) all                          \
	"RM             = $(RM)"        "RM_LIST        = $(RM_LIST)"   \
	"LN             = $(LN)"        "MACH           = PGI"          \
	"MAKE           = $(MAKE)"      "CPP            = fpp"  \
	"CPPFLAGS       =  "      \
	"FC             = pgf90"        "FCFLAGS        = -O3 -fastsse -Mfree" \
	"LDOPTIONS      = -O3 -fastsse -Mfree -lnetcdff -L$(NETCDF)/lib" \
	"FCFLAGS        = -O3 -fastsse -Mfree -lnetcdff -I$(NETCDF)/include"          \
	"LOCAL_LIBRARIES=  " ) ; \
	else echo "Do not know how to compile for the `cat .tmpfile` machine." \
	fi ; \
	fi ; \
	fi ; \

all: convert.exe

convert.exe: $(objetcs)
	$(FC) -o $@ $^  $(LDOPTIONS)

%.mod: %.f90 $(DEPS)
	$(FC) -c -o $@ $^ $(FCFLAGS)

%.o: %.f90
	$(FC) -c -o $@ $^ $(FCFLAGS)

.PHONY: clean
clean:
	$(RM) $(RM_LIST)
