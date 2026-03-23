import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/service_model.dart';
import '../config/theme.dart';
import '../utils/price_formatter.dart';
import 'glass_card.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  final bool showBookingButton;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.showBookingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final textSec = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColorsDark.textHint : AppColors.textHint;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: HugeIcon(
                  icon: _getIcon(service.name),
                  color: isDark ? AppColorsDark.primaryLight : AppColors.primaryLight,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SERVICE', // Static category label as per spec "overline"
                    style: AppTextStyles.overline.copyWith(color: primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service.name,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedStar, color: isDark ? AppColorsDark.warning : AppColors.warning, size: 14),
                      const SizedBox(width: 4),
                      Text('4.8', style: AppTextStyles.bodySmall.copyWith(color: textSec)),
                      const SizedBox(width: 12),
                      HugeIcon(icon: HugeIcons.strokeRoundedClock01, color: textHint, size: 14),
                      const SizedBox(width: 4),
                      Text('45 min', style: AppTextStyles.bodySmall.copyWith(color: textHint)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  PriceFormatter.format(service.basePrice),
                  style: AppTextStyles.priceText.copyWith(
                    color: isDark ? AppColorsDark.primary : AppColors.primaryDark,
                  ),
                ),
                Text(
                  service.priceUnit,
                  style: AppTextStyles.labelSmall.copyWith(color: textHint),
                ),
              ],
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
    if (n.contains('beauty') || n.contains('salon')) return HugeIcons.strokeRoundedFlower;
    return HugeIcons.strokeRoundedTask01;
  }
}
