import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';
import 'package:quiz_app/feature/widget/item_card.dart';

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
    final controller = Get.find<LibraryController>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flashcardSets.length,
      itemBuilder: (context, index) {
        final set = flashcardSets[index];
        return Dismissible(
          key: ValueKey(set),
          onDismissed: (direction) {
            controller.removeFlashcardSet(index);
          },
          child: ItemCard(
            title: set.title,
            iconData: const Icon(Icons.style_outlined),
            count: '${set.cardCount} thẻ',
            onTap: () {
              controller.goToSetDetail(set);
            },
          ),
        );
      },
    );
  }
}
