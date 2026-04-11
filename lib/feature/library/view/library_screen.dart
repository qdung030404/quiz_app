import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/base_screen.dart';
import '../controller/library_controller.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final LibraryController controller = Get.put(LibraryController());

    return const BaseScreen(
      child: Center(
        child: Text(
          "Thư viện của bạn",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
