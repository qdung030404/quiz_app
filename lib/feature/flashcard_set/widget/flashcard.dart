import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_color.dart';

class Flashcard extends StatefulWidget {
  final TextEditingController terminologyController;
  final TextEditingController definitionController;

  const Flashcard({
    super.key,
    required this.terminologyController,
    required this.definitionController,
  });

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Column(
          children: [
            TextFormField(
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              controller: widget.terminologyController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.fillColor(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 3.0,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'THUẬT NGỮ',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'CHỌN NGÔN NGỮ',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              controller: widget.definitionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.fillColor(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 3.0,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.borderColor(context),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ĐỊNH NGHĨA',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'CHỌN NGÔN NGỮ',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
