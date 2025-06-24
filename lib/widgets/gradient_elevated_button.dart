import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';

class GradientElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFD2A22), Color(0xFFFE6C57)],
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              blurRadius: 2.8,
              color: Colors.black.withValues(alpha: 0.2),
              inset: true,
            ),
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
              color: const Color(0xFFFD251E).withValues(alpha: 0.3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
