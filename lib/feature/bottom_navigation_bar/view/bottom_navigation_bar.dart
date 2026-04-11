import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/view/home_screen.dart';
import '../../library/view/library_screen.dart';
import '../controller/nav_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());

    final List<Widget> pages = const [HomeTab(), LibraryTab()];

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.pageIndex, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.navIndex.value,
          onTap: (index) => controller.onTabTapped(index, context),
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 22),
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tạo'),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'Thư viện',
            ),
          ],
        ),
      ),
    );
  }
}
