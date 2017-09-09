##============================================================================#
# Bin_Target
# Brief : binary target from libs and objs reqs
##============================================================================#
define Bin_Target
$(bin:%=$($(_flavor_)_BIN_DIR)/%) : $(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $(bin_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a) $($(_flavor_)_INC:$($(_flavor_)_INC_DIR)/%) $($(_flavor_)_BIN_DIR)
	$(CPP) $(CPPFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-iquote %) -o $$@ $(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) -L $($(_flavor_)_LIB_DIR) $(bin_libs:%=-l%);
endef
##============================================================================#
# Inc_Target
# Brief : include target from publich api headers
# 1 : inc name
##============================================================================#
define Inc_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1))"
$($(_flavor_)_INC_DIR)/$(1) : $(realpath $($(_flavor_)_$(_feat_)_dir))/$(1) $($(_flavor_)_INC_DIR)
	$(CP) $(CPFLAGS) $$< $$@;
endif
endef
##============================================================================#
# Lib_Target
# Brief : static library target from output reqs
##============================================================================#
define Lib_Target
$(lib:%=$($(_flavor_)_LIB_DIR)/lib%.a) : $(lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $(lib_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a) $($(_flavor_)_LIB_DIR)
ifdef $(_flavor_)_$(_feat_)_lib_objs
	$(AR) $(AFLAGS) $$@ $(lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o);
else
	$(AR) $(LFLAGS) $$@ $(lib_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a);
endif
endef

##============================================================================#
# Obj_Target
# Brief : object target from C/C++ source files only reqs
# 1 : src name
# 1 : src extension
##============================================================================#
define Obj_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1).$(2))"
$($(_flavor_)_OBJ_DIR)/$(1).o : $($(_flavor_)_$(_feat_)_dir)$(1).$(2) $($(_flavor_)_INC:%=$($(_flavor_)_INC_DIR)/%) $($(_flavor_)_OBJ_DIR)
  ifeq "cpp" "$(2)"
	$(CPP) $(CPPFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-iquote %) -o $$@ -c $$<;
  else
	$(CC) $(CFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-iquote %) -o $$@ -c $$<;
  endif
endif
endef

##============================================================================#
# Call Targets
##============================================================================#
bin:=$($(_flavor_)_$(_feat_)_bin)
bin_objs:=$($(_flavor_)_$(_feat_)_bin_objs)
bin_libs:=$($(_flavor_)_$(_feat_)_bin_libs)

lib:=$($(_flavor_)_$(_feat_)_lib)
lib_objs:=$($(_flavor_)_$(_feat_)_lib_objs)
lib_libs:=$($(_flavor_)_$(_feat_)_lib_libs)

ifneq "" "$($(_flavor_)_$(_feat_)_bin)$($(_flavor_)_$(_feat_)_bin_libs)$($(_flavor_)_$(_feat_)_bin_objs)"
$(eval $(call Verbose,$(call Bin_Target)))
endif

ifndef $(_flavor_)_$(_feat_)_ovr_lib_tar
ifneq "" "$($(_flavor_)_$(_feat_)_lib)"
$(eval $(call Verbose,$(call Lib_Target)))
endif
endif

$(foreach inc,$($(_flavor_)_$(_feat_)_inc),\
   $(eval $(call Verbose,$(call Inc_Target,$(inc)))) \
)

$(foreach src,$($(_flavor_)_$(_feat_)_bin_objs) $($(_flavor_)_$(_feat_)_lib_objs),\
   $(eval $(call Verbose,$(call Obj_Target,$(src),c)))\
   $(eval $(call Verbose,$(call Obj_Target,$(src),cpp)))\
)
