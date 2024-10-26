#!/usr/bin/env bash

# Dependencies #####################################
apash.import fr.hastec.apash.commons-lang.StringUtils.indexOf
apash.import fr.hastec.apash.commons-lang.ArrayUtils.clone

# File description ###########################################################
# @name StringUtils.indexOfAny
# @brief Search a string to find the first index of any character in the given set of characters.
# @description
#
# ### Since:
# 0.1.0
#
# ### Authors:
# * Benjamin VARGIN
#
# ### Parents
# <!-- apash.parentBegin -->
# [](../../../../.md) / [apash](../../../apash.md) / [commons-lang](../../commons-lang.md) / [StringUtils](../StringUtils.md) / 
# <!-- apash.parentEnd -->

# Method description #########################################################
# @description
# #### Arguments
# | #      | varName        | Type          | in/out   | Default    | Description                           |
# |--------|----------------|---------------|----------|------------|---------------------------------------|
# | $1     | inString       | string        | in       |            | The string to check.                  |
#
# @example
#                        StringUtils.indexOfAny ""                 # -1
#    arr=("")          ; StringUtils.indexOfAny ""           arr   #  0
#    arr=("a")         ; StringUtils.indexOfAny ""           arr   # -1
#    arr=("cd" "ab" )  ; StringUtils.indexOfAny "zzabyycdxx" arr   #  2
#    arr=("zab" "aby") ; StringUtils.indexOfAny "zzabyycdxx" arr   #  1
#
# @stdout The first minimum index matching researches, -1 if no match
#         or empty input string or empty research.
# @stderr None.
#
# @see [indexOf](indexOf.md)
# @see [StringUtils](../StringUtils.md)
#
# @exitcode 0 If the index can be displayed.
# @exitcode 1 Otherwise.
#
# Note for passing array by reference
# see https://stackoverflow.com/questions/10953833/passing-multiple-distinct-arrays-to-a-shell-function
StringUtils.indexOfAny() {
  local inString="$1"
  local researchName="$2"  
  local index=-1
  local i r
  local researh=()
  ArrayUtils.clone "$researchName" "research"

  # If the researsh is empty then return -1.
  if [[ ${#research[@]} -eq 0 ]]; then
    echo "$index" && return "$APASH_FUNCTION_SUCCESS"
    return "$APASH_FUNCTION_FAILURE"
  fi

  # For each reseach, apply the function indexOf
  # and keep the minimum index if string has been found.
  for r in "${research[@]}"; do
    i=$(StringUtils.indexOf "$inString" "$r")
    [[ $i -ge 0  && ($index -eq -1 || $i -lt $index) ]] && index=$i
  done

  echo "$index" && return "$APASH_FUNCTION_SUCCESS"
  return "$APASH_FUNCTION_FAILURE"
}