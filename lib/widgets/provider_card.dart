import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/provider_model.dart';
import '../config/theme.dart';
import 'glass_card.dart';
import 'star_rating.dart';

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        margin: const EdgeInsets.only(right: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: 140,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, color: primary, size: 28),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                provider.fullName,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              StarRating(rating: provider.rating),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${provider.totalReviews} reviews',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColorsDark.textHint : AppColors.textHint,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
