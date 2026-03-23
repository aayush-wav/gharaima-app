import 'package:flutter/material.dart';
import '../config/theme.dart';

class BookingStatusChip extends StatelessWidget {
  final String status;

  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = isDark ? AppColorsDark.pendingBg : AppColors.pendingBg;
        text = isDark ? AppColorsDark.pendingText : AppColors.pendingText;
        break;
      case 'confirmed':
        bg = isDark ? AppColorsDark.confirmedBg : AppColors.confirmedBg;
        text = isDark ? AppColorsDark.confirmedText : AppColors.confirmedText;
        break;
      case 'in_progress':
        bg = isDark ? AppColorsDark.inProgressBg : AppColors.inProgressBg;
        text = isDark ? AppColorsDark.inProgressText : AppColors.inProgressText;
        break;
      case 'completed':
        bg = isDark ? AppColorsDark.completedBg : AppColors.completedBg;
        text = isDark ? AppColorsDark.completedText : AppColors.completedText;
        break;
      case 'cancelled':
        bg = isDark ? AppColorsDark.cancelledBg : AppColors.cancelledBg;
        text = isDark ? AppColorsDark.cancelledText : AppColors.cancelledText;
        break;
      default:
        bg = isDark ? AppColorsDark.primarySurface : AppColors.primarySurface;
        text = isDark ? AppColorsDark.textHint : AppColors.textHint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
