import 'package:flutter/material.dart';
import '../../config/theme.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exclusive Offers'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.p24),
        children: [
          _buildOfferCard(
            'SUMMER25',
            'Get 25% off on all AC services',
            'Valid until Aug 31',
            const Color(0xFF6366F1),
          ),
          const SizedBox(height: AppTheme.p20),
          _buildOfferCard(
            'FIRST500',
            'Rs. 500 cashback on first booking',
            'New users only',
            const Color(0xFFC084FC),
          ),
          const SizedBox(height: AppTheme.p20),
          _buildOfferCard(
            'CLEANUP',
            'Flat 15% off on Deep Cleaning',
            'Limited time offer',
            const Color(0xFF2DD4BF),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String code, String desc, String validity, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.p24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'COUPON',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PROMO CODE', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(code, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'COPY',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(validity, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }
}
