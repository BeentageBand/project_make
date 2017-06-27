define Bin_Target
$($(_flavor_)_$(_feat_)_bin:%=$($(_flavor_)_BIN_DIR)/%) : $($(_flavor_)_$(_feat_)_bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $($(_flavor_)_$(_feat_)_bin_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a) $($(_flavor_)_INC:$($(_flavor_)_INC_DIR)/%.h) $($(_flavor_)_BIN_DIR)
	$(CC) $(CFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-iquote %) -o $$@ $($(_flavor_)_$(_feat_)_bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) -L $($(_flavor_)_LIB_DIR) $($(_flavor_)_$(_feat_)_bin_libs:%=-l%);
endef

define Inc_Target
$($(_flavor_)_INC_DIR)/%.h : $($(_flavor_)_$(_feat_)_dir)/%.h $($(_flavor_)_INC_DIR)
	$(CP) $(CPFLAGS) $$< $$@;
endef

define Lib_Target
$($(_flavor_)_$(_feat_)_lib:%=$($(_flavor_)_LIB_DIR)/lib%.a) : $($(_flavor_)_$(_feat_)_lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $($(_flavor_)_LIB_DIR)
	$(AR) $(AFLAGS) $$@ $($(_flavor_)_$(_feat_)_lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o);
endef

define Obj_Target
$($(_flavor_)_OBJ_DIR)/%.o : $($(_flavor_)_$(_feat_)_dir)/%.c $($(_flavor_)_INC:%=$($(_flavor_)_INC_DIR)/%.h) $($(_flavor_)_OBJ_DIR)
	$(CC) $(CFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-iquote %) -o $$@ -c $$<;
endef

ifneq "" "$($(_flavor_)_$(_feat_)_bin)$($(_flavor_)_$(_feat_)_bin_libs)$($(_flavor_)_$(_feat_)_bin_objs)"
$(eval $(call Verbose,$(call Bin_Target)))
endif

ifneq "" "$($(_flavor_)_$(_feat_)_lib)$($(_flavor_)_$(_feat_)_lib_objs)"
$(eval $(call Verbose,$(call Lib_Target)))
endif

$(eval $(call Verbose,$(call Inc_Target)))
$(eval $(call Verbose,$(call Obj_Target)))
