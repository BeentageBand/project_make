define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=gnu99
AR:=ar
AFLAGS:=-rcs
CP:=-cp
CPFLAGS:=-Pf

endef

$(eval $(call Verbose,$(call LINUX_MAKE)))

include $(PROJ_MAK_DIR)/make.mk