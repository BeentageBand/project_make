define Bin_Target
$(bin:%=$($(_flavor_)_BIN_DIR)/%) : $(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $(bin_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a) $($(_flavor_)_INC:$($(_flavor_)_INC_DIR)/%) $($(_flavor_)_BIN_DIR)
	-@echo "Link $(bin)-$(_flavor_) .."
	$(CPP) $(CPPFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-I %) -o $$@ $(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) -L $($(_flavor_)_LIB_DIR) $(bin_libs:%=-l%) $($($(_flavor_)_build)_PROJ_LIBS) ;
endef

define Inc_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1))"
$($(_flavor_)_INC_DIR)/$(1) : $(realpath $($(_flavor_)_$(_feat_)_dir))/$(1) $($(_flavor_)_INC_DIR)
	-@echo "Copying $(_feat_)-$(_flavor_) dependencies ..."
	@$(CP) $(CPFLAGS) $$< $$@;
endif
endef

define Lib_Target
$(lib:%=$($(_flavor_)_LIB_DIR)/lib%.a) : $(lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o) $(lib_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a) $($(_flavor_)_LIB_DIR)
	-@echo "Compiling $(_feat_)-$(_flavor_) ...";
ifdef $(_flavor_)_$(_feat_)_lib_objs
	@$(AR) $(AFLAGS) $$@ $(lib_objs:%=$($(_flavor_)_OBJ_DIR)/%.o);
else
	@$(AR) $(LFLAGS) $$@ $(lib_libs:%=$($(_flavor_)_LIB_DIR)/lib%.a);
endif
endef

define Obj_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1).$(2))"
$($(_flavor_)_OBJ_DIR)/$(1).o : $($(_flavor_)_$(_feat_)_dir)$(1).$(2) $($(_flavor_)_INC:%=$($(_flavor_)_INC_DIR)/%) $($(_flavor_)_OBJ_DIR)
  ifeq "cpp" "$(2)"
	@$(CPP) $(CPPFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-I %) -o $$@ -c $$<;
  else
	@$(CC) $(CFLAGS) $(CMACROS) $($(_flavor_)_PROJ_INC:%=-I %) -o $$@ -c $$<;
  endif
endif
endef

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
