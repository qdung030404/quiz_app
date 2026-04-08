import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Create/view/create_bottom_sheet.dart';

class NavController extends GetxController {
  // Index hiển thị trên BottomNavigationBar (0=Home, 1=Create, 2=Library)
  var navIndex = 0.obs;

  // Index tương ứng với danh sách các trang (0=Home, 1=Library)
  int get pageIndex => navIndex.value == 2 ? 1 : 0;

  void onTabTapped(int index, BuildContext context) {
    if (index == 1) {
      openCreateSheet(context);
    } else {
      navIndex.value = index;
    }
  }

  void openCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateBottomSheet(),
    );
  }
}
