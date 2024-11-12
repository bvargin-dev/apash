#!/usr/bin/env bash

# Dependencies #####################################
apash.import fr.hastec.apash.commons-lang.ArrayUtils.nullToEmpty
apash.import fr.hastec.apash.commons-lang.VersionUtils.isLowerOrEquals
apash.import fr.hastec.apash.util.Array.bubbleSort
[ "$APASH_SHELL" = "zsh" ] && apash.import fr.hastec.apash.commons-lang.ArrayUtils.clone

# File description ###########################################################
# @name Array.sort
# @brief Sorts the specified array into ascending natural order.
# @description
#   Non array reference will be transformed to empty array.
#
# ### Since:
# 0.1.0
#
# ### Authors:
# * Benjamin VARGIN
#
# ### Parents
# <!-- apash.parentBegin -->
# [](../../../../.md) / [apash](../../../apash.md) / [util](../../util.md) / [Array](../Array.md) / 
# <!-- apash.parentEnd -->

# Method description #########################################################
# @description
# #### Arguments
# | #      | varName        | Type          | in/out   | Default    | Description                           |
# |--------|----------------|---------------|----------|------------|---------------------------------------|
# | $1     | inArrayName    | ref(string[]) | in & out |            | The array to sort.                    |
#
# #### Example
# ```bash
#    myArray=("a" "b" "c")
#    Array.sort "myArray"  # ("a" "b" "c")
#
#    myArray=("a" "c" "b")
#    Array.sort "myArray"  # ("a" "b" "c")
#
#    myArray=("beta-20" "beta-10" "beta-1")
#    Array.sort "myArray"  # ("beta-1" "beta-10" "beta-20")
#
#    myArray=("1" "a" "2" "3")
#    Array.sort "myArray"  # ("1" "2" "3" "a")
#   
#    myArray=("1" "")
#    Array.sort "myArray"  # ("" "1")
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 True Whether the array is sorted according to natural ordering.
# @exitcode 1 Otherwise.
Array.sort() {
  local inArrayName="$1"
  ArrayUtils.nullToEmpty "$inArrayName" || return "$APASH_FUNCTION_FAILURE"
  
  if [ "$APASH_SHELL" = "zsh" ]; then
    local ref_Array_sort_inArray=("${(o)${(P)inArrayName}[@]}")
    ArrayUtils.clone "ref_Array_sort_inArray" "$inArrayName" && return "$APASH_FUNCTION_SUCCESS"
  else # bash
    local -n inArray="$inArrayName"
    [[ ${#inArray[@]} -eq 0 ]] && return "$APASH_FUNCTION_SUCCESS"
    if VersionUtils.isLowerOrEquals "$APASH_SHELL_VERSION" "4.3"; then
      Array.bubbleSort "$inArrayName" &&  return "$APASH_FUNCTION_SUCCESS"
    else
      readarray -d '' inArray < <(printf "%s\0" "${inArray[@]}" | sort -z) &&  return "$APASH_FUNCTION_SUCCESS"
    fi
  fi

  return "$APASH_FUNCTION_FAILURE"
}