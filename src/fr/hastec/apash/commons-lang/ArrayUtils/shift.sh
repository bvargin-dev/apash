#!/usr/bin/env bash

# Dependencies #################################################################
apash.import fr.hastec.apash.util.Log
apash.import fr.hastec.apash.commons-lang.ArrayUtils.clone
apash.import fr.hastec.apash.commons-lang.ArrayUtils.swap
apash.import fr.hastec.apash.commons-lang.NumberUtils.isLong

##/
# @name ArrayUtils.shift
# @brief Shifts the order of a series of elements in the given array.
# @description
#   This method does nothing for non existing array.
#
# ## History
# @since 0.1.0 (hastec-fr)
#
# ## Interface
# @apashPackage
#
# ### Arguments
# | #      | varName        | Type          | in/out   | Default         | Description                          |
# |--------|----------------|---------------|----------|-----------------|--------------------------------------|
# | $1     | ioArrayName    | ref(string[]) | in       |                 |  Name of the array to shift.         |
# | $2 ?   | inOffset       | number        | in       | 0               |  The number of positions to rotate the elements. If the offset is larger than the number of elements to rotate, than the effective offset is modulo the number of elements to rotate. |
# | $3 ?   | inStartIndex   | number        | in       | 0               |  The starting inclusive index for reversing. Undervalue (<0) is promoted to 0, overvalue (>array.length) results in no change. |
# | $4 ?   | inEndIndex     | number        | in       | lastIndex+1     |  The ending exclusive index (up to endIndex-1) for reversing. Undervalue (< start index) results in no change. Overvalue (>array.length) is demoted to array length. |
#
# ### Example
# ```bash
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"                    # ("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"  "2"               # ("" "d" "a" "b" "c")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"  "${#myArray[@]}"  # ("a" "b" "c" "" "d")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"  "1" "3"           # ("a" "b" "c" "d" "")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"  "1" "1" "3"       # ("a" "" "b" "c" "d")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.shift    "myArray"  "-1"              # ("b" "c" "" "d" "a")
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the array is shifted.
# @exitcode 1 When the input is not an array or the offset/indexes are not integers.
#
# @see https://commons.apache.org/proper/commons-lang/javadocs/api-release/src-html/org/apache/commons/lang3/ArrayUtils.html#line.6959
#/
ArrayUtils.shift() {
  Log.in $LINENO "$@"
  local ioArrayName="${1:-}"
  local inOffset="${2:-0}"
  local inStartIndex="${3:-0}"
  local inEndIndex="${4:-}"
  local distance=0
  local distance_offset=0
  local lastIndex

  local -a apash_outArray=()
  ArrayUtils.clone "$ioArrayName" "apash_outArray" || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  
  # Set the default value to the last index + 1
  lastIndex=$(ArrayUtils.getLastIndex "$ioArrayName") || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  [ -z "$inEndIndex" ] && inEndIndex=$((lastIndex+1))

  NumberUtils.isLong "$inOffset"     || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  NumberUtils.isLong "$inStartIndex" || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  NumberUtils.isLong "$inEndIndex"   || { Log.ex $LINENO; return "$APASH_FAILURE"; }

  [[ $inStartIndex -ge $lastIndex ]]               && { Log.out $LINENO; return "$APASH_SUCCESS"; }
  [[ $inEndIndex   -le $APASH_ARRAY_FIRST_INDEX ]] && { Log.out $LINENO; return "$APASH_SUCCESS"; }

  [[ $inStartIndex -lt $APASH_ARRAY_FIRST_INDEX ]] && inStartIndex=$APASH_ARRAY_FIRST_INDEX
  [[ $inEndIndex   -gt $lastIndex ]] && inEndIndex=$((lastIndex+1))
  
  distance=$((inEndIndex - inStartIndex))
  [[ $distance -le 1 ]] && { Log.out $LINENO; return "$APASH_SUCCESS"; }

  inOffset=$((inOffset%(distance)))
    
  while [[ $distance -gt 1 && $inOffset -gt 0 ]]; do
    distance_offset=$((distance - inOffset))

    if [[ $inOffset -gt $distance_offset ]]; then
      ArrayUtils.swap "apash_outArray" "$inStartIndex" $((inStartIndex + distance - distance_offset)) $distance_offset
      distance=$inOffset
      inOffset=$((inOffset - distance_offset))
    elif [[ $inOffset -lt  $distance_offset ]]; then
      ArrayUtils.swap "apash_outArray" "$inStartIndex" $((inStartIndex + distance_offset)) $inOffset
      inStartIndex=$((inStartIndex + inOffset))
      distance=$distance_offset
    else
      ArrayUtils.swap "apash_outArray" "$inStartIndex" $((inStartIndex + distance_offset)) $inOffset
      break;
    fi
  done

  ArrayUtils.clone "apash_outArray" "$ioArrayName" || { Log.ex $LINENO; return "$APASH_FAILURE"; }

  Log.out $LINENO; return "$APASH_SUCCESS"
}
