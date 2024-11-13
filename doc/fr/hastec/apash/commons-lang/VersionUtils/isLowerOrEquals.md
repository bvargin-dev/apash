
<div align='center' id='apash-top'>
  <a href='https://github.com/hastec-fr/apash'>
    <img alt='apash-logo' src='../../../../../../assets/apash-logo.svg'/>
  </a>

  # Apash
</div>

# VersionUtils.isLower

Compare two versions and determine if the first one is lower than the second one

## Overview

Please not that for a real comparison, both 
### Since:
0.2.0

### Authors:
* Benjamin VARGIN

### Parents
<!-- apash.parentBegin -->
[](../../../../.md) / [apash](../../../apash.md) / [commons-lang](../../commons-lang.md) / [VersionUtils](../VersionUtils.md) / 
<!-- apash.parentEnd -->

## Index

* [VersionUtils.isLowerOrEquals](#versionutilsislowerorequals)

### VersionUtils.isLowerOrEquals

#### Arguments
| #      | varName        | Type          | in/out   | Default    | Description                           |
|--------|----------------|---------------|----------|------------|---------------------------------------|
| $1     | inString       | string        | in       |            | The first version to check            |
| $2     | inString       | string        | in       |            | The second version to check           |

#### Example

```bash
VersionUtils.isLower "1.2.0"          "1.2.0"         # true
VersionUtils.isLower "1.2.1"          "1.10.0"        # true
VersionUtils.isLower "1.2.0-alpha2"   "1.2.0-alpha10" # true
VersionUtils.isLower "1.2.0-alpha2"   "1.2.0-beta1"   # true
VersionUtils.isLower "1.10.1"         "1.2.0"         # false
VersionUtils.isLower "1.2.0-alpha10"  "1.2.0-alpha2"  # false
VersionUtils.isLower "1.2.0-final"    "1.2.0-alpha2"  # false
VersionUtils.isLower "1.2.0"          "1.2.0-alpha2"  # false
```

#### Exit codes

* **0**: If the first version is less or equals than the second one.
* **1**: Otherwise

#### Output on stdout

* None.

#### Output on stderr

* None.


  <div align='right'>[ <a href='#apash-top'>↑ Back to top ↑</a> ]</div>
