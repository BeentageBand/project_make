define LINUX_MAKE
CC:=gcc
CFLAGS:=-std=gnu11 -Wall -pthread -g
AR:=ar
AFLAGS:=-rcs
LFLAGS:=-rcT
CP:=-cp
CMACROS:=$($($(_flavor_)_build)_MACROS)
CPFLAGS:=-sf
CPP:=g++
CPPFLAGS:=-std=gnu++11 -Wall -pthread -g
RECIPES=gcc
endef

$(eval $(call Verbose,$(call LINUX_MAKE)))
