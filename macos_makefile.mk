define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=c11 -g 
AR:=ar
AFLAGS:=-rcs
LFLAGS:=-rcT
CP:=-ln
CMACROS:=$($($(_flavor_)_build)_MACROS)
LD_LIBS:=$($($(_flavor_)_build)_PROJ_LIBS)
CPFLAGS:=-sf
CPP:=g++
CXX:=g++
CPPFLAGS:=-std=c++11 -g
RECIPES=gcc_macos
endef

$(eval $(call Verbose,$(call LINUX_MAKE)))
