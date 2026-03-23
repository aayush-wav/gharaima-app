import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../config/theme.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: AppTheme.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 80, // Increased for better presence
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.primary.withOpacity(0.1), width: 1.5),
              ),
              child: Center(
                child: Icon(
                  _getIcon(category.name),
                  color: AppTheme.primary,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.p12),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
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
    if (name.toLowerCase().contains('clean')) return Icons.cleaning_services_rounded;
    if (name.toLowerCase().contains('plumb')) return Icons.plumbing_rounded;
    if (name.toLowerCase().contains('electr')) return Icons.electrical_services_rounded;
    if (name.toLowerCase().contains('paint')) return Icons.format_paint_rounded;
    if (name.toLowerCase().contains('repair')) return Icons.home_repair_service_rounded;
    return Icons.category_rounded;
  }
}
