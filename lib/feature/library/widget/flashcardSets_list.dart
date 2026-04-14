import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';

class FlashcardsetsList extends StatelessWidget {
  final List<FlashCardSetModel> flashcardSets;
  final Function(FlashCardSetModel) onTap;

  const FlashcardsetsList({
    super.key,
    required this.flashcardSets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: flashcardSets.length,
      itemBuilder: (context, index) {
        final set = flashcardSets[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(width: 2, color: Colors.grey),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 4.h,
            ),
            leading: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(Icons.quiz_outlined),
            ),
            title: Text(
              set.title,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            subtitle: Text(
              '${set.cardCount} thẻ',
              style: TextStyle(fontSize: 13.sp),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
    );
  }
}
