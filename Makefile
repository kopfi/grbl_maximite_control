# file: Makefile
# project: TFT Maximate control application for a GRBL-based mill
# author: Michael Kopfensteiner
#
# This work is based upon the sourcecode that was provided by the
# c't Hacks magazine and that its description in the c't Hacks 01/2014.
#


# The directory that is used to prepare the final SDCard structure
OUTDIR := sdcard
# A list of subdirectories, that are created underneath the sdcard directory
SUBDIRS := IMG LIB GCODE LOG APP JOBS
# The applications that shall be copied
APPS := AUTORUN INIT MENU USB GFILE JOG
# The libraries that shall be copied
LIBRARIES := COM FSEL GCODE


####
# Internal Variables
####
RESDIR := resources
SRCDIR := src
SRCLIBDIR := $(SRCDIR)/lib

OUTSUBDIRSFULL := $(foreach SUBDIR,$(SUBDIRS),$(OUTDIR)/$(SUBDIR))
OUTLIBPATH := $(OUTDIR)/LIB
OUTAPPS := $(foreach APP,$(APPS),$(OUTDIR)/$(APP).BAS)
OUTLIBS := $(foreach LIBRARY,$(LIBRARIES),$(OUTLIBPATH)/$(LIBRARY).LIB)
APPDIR := $(OUTDIR)/APP
OUTIMGDIR = $(OUTDIR)/IMG

all: $(OUTLIBS) $(OUTAPPS) $(OUTSUBDIRSFULL)

$(OUTDIR)/%.BAS: $(SRCDIR)/%.BAS $(OUTDIR) $(APPDIR) misc
	@echo "Install App: $*"
	@if [ -e $(RESDIR)/$* ]; then \
		cp -R "$(RESDIR)/$*" $(OUTDIR)/APP/; \
	 fi
	@cp $< $@

$(OUTLIBPATH)/%.LIB: $(SRCDIR)/lib/%.LIB $(OUTLIBPATH)
	@echo "Install Library: $*"
	@cp $< $@

$(OUTDIR):
	@echo Create output directory
	@mkdir -p $@

$(OUTSUBDIRSFULL): $(OUTDIR)
	@mkdir -p $@

misc: $(OUTSUBDIRSFULL)
	@cp images/*.BMP $(OUTIMGDIR)
