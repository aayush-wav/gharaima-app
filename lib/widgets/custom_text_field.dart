import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../config/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              validator: validator,
              obscureText: isPassword,
              keyboardType: keyboardType,
              maxLines: maxLines,
              cursorColor: isDark ? AppColorsDark.primary : AppColors.primary,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColorsDark.textHint : AppColors.textHint,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: prefixIcon != null 
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: HugeIcon(
                        icon: prefixIcon!, 
                        color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                        size: 20,
                      ),
                    )
                  : null,
                filled: true,
                fillColor: (isDark ? AppColorsDark.glassFill : AppColors.glassFill),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(color: isDark ? AppColorsDark.borderStrong : AppColors.borderStrong, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(color: isDark ? AppColorsDark.error : AppColors.error, width: 1.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: BorderSide(color: isDark ? AppColorsDark.error : AppColors.error, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
