import 'package:flutter/material.dart';

class HexColor extends Color {
  static _hexToColor(String code) {
    code = code.toUpperCase();
    if (code.length == 7) {
      return int.parse(code.substring(1, 7), radix: 16) + 0xFF000000;
    } else if (code.length > 7 && code.length <= 9) {
      return int.parse(code.substring(7) + code.substring(1, 7), radix: 16) +
          0x00000000;
    }
  }

  HexColor(final String code) : super(_hexToColor(code));
}
