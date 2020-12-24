AVR_CXXFLAGS= \
-funsigned-char                                                       \
-funsigned-bitfields                                                  \
-fdata-sections                                                       \
-fpack-struct                                                         \
-fshort-enums                                                         \
-g2                                                                   \
-Wall                                                                 \
-mmcu=$($($(_flavor_)_build)_MCU)                                     \
-Os                                                                   \
-ffunction-sections                                                   \
-DF_CPU=8000000L                                                      

define AVR_MAKE
CC:=avr-gcc
CFLAGS:=-std=gnu11 $(AVR_CXXFLAGS)
AR:=avr-ar
AFLAGS:=-rcs
LFLAGS:=-rcT
CP:=-ln
CMACROS:=$($($(_flavor_)_build)_MACROS)
LD_LIBS:=$($($(_flavor_)_build)_PROJ_LIBS)
CPFLAGS:=-sf
CPP:=avr-g++
CPPFLAGS:=-std=gnu++11 $(AVR_CXXFLAGS) -fno-threadsafe-statics
RECIPES=gcc
endef

$(eval $(call Verbose,$(call AVR_MAKE)))
