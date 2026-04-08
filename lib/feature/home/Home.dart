import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/data/models/user_model.dart';
import 'package:quiz_app/data/repositories/profile_repository.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.sp,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF0C0630),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 12),
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              "Tìm kiếm...",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StreamBuilder(
                    stream: _profileRepository.watchCurrentUserProfile(),
                    builder: ((context, snapshot){
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return CircularProgressIndicator();
                      }
                      final profile = snapshot.data!.first;
                      return Column(
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(profile['avatar_url'])),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(16.0),
              child: Divider(
                color: Colors.grey[300],
                height: 1.0,
                thickness: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
