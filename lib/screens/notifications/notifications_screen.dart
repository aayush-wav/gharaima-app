import 'package:flutter/material.dart';
import '../../config/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.p24),
        children: [
          _buildNotification(
            'Booking Confirmed',
            'Your plumbing service is confirmed for tomorrow 10:00 AM.',
            '2 mins ago',
            Icons.check_circle_rounded,
            AppTheme.success,
          ),
          const SizedBox(height: 16),
          _buildNotification(
            'New Offer!',
            'Get 20% off on your next Salon service. Valid till June.',
            '1 hour ago',
            Icons.local_offer_rounded,
            AppTheme.primary,
          ),
          const SizedBox(height: 16),
          _buildNotification(
            'Payment Received',
            'Payment of Rs. 1500 for Deep Cleaning was successful.',
            'Yesterday',
            Icons.account_balance_wallet_rounded,
            AppTheme.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildNotification(String title, String body, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTheme.textTheme.displaySmall?.copyWith(fontSize: 15)),
                    Text(time, style: AppTheme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(height: 1.4, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
