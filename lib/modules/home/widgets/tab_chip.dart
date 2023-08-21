import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/modules/home/controllers/home_tab_controller.dart';

class TabChip extends GetView<HomeTabController> {
  // todo remove GetX dependency

  final HomeTracksTab tab;
  final int index;
  const TabChip({
    super.key,
    required this.tab,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(10);

    return Obx(
      () => GestureDetector(
        onTap: () => controller.currentIndex.value = index,
        child: Container(
          decoration: controller.currentIndex.value == index
              ? BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurpleAccent.withOpacity(0.4),
                    ],
                  ))
              : const BoxDecoration(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          margin: const EdgeInsets.only(right: 15),
          child: Text(
            tab.title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
