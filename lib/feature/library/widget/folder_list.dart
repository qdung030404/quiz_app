import 'package:flutter/material.dart';
import 'package:quiz_app/feature/library/controller/library_controller.dart';
import 'package:quiz_app/feature/widget/item_card.dart';

import '../../../data/models/folder_model.dart';

class FolderList extends StatelessWidget {
  final List<FolderModel> folders; // Tên biến rõ ràng là 'folders'
  final Function(FolderModel) onTap;

  const FolderList({super.key, required this.folders, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = LibraryController();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final folder = folders[index];
        return ItemCard(
          title: folder.title,
          iconData: Icon(Icons.folder_outlined),
          onTap: () => controller.goToFolderDetail(folder),
        );
      },
    );
  }
}
