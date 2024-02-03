import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const SizedBox(
        height: 60,
        width: 60,
        child: Icon(
          Icons.menu,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
