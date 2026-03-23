import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_card.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _onComplete() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final newUser = UserModel(
          id: user.id,
          phone: user.phone ?? '',
          fullName: _nameController.text,
          createdAt: DateTime.now(),
        );
        await ref.read(authServiceProvider).createUserProfile(newUser);
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.error, content: Text('Error: ${e.toString()}')),
      );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Text('Complete Identity', style: AppTextStyles.displayMedium),
                  const SizedBox(height: 8),
                  Text('Tell us how we should address you for our luxury concierge services.', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
                  const SizedBox(height: 60),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                            child: HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, color: primary, size: 48),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Media selection integrated.')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                              child: const HugeIcon(icon: HugeIcons.strokeRoundedCamera01, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    label: 'Full Name',
                    hintText: 'Enter your given names',
                    controller: _nameController,
                    validator: (val) => val == null || val.isEmpty ? 'Commit your name for identification' : null,
                    prefixIcon: HugeIcons.strokeRoundedPassport,
                  ),
                  const SizedBox(height: 48),
                  CustomButton(
                    text: 'Complete Registry',
                    onPressed: _onComplete,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
