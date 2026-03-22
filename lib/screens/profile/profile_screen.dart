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
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.p24),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.surface,
                  child: Icon(Icons.person, size: 50, color: AppTheme.textSecondary),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(userProfile?.fullName ?? 'No Name', style: AppTheme.textTheme.displayMedium),
            Text(userProfile?.phone ?? '', style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            
            _buildMenuItem(context, Icons.event_note, 'My Bookings', () => context.go('/bookings')),
            _buildMenuItem(context, Icons.help_outline, 'Help & Support', () => _showComingSoon(context)),
            _buildMenuItem(context, Icons.info_outline, 'About', () => _showComingSoon(context, title: 'HamroSewa v1.0.0')),
            const Divider(),
            _buildMenuItem(context, Icons.logout, 'Logout', () => _logout(context, ref), isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppTheme.primary : AppTheme.textPrimary),
      title: Text(label, style: TextStyle(color: isDestructive ? AppTheme.primary : AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, {String title = 'Coming Soon'}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('This feature is currently in development.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
