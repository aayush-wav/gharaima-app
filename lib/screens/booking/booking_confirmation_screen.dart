import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColorsDark.success : AppColors.success).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCheckmarkCircle01, 
                        size: 80, 
                        color: isDark ? AppColorsDark.success : AppColors.success
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text('Booking Placed!', style: AppTextStyles.displayLarge),
                        const SizedBox(height: 12),
                        Text(
                          'Your service request has been successfully received. We will assign a certified provider shortly.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                            height: 1.5
                          ),
                        ),
                        const SizedBox(height: 48),
                        _buildSummaryCard(isDark),
                        const SizedBox(height: 48),
                        CustomButton(
                          text: 'Track Activity',
                          onPressed: () => context.go('/bookings'),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextButton(
                          onPressed: () => context.go('/home'),
                          child: Text('Return to Home', style: AppTextStyles.labelLarge.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _buildRow('STATUS', 'PENDING', isDark, isWarning: true),
          const SizedBox(height: 12),
          _buildRow('PAYMENT', 'CASH ON SERVICE', isDark),
          const Divider(height: 32, thickness: 0.5),
          _buildRow('REF ID', '#GH-8821', isDark, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark, {bool isWarning = false, bool isBold = false}) {
    final textHint = isDark ? AppColorsDark.textHint : AppColors.textHint;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final warning = isDark ? AppColorsDark.warning : AppColors.warning;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.overline.copyWith(color: textHint, letterSpacing: 1.5)),
        Text(
          value,
          style: (isBold ? AppTextStyles.labelLarge : AppTextStyles.labelMedium).copyWith(
            color: isWarning ? warning : textPrimary,
          ),
        ),
      ],
    );
  }
}
