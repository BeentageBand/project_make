define Bin_Target
$($(_flavor_)_BIN_DIR:%=%/$(1)) : $(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.ino) $($(_flavor_)_BIN_DIR) $(bin_libs:%=$($(_flavor_)_LIB_DIR)/%) 
	$(ARDUINO_BUILDER) \
	-build-path $($(_flavor_)_BIN_DIR) \
    $(addprefix -tools ,$(ARDUINO_TOOLS)) \
	$(addprefix -hardware , $(ARDUINO_HW)) \
    -fqbn=$(ARDUINO_QFBN) \
	-warnings 'all' \
	$(ARDUINO_BUILTIN_LIBS:%=-libraries %) \
	$(addprefix -libraries $($(_flavor_)_LIB_DIR)/, $(bin_libs)) \
	-libraries $($(_flavor_)_INC_DIR) \
	$(bin_objs:%=$($(_flavor_)_OBJ_DIR)/%.ino) 
endef

define Inc_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1))"
$($(_flavor_)_LIB_DIR)/$(lib)/$(1) : $(realpath $($(_flavor_)_$(_feat_)_dir))/$(1) $($(_flavor_)_LIB_DIR)/$(lib)
	$(CP) $(CPFLAGS) $$< $$@;
endif
endef

define Lib_Target
ifneq "" "$(lib)"
$($(_flavor_)_LIB_DIR)/$(lib) : $($(_flavor_)_$(_feat_)_dir) $($(_flavor_)_LIB_DIR)
	-mkdir $$@;
endif
endef

define Obj_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1).$(2))"
$($(_flavor_)_LIB_DIR)/$(lib)/$(1).$(2) : $(realpath $($(_flavor_)_$(_feat_)_dir))/$(1).$(2) $($(_flavor_)_LIB_DIR)/$(lib)
	$(CP) $(CPFLAGS) $$< $$@;
endif
endef

define Bin_Obj_Target
ifneq "" "$(shell find $($(_flavor_)_$(_feat_)_dir) -name $(1).cpp)"
$($(_flavor_)_OBJ_DIR)/$(1).ino : $(realpath $($(_flavor_)_$(_feat_)_dir))/$(1).cpp $($(_flavor_)_OBJ_DIR)
	$(CP) $(CPFLAGS) $$< $$@;
endif
endef

define Proj_Inc
ifneq "$(dir $(1))" "$($(_flavor_)_INC_DIR)"

$($(_flavor_)_INC_DIR:%=%/$(notdir $(1))) : $(realpath $(1)) $($(_flavor_)_INC_DIR) 
	$(CP) $(CPFLAGS) $$< $$@;

endif
endef

bin:=$($(_flavor_)_$(_feat_)_bin)
bin_objs:=$($(_flavor_)_$(_feat_)_bin_objs)
bin_libs:=$($(_flavor_)_$(_feat_)_bin_libs)

lib:=$($(_flavor_)_$(_feat_)_lib)
lib_objs:=$($(_flavor_)_$(_feat_)_lib_objs)
lib_libs:=$($(_flavor_)_$(_feat_)_lib_libs)

#all but arduino libraries needs tobe compiled.
ifneq "" "$(lib)"
$(eval $(call Verbose, $(call Lib_Target,$(_inc_))))
endif

$(foreach _inc_, $($(_flavor_)_$(_feat_)_inc), \
	$(eval $(call Verbose, $(call Inc_Target,$(_inc_)))) \
)

$(foreach _obj_, $(lib_objs), \
	$(eval $(call Verbose, $(call Obj_Target,$(_obj_),c))) \
	$(eval $(call Verbose, $(call Obj_Target,$(_obj_),cpp))) \
)

$(foreach _bin_, $(bin), \
    $(eval $(call Verbose, $(call Bin_Target,$(_bin_)))) \
)

$(foreach _obj_, $(bin_objs), \
	$(eval $(call Verbose, $(call Bin_Obj_Target,$(_obj_)))) \
)

$(foreach _proj_inc_, $($(_flavor_)_PROJ_INC), \
	$(foreach _inc_, $(shell find $(_proj_inc_) -name *.h), \
		$(eval $(call Verbose, $(call Proj_Inc,$(_inc_)))) \
	) \
)
