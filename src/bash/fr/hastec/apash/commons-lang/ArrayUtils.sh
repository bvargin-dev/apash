#!/usr/bin/env bash
# shellcheck disable=SC2034
# <!-- @class -->
# @name ArrayUtils
# @brief Operations on arrays.
# @description
#     This implementation do reference to the [java apache implementation](https://commons.apache.org/proper/commons-lang/javadocs/api-release/index.html)
# ### WARNING
# Contrary Java implementation methods are generally modifying directly the input array given by reference.
#
# ### Parents
# <!-- apash.parentBegin -->
# [](../../../.md) / [apash](../../apash.md) / [commons-lang](../commons-lang.md) / 
# <!-- apash.parentEnd -->
#
# 
# ### Method Summary
# <!-- apash.summaryTableBegin -->
# | Methods                  | Brief                                 |
# |--------------------------|---------------------------------------|
# |[add](ArrayUtils/add.md)|Adds a given element at the end of an array.|
# |[addAll](ArrayUtils/addAll.md)|Adds given elements at the end of an array.|
# |[addFirst](ArrayUtils/addFirst.md)|Adds given elements at the beginning of an array.|
# |[clone](ArrayUtils/clone.md)|Copy an array into another array using references.|
# |[contains](ArrayUtils/contains.md)|Adds given elements at the end of an array.|
# |[get](ArrayUtils/get.md)|Gets the nTh element of an array or a default value if the index is out of bounds.|
# |[getLength](ArrayUtils/getLength.md)|Returns the length of the specified array.|
# |[indexOf](ArrayUtils/indexOf.md)|Finds the first index of the given value in the array starting at the given index.|
# |[indexesOf](ArrayUtils/indexesOf.md)|Finds the indices of the given value in the array starting at the given index.|
# |[insert](ArrayUtils/insert.md)|Inserts elements into an array at the given index (starting from zero).|
# |[isArray](ArrayUtils/isArray.md)|Check if the input name is an array or not.|
# |[isArrayIndexValid](ArrayUtils/isArrayIndexValid.md)|Returns whether a given array can safely be accessed at the given index.|
# |[isEmpty](ArrayUtils/isEmpty.md)|Checks if an array exist and is empty.|
# |[isNotEmpty](ArrayUtils/isNotEmpty.md)|Checks if an array exist and has at least one element.|
# |[isSameLength](ArrayUtils/isSameLength.md)|Checks whether two arrays are the same length, return false if it's not an array.|
# |[isSorted](ArrayUtils/isSorted.md)|This method checks whether the provided array is sorted according to natural ordering.|
# |[lastIndexOf](ArrayUtils/lastIndexOf.md)|Finds the last index of the given value in the array starting at the given index.|
# |[remove](ArrayUtils/remove.md)|Removes the element at the specified position from the specified array.|
# |[removeAll](ArrayUtils/removeAll.md)|Removes the elements at the specified positions from the specified array.|
# |[removeAllOccurrences](ArrayUtils/removeAllOccurrences.md)|Removes the occurrences of the specified element from the specified array.|
# |[removeDuplicates](ArrayUtils/removeDuplicates.md)|Removes elements which are present multiple times in the array.|
# |[removeElement](ArrayUtils/removeElement.md)|Removes the first occurrence of the specified element from the specified array.|
# |[removeElements](ArrayUtils/removeElements.md)|Removes the first occurrence of the specified element from the specified array.|
# <!-- apash.summaryTableEnd -->

ArrayUtils_INDEX_NOT_FOUND="-1"










