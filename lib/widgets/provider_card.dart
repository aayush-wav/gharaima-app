import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../config/theme.dart';
import 'star_rating.dart';

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final VoidCallback onTap;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppTheme.p12),
        padding: const EdgeInsets.all(AppTheme.p12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.surface,
              child: const Icon(Icons.person, color: AppTheme.textSecondary), // TODO: Use provider.profilePhotoUrl
            ),
            const SizedBox(height: AppTheme.p8),
            Text(
              provider.fullName,
              style: AppTheme.textTheme.displaySmall?.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.p4),
            StarRating(rating: provider.rating),
            const SizedBox(height: AppTheme.p4),
            Text(
              '${provider.totalReviews} reviews',
              style: AppTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
