#                                                                            #
# Hetero Streams Library - A streaming library for heterogeneous platforms   #
# Copyright (c) 2014 - 2016, Intel Corporation.                              #
#                                                                            #
# This program is free software; you can redistribute it and/or modify it    #
# under the terms and conditions of the GNU Lesser General Public License,   #
# version 2.1, as published by the Free Software Foundation.                 #
#                                                                            #
# This program is distributed in the hope it will be useful, but WITHOUT ANY #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS  #
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for   #
# more details.                                                              #
#                                                                            #

name    := hstreams
version_major := 1
version_minor := 0
version_micro := 0
ifdef BUILDNO
version_build := $(BUILDNO)
else
version_build := DEVBOX
endif

version := $(version_major).$(version_minor).$(version_micro).$(version_build)

.PHONY: all
all: build-host build-knc-card build-doc
.PHONY: install
install: install-knc

# Here's the root directory
TOP_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOP_DIR)conf/mk/toolchain.mk
include $(TOP_DIR)conf/mk/knc-card.mk
include $(TOP_DIR)conf/mk/host.mk
include $(TOP_DIR)conf/mk/headers.mk
include $(TOP_DIR)conf/mk/doc.mk
include $(TOP_DIR)conf/mk/artifacts.mk

# Check formatting (only if we're not doing formatting right now). Also do not check
# if prepping for rpm creation
ifeq "$(or $(findstring $(MAKECMDGOALS),format),$(findstring $(MAKECMDGOALS),artifacts))" ""
    ifneq ($(strip $(shell $(ASTYLE) $(ASTYLE_OPTIONS) --dry-run | grep ^Formatted)),)
        $(warning [WARN] The code is not formatted properly. Please run make format)
    endif # ifneq ($(strip $(shell $(ASTYLE) $(ASTYLE_OPTIONS) --dry-run | grep ^Formatted)),)
endif

format:
	$(ASTYLE) $(ASTYLE_OPTIONS)

.PHONY: install-knc
install-knc: install-host install-knc-card install-headers install-doc

.PHONY: clean
clean: clean-host clean-knc-card clean-doc
