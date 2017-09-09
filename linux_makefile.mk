define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=c99 -Wall -pthread -g
AR:=ar
AFLAGS:=-rcs
LFLAGS:=-rcT
CP:=-cp
CPFLAGS:=-sf
CPP:=g++
CPPFLAGS:=-std=c++11 -Wall -pthread -g
endef

$(eval $(call Verbose,$(call LINUX_MAKE)))
