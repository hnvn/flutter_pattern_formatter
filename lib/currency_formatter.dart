import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter {
  CurrencyFormatter({
    this.locale,
    this.name,
    this.symbol,
    this.isGrouped = false,
  });

  final String? locale;
  final String? name;
  final String? symbol;
  final bool isGrouped;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final isInserted = oldValue.text.length + 1 == newValue.text.length && newValue.text.startsWith(oldValue.text);
    final isRemoved = oldValue.text.length - 1 == newValue.text.length && oldValue.text.startsWith(newValue.text);

    if (!isInserted && !isRemoved) {
      return oldValue;
    }

    final format = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
    );

    if (isGrouped) {
      format.turnOffGrouping();
    }

    final isNegativeValue = newValue.text.startsWith('-');
    var newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    if (isRemoved && !_lastCharacterIsDigit(oldValue.text)) {
      final length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    if (newText.trim() == '') {
      return newValue.copyWith(
        text: isNegativeValue ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegativeValue ? 1 : 0),
      );
    } else if (newText == '00' || newText == '000') {
      return TextEditingValue(
        text: isNegativeValue ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegativeValue ? 1 : 0),
      );
    }

    num newInt = int.parse(newText);
    if (format.decimalDigits! > 0) {
      newInt /= pow(10, format.decimalDigits!);
    }

    final newString = (isNegativeValue ? '-' : '') + format.format(newInt).trim();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }

  static bool _lastCharacterIsDigit(String text) {
    final lastChar = text.substring(text.length - 1);
    return RegExp('[0-9]').hasMatch(lastChar);
  }
}
