#!/usr/bin/env bash

# Dependencies #################################################################
apash.import fr.hastec.apash.util.Log
apash.import fr.hastec.apash.commons-lang.ArrayUtils.clone
apash.import fr.hastec.apash.commons-lang.ArrayUtils.getLastIndex
apash.import fr.hastec.apash.commons-lang.NumberUtils.isLong

##/
# @name ArrayUtils.reverse
# @brief Reverses the order of the given array in the given range.
# @description
# This method does nothing for non existing array.
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
# | $1     | ioArrayName    | ref(string[]) | in/out   |                 |  Name of the array to reverse.       |
# | $2 ?   | inStartIndex   | number        | in       | 0               |  The starting inclusive index for reversing. Undervalue (<0) is promoted to 0, overvalue (>array.length) results in no change. |
# | $3 ?   | inEndIndex     | number        | in       | ${#1[@]} length |  The ending exclusive index (up to endIndex-1) for reversing. Undervalue (< start index) results in no change. Overvalue (>array.length) is demoted to array length. |
#
# ### Example
# ```bash
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.reverse  "myVar"           # failure
#    ArrayUtils.reverse  "myArray"         # failure
#    ArrayUtils.reverse  "myArray"         # ("d" "" "c" "b" "a")
#
#    myArray=("a")
#    ArrayUtils.reverse  "myArray"  "a"    # ("a")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.reverse  "myVar" "2"       #  myArray=("a" "b" "d" "" "c")
#
#    myArray=("a" "b" "c" "" "d")
#    ArrayUtils.reverse  "myVar" "1" "4"   #  myArray=("a" "" "c" "b" "d")
#
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When the array is reversed.
# @exitcode 1 When the input is not an array or the indexes are not integers.
#/
ArrayUtils.reverse() {
  Log.in $LINENO "$@"
  local ioArrayName="${1:-}"
  local inStartIndex="${2:-0}"
  local inEndIndex="${3:-}"
  local swap=""
  local -a outArray=()
  local lastIndex
  
  ArrayUtils.clone "$ioArrayName" "outArray"           || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  lastIndex=$(ArrayUtils.getLastIndex "$ioArrayName")  || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  [[ -z "$inEndIndex" ]] && inEndIndex=$((lastIndex+1))

  NumberUtils.isLong "$inStartIndex" || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  NumberUtils.isLong "$inEndIndex"   || { Log.ex $LINENO; return "$APASH_FAILURE"; }

  [[ $inStartIndex -ge $lastIndex ]]               && { Log.out $LINENO; return "$APASH_SUCCESS"; }
  [[ $inEndIndex   -le $APASH_ARRAY_FIRST_INDEX ]] && { Log.out $LINENO; return "$APASH_SUCCESS"; }

  [[ $inStartIndex -lt $APASH_ARRAY_FIRST_INDEX ]] && inStartIndex=$APASH_ARRAY_FIRST_INDEX
  [[ $inEndIndex   -gt $lastIndex ]] && inEndIndex=$((lastIndex+1))
  
  [[ "$inStartIndex" -ge "$inEndIndex" ]] && { Log.out $LINENO; return "$APASH_SUCCESS"; }
    
  while [[ $inStartIndex -lt $inEndIndex ]]; do
    swap=${outArray[inStartIndex]}
    outArray[inStartIndex]=${outArray[inEndIndex-1]}
    outArray[inEndIndex-1]="$swap"
    inStartIndex=$((inStartIndex + 1))
    inEndIndex=$((inEndIndex - 1))
  done

  ArrayUtils.clone "outArray" "$ioArrayName" || { Log.ex $LINENO; return "$APASH_FAILURE"; }

  Log.out $LINENO; return "$APASH_SUCCESS"
}
