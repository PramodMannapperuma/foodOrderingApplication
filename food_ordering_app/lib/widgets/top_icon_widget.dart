import 'package:flutter/material.dart';

class TopIconsWidget extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  final Color defaultColor;
  final Function(int) onIconPressed;

  TopIconsWidget({
    required this.selectedIndex,
    required this.selectedColor,
    required this.defaultColor,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -1,
      left: 100,
      right: 100,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(Icons.delivery_dining_outlined, 0),
            _buildIconButton(Icons.lock_outline, 1),
            _buildIconButton(Icons.table_bar_outlined, 2),
          ],
        ),
      ),
    );
  }

  IconButton _buildIconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? selectedColor : defaultColor,
        size: 30,
      ),
      onPressed: () => onIconPressed(index),
    );
  }
}
