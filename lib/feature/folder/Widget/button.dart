import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPress;

  const Button({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *0.5,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: onPress,
        child: Text(text, style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.white
        )),
      ),
    );
  }
}
