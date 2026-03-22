import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/custom_button.dart';

class BookingSummaryScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingSummaryScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.p24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.p16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
                boxShadow: const [AppTheme.cardShadow],
              ),
              child: Column(
                children: [
                  _buildRow('Booking ID', booking.id.substring(0, 8).toUpperCase(), isBold: true),
                  _buildRow('Status', booking.status.toUpperCase(), isStatus: true),
                  const Divider(),
                  _buildRow('Service Date', DateFormatter.formatFullDate(booking.scheduledAt)),
                  _buildRow('Service Time', DateFormatter.formatTime(booking.scheduledAt)),
                  _buildRow('Location', booking.address),
                  _buildRow('Total Amount', PriceFormatter.format(booking.totalPrice ?? 0), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isStatus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isStatus ? Colors.orange : AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
