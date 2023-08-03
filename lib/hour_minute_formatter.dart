import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show TextField;
import 'package:pattern_formatter/services/pattern_formatter_service.dart';

/// An implementation of [TextInputFormatter] provides a way to input hour and minute form
/// with [TextField], such as HH:mm. In order to guide user about input form,
/// the formatter will provide [TextField] a placeholder --:-- as soon as
/// user start editing. During editing session, the formatter will replace appropriate
/// placeholder characters by user's input.

class HourMinuteInputFormatter extends TextInputFormatter {
  String _placeholder = '--:--';
  TextEditingValue? _lastNewValue;
  final List<int> indexs = [0, 1, 3, 4];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// provides placeholder text when user start editing

    final fillInputToPlaceholder = PatternFormatterService()
        .fillInputToPlaceholder(
            input: newValue.text, indexs: indexs, placeholder: _placeholder);

    if (oldValue.text.isEmpty) {
      oldValue = oldValue.copyWith(
        text: _placeholder,
      );
      newValue = newValue.copyWith(
        text: fillInputToPlaceholder,
      );
      return newValue;
    }

    /// nothing changes, nothing to do
    if (newValue == _lastNewValue) {
      return oldValue;
    }
    _lastNewValue = newValue;

    int offset = newValue.selection.baseOffset;

    /// restrict user's input within the length of date form
    if (offset > 5) {
      return oldValue;
    }

    if (oldValue.text == newValue.text && oldValue.text.length > 0) {
      return newValue;
    }

    final String oldText = oldValue.text;
    final String newText = newValue.text;
    String? resultText;

    /// handle user editing, there're two cases:
    /// 1. user add new digit: replace '-' at cursor's position by user's input.
    /// 2. user delete digit: replace digit at cursor's position by '-'
    // int index = _indexOfDifference(newText, oldText);
    int index =
        PatternFormatterService().indexOfDiference(cs1: newText, cs2: oldText);
    if (oldText.length < newText.length) {
      /// add new digit
      String newChar = newText[index];
      if (index == 2) {
        index++;
        offset++;
      }
      resultText = oldText.replaceRange(index, index + 1, newChar);
      if (offset == 2) {
        offset++;
      }
    } else if (oldText.length > newText.length) {
      /// delete digit
      if (oldText[index] != ':') {
        resultText = oldText.replaceRange(index, index + 1, '-');
        if (offset == 3) {
          offset--;
        }
      } else {
        resultText = oldText;
      }
    }

    return oldValue.copyWith(
      text: resultText,
      selection: TextSelection.collapsed(offset: offset),
      composing: defaultTargetPlatform == TargetPlatform.iOS
          ? TextRange(start: 0, end: 0)
          : TextRange.empty,
    );
  }
}
