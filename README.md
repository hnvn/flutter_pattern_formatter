# PatternFormatter

[![pub package](https://img.shields.io/pub/v/pattern_formatter.svg)](https://pub.dartlang.org/packages/pattern_formatter) [![Build Status](https://travis-ci.org/hnvn/flutter_pattern_formatter.svg?branch=master)](https://travis-ci.org/hnvn/flutter_pattern_formatter)

A Flutter package provides some implementations of TextInputFormatter that format input with pre-defined patterns

## How to use

```dart
import 'package:pattern_formatter/pattern_formatter.dart';
```

### Thousands grouping

* Integer number:

<p>
    <img width="512" src="https://github.com/hnvn/flutter_pattern_formatter/blob/master/screenshots/integer_formatter.gif?raw=true"/>
</p>

```dart
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    ThousandsFormatter()
  ],
)
```

* Decimal number:

<p>
    <img width="512" src="https://github.com/hnvn/flutter_pattern_formatter/blob/master/screenshots/decimal_formatter.gif?raw=true"/>
</p>

```dart
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    ThousandsFormatter(allowFraction: true)
  ],
)
```

### Card number grouping

<p>
    <img width="512" src="https://github.com/hnvn/flutter_pattern_formatter/blob/master/screenshots/card_number_formatter.gif?raw=true"/>
</p>

```dart
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    CreditCardFormatter(),
  ],
)
```

### Date format

<p>
    <img width="512" src="https://github.com/hnvn/flutter_pattern_formatter/blob/master/screenshots/date_formatter.gif?raw=true"/>
</p>

```dart
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    DateInputFormatter(),
  ],
)
```

