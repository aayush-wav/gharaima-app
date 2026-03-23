import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_card.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    _nameController = TextEditingController(text: profile?.fullName);
    _addressController = TextEditingController(text: profile?.defaultAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ref.read(authServiceProvider).updateProfile(
          userId: user.id,
          fullName: _nameController.text,
          address: _addressController.text,
        );
        ref.invalidate(userProfileProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.error, content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                                child: HugeIcon(icon: HugeIcons.strokeRoundedUser01, color: primary, size: 40),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                                child: const HugeIcon(icon: HugeIcons.strokeRoundedCamera01, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      CustomTextField(
                        label: 'Full Name',
                        controller: _nameController,
                        prefixIcon: HugeIcons.strokeRoundedUserIdentityCard,
                        hintText: 'Your given names',
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      CustomTextField(
                        label: 'Default Address',
                        controller: _addressController,
                        prefixIcon: HugeIcons.strokeRoundedMapsLocation01,
                        maxLines: 3,
                        hintText: 'House No, Street...',
                      ),
                      const SizedBox(height: 60),
                      CustomButton(text: 'Commit Changes', onPressed: _onSave, isLoading: _isLoading),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 24),
            onPressed: () => context.pop(),
          ),
          Text('Edit Identity', style: AppTextStyles.headingMedium),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
