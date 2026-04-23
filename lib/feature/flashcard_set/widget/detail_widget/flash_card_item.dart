import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/models/flashcard_model.dart';
import 'package:quiz_app/feature/flashcard_set/controller/flashcard_controller.dart';

class FlashCardItem extends StatefulWidget {
  final FlashCardModel flashCardModel;
  const FlashCardItem({
    super.key,
    required this.flashCardModel
  });

  @override
  State<FlashCardItem> createState() => _FlashCardItemState();
}

class _FlashCardItemState extends State<FlashCardItem> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  bool isFront = true;
  final controller = Get.put(FlashcardController());
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
  void _handleFlip() {
    if (isFront) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleFlip,
      child: AnimatedBuilder(
        animation: _animationController,
        builder:(context, child){
          final angle = _animationController.value * pi;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle),
            alignment: Alignment.center,
            child: angle < pi / 2
                ? _buildFront()
                : _buildBack(angle),
          );
        }
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      key: const ValueKey(true),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          widget.flashCardModel.terminology,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.normal,
            fontSize: 28.sp,
          ),
        ),
      ),
    );
  }
  Widget _buildBack(double angle) {
    return Transform(
      transform: Matrix4.identity()..rotateX(pi),
      alignment: Alignment.center,
      child: Container(
        key: const ValueKey(false),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            widget.flashCardModel.definition,
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.normal,
              fontSize: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}
