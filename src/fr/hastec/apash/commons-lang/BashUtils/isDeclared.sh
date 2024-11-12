#!/usr/bin/env bash

# File description ###########################################################
# @name BashUtils.isDeclared
# @brief Defensive programming technique to check that a variable is declared.
# @description
#   Arrays and Maps are considered as declared too.
#
# ### Since:
# 0.2.0
#
# ### Authors:
# * Benjamin VARGIN
#
# ### Parents
# <!-- apash.parentBegin -->
# [](../../../../.md) / [apash](../../../apash.md) / [commons-lang](../../commons-lang.md) / [BashUtils](../BashUtils.md) / 
# <!-- apash.parentEnd -->

# Method description #########################################################
# @description
# #### Arguments
# | #      | varName        | Type          | in/out   | Default    | Description                           |
# |--------|----------------|---------------|----------|------------|---------------------------------------|
# | $1     | varName        | string        | in       |            | Variable name to check.               |
#
# #### Example
# ```bash
#    BashUtils.isDeclared  ""              # false
#    BashUtils.isDeclared  "myVar"         # false
#
#    myVar=myValue
#    BashUtils.isDeclared  "myVar"         # true
#
#    declare -a myArray=()
#    BashUtils.isDeclared  "myArray"       # true
#
#    declare -A myMap=([foo]=bar)
#    BashUtils.isDeclared  "myMap"         # true
#
# ```
#
# @see 
# - [BashUtils.isDeclared](./isDeclared.md), 
# - [ArrayUtils.isArray](../ArrayUtils/isArray.md),
# - [MapUtils.isMap](../MapUtils/isMap.md)
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the variable is declared (even an array or a map).
# @exitcode 1 Otherwise.
BashUtils.isDeclared() {
  local varName="$1"
  declare -p "$varName" > /dev/null 2>&1 && return "$APASH_FUNCTION_SUCCESS"
  return "$APASH_FUNCTION_FAILURE"
}