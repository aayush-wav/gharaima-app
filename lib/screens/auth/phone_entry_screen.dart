import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

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
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.p32, vertical: AppTheme.p16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  
                  // Brand Section
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(Icons.home_repair_service_rounded, size: 72, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Gharaima App',
                    style: AppTheme.textTheme.displayLarge?.copyWith(fontSize: 34, letterSpacing: -1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.p12),
                  Text(
                    'Expert home services, beautifully delivered at your doorstep.',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                  
                  // Entry Section (Animated separately if needed, but here simple fade)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '🇳🇵 +977',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.p12),
                      Expanded(
                        child: CustomTextField(
                          label: '',
                          hintText: '98XXXXXXXX',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.p24),
                  CustomButton(
                    text: 'Continue',
                    onPressed: _sendOTP,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppTheme.p12),
                  
                  // Demo Option
                  TextButton(
                    onPressed: () {
                      ref.read(guestModeProvider.notifier).state = true;
                      context.go('/home');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryLight.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Explore Demo Mode', style: AppTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primary)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.primary),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  Text(
                    "By continuing, you agree to our Terms of Service.",
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.p16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
