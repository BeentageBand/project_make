define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=gnu99 -Wall -pthread -g
AR:=ar
AFLAGS:=-rcs
CP:=-cp
CPFLAGS:=-Pf

CPP:=g++
CPPFLAGS:=-std=gnu++11 -Wall -pthread -g

endef

$(eval $(call Verbose,$(call LINUX_MAKE)))

include $(PROJ_MAK_DIR)/make.mk