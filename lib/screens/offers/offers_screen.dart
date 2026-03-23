import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../widgets/glass_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  children: [
                    _buildOfferCard(
                      'SUMMER25',
                      'High-Performance Cooling',
                      'Get 25% off on all premium AC restoration services.',
                      'Valid until Aug 31',
                      isDark ? AppColorsDark.primary : AppColors.primary,
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildOfferCard(
                      'EXECUTIVE500',
                      'Welcome Reward',
                      'Exclusive Rs. 500 cashback on your first luxury concierge.',
                      'New users only',
                      isDark ? AppColorsDark.success : AppColors.success,
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildOfferCard(
                      'RENEWAL15',
                      'Immaculate Spaces',
                      'Flat 15% off on Deep Cleaning & Renovation.',
                      'Limited availability',
                      isDark ? AppColorsDark.warning : AppColors.warning,
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 24),
            onPressed: () => context.pop(),
          ),
          Text('Privileged Offers', style: AppTextStyles.headingMedium),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String code, String title, String desc, String validity, Color color, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: color.withOpacity(0.5), width: 0.5),
                ),
                child: Text(
                  'EXCLUSIVE',
                  style: AppTextStyles.overline.copyWith(color: color, fontSize: 8, letterSpacing: 1.5, fontWeight: FontWeight.w800),
                ),
              ),
              HugeIcon(icon: HugeIcons.strokeRoundedTicket01, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Text(title.toUpperCase(), style: AppTextStyles.headingSmall.copyWith(fontSize: 16, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(
            desc,
            style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PROMO CODE', style: AppTextStyles.overline.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint, fontSize: 8, letterSpacing: 1.0)),
                  Text(code, style: AppTextStyles.headingMedium.copyWith(color: color, fontSize: 22)),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'COPY',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(validity, style: AppTextStyles.caption.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint, fontSize: 9)),
        ],
      ),
    );
  }
}
