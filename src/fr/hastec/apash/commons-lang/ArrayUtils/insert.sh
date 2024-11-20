#!/usr/bin/env bash

# Dependencies #################################################################
apash.import fr.hastec.apash.util.Log
apash.import fr.hastec.apash.commons-lang.ArrayUtils.isArray
apash.import fr.hastec.apash.commons-lang.ArrayUtils.isArrayIndex
apash.import fr.hastec.apash.commons-lang.ArrayUtils.clone

##/
# @name ArrayUtils.insert
# @brief Inserts elements into an array at the given index (starting from zero).
#
# ## History
# @since 0.2.0 (hastec-fr)
#
# ## Interface
# @apashPackage
#
# ### Arguments
# | #      | varName        | Type          | in/out   | Default    | Description                          |
# |--------|----------------|---------------|----------|------------|--------------------------------------|
# | $1     | apash_inIndex        | number        | in       |            | Positive index of the array to insert values. |
# | $2     | apash_ioArrayName    | ref(string[]) | in       |            | Name of the array to modify.                  |
# | ${@:3} | apash_inValues       | string...     | in       |            | Values to insert at the indicated index.      |
#
# ### Example
# ```bash
#    myArray=()
#    ArrayUtils.insert  "0"           "myArray"              # () - failure
#    ArrayUtils.insert  "0"           "myArray"  "a"         # ("a")
#    ArrayUtils.insert  "${#ioArray}" "myArray"  "b" ""      # ("a" "b" "")
#    ArrayUtils.insert  "2"           "myArray"  "c" "d"     # ("a" "b" "c" "d" "")
#    ArrayUtils.insert  "1"           "myArray"  "foo bar"   # ("a" "foo bar" "b" "c" "d" "")
#    ArrayUtils.insert  "-1"          "myArray" "test"       # ("a" "foo bar" "b" "c" "d" "") - failure
# ```
#
# @stdout None.
# @stderr None.
#
# @exitcode 0 When all elements are inserted.
# @exitcode 1 When the index is not a positive number or reference is not an array or there are no value to insert.
#/
ArrayUtils.insert() {
  Log.in $LINENO "$@"
  [ $# -lt 3 ] && { Log.ex $LINENO; return "$APASH_FAILURE"; }

  local apash_inIndex="${1:-}"
  local apash_ioArrayName="${2:-}"
  ArrayUtils.isArray "$apash_ioArrayName" || { Log.ex $LINENO; return "$APASH_FAILURE"; }
  ArrayUtils.isArrayIndex "$apash_inIndex"                     || { Log.ex $LINENO; return "$APASH_FAILURE"; }  
  shift 2
  local apash_inValues=("$@")
  local apash_i 
  local apash_j

  if [ "$APASH_SHELL" = "zsh" ]; then
    local -a apash_outArray=()
    apash_outArray=("${${(P)apash_ioArrayName}[@]:0:$((apash_inIndex-APASH_ARRAY_FIRST_INDEX))}" \
                    "${apash_inValues[@]}" \
                    "${${(P)apash_ioArrayName}[@]:$((apash_inIndex-APASH_ARRAY_FIRST_INDEX))}")
    ArrayUtils.clone "apash_outArray" "$apash_ioArrayName" && { Log.out $LINENO; return "$APASH_SUCCESS"; }
  else
    local -n apash_ioArray="$apash_ioArrayName"
    local apash_isInserted=false
    # Need to preserve indexes in bash
    for apash_i in "${!apash_ioArray[@]}"; do
      if [[ $apash_i -lt apash_inIndex ]]; then
        apash_outArray[apash_i]="${apash_ioArray[apash_i]}"
      elif [[ $apash_i -ge apash_inIndex ]]; then
        if [[ $apash_isInserted == false ]]; then
          for ((apash_j=0; apash_j < ${#apash_inValues[@]}; apash_j++ )); do
            apash_outArray[apash_j+apash_inIndex]=${apash_inValues[apash_j]}
          done
          apash_isInserted=true
        fi
        apash_outArray[apash_i+${#apash_inValues[@]}]="${apash_ioArray[apash_i]}"
      fi
    done
    
    # If the value have not been insert because after the last element
    # Then insert it at the demanded index.
    if [[ $apash_isInserted == false ]]; then
      for ((apash_i=0; apash_i < ${#apash_inValues[@]}; apash_i++ )); do
        apash_outArray[apash_i+apash_inIndex]="${apash_inValues[apash_i]}"
      done
    fi
    ArrayUtils.clone "apash_outArray" "$apash_ioArrayName" && { Log.out $LINENO; return "$APASH_SUCCESS"; }
  fi

  Log.out $LINENO; return "$APASH_FAILURE"
}
