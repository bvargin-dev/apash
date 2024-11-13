
<div align='center' id='apash-top'>
  <a href='https://github.com/hastec-fr/apash'>
    <img alt='apash-logo' src='../../../../../../assets/apash-logo.svg'/>
  </a>

  # Apash
</div>

# MatrixUtils.create

Set the value of a cell according to the dimensions of the matrix.

## Overview

⚠️ It is an experimental function.
Note that index in matrix start from 0 (even in zsh).

### Authors:
* Benjamin VARGIN

### Parents
<!-- apash.parentBegin -->
[](../../../../.md) / [apash](../../../apash.md) / [commons-lang](../../commons-lang.md) / [MatrixUtils](../MatrixUtils.md) / 
<!-- apash.parentEnd -->

## Index

* [MatrixUtils.set](#matrixutilsset)

### MatrixUtils.set

#### Example
```bash
myMatrix=(1 2 3 4 5 6 7 8 9)
MatrixUtils.create myMatrix 3 3
MatrixUtils.set "myMatrix" "a" 0 0  # (a 2 3 4 5 6 7 8 9)
MatrixUtils.set "myMatrix" "b" 0 2  # (a 2 b 4 5 6 7 8 9)
MatrixUtils.set "myMatrix" "c" 1 1  # (a 2 b 4 c 6 7 8 9)
```

#### Arguments

* **$1** (string): The new value.
* **$2** (number...): The index per dimension.

#### Exit codes

* **0**: When the cell is updated.
* **1**: Otherwise.

#### Output on stdout

* None.

#### Output on stderr

* None.


  <div align='right'>[ <a href='#apash-top'>↑ Back to top ↑</a> ]</div>
