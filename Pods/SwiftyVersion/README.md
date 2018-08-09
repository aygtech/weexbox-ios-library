# SwiftyVersion 
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Build Status](https://travis-ci.org/dcordero/SwiftyVersion.svg?branch=master)](https://travis-ci.org/dcordero/SwiftyVersion)

A simpler way to manage **Versions** in Swift

## Initialization

Using the default separator (which is a single point)
```
let myVersion = Version("1.5.2")
```

Or using a different separator
```
let myVersion = Version("1-5-1", usingSeparator: "-")
```

## Logic Operator

**Version** supports the ```==```, ```>```, ```<```, ```<=```, and ```>=``` operators


## Example

```
let myVersion1 = Version("1-5-2", usingSeparator: "-")
let myVersion2 = Version("1.5.2.1")

print(myVersion1 == myVersion2) // "false"
print(myVersion1 > myVersion2)  // "false"
print(myVersion1 >= myVersion2) // "false"
print(myVersion1 < myVersion2)  // "true"
print(myVersion1 <= myVersion2) // "true"
```
