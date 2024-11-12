#!/usr/bin/env bash

# Dependencies #####################################
apash.import fr.hastec.apash.commons-lang.ArrayUtils.sh
apash.import fr.hastec.apash.commons-lang.ArrayUtils.isArray
apash.import fr.hastec.apash.commons-lang.ArrayUtils.remove
apash.import fr.hastec.apash.commons-lang.ArrayUtils.indexOf

# File description ###########################################################
# @name ArrayUtils.removeElement
# @brief Removes the first occurrence of the specified element from the specified array.
# @description
#   All subsequent elements are shifted to the left (subtracts one from their indices). 
#   If the array doesn't contains such an element, no elements are removed from the array.
#
# ### Since:
# 0.1.0
#
# ### Authors:
# * Benjamin VARGIN
#
# ### Parents
# <!-- apash.parentBegin -->
# [](../../../../.md) / [apash](../../../apash.md) / [commons-lang](../../commons-lang.md) / [ArrayUtils](../ArrayUtils.md) / 
# <!-- apash.parentEnd -->

# Method description #########################################################
# @description
# #### Arguments
# | #      | varName        | Type          | in/out   | Default    | Description                          |
# |--------|----------------|---------------|----------|------------|--------------------------------------|
# | $1     | ioArrayName    | ref(string[]) | in       |            |  Name of the array to modify.        |
# | $2     | inValue        | string        | in       |            |  The first occurence of the value to remove from the array.  |
#
# #### Example
# ```bash
#    myArray=("a" "b" "a" "c" "" "d")
#    ArrayUtils.removeElement  "myArray"            # failure
#    ArrayUtils.removeElement  "myArray"  "a"       # ("b" "a" "c" "" "d")
#    ArrayUtils.removeElement  "myArray"  "a"       # ("b" "c" "" "d")
#    ArrayUtils.removeElement  "myArray"  ""        # ("b" "c" "d")
#    ArrayUtils.removeElement  "myArray"  "e"       # ("b" "c" "d")
#
#    myArray=("a")
#    ArrayUtils.removeElement  "myArray"  "a"       # ()
#    ArrayUtils.removeElement  "myArray"  "a"       # ()
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the first occurence is removed from the array.
# @exitcode 1 Otherwise.
ArrayUtils.removeElement() {
  [ $# -ne 2 ] && return "$APASH_FUNCTION_FAILURE"
  
  local ioArrayName="$1"
  local inValue="$2"
  local index
  ArrayUtils.isArray "$ioArrayName" || return "$APASH_FUNCTION_FAILURE"
  
  # Get the index to remove
  index=$(ArrayUtils.indexOf "$ioArrayName" "$inValue")
  [[ "$index" = "$ArrayUtils_INDEX_NOT_FOUND" ]] && return "$APASH_FUNCTION_SUCCESS"
  ArrayUtils.remove "$ioArrayName" "$index" || return "$APASH_FUNCTION_FAILURE"

  return "$APASH_FUNCTION_SUCCESS"
}