import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:pattern_formatter/pattern_formatter.dart';

void main() {
  group('numeric formatter smoke test', _numericFormatterSmokeTest);

  group('date formatter smoke test', _dateFormatterSmokeTest);
}

_numericFormatterSmokeTest() {
  final ThousandsFormatter thousandsFormatter =
      ThousandsFormatter(formatter: NumberFormat.decimalPattern('en_US'));

  final ThousandsFormatter thousandsFormatterAllowedFraction =
      ThousandsFormatter(
          formatter: NumberFormat.decimalPattern('en_US'), allowFraction: true);

  final ThousandsFormatter decimalFormatterUS = ThousandsFormatter(
      formatter: NumberFormat.decimalPattern('en_US'), allowFraction: true);
  final ThousandsFormatter decimalFormatterES = ThousandsFormatter(
      formatter: NumberFormat.decimalPattern('es_ES'), allowFraction: true);
  final CreditCardFormatter creditCardFormatter = CreditCardFormatter();

  test('numeric filter smoke test', () {
    final newValue1 = thousandsFormatter.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12a', selection: TextSelection.collapsed(offset: 3)));

    final newValue2 = creditCardFormatter.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12a', selection: TextSelection.collapsed(offset: 3)));

    final newValue3 = decimalFormatterUS.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12a', selection: TextSelection.collapsed(offset: 3)));

    final newValue4 = decimalFormatterES.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12a', selection: TextSelection.collapsed(offset: 3)));

    expect(newValue1.text, equals('12'));

    expect(newValue2.text, equals('12'));

    expect(newValue3.text, equals('12'));

    expect(newValue4.text, equals('12'));
  });

  test('when input is below than 1 return expected value', () {
    final newValue2 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '20.', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '20.0', selection: TextSelection.collapsed(offset: 3)));

    expect(newValue2.text, equals('20.0'));
  });

  test('when input is below than 1 return expected value', () {
    final newValue1 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0', selection: TextSelection.collapsed(offset: 1)),
        TextEditingValue(
            text: '0.', selection: TextSelection.collapsed(offset: 2)));

    final newValue2 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0.', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '0.0', selection: TextSelection.collapsed(offset: 3)));

    final newValue3 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0.0', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '0.00', selection: TextSelection.collapsed(offset: 4)));

    final newValue4 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0.00', selection: TextSelection.collapsed(offset: 4)),
        TextEditingValue(
            text: '0.005', selection: TextSelection.collapsed(offset: 5)));

    final newValue5 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0.', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '0.2', selection: TextSelection.collapsed(offset: 3)));

    final newValue6 = thousandsFormatterAllowedFraction.formatEditUpdate(
        TextEditingValue(
            text: '0.0', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '0.02', selection: TextSelection.collapsed(offset: 4)));

    expect(newValue1.text, equals('0.'));
    expect(newValue2.text, equals('0.0'));
    expect(newValue3.text, equals('0.00'));
    expect(newValue4.text, equals('0.005'));

    expect(newValue5.text, equals('0.2'));
    expect(newValue6.text, equals('0.02'));
  });

  test('thousands grouping smoke test', () {
    final newValue1 = thousandsFormatter.formatEditUpdate(
        TextEditingValue(
            text: '123', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '1234', selection: TextSelection.collapsed(offset: 4)));

    expect(
        newValue1,
        TextEditingValue(
            text: '1,234', selection: TextSelection.collapsed(offset: 5)));

    final newValue2 = thousandsFormatter.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12.', selection: TextSelection.collapsed(offset: 3)));

    expect(newValue2.text, equals('12'));

    final newValue3 = decimalFormatterUS.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12.', selection: TextSelection.collapsed(offset: 3)));

    expect(newValue3.text, equals('12.'));

    final newValue4 = decimalFormatterUS.formatEditUpdate(
        newValue1,
        TextEditingValue(
            text: '1,234.', selection: TextSelection.collapsed(offset: 6)));

    expect(newValue4.text, equals('1,234.'));

    final newValue5 = decimalFormatterUS.formatEditUpdate(
        newValue4,
        TextEditingValue(
            text: '1,234.5', selection: TextSelection.collapsed(offset: 7)));

    expect(newValue5.text, equals('1,234.5'));

    final newValue6 = decimalFormatterUS.formatEditUpdate(
        TextEditingValue(
            text: '1,234.5', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '1,2134.5', selection: TextSelection.collapsed(offset: 4)));

    expect(
        newValue6,
        equals(TextEditingValue(
            text: '12,134.5', selection: TextSelection.collapsed(offset: 4))));

    final newValue7 = decimalFormatterES.formatEditUpdate(
        TextEditingValue(
            text: '12', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12,', selection: TextSelection.collapsed(offset: 3)));

    expect(newValue7.text, equals('12,'));

    final newValue8 = decimalFormatterES.formatEditUpdate(
        newValue1,
        TextEditingValue(
            text: '1.234,', selection: TextSelection.collapsed(offset: 6)));

    expect(newValue8.text, equals('1.234,'));

    final newValue9 = decimalFormatterES.formatEditUpdate(
        newValue8,
        TextEditingValue(
            text: '1.234,5', selection: TextSelection.collapsed(offset: 7)));

    expect(newValue9.text, equals('1.234,5'));

    final newValue10 = decimalFormatterES.formatEditUpdate(
        TextEditingValue(
            text: '1.234,5', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '1.2134,5', selection: TextSelection.collapsed(offset: 4)));

    expect(
        newValue10,
        equals(TextEditingValue(
            text: '12.134,5', selection: TextSelection.collapsed(offset: 4))));
  });

  test('credit card number grouping smoke test', () {
    final newValue1 = creditCardFormatter.formatEditUpdate(
        TextEditingValue(
            text: '1234', selection: TextSelection.collapsed(offset: 4)),
        TextEditingValue(
            text: '12345', selection: TextSelection.collapsed(offset: 5)));

    expect(
        newValue1,
        TextEditingValue(
            text: '1234 5', selection: TextSelection.collapsed(offset: 6)));

    final newValue2 = creditCardFormatter.formatEditUpdate(
        TextEditingValue(
            text: '1234 5', selection: TextSelection.collapsed(offset: 2)),
        TextEditingValue(
            text: '12134 5', selection: TextSelection.collapsed(offset: 3)));

    expect(
        newValue2,
        equals(TextEditingValue(
            text: '1213 45', selection: TextSelection.collapsed(offset: 3))));
  });
}

_dateFormatterSmokeTest() {
  final formatter = DateInputFormatter();

  test('date form input smoke test', () {
    // test insert placeholder when user start editing
    final newValue1 = formatter.formatEditUpdate(
        TextEditingValue(
            text: '', selection: TextSelection.collapsed(offset: 0)),
        TextEditingValue(
            text: '', selection: TextSelection.collapsed(offset: 0)));
    expect(
        newValue1,
        TextEditingValue(
            text: '--/--/----', selection: TextSelection.collapsed(offset: 0)));

    // test add a new digit at start position
    final newValue2 = formatter.formatEditUpdate(
        newValue1,
        TextEditingValue(
            text: '1--/--/----',
            selection: TextSelection.collapsed(offset: 1)));
    expect(
        newValue2,
        TextEditingValue(
            text: '1-/--/----', selection: TextSelection.collapsed(offset: 1)));

    // test add a new digit in the middle
    final newValue3 = formatter.formatEditUpdate(
        newValue2.copyWith(selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '1-/2--/----',
            selection: TextSelection.collapsed(offset: 4)));
    expect(
        newValue3,
        TextEditingValue(
            text: '1-/2-/----', selection: TextSelection.collapsed(offset: 4)));

    // test delete
    final newValue4 = formatter.formatEditUpdate(
        newValue3,
        TextEditingValue(
            text: '1-/-/----', selection: TextSelection.collapsed(offset: 3)));
    expect(
        newValue4,
        TextEditingValue(
            text: '1-/--/----', selection: TextSelection.collapsed(offset: 2)));

    // test restrict input length
    final newValue5 = formatter.formatEditUpdate(
        TextEditingValue(
            text: '12/12/2018', selection: TextSelection.collapsed(offset: 10)),
        TextEditingValue(
            text: '12/12/20180',
            selection: TextSelection.collapsed(offset: 11)));
    expect(
        newValue5,
        TextEditingValue(
            text: '12/12/2018',
            selection: TextSelection.collapsed(offset: 10)));

    // test delete when cursor stands right after splash
    final newValue6 = formatter.formatEditUpdate(
        TextEditingValue(
            text: '12/12/2018', selection: TextSelection.collapsed(offset: 3)),
        TextEditingValue(
            text: '1212/2018', selection: TextSelection.collapsed(offset: 2)));
    expect(
        newValue6,
        TextEditingValue(
            text: '12/12/2018', selection: TextSelection.collapsed(offset: 2)));
  });
}
