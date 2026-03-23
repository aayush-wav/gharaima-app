import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';

class BookingSummaryScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingSummaryScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          children: [
                            _buildInfoRow('SERVICE ID', '#${booking.id.substring(0, 8).toUpperCase()}', isDark, isBold: true),
                            _buildInfoRow('STATUS', booking.status.toUpperCase(), isDark, isStatus: true),
                            const Divider(height: 32, thickness: 0.5),
                            _buildInfoRow('SCHEDULED', DateFormatter.formatFullDate(booking.scheduledAt), isDark),
                            _buildInfoRow('TIME SLOT', DateFormatter.formatTime(booking.scheduledAt), isDark),
                            _buildInfoRow('LOCATION', booking.address, isDark, isSmall: true),
                            const Divider(height: 32, thickness: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL INVESTMENT', style: AppTextStyles.labelLarge.copyWith(fontSize: 12, letterSpacing: 1.0)),
                                Text(PriceFormatter.format(booking.totalPrice ?? 0), style: AppTextStyles.priceLarge.copyWith(color: primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      CustomButton(
                        text: 'Return to Hub',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Concierge Summary', style: AppTextStyles.headingMedium),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isStatus = false, bool isBold = false, bool isSmall = false}) {
    final textHint = isDark ? AppColorsDark.textHint : AppColors.textHint;
    final warning = isDark ? AppColorsDark.warning : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: textHint, fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.labelMedium.copyWith(
                fontSize: isSmall ? 11 : 12,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isStatus ? warning : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
