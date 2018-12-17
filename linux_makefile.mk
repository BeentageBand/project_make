define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=gnu11 -g 
AR:=ar
AFLAGS:=-rcs
LFLAGS:=-rcT
CP:=-ln
CMACROS:=$($($(_flavor_)_build)_MACROS)
LD_LIBS:=$($($(_flavor_)_build)_PROJ_LIBS)
CPFLAGS:=-sf
CPP:=g++
CPPFLAGS:=-std=gnu++11 -g
RECIPES=gcc
endef

$(eval $(call Verbose,$(call LINUX_MAKE)))
