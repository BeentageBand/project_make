#=======================================================================================#
#host_make.mk
#=======================================================================================#
# Created on: Oct 5, 2015
#     Author: puch
#=======================================================================================#
_gc_=gcc
_gc_flags_= -Wall -pthread -g

_gpp_=g++
_gpp_flags_=-std=gnu++11 -Wall -pthread -g
_ar_=ar

include $($(_build_)_PROJECT_DIR)/$($(_build_)_MAK_DIR)/make.mk
#=======================================================================================#
# host_make.mk
#=======================================================================================#
# Changes Log
#
#
#=======================================================================================#