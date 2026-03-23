import 'package:flutter/material.dart';
import '../config/theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final starColor = isDark ? AppColorsDark.warning : AppColors.warning;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: starColor, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: starColor, size: size);
        } else {
          return Icon(Icons.star_border, color: starColor, size: size);
        }
      }),
    );
  }
}
