import 'package:flutter/material.dart';
import 'package:quiz_app/data/models/flashcard_set_model.dart';
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: flashcardSets.length,
      itemBuilder: (context, index) {
        final set = flashcardSets[index];
        return ItemCard(
          title: set.title,
          iconData: Icon(Icons.quiz_outlined),
          count: '${set.cardCount} thẻ',
          onTap: () {},
        );
      },
    );
  }
}
