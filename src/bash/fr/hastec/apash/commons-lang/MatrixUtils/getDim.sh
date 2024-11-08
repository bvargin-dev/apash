#!/usr/bin/env bash

# Dependencies #####################################
apash.import fr.hastec.apash.commons-lang.MatrixUtils.isMatrix
apash.import fr.hastec.apash.commons-lang.MatrixUtils.getIndex
apash.import fr.hastec.apash.commons-lang.MatrixUtils.getDimOffset
apash.import fr.hastec.apash.commons-lang.ArrayUtils.nullToEmpty
apash.import fr.hastec.apash.commons-lang.ArrayUtils.subarray

# File description ###########################################################
# @name MatrixUtils.getDim
# @brief Return the corresponding array according to virtual dimensions.
#
# @description
#   ⚠️ It is an experimental function.
#   The simple case on a two dimensional array is to retreive a row.
#   For more dimensions, it returns an array containing all sub dimensions
#   of the current offset.
#
# ### Since:
# 0.2.0
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
# #### Example
# ```bash
#    myMatrix=(1 2 3 4 5 6 7 8 9)
#    MatrixUtils.create "mySubArray" "myMatrix" 3 3
#    MatrixUtils.getDim "mySubArray" "myMatrix" 0 1  # (1)
#    MatrixUtils.getDim "mySubArray" "myMatrix" 0    # (1 2 3)
#    MatrixUtils.getDim "mySubArray" "myMatrix" 1    # (4 5 6)
# ```
#
# @arg $1 ref(string[]) Name of the matrix.
# @arg $2 number... The index per dimension.
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the subarray is returned.
# @exitcode 1 Otherwise.
MatrixUtils.getDim() {
  [ $# -lt 2 ] && return "$APASH_FUNCTION_FAILURE"
  local inArrayName="$1"
  local matrixName="$2"
  shift 2
  local indexes=("$@")
  local start=$APASH_ARRAY_FIRST_INDEX
  local length=0

  ArrayUtils.nullToEmpty "$inArrayName"                            || return "$APASH_FUNCTION_FAILURE"
  MatrixUtils.isMatrix   "$matrixName"                             || return "$APASH_FUNCTION_FAILURE"
  start=$(MatrixUtils.getIndex "$matrixName" "${indexes[@]}")      || return "$APASH_FUNCTION_FAILURE"
  length=$(MatrixUtils.getDimOffset "$matrixName" "${indexes[@]}") || return "$APASH_FUNCTION_FAILURE"
  
  # Keep at least one cell
  [[ $length -le 0 ]] && length=1
  ArrayUtils.subarray "$inArrayName" "$matrixName" "$start" $((start + length)) || return "$APASH_FUNCTION_FAILURE"

  return "$APASH_FUNCTION_SUCCESS"
}
