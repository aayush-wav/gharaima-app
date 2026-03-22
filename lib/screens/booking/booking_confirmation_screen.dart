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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(Icons.check_circle, size: 100, color: AppTheme.success),
              ),
              const SizedBox(height: AppTheme.p24),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text('Booking Confirmed!', style: AppTheme.textTheme.displayLarge),
                    const SizedBox(height: AppTheme.p12),
                    Text(
                      'Your service has been scheduled successfully. A provider will arrive at your location shortly.',
                      textAlign: TextAlign.center,
                      style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: AppTheme.p32),
                    _buildSummaryCard(),
                    const SizedBox(height: AppTheme.p32),
                    CustomButton(
                      text: 'View Booking',
                      onPressed: () {
                        // Navigate to bookings list for now
                        context.go('/bookings');
                      },
                    ),
                    const SizedBox(height: AppTheme.p12),
                    CustomButton(
                      text: 'Back to Home',
                      onPressed: () {
                        context.go('/home');
                      },
                      isSecondary: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.p16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          _buildRow('Status', 'Pending Confirmation', isStatus: true),
          _buildRow('Payment', 'Cash on completion'),
          const Divider(),
          _buildRow('Booking ID', 'BK-REF-82', isBold: true), // Placeholder for demo
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isStatus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isStatus ? Colors.orange : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
