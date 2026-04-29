import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/data/models/folder_model.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';
import 'package:quiz_app/feature/widget/item_card.dart';


class FolderList extends StatelessWidget {
  final List<FolderModel> folders;
  final Function(FolderModel) onTap;

  const FolderList({super.key, required this.folders, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return Dismissible(
          key: ValueKey(folder),
          onDismissed: (direction) {
            controller.removeFolder(index);
          },
          child: ItemCard(
            title: folder.title,
            iconData: const Icon(Icons.folder_outlined),
            onTap: () => controller.goToFolderDetail(folder),
          ),
        );
      },
    );
  }
}
