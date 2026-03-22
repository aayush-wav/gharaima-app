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
        padding: const EdgeInsets.all(AppTheme.p12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
          boxShadow: const [AppTheme.cardShadow],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined, color: AppTheme.textSecondary), // TODO: Use service.imageUrl
              ),
            ),
            const SizedBox(width: AppTheme.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: AppTheme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppTheme.p4),
                  if (service.description != null)
                    Text(
                      service.description!,
                      style: AppTheme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppTheme.p8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PriceFormatter.format(service.basePrice),
                            style: AppTheme.textTheme.displaySmall?.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            service.priceUnit,
                            style: AppTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      if (showBookingButton)
                        ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Book Now'),
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
