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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(Icons.home_repair_service_rounded, size: 64, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Gharaima App',
                  style: AppTheme.textTheme.displayLarge?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.p12),
                Text(
                  'Your companion for expert home services in Nepal.',
                  style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Entry Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56, // Match TextField height
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border, width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          '🇳🇵 +977',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                
                // Subtle attribution
                Text(
                  "By continuing, you agree to our Terms of Service.",
                  style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.p16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
