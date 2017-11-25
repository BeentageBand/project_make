define ARDUINO_MAKE
ARDUINO_BUILDER=$(ARDUINO_PACKAGE_PATH)/arduino-builder
ARDUINO_HW=$(ARDUINO_PACKAGE_PATH)/hardware/
ARDUINO_TOOLS=$(ARDUINO_PACKAGE_PATH)/hardware/tools/ $(ARDUINO_PACKAGE_PATH)/tools-builder/
ARDUINO_QFBN=arduino:avr:uno
RECIPES=arduino-builder
endef

$(eval $(call Verbose,$(call ARDUINO_MAKE)))
