import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/category_model.dart';
import '../config/theme.dart';
import 'glass_card.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppSpacing.lg),
        child: Column(
          children: [
            GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: AppRadius.md,
              child: SizedBox(
                height: 70,
                width: 70,
                child: Center(
                  child: HugeIcon(
                    icon: _getIcon(category.name),
                    color: isDark ? AppColorsDark.primary : AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('clean')) return HugeIcons.strokeRoundedSparkles;
    if (n.contains('plumb')) return HugeIcons.strokeRoundedDroplet;
    if (n.contains('electri')) return HugeIcons.strokeRoundedLightning02;
    if (n.contains('beauty') || n.contains('salon') || n.contains('wellness')) return HugeIcons.strokeRoundedFlower;
    if (n.contains('repair') || n.contains('maintenance')) return HugeIcons.strokeRoundedSettings01;
    if (n.contains('paint')) return HugeIcons.strokeRoundedColorPicker;
    if (n.contains('appliance') || n.contains('washing')) return HugeIcons.strokeRoundedTv01;
    return HugeIcons.strokeRoundedTask01;
  }
}
