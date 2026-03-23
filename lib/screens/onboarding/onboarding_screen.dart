import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../widgets/glass_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) context.go('/auth/phone');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _buildSlide(
                      0,
                      'Quality Services at Your Door',
                      'Book trusted professionals for your home in minutes with our premium concierge service.',
                    ),
                    _buildSlide(
                      1,
                      'Track in Real Time',
                      'Know exactly when your provider arrives with our precise live tracking and map system.',
                    ),
                    _buildSlide(
                      2,
                      'Pay Your Way',
                      'Choose from secure digital payments like eSewa and Khalti, or reliable cash on delivery.',
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: index == _currentPage 
                            ? (isDark ? AppColorsDark.primary : AppColors.primary)
                            : (isDark ? AppColorsDark.border : AppColors.border),
                        ),
                      )),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          _completeOnboarding();
                        }
                      },
                      child: Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_currentPage < 2)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text('Skip', style: AppTextStyles.labelLarge.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint)),
                      )
                    else
                      const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(int index, String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(index: index),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayLarge.copyWith(height: 1.1),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingIllustration extends StatefulWidget {
  final int index;
  const OnboardingIllustration({super.key, required this.index});

  @override
  State<OnboardingIllustration> createState() => _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<OnboardingIllustration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 0: return _buildSlide1();
      case 1: return _buildSlide2();
      case 2: return _buildSlide3();
      default: return const SizedBox();
    }
  }

  Widget _buildSlide1() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final surf = isDark ? AppColorsDark.primarySurface : AppColors.primarySurface;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: surf,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
        ),
        RotationTransition(
          turns: _controller,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(width: 160, height: 160),
              _buildFloatingBadge(HugeIcons.strokeRoundedSparkles, 10, -50, -50),
              _buildFloatingBadge(HugeIcons.strokeRoundedStar, 2, 50, -50),
              _buildFloatingBadge(HugeIcons.strokeRoundedCheckmarkCircle01, 6, 0, 70),
            ],
          ),
        ),
        GlassCard(
          borderRadius: 80,
          padding: const EdgeInsets.all(30),
          child: HugeIcon(icon: HugeIcons.strokeRoundedHome04, color: primary, size: 48),
        ),
      ],
    );
  }

  Widget _buildSlide2() {
    return _PingIllustration();
  }

  Widget _buildSlide3() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final surf = isDark ? AppColorsDark.primarySurface : AppColors.primarySurface;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(color: surf, shape: BoxShape.circle, border: Border.all(color: border)),
            ),
            Transform.translate(
              offset: const Offset(0, -10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(angle: -8 * pi / 180, child: _buildCard(const Color(0xFFD9C9A8))),
                  Transform.rotate(angle: -3 * pi / 180, child: _buildCard(surf, border: border)),
                  _buildCard(Colors.white.withOpacity(0.5), hasIcon: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallPill('Cash'),
            const SizedBox(width: 8),
            _buildSmallPill('eSewa'),
            const SizedBox(width: 8),
            _buildSmallPill('Khalti'),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingBadge(IconData icon, int position, double x, double y) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
        ),
        child: HugeIcon(icon: icon, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 16),
      ),
    );
  }

  Widget _buildCard(Color color, {bool hasIcon = false, Color? border}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: hasIcon ? Center(child: HugeIcon(icon: HugeIcons.strokeRoundedMoney01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 20)) : null,
    );
  }

  Widget _buildSmallPill(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
      ),
      child: Text(text, style: AppTextStyles.labelSmall.copyWith(fontSize: 9, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
    );
  }
}

class _PingIllustration extends StatefulWidget {
  @override
  State<_PingIllustration> createState() => _PingIllustrationState();
}

class _PingIllustrationState extends State<_PingIllustration> with TickerProviderStateMixin {
  late AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
            shape: BoxShape.circle,
            border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
          ),
          child: CustomPaint(painter: _GridPainter(isDark)),
        ),
        AnimatedBuilder(
          animation: _pingController,
          builder: (context, child) => Container(
            width: 80 * _pingController.value,
            height: 80 * _pingController.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary.withOpacity(1 - _pingController.value), width: 2),
            ),
          ),
        ),
        HugeIcon(icon: HugeIcons.strokeRoundedMapsLocation02, color: primary, size: 48),
        _buildAvatar(Offset(-50, 0), isDark),
        _buildAvatar(Offset(40, -40), isDark),
      ],
    );
  }

  Widget _buildAvatar(Offset offset, bool isDark) {
    return Transform.translate(
      offset: offset,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
        ),
        child: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary, size: 14),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  _GridPainter(this.isDark);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = (isDark ? Colors.white10 : Colors.black12)..strokeWidth = 1;
    for (double i = 0; i <= size.width; i += 16) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += 16) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
