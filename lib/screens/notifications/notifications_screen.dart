import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../widgets/glass_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                    _buildNotification(
                      'Booking Confirmed',
                      'Your plumbing service is confirmed for tomorrow 10:00 AM.',
                      '2 mins ago',
                      HugeIcons.strokeRoundedCheckmarkCircle01,
                      isDark ? AppColorsDark.success : AppColors.success,
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildNotification(
                      'New Offer!',
                      'Get 20% off on your next Salon service. Valid till June.',
                      '1 hour ago',
                      HugeIcons.strokeRoundedTicket01,
                      isDark ? AppColorsDark.primary : AppColors.primary,
                      isDark,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildNotification(
                      'Payment Received',
                      'Payment of Rs. 1500 for Deep Cleaning was successful.',
                      'Yesterday',
                      HugeIcons.strokeRoundedCircleArrowUp01,
                      isDark ? AppColorsDark.primaryDark : AppColors.primary,
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
          Text('Activity Hub', style: AppTextStyles.headingMedium),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildNotification(String title, String body, String time, IconData icon, Color color, bool isDark) {
    final textSec = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColorsDark.textHint : AppColors.textHint;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: HugeIcon(icon: icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700)),
                    Text(time, style: AppTextStyles.caption.copyWith(color: textHint, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: AppTextStyles.bodySmall.copyWith(color: textSec, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
