import 'dart:math';

import '../consts.dart';

abstract class IPatternFormatterService {
  int indexOfDiference({
    required String? cs1,
    required String? cs2,
  });
  String fillInputToPlaceholder({
    required String input,
    required String placeholder,
    required List<int> indexs,
  });
}

class PatternFormatterService implements IPatternFormatterService {
  @override
  String fillInputToPlaceholder({
    required String input,
    required String placeholder,
    required List<int> indexs,
  }) {
    if (input.isEmpty) {
      return placeholder;
    }
    String result = placeholder;
    final index = indexs;
    final length = min(index.length, input.length);
    for (int i = 0; i < length; i++) {
      result = result.replaceRange(index[i], index[i] + 1, input[i]);
    }
    return result;
  }

  @override
  int indexOfDiference({required String? cs1, required String? cs2}) {
    if (cs1 == cs2) {
      return INDEX_NOT_FOUND;
    }
    if (cs1 == null || cs2 == null) {
      return 0;
    }
    int i;
    for (i = 0; i < cs1.length && i < cs2.length; ++i) {
      if (cs1[i] != cs2[i]) {
        break;
      }
    }
    if (i < cs2.length || i < cs1.length) {
      return i;
    }
    return INDEX_NOT_FOUND;
  }
}
