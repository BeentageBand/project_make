##============================================================================#
# Verbose 
# Brief: make verbose
# 1 : statement
##============================================================================#
define Verbose
$(1)
endef

##============================================================================#
# Project Setup
# Brief: searches features in project
##============================================================================#
define Project_Setup
FEATURE_LIST=$(shell find $(PROJ_DIR) -name *_make.mk)
ifndef OUT_DIR
OUT_DIR=$(PROJ_DIR)/out
endif
endef

##============================================================================#
# Call_Build
# Brief: defines project targets
##============================================================================#
define Call_Build

.PHONY : all clean-all $(FLAVOR_LIST:%=clean-%) $(FLAVOR_LIST)


all : $(FLAVOR_LIST)
	echo $(FLAVOR_LIST);

$(OUT_DIR) :
	-mkdir $$@;

clean-all:
	-rm -rf $(OUT_DIR) $(FLAVOR_LIST:%=$($(%)_clean));
	
endef

##============================================================================#
# Make_Flavors
# Brief: declare flavor and flavor output dir
# 1 : flavor name
##============================================================================#
define Make_Flavors
_flavor_:=$(1)
$(1)_OUT_DIR=$(OUT_DIR)/$(1)
endef

##============================================================================#
# Flavor_Setup
# Brief : declares flavor output dir tree
##============================================================================#
define Flavor_Setup
$(_flavor_)_INC_DIR=$($(_flavor_)_OUT_DIR)/inc
$(_flavor_)_LIB_DIR=$($(_flavor_)_OUT_DIR)/lib
$(_flavor_)_OBJ_DIR=$($(_flavor_)_OUT_DIR)/obj
$(_flavor_)_BIN_DIR=$($(_flavor_)_OUT_DIR)/bin

endef

##============================================================================#
# Call_Flavor
# Brief : defines targets for specific flavor 
##============================================================================#
define Call_Flavor

$(_flavor_) : $($(_flavor_)_BIN:%=$($(_flavor_)_BIN_DIR)/%)

$($(_flavor_)_INC_DIR) $($(_flavor_)_BIN_DIR) $($(_flavor_)_LIB_DIR) $($(_flavor_)_OBJ_DIR) : $($(_flavor_)_OUT_DIR)
	-mkdir $$@;

$($(_flavor_)_OUT_DIR) : $(OUT_DIR)
	-mkdir $$@;

clean-$(_flavor_) :
	-rm -rf $($(_flavor_)_OUT_DIR) $($(_flavor_)_clean);

endef

##============================================================================#
# Make_Feat
# Brief: searches features dir and makes targets
# 1 : feat's filename
##============================================================================#
define Make_Feat
$(_flavor_)_$(_feat_)_dir=$(dir $(1))
include $(1)
endef

##============================================================================#
# Eval Project's Build
##============================================================================#
$(eval $(call Verbose,$(call Project_Make)))
$(eval $(call Verbose,$(call Project_Setup)))
$(eval $(call Verbose,$(call Call_Build)))
$(foreach fl,$(FLAVOR_LIST),\
   $(eval $(call Verbose,$(call Make_Flavors,$(fl)))) \
   $(eval $(call Verbose,$(call Flavor_Setup))) \
   $(eval $(call Verbose,$(fl)_PROJ_INC+=$($(fl)_INC_DIR))) \
   $(eval $(call Verbose,include $(PROJ_MAK_DIR)/$($(_flavor_)_build)_makefile.mk)) \
   $(foreach ft,$(FEATURE_LIST),\
      $(eval $(call Verbose,_feat_:=$(notdir $(ft:_make.mk=)))) \
      $(eval $(call Verbose,$(call Make_Feat,$(ft)))) \
   )\
   $(foreach ft,$(FEATURE_LIST),\
      $(eval $(call Verbose,_feat_:=$(notdir $(ft:_make.mk=)))) \
      $(eval $(call Verbose,include $(PROJ_MAK_DIR)/$(RECIPES).mk)) \
   ) \
   $(eval $(call Verbose,$(call Call_Flavor))) \
)
