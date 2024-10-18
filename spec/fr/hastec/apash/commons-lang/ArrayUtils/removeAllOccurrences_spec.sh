Describe 'ArrayUtils.removeAllOccurrences'
  if [ "$APASH_TEST_MINIFIED" != "true" ]; then
    Include "$APASH_HOME_DIR/src/bash/fr/hastec/apash.import"
    apash.import fr.hastec.apash.commons-lang.ArrayUtils.removeAllOccurrences
  else
    Include "$APASH_HOME_DIR/apash-${APASH_SHELL}-min.sh"
  fi

  It 'fails when the input does not refer to an array'
    When call ArrayUtils.removeAllOccurrences
    The output should equal ""
    The status should be failure
  End
  
  It 'fails when the input does not refer to an array'
    When call ArrayUtils.removeAllOccurrences "" "a"
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input does not refer to an array'
    When call ArrayUtils.removeAllOccurrences " " "a"
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input does not refer to an array'
    When call ArrayUtils.removeAllOccurrences "myArray" "a"
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input name refer to variable which is not an array'
    local myVar="a"
    When call ArrayUtils.removeAllOccurrences "myVar" "a"
    The output should equal ""
    The status should be failure
  End

  It 'fails when the input name refer to variable which is not an array'
    local -A myMap=(["foo"]="a")
    When call ArrayUtils.removeAllOccurrences "myMap" "a"
    The output should equal ""
    The status should be failure
  End
 
  It 'passes when the reference is an array'
    local myArray=("a" "b" "a" "c" "" "d")
    When call ArrayUtils.removeAllOccurrences "myArray" "a"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 4
    The variable 'myArray[0]' should eq "b"
    The variable 'myArray[1]' should eq "c"
    The variable 'myArray[2]' should eq ""
    The variable 'myArray[3]' should eq "d"
  End

  It 'passes when the reference is an array'
    local myArray=("b" "c" "" "d")
    When call ArrayUtils.removeAllOccurrences "myArray" ""
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 3
    The variable 'myArray[0]' should eq "b"
    The variable 'myArray[1]' should eq "c"
    The variable 'myArray[2]' should eq "d"
  End

  It 'passes when the reference is an array'
    local myArray=("a")
    When call ArrayUtils.removeAllOccurrences "myArray" "a"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 0
  End

  It 'passes when the reference is an array'
    local myArray=()
    When call ArrayUtils.removeAllOccurrences "myArray" "a"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 0
  End

End
