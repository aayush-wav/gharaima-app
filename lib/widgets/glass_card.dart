import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final EdgeInsets? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppRadius.md,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassFill = isDark ? AppColorsDark.glassFill : AppColors.glassFill;
    final glassBorder = isDark ? AppColorsDark.glassBorder : AppColors.glassBorder;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppColors.glassBlur, sigmaY: AppColors.glassBlur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: glassFill,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: glassBorder, width: 0.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassBottomSheet extends StatelessWidget {
  final Widget child;

  const GlassBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassFill = isDark ? AppColorsDark.glassFill : AppColors.glassFill;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppColors.glassBlur, sigmaY: AppColors.glassBlur),
        child: Container(
          decoration: BoxDecoration(
            color: glassFill,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: (isDark ? AppColorsDark.textHint : AppColors.textHint).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class OrbBackground extends StatefulWidget {
  final Widget child;

  const OrbBackground({super.key, required this.child});

  @override
  State<OrbBackground> createState() => _OrbBackgroundState();
}

class _OrbBackgroundState extends State<OrbBackground> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = [
      AnimationController(vsync: this, duration: const Duration(seconds: 10)),
      AnimationController(vsync: this, duration: const Duration(seconds: 13)),
      AnimationController(vsync: this, duration: const Duration(seconds: 8)),
    ];

    _animations = _controllers.map((c) {
      c.repeat(reverse: true);
      return Tween<Offset>(
        begin: const Offset(-0.05, -0.04),
        end: const Offset(0.05, 0.04),
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orb1 = isDark ? AppColorsDark.orbColor1 : AppColors.orbColor1;
    final orb2 = isDark ? AppColorsDark.orbColor2 : AppColors.orbColor2;
    final orb3 = isDark ? AppColorsDark.orbColor3 : AppColors.orbColor3;

    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: SlideTransition(
            position: _animations[0],
            child: _Orb(color: orb1, size: 220),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: SlideTransition(
            position: _animations[1],
            child: _Orb(color: orb2, size: 180),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: MediaQuery.of(context).size.width * 0.45,
          child: SlideTransition(
            position: _animations[2],
            child: _Orb(color: orb3, size: 140),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;

  const _Orb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
