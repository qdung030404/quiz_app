import 'package:flutter/material.dart';
import 'package:quiz_app/feature/intro/intro.dart';
import 'package:quiz_app/feature/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  Future<void> nextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if (supabase.auth.currentSession == null) {
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Intro()),
        );
      }
    } else {
      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(child: FlutterLogo(size: 100)),
    );
  }
}
