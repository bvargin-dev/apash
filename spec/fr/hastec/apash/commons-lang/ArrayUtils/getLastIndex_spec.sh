Describe 'ArrayUtils.getLastIndex'
  if [ "$APASH_TEST_MINIFIED" != "true" ]; then
    Include "$APASH_HOME_DIR/src/bash/fr/hastec/apash.import"
    Include "$APASH_HOME_DIR/src/bash/fr/hastec/apash/commons-lang/ArrayUtils/getLastIndex.sh"
  else
    Include "$APASH_HOME_DIR/apash-${APASH_SHELL}-min.sh"
  fi

  It 'fails when the input name does not refere to an array'
    When call ArrayUtils.getLastIndex 
    The output should equal ""
    The status should be failure
  End
  
  It 'fails when the input name does not refer to an array'
    When call ArrayUtils.getLastIndex ""
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input name does not refer to an array'
    When call ArrayUtils.getLastIndex " "
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input name does not refer to an array'
    local myVar="test"
    When call ArrayUtils.getLastIndex "myVar" "0"
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input name does not refer to an array'
    local -A myMap=(["foo"]="bar")
    When call ArrayUtils.getLastIndex "myMap" "0"
    The output should equal ""
    The status should be failure
  End

  It 'returns empty string when the array is empty'
    local myArray=()
    When call ArrayUtils.getLastIndex "myArray"
    The output should equal ""
    The status should be success
  End

  It 'passes references are arrays and value is present'
    local myArray=("a" "b" "" "c" "b")
    When call ArrayUtils.getLastIndex "myArray"
    The output should equal "4"
    The status should be success
  End

  It 'passes references are arrays and value is present'
    local myArray=("")
    When call ArrayUtils.getLastIndex "myArray"
    The output should equal "0"
    The status should be success
  End
  
  It 'passes references are arrays and value is present'
    local myArray=("a" "b" "" "c")
    myArray[9223372036854775807]=z
    When call ArrayUtils.getLastIndex "myArray"
    The output should equal "9223372036854775807"
    The status should be success
  End

End