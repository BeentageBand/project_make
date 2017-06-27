##============================================================================#
# Eval Feat's Target 
##============================================================================#
define Add_Include
$(_flavor_)_INC+=$($(_flavor_)_$(_feat_)_inc)
endef

define Add_Binary
$(_flavor_)_BIN+=$($(_flavor_)_$(_feat_)_bin)
endef
##============================================================================#
# Include build's CC config
##============================================================================#

$(eval $(call Verbose,$(call $(_flavor_)_$(_feat_)_MAKE)))
$(eval $(call Verbose,$(call Add_Include)))
$(eval $(call Verbose,$(call Add_Binary)))
