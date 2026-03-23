import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.p32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, size: 100, color: AppTheme.success),
                  ),
                ),
                const SizedBox(height: AppTheme.p32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text('Booking Placed!', style: AppTheme.textTheme.displayLarge),
                      const SizedBox(height: AppTheme.p12),
                      Text(
                        'Your service has been scheduled. A certified provider will be assigned to your request shortly.',
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 48),
                      _buildSummaryCard(),
                      const SizedBox(height: 48),
                      CustomButton(
                        text: 'Track My Booking',
                        onPressed: () => context.go('/bookings'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/home'),
                        style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
                        child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.p24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        children: [
          _buildRow('Status', 'Pending Assignment', isStatus: true),
          const SizedBox(height: 12),
          _buildRow('Payment', 'Secure Cash'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildRow('Ref Number', 'BK-HAMRO-8291', isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isStatus = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            fontSize: isBold ? 15 : 14,
            color: isStatus ? AppTheme.warning : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
