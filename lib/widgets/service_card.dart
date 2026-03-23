import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../config/theme.dart';
import '../utils/price_formatter.dart';
import 'star_rating.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  final bool showBookingButton;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.showBookingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.p16),
        padding: const EdgeInsets.all(AppTheme.p16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border),
          boxShadow: const [AppTheme.softShadow],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border.withOpacity(0.5)),
              ),
              child: const Center(
                child: Icon(Icons.image_rounded, color: AppTheme.textMuted, size: 32),
              ),
            ),
            const SizedBox(width: AppTheme.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service.name,
                    style: AppTheme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppTheme.p4),
                  if (service.description != null)
                    Text(
                      service.description!,
                      style: AppTheme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppTheme.p12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppTheme.textTheme.displaySmall?.copyWith(color: AppTheme.primary, fontSize: 16),
                          children: [
                            TextSpan(text: PriceFormatter.format(service.basePrice)),
                            TextSpan(
                              text: ' ${service.priceUnit}',
                              style: AppTheme.textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      if (showBookingButton)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [AppTheme.accentShadow.copyWith(offset: const Offset(0, 4), blurRadius: 10)],
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
