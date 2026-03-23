import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_card.dart';

class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final phone = '+977${_phoneController.text}';
      await ref.read(authServiceProvider).signInWithOtp(phone);
      context.push('/auth/otp', extra: phone);
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
                  const Spacer(flex: 3),
                  
                  // Elegant Brand Presence
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColorsDark.primary : AppColors.primary).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedHome04, 
                        size: 64, 
                        color: isDark ? AppColorsDark.primary : AppColors.primary
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Gharaima App',
                    style: AppTextStyles.displayLarge.copyWith(fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expert home services, beautifully delivered at your doorstep.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Phone Entry Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 58,
                        width: 70,
                        decoration: BoxDecoration(
                          color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            '+977',
                            style: AppTextStyles.labelLarge.copyWith(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: CustomTextField(
                          label: 'Phone number',
                          hintText: '98XXXXXXXX',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                          prefixIcon: HugeIcons.strokeRoundedSmartphone01,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CustomButton(
                    text: 'Continue',
                    onPressed: _sendOTP,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Luxury Demo Hub
                  TextButton(
                    onPressed: () {
                      ref.read(guestModeProvider.notifier).state = true;
                      context.go('/home');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: (isDark ? AppColorsDark.primary : AppColors.primary).withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Explore Demo Mode', style: AppTextStyles.labelLarge.copyWith(color: isDark ? AppColorsDark.primary : AppColors.primary)),
                        const SizedBox(width: 8),
                        HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  Text(
                    "By continuing, you secure your commitment to our luxury standards.",
                    style: AppTextStyles.caption.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
