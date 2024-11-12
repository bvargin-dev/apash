#!/usr/bin/env bash

# Dependencies #####################################
apash.import fr.hastec.apash.commons-lang.BashUtils.isDeclared
apash.import fr.hastec.apash.commons-lang.ArrayUtils.isArray
apash.import fr.hastec.apash.commons-lang.MapUtils.isMap

# File description ###########################################################
# @name BashUtils.isVariable
# @brief Defensive programming technique to check that a variable exists.
# @description
#   Arrays and Maps are not considered as variables.
#   If you need to consider arrays and maps then use BashUtils.isDeclared.
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
#    BashUtils.isVariable  ""              # false
#    BashUtils.isVariable  "myVar"         # false
#
#    myVar=myValue
#    BashUtils.isVariable  "myVar"         # true
#
#    declare -a myArray=()
#    BashUtils.isVariable  "myArray"       # false
#
#    declare -A myMap=([foo]=bar)
#    BashUtils.isVariable  "myMap"         # false
#
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the input name corresponds to a variable (not including arrays and maps).
# @exitcode 1 Otherwise.
BashUtils.isVariable() {
  local varName="$1"
  BashUtils.isDeclared "$varName" || return "$APASH_FUNCTION_FAILURE"
  ArrayUtils.isArray   "$varName" && return "$APASH_FUNCTION_FAILURE"
  MapUtils.isMap       "$varName" && return "$APASH_FUNCTION_FAILURE"
  return "$APASH_FUNCTION_SUCCESS"
}