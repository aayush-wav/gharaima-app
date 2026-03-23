import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Logout', style: TextStyle(color: AppTheme.primary))),
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

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.primaryLight,
                        child: Icon(Icons.person_rounded, size: 40, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userProfile?.fullName ?? 'Service Explorer',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    ),
                    Text(
                      userProfile?.phone ?? 'Nepal',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account Management'),
                  const SizedBox(height: 12),
                  _buildProfileCard([
                    _buildMenuRow(Icons.person_outline_rounded, 'Edit Profile', () => context.push('/profile/edit')),
                    _buildMenuRow(Icons.location_on_outlined, 'Saved Addresses', () {}),
                    _buildMenuRow(Icons.payment_rounded, 'Payment Methods', () {}),
                  ]),
                  
                  const SizedBox(height: 28),
                  _buildSectionTitle('Engagement'),
                  const SizedBox(height: 12),
                  _buildProfileCard([
                    _buildMenuRow(Icons.star_outline_rounded, 'Reviews & Ratings', () {}),
                    _buildMenuRow(Icons.share_outlined, 'Invite Friends', () {}),
                    _buildMenuRow(Icons.help_outline_rounded, 'Support Center', () {}),
                  ]),
                  
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _logout(context, ref),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        foregroundColor: AppTheme.error,
                        backgroundColor: AppTheme.error.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Sign Out Securely', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('Version 2.4.0 (Gold)', style: AppTheme.textTheme.bodySmall),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.5));
  }

  Widget _buildProfileCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: AppTheme.textPrimary),
            ),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
