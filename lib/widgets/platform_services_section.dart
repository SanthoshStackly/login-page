import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../models/service_data.dart';
import '../providers/dashboard_provider.dart';

class PlatformServicesSection extends StatelessWidget {
  final String searchQuery;
  const PlatformServicesSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? kPlatformServices
        : kPlatformServices.where((s) {
            final inTitle = s.title.toLowerCase().contains(query);
            final inFeatures = s.features.any(
              (f) => f.toLowerCase().contains(query),
            );
            return inTitle || inFeatures;
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Domain Microservices Layer — each domain runs as one independent microservice',
          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
        ),
        const SizedBox(height: 18),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No services match "$searchQuery"',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 1;
              if (constraints.maxWidth > 1300) {
                columns = 4;
              } else if (constraints.maxWidth > 950) {
                columns = 3;
              } else if (constraints.maxWidth > 600) {
                columns = 2;
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 280,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final s = filtered[index];
                  return GestureDetector(
                    onTap: () =>
                        context.read<DashboardProvider>().selectService(s),
                    child: _ServiceCardAnimated(index: index, service: s),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

class _ServiceCardAnimated extends StatefulWidget {
  final int index;
  final ServiceData service;
  const _ServiceCardAnimated({required this.index, required this.service});

  @override
  State<_ServiceCardAnimated> createState() => _ServiceCardAnimatedState();
}

class _ServiceCardAnimatedState extends State<_ServiceCardAnimated> {
  bool _visible = false;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.06),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: s.color.withOpacity(_hovering ? 0.55 : 0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovering
                      ? s.color.withOpacity(0.18)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: _hovering ? 16 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: s.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(s.icon, color: s.color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: s.features.take(6).map((f) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: s.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: s.color.withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: s.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.storage_rounded, size: 14, color: s.color),
                    const SizedBox(width: 6),
                    Text(
                      s.db,
                      style: TextStyle(
                        fontSize: 11,
                        color: s.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
