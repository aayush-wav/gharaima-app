import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/categories_provider.dart';
import '../../providers/services_provider.dart';
import '../../widgets/service_card.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final int categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryDetail = ref.watch(categoryDetailProvider(categoryId));
    final services = ref.watch(servicesProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: categoryDetail.when(
          data: (data) => Text(data?.name ?? 'Category'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: categoryDetail.when(
        data: (category) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.p24),
              child: Text(
                category?.description ?? '',
                style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              ),
            ),
            Expanded(
              child: services.when(
                data: (data) => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }
}
