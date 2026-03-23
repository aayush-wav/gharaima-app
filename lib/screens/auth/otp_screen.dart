import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _timerSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) return;

    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyOTP(widget.phone, otp);
      
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final profile = await authService.getUserProfile(user.id);
        if (profile == null) {
          context.go('/auth/setup');
        } else {
          context.go('/home');
        }
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
    final maskedPhone = widget.phone.replaceRange(8, 11, '***');

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                IconButton(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary, size: 24),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text('Verification Code', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'We have sent a 6-digit verification code to $maskedPhone. Please enter it below.',
                  style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOTPBox(index, isDark)),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Verify Authenticity',
                  onPressed: _verifyOTP,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Did not receive code?', style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
                      TextButton(
                        onPressed: _timerSeconds == 0 ? _startTimer : null,
                        child: Text(
                          _timerSeconds == 0 ? 'Resend Now' : 'Resend in ${_timerSeconds}s',
                          style: AppTextStyles.labelLarge.copyWith(color: _timerSeconds == 0 ? (isDark ? AppColorsDark.primary : AppColors.primary) : (isDark ? AppColorsDark.textHint : AppColors.textHint)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final glassFill = isDark ? AppColorsDark.glassFill : AppColors.glassFill;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: glassFill,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: border, width: 0.5),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        cursorColor: primary,
        style: AppTextStyles.displayMedium.copyWith(fontSize: 22, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          if (index == 5 && value.isNotEmpty) {
            _verifyOTP();
          }
        },
        decoration: const InputDecoration(
          counterText: '',
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
