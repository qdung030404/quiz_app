import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';
import 'package:quiz_app/data/models/public_folder_model.dart';
import 'package:quiz_app/data/models/public_set_model.dart';
import 'package:quiz_app/feature/home/controller/home_controller.dart';
import 'package:quiz_app/feature/widget/item_card.dart';

class PublicFlashcardSetList extends StatelessWidget {
  final List<PublicFolderModel> folders;
  final List<PublicSetModel> sets;

  const PublicFlashcardSetList({
    super.key,
    required this.sets,
    required this.folders,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return BaseScreen(
      appBar: AppBar(
        title: Text(folders.first.title),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (sets.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sets.length,
              itemBuilder: (context, index) {
                final set = sets[index];
                return ItemCard(
                  title: set.title,
                  count: '${set.totalCards} thẻ',
                  iconData: const Icon(Icons.style_outlined),
                  onTap: () => controller.goToFlashcardDetailFromPublic(set),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
