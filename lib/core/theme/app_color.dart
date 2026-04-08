import 'package:flutter/material.dart';

class AppColor {
  // Hàm lấy màu nền tùy theo Brightness
  static Color fillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff9181F4)
        : Colors.grey.shade100;
  }

  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xff9181F4);
  }

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xff9181F4), Color(0xff5038ED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient backgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [Colors.white,Color(0xFFC5C5FF)],
            stops: [0.7, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          );
  }
}
