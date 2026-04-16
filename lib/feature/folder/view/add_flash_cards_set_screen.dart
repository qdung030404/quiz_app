import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/feature/folder/controller/folder_controller.dart';

import '../../library/controller/library_controller.dart';

class AddFlashCardsSetScreen extends StatefulWidget {
  const AddFlashCardsSetScreen({super.key});

  @override
  State<AddFlashCardsSetScreen> createState() => _AddFlashCardsSetScreenState();
}

class _AddFlashCardsSetScreenState extends State<AddFlashCardsSetScreen> {
  final controller = Get.put(LibraryController());
  final folderController = Get.put(FolderController());
  final RxSet<String> _selectedSetIds = <String>{}.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Thêm học Phần',
          style: GoogleFonts.beVietnamPro(fontSize: 16.sp),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.flashcardSet.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text("Bạn chưa có Học phần nào!")),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: controller.flashcardSet.length,
            itemBuilder: (context, index) {
              final set = controller.flashcardSet[index];
              final setId = set.id ?? '';
              return Obx(() {
                final isSelected = _selectedSetIds.contains(setId);
                return AddSetCardItem(
                  title: set.title,
                  cardCount: set.cardCount,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      _selectedSetIds.remove(setId);
                    } else {
                      _selectedSetIds.add(setId);
                    }
                  },
                );
              });
            },
          );
        }),
      ),
      bottomNavigationBar: Stack(
        children: [
          Obx(
            () => ElevatedButton(
              onPressed: _selectedSetIds.isNotEmpty
                  ? () => folderController.addSetsToFolder(
                      _selectedSetIds.toList(),
                    )
                  : null,
              child: Text('Thêm ${_selectedSetIds.length} mục'),
            ),
          ),
        ],
      ),
    );
  }
}

class AddSetCardItem extends StatelessWidget {
  final String title;
  final int cardCount;
  final bool isSelected;
  final VoidCallback onTap;

  const AddSetCardItem({
    super.key,
    required this.title,
    required this.cardCount,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.quiz_outlined),
      title: Text(title),
      subtitle: Text('$cardCount thẻ'),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.add_circle_outline),
      onTap: onTap,
    );
  }
}
