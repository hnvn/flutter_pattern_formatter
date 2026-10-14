## 4.2.0

* fix `ThousandsFormatter` with `allowFraction: true` rounding fraction digits (to 3 places) and dropping trailing zeros; the exact fraction digits typed are now preserved (e.g. `1.0`, `10.50`, `1.2345`)
* fix large integers collapsing to `0`; values too large for `int` now keep their digits
* strip stray extra decimal separators instead of falling back to `0`
* escape the locale decimal separator when building internal regexes

## 4.1.0

* remove `package:flutter/material.dart` dependency from the library; formatters now rely only on `package:flutter/services.dart`
* migrate the example app to the standalone `material_ui` package (Flutter 3.47+)

## 4.0.1

* remove constraints to version of `intl`

## 4.0.0

* upgrade `intl` to v0.19

## 3.0.0

* upgrade `intl` dependency to v0.18
* update sdk constraint to support Dart 3

## 2.0.0

* migrate to nullsafety

## 1.0.2

* fix bug international number seperators

## 1.0.1

* upgrade `intl` dependency

## 1.0.0

* stable release

## 0.0.3

* fix bug: text flickering in iOS (still happens in v0.0.2)

## 0.0.2

* fix bug: text flickering in iOS

## 0.0.1

* initial release.
