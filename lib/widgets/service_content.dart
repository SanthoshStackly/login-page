import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/service_data.dart';

// ------------------------------------------------------------
// ServiceContent - rich inline view shown when a sidebar service
// (HRM, CRM, etc.) is clicked. Shown inside the dashboard's
// scrollable content area - NOT a separate page.
// ------------------------------------------------------------

class ServiceContent extends StatelessWidget {
  final ServiceData service;
  const ServiceContent({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero banner with gradient using the service's own color
        _FadeSlideIn(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [service.color, service.color.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: service.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(service.icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.storage_rounded,
                            size: 14,
                            color: Colors.white.withOpacity(0.85),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            service.db,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: Colors.white.withOpacity(0.85),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${service.features.length} features',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
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
        ),
        const SizedBox(height: 24),

        // Quick stat chips row
        _FadeSlideIn(
          delayMs: 80,
          child: Row(
            children: [
              _miniStat(
                'Status',
                'Active',
                Icons.check_circle_rounded,
                Colors.green,
              ),
              const SizedBox(width: 12),
              _miniStat('Version', 'v1.0', Icons.tag_rounded, service.color),
              const SizedBox(width: 12),
              _miniStat('Uptime', '99.9%', Icons.bolt_rounded, Colors.orange),
            ],
          ),
        ),
        const SizedBox(height: 26),

        Text(
          'Features',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Everything included in this microservice module',
          style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
        ),
        const SizedBox(height: 14),

        // Feature grid (2 columns on wide screens)
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final tiles = service.features.asMap().entries.map((entry) {
              return _FadeSlideIn(
                delayMs: 60 * entry.key,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: service.color.withOpacity(0.3),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: service.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: service.color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();

            if (!isWide) {
              return Column(
                children: tiles
                    .map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: t,
                      ),
                    )
                    .toList(),
              );
            }
            // 2-column wrap layout
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tiles
                  .map(
                    (t) => SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: t,
                    ),
                  )
                  .toList(),
            );
          },
        ),

        const SizedBox(height: 22),
        _FadeSlideIn(
          delayMs: 500,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This module is part of the POC. Full functionality will be connected once the backend microservice is ready.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10.5, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _FadeSlideIn({required this.child, this.delayMs = 0});

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 350),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
