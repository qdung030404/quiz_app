import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final bool useSafeArea;

  const BaseScreen({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backgroundGradient(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: useSafeArea ? SafeArea(child: child) : child,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
      ),
    );
  }
}
