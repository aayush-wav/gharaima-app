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
        margin: const EdgeInsets.only(right: AppTheme.p12),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Center(
                child: Icon(
                  Icons.home_repair_service, // TODO: Use category.iconUrl if available
                  color: AppTheme.primary,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.p8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
