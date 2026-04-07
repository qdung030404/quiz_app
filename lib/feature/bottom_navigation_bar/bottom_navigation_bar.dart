import 'package:flutter/material.dart';
import 'package:quiz_app/feature/Create/create.dart';
import 'package:quiz_app/feature/home/Home.dart';
import 'package:quiz_app/feature/library/library.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = const [HomeTab(), LibraryTab()];

  // Index hiển thị trên BottomNavigationBar (0=Home, 1=Create, 2=Library)
  int _navIndex = 0;

  // Index tương ứng với _pages (0=Home, 1=Library)
  int get _pageIndex => _navIndex == 2 ? 1 : 0;

  void _onTabTapped(int index) {
    if (index == 1) {
      _openCreateSheet();
    } else {
      setState(() => _navIndex = index);
    }
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _pageIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onTabTapped,
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
    );
  }
}
