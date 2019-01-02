import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show TextField;
import 'package:intl/intl.dart';

import 'dart:math';

///
/// An implementation of [NumberInputFormatter] automatically inserts thousands
/// separators to numeric input. For example, a input of `1234` should be
/// formatted to `1,234`.
///
class ThousandsFormatter extends NumberInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern();

  final WhitelistingTextInputFormatter _decimalFormatter;
  final String _decimalSeparator;

  final NumberFormat formatter;
  final bool allowFraction;

  ThousandsFormatter({this.formatter, this.allowFraction = false})
      : _decimalSeparator = (formatter ?? _formatter).symbols.DECIMAL_SEP,
        _decimalFormatter = WhitelistingTextInputFormatter(RegExp(allowFraction
            ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
            : r'\d+'));

  @override
  String _formatPattern(String digits) {
    if (digits == null || digits.isEmpty) return digits;
    final number = allowFraction
        ? double.tryParse(digits) ?? 0.0
        : int.tryParse(digits) ?? 0;
    final result = (formatter ?? _formatter).format(number);
    if (allowFraction && digits.endsWith(_decimalSeparator)) {
      return '$result$_decimalSeparator';
    }
    return result;
  }

  @override
  TextEditingValue _formatNumber(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _decimalFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isSeparator(String s) => allowFraction && _decimalSeparator == s;
}

///
/// An implementation of [NumberInputFormatter] that converts a numeric input
/// to credit card number form (4-digit grouping). For example, a input of
/// `12345678` should be formatted to `1234 5678`.
///
class CreditCardFormatter extends NumberInputFormatter {
  static final WhitelistingTextInputFormatter _digitOnlyFormatter =
      WhitelistingTextInputFormatter(RegExp(r'\d+'));

  final String separator;

  CreditCardFormatter({this.separator = ' '});

  @override
  String _formatPattern(String digits) {
    StringBuffer buffer = StringBuffer();
    int offset = 0;
    int count = min(4, digits.length);
    final length = digits.length;
    for (; count <= length; count += min(4, max(1, length - count))) {
      buffer.write(digits.substring(offset, count));
      if (count < length) {
        buffer.write(separator);
      }
      offset = count;
    }
    return buffer.toString();
  }

  @override
  TextEditingValue _formatNumber(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _digitOnlyFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isSeparator(String s) => false;
}

///
/// An abstract class extends from [TextInputFormatter] and does numeric filter.
/// It has an abstract method `_format()` that lets its children override it to
/// format input displayed on [TextField]
///
abstract class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// nothing changes, do nothing
    if (oldValue.text == newValue.text) {
      return newValue;
    }

    /// remove all invalid characters
    newValue = _formatNumber(oldValue, newValue);

    /// current selection
    int selectionIndex = newValue.selection.end;

    /// format original string, this step would add some separator
    /// characters to original string
    final newText = _formatPattern(newValue.text);

    /// count number of inserted character in new string
    int insertCount = 0;

    /// count number of original input character in new string
    int inputCount = 0;
    for (int i = 0; i < newText.length && inputCount < selectionIndex; i++) {
      final character = newText[i];
      if (_isNumeric(character) || _isSeparator(character)) {
        inputCount++;
      } else {
        insertCount++;
      }
    }

    /// adjust selection according to number of inserted characters staying before
    /// selection
    selectionIndex += insertCount;
    selectionIndex = min(selectionIndex, newText.length);

    /// if selection is right after an inserted character, it should be moved
    /// backward, this adjustment prevents an issue that user cannot delete
    /// characters when cursor stands right after inserted characters
    if (selectionIndex - 1 >= 0 &&
        selectionIndex - 1 < newText.length &&
        !_isNumeric(newText[selectionIndex - 1]) &&
        !_isSeparator(newText[selectionIndex - 1])) {
      selectionIndex--;
    }
    return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex));
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  bool _isSeparator(String s);

  String _formatPattern(String digits);

  TextEditingValue _formatNumber(
      TextEditingValue oldValue, TextEditingValue newValue);
}
