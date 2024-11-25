Describe 'StringUtils.equals'
  apash.import "fr.hastec.apash.commons-lang.StringUtils.equals"

  It 'passes without argument'
    When call StringUtils.equals
    The output should equal ""
    The status should be success
  End

  It 'passes with an empty argument'
    When call StringUtils.equals ""
    The output should equal ""
    The status should be success
  End

  It 'passes with empty arguments'
    When call StringUtils.equals "" ""
    The output should equal ""
    The status should be success
  End
  
  It 'passes with two blank arguments'
    When call StringUtils.equals "  " "  "
    The output should equal ""
    The status should be success
  End

  It 'passes when arguments are identical'
    When call StringUtils.equals "abc" "abc"
    The output should equal ""
    The status should be success
  End

  It 'fails when blank arguments are different'
    When call StringUtils.equals "  " " "
    The output should equal ""
    The status should be failure
  End

  It 'fails when arguments are different'
    When call StringUtils.equals "abc" "abcd"
    The output should equal ""
    The status should be failure
  End

  It 'fails when first argument is empty and not the second'
    When call StringUtils.equals "" "abc"
    The output should equal ""
    The status should be failure
  End

  It 'fails when second argument is empty and not the first'
    When call StringUtils.equals "abc" ""
    The output should equal ""
    The status should be failure
  End

End
