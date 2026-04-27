import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quiz_app/core/widgets/base_screen.dart';

import '../controller/match_controller.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchController());
    return BaseScreen(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Obx(
          () => Text('${controller.second.value.toStringAsFixed(1)}s'),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => controller.toggleSound(),
              icon: Icon(
                controller.isMuted.value ? Icons.volume_up : Icons.volume_off,
              ),
            ),
          ),
        ],
      ),
      child: Obx(
        () => GridView.builder(
          itemCount: controller.cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = controller.cards[index];
            if (item.isMatched) {
              return SizedBox.shrink();
            }
            return GestureDetector(
              onTap: () => controller.onCardTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: item.isSelected
                      ? Colors.blue.shade100
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: item.isSelected ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  item.text,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
