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
}