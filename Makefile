SHARED_FSPATH=./../shared
BOILERPLATE_FSPATH=$(SHARED_FSPATH)/boilerplate

include $(BOILERPLATE_FSPATH)/help.mk
include $(BOILERPLATE_FSPATH)/os.mk
include $(BOILERPLATE_FSPATH)/gitr.mk
include $(BOILERPLATE_FSPATH)/tool.mk
include $(BOILERPLATE_FSPATH)/flu.mk
include $(BOILERPLATE_FSPATH)/go.mk


# remove the "v" prefix
VERSION ?= $(shell echo $(TAGGED_VERSION) | cut -c 2-)

override FLU_SAMPLE_NAME =client
override FLU_LIB_NAME =client

this-all: this-print this-dep this-build this-print-end
 
## Print all settings
this-print: 
	@echo
	@echo "-- SYS-SHARE: start --"
	@echo
	@echo

this-print-end:
	@echo
	@echo "-- SYS-SHARE: end --"
	@echo
	@echo

this-dep:
	cd $(SHARED_FSPATH) && $(MAKE) this-all

this-build:

	cd sys-account && $(MAKE) this-all
