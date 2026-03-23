import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final bool isSecondary;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.isSecondary = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final onPrimary = isDark ? AppColorsDark.textOnPrimary : AppColors.textOnPrimary;
    final surf = isDark ? AppColorsDark.surfaceSecondary : AppColors.surface;
    final textCol = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 80),
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isSecondary ? surf : (widget.backgroundColor ?? primary),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: widget.isSecondary ? Border.all(color: (isDark ? AppColorsDark.border : AppColors.border), width: 0.5) : null,
          ),
          child: Center(
            child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.isSecondary ? primary : onPrimary,
                  ),
                )
              : Text(
                  widget.text,
                  style: AppTextStyles.buttonText.copyWith(
                    color: widget.isSecondary ? textCol : onPrimary,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
