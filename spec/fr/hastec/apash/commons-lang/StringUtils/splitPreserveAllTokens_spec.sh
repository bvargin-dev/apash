Describe 'StringUtils.splitPreserveAllTokens'
  if [ "$APASH_TEST_MINIFIED" != "true" ]; then
    Include "$APASH_HOME_DIR/src/bash/fr/hastec/apash.import"
    apash.import -f "fr.hastec.apash.commons-lang.StringUtils.splitPreserveAllTokens"
  else
    Include "$APASH_HOME_DIR/apash-${APASH_SHELL}-min.sh"
  fi    

  # @todo: check with shell spec the support of array for null length.
  It 'returns an empty array when the input string is empty'
    When call StringUtils.splitPreserveAllTokens myArray "" ""
    The output should equal ""
    The status should be success
    The value  "${#myArray[@]}" should eq 0
  End

  It 'returns an empty array when the input string is empty'
    When call StringUtils.splitPreserveAllTokens myArray "" ":"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 0
  End

  It 'returns the full string if the delimiter is empty'
    When call StringUtils.splitPreserveAllTokens myArray "ab:cd:ef" ""
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 1
    The variable 'myArray[0]' should eq "ab:cd:ef"
  End

  It 'returns the full string if the delimiter is empty'
    When call StringUtils.splitPreserveAllTokens myArray $'ab:cd:\nef' ""
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 1
    The variable 'myArray[0]' should eq $'ab:cd:\nef'
  End

  It 'returns the correct number of elements according to sequence occurence'
    When call StringUtils.splitPreserveAllTokens myArray "ab:cd:ef" ":"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 3
    The variable 'myArray[0]' should eq "ab"
    The variable 'myArray[1]' should eq "cd"
    The variable 'myArray[2]' should eq "ef"
  End

  It 'returns the correct number of elements according to sequence occurence'
    When call StringUtils.splitPreserveAllTokens myArray $'ab: cd:\nef gh:\nij ' ":"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 4
    The variable 'myArray[0]' should eq "ab"
    The variable 'myArray[1]' should eq " cd"
    The variable 'myArray[2]' should eq $'\nef gh'
    The variable 'myArray[3]' should eq $'\nij '
  End

  It 'returns the correct number of elements according to sequence occurence'
    When call StringUtils.splitPreserveAllTokens myArray "ab:cd:ef" "cd"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 2
    The variable 'myArray[0]' should eq "ab:"
    The variable 'myArray[1]' should eq ":ef"
  End

  It 'returns item even when adjacent delimiter are encountered'
    When call StringUtils.splitPreserveAllTokens myArray "ab::cd:ef" ":"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 4
    The variable 'myArray[0]' should eq "ab"
    The variable 'myArray[1]' should eq ""
    The variable 'myArray[2]' should eq "cd"
    The variable 'myArray[3]' should eq "ef"
  End

  It 'returns item even when adjacent delimiter are encountered'
    When call StringUtils.splitPreserveAllTokens myArray $'ab\n\ncd\nef' $'\n'
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 4
    The variable 'myArray[0]' should eq "ab"
    The variable 'myArray[1]' should eq ""
    The variable 'myArray[2]' should eq "cd"
    The variable 'myArray[3]' should eq "ef"
  End

  It 'returns item even when adjacent delimiter are encountered'
    When call StringUtils.splitPreserveAllTokens myArray "::ab::cd:::ef::" ":"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 10
    The variable 'myArray[0]' should eq ""
    The variable 'myArray[1]' should eq ""
    The variable 'myArray[2]' should eq "ab"
    The variable 'myArray[3]' should eq ""
    The variable 'myArray[4]' should eq "cd"
    The variable 'myArray[5]' should eq ""
    The variable 'myArray[6]' should eq ""
    The variable 'myArray[7]' should eq "ef"
    The variable 'myArray[8]' should eq ""
    The variable 'myArray[9]' should eq ""
  End

  It 'returns item even when adjacent delimiter are encountered'
    When call StringUtils.splitPreserveAllTokens myArray "abab::cd:ab:ef::ab" "ab"
    The output should equal ""
    The status should be success
    The value "${#myArray[@]}" should eq 5
    The variable 'myArray[0]' should eq ""
    The variable 'myArray[1]' should eq ""
    The variable 'myArray[2]' should eq "::cd:"
    The variable 'myArray[3]' should eq ":ef::"
    The variable 'myArray[4]' should eq ""
  End

End