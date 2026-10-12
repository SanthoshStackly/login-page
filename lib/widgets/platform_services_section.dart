import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_theme.dart';
import '../models/service_data.dart';
import '../providers/dashboard_provider.dart';

class PlatformServicesSection extends ConsumerWidget {
  final String searchQuery;
  const PlatformServicesSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? kPlatformServices
        : kPlatformServices
              .where((s) => s.title.toLowerCase().contains(query))
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Services',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textInk,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Manage your domain microservices',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Matching Figma
            mainAxisExtent: 240,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final s = filtered[index];
            return GestureDetector(
              onTap: () =>
                  ref.read(dashboardProvider.notifier).selectService(s),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(s.icon, color: s.color, size: 24),
                    const SizedBox(height: 16),
                    Text(
                      s.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textInk,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...s.features
                        .take(4)
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• $f',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
