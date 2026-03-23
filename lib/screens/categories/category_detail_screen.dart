import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/categories_provider.dart';
import '../../providers/services_provider.dart';
import '../../widgets/service_card.dart';
import '../../widgets/glass_card.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final int categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryDetail = ref.watch(categoryDetailProvider(categoryId));
    final services = ref.watch(servicesProvider(categoryId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, categoryDetail),
              _buildFilterBar(isDark),
              Expanded(
                child: services.when(
                  data: (data) => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    itemCount: data.length,
                    itemBuilder: (context, index) => ServiceCard(
                      service: data[index],
                      onTap: () => context.go('/home/services/${data[index].id}'),
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AsyncValue categoryDetail) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 24),
            onPressed: () => context.pop(),
          ),
          categoryDetail.when(
            data: (data) => Text(data?.name ?? 'Category', style: AppTextStyles.headingMedium),
            loading: () => Text('Loading...', style: AppTextStyles.headingMedium),
            error: (_, __) => Text('Category', style: AppTextStyles.headingMedium),
          ),
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedFilter, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          _buildChip('Recommended', true, isDark),
          _buildChip('Price: Low to High', false, isDark),
          _buildChip('Premium Tier', false, isDark),
          _buildChip('Fastest', false, isDark),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        borderRadius: AppRadius.pill,
        child: Text(
          label, 
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? primary : (isDark ? AppColorsDark.textHint : AppColors.textHint),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          )
        ),
      ),
    );
  }
}
