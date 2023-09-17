import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerTop extends StatelessWidget {
  const PlayerTop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            CupertinoIcons.chevron_down,
            color: Colors.white,
          ),
        ),
        const Text(
          "dont look at this shit bro",
          style: TextStyle(fontSize: 16),
        ),
        const Icon(
          Icons.more_horiz,
          color: Colors.white,
          size: 34,
        ),
      ],
    );
  }
}
