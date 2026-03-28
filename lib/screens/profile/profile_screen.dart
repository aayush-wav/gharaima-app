import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surfaceElevated : AppColors.surfaceElevated,
        title: Text('Logout Securely?', style: AppTextStyles.headingLarge),
        content: Text('Are you sure you want to log out of your Gharaima account?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No', style: AppTextStyles.labelLarge)),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: Text('Yes, Logout', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authServiceProvider).signOut();
      context.go('/auth/phone');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;
    final themeMode  = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Scaffold(
      body: OrbBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                            child: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: primary, size: 40),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userProfile?.fullName ?? 'Service Explorer',
                          style: AppTextStyles.displayMedium.copyWith(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                        ),
                        Text(
                          userProfile?.phone ?? 'Nepal',
                          style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Account settings', isDark),
                    const SizedBox(height: AppSpacing.md),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildMenuRow(HugeIcons.strokeRoundedPencilEdit01, 'Edit Profile', () => context.push('/profile/edit'), isDark),
                          _buildMenuRow(HugeIcons.strokeRoundedMapsLocation01, 'Saved Addresses', () {}, isDark),
                          _buildMenuRow(HugeIcons.strokeRoundedCreditCard, 'Payment Methods', () {}, isDark),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xxl),
                    _buildSectionTitle('Engagement', isDark),
                    const SizedBox(height: AppSpacing.md),
                    GlassCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildMenuRow(HugeIcons.strokeRoundedStar, 'Reviews & Ratings', () {}, isDark),
                          _buildMenuRow(HugeIcons.strokeRoundedShare01, 'Invite Friends', () {}, isDark),
                          _buildMenuRow(HugeIcons.strokeRoundedHelpCircle, 'Support Center', () {}, isDark),
                          _buildThemeRow(context, ref, themeMode, isDark),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xxxl),
                    InkWell(
                      onTap: () => _logout(context, ref),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HugeIcon(icon: HugeIcons.strokeRoundedLogout01, color: AppColors.error, size: 20),
                              const SizedBox(width: 12),
                              Text('Sign Out Securely', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Center(
                      child: Text('Version 3.0.0 (Concierge)', style: AppTextStyles.caption.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint)),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title.toUpperCase(), 
      style: AppTextStyles.overline.copyWith(
        color: isDark ? AppColorsDark.textHint : AppColors.textHint,
        letterSpacing: 2.0,
      )
    );
  }

  Widget _buildThemeRow(BuildContext context, WidgetRef ref, ThemeMode mode, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final textCol = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final hintCol = isDark ? AppColorsDark.textHint : AppColors.textHint;

    final (icon, label) = switch (mode) {
      ThemeMode.light  => (HugeIcons.strokeRoundedSun01,   'Light Mode'),
      ThemeMode.dark   => (HugeIcons.strokeRoundedMoon01,  'Dark Mode'),
      ThemeMode.system => (HugeIcons.strokeRoundedSmart,   'System Default'),
    };

    return InkWell(
      onTap: () => ref.read(themeModeProvider.notifier).toggle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: primary, size: 22),
            const SizedBox(width: 16),
            Text('Appearance', style: AppTextStyles.labelLarge.copyWith(color: textCol)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: primary, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String label, VoidCallback onTap, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final textCol = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: primary, size: 22),
            const SizedBox(width: 16),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: textCol)),
            const Spacer(),
            HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: isDark ? AppColorsDark.textHint : AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}
