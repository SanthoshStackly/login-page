import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/service_data.dart';

class ServiceContent extends StatelessWidget {
  final ServiceData service;
  final String? focusedFeature;
  const ServiceContent({super.key, required this.service, this.focusedFeature});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        if (focusedFeature != null) ...[
          const SizedBox(height: 18),
          _FadeSlideIn(
            delayMs: 60,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: service.color.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt_rounded, color: service.color, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textInk,
                        ),
                        children: [
                          const TextSpan(text: 'Viewing '),
                          TextSpan(
                            text: focusedFeature,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: service.color,
                            ),
                          ),
                          const TextSpan(text: ' inside this module.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),
        Row(
          children: [
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const Spacer(),
            Text(
              'Everything included in this microservice module',
              style: TextStyle(fontSize: 11.5, color: AppColors.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 14),

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final tiles = service.features.asMap().entries.map((entry) {
              final isFocused =
                  focusedFeature != null && entry.value == focusedFeature;
              return _FadeSlideIn(
                delayMs: 60 * entry.key,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isFocused
                        ? service.color.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isFocused
                          ? service.color
                          : service.color.withOpacity(0.3),
                      width: isFocused ? 2 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isFocused
                            ? service.color.withOpacity(0.15)
                            : Colors.black.withOpacity(0.02),
                        blurRadius: isFocused ? 14 : 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: service.color.withOpacity(
                            isFocused ? 0.2 : 0.12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isFocused ? Icons.star_rounded : Icons.check_rounded,
                          color: service.color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.5,
                            fontWeight: isFocused
                                ? FontWeight.w700
                                : FontWeight.w500,
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
