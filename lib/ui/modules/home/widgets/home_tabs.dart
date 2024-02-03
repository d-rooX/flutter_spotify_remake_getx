import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/ui/modules/home/controllers/home_tab_controller.dart';
import 'package:spotify_remake_getx/ui/modules/home/widgets/tab_chip.dart';

class HomeTabs extends GetView<HomeTabController> {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(
      controller.tabs.length,
      (index) => TabChip(
        tab: controller.tabs[index],
        index: index,
      ),
    );

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 30),
            ...tabs,
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
