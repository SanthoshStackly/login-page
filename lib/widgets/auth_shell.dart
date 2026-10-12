import 'package:flutter/material.dart';

import '../app_theme.dart';

// ------------------------------------------------------------
// AuthShell - common layout for Sign-in and Sign-up.
//   Wide screens  (>= 900px): dark brand panel on the left + form on the right
//   Mobile screens (< 900px): brand panel hidden, compact logo on top of the form
// ------------------------------------------------------------

const Color _kBlue = Color(0xFF2F6FE0);
const Color _kBlueLight = Color(0xFF6EA8FF);

class AuthShell extends StatelessWidget {
  final Widget child;
  final double maxFormWidth;
  const AuthShell({super.key, required this.child, this.maxFormWidth = 400});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final form = _FormPanel(
            maxWidth: maxFormWidth,
            showMobileBrand: !wide,
            child: child,
          );
          if (!wide) {
            return SafeArea(child: form);
          }
          return Row(
            children: [
              const Expanded(flex: 11, child: AuthBrandPanel()),
              Expanded(flex: 9, child: form),
            ],
          );
        },
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool showMobileBrand;
  const _FormPanel({
    required this.child,
    required this.maxWidth,
    required this.showMobileBrand,
  });

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        showMobileBrand ? 22 : 40,
        showMobileBrand ? 16 : 28,
        showMobileBrand ? 22 : 40,
        28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: child,
          ),
        ),
      ),
    );

    if (!showMobileBrand) {
      // Desktop: no logo needed here (already shown on the left brand panel).
      return Container(color: Colors.white, child: content);
    }

    // Mobile: logo stays fixed at the top; only the form below scrolls.
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 18, 22, 12),
              child: _MobileBrand(),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _MobileBrand extends StatefulWidget {
  const _MobileBrand();

  @override
  State<_MobileBrand> createState() => _MobileBrandState();
}

class _MobileBrandState extends State<_MobileBrand> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(-0.06, 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.tealData, _kBlue],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cloud_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'OneCloud',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============== LEFT BRAND PANEL ==============
class AuthBrandPanel extends StatelessWidget {
  const AuthBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF04050D), Color(0xFF0A0E2A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(44, 36, 44, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.tealData, _kBlue],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.cloud_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'ONECLOUD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'CLOUD PLATFORM  ·  HRMS  ·  CRM  ·  ERP  ·  FINANCE  ·  AI',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 9.5,
                          letterSpacing: 1.2,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.15,
                          ),
                          children: [
                            TextSpan(text: 'One identity.\n'),
                            TextSpan(
                              text: 'Infinite',
                              style: TextStyle(color: _kBlue),
                            ),
                            TextSpan(text: ' Potential.'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: const BrandRingDiagram(),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: 28, height: 2, color: _kBlue),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 18,
                                  children: [
                                    _footText('Secure'),
                                    _footText('Scalable'),
                                    _footText('Future-Ready'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'BUILT FOR\nA BRIGHTER\nTOMORROW',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 8.5,
                              height: 1.5,
                              letterSpacing: 1,
                              fontFamily: 'monospace',
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
        },
      ),
    );
  }

  Widget _footText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 9.5,
        fontFamily: 'monospace',
      ),
    );
  }
}

// ============== GLOWING RING + 4 CARDS (public, reusable) ==============
// Self-contained - owns its own pulse animation, so it can be dropped into
// any screen (the Sign-in brand panel, or the standalone Landing page).
class BrandRingDiagram extends StatefulWidget {
  const BrandRingDiagram({super.key});

  @override
  State<BrandRingDiagram> createState() => _BrandRingDiagramState();
}

class _BrandRingDiagramState extends State<BrandRingDiagram>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _RingDiagram(pulse: _pulse);
}

class _RingDiagram extends StatelessWidget {
  final Animation<double> pulse;
  const _RingDiagram({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 380,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RingPainter())),
          const Positioned(
            left: 22,
            top: 66,
            child: _GlassCard(
              icon: Icons.groups_rounded,
              title: 'People',
              subtitle: 'Manage users & teams',
            ),
          ),
          const Positioned(
            left: 218,
            top: 66,
            child: _GlassCard(
              icon: Icons.inventory_2_outlined,
              title: 'Applications',
              subtitle: 'Integrate & manage',
            ),
          ),
          const Positioned(
            left: 22,
            top: 222,
            child: _GlassCard(
              icon: Icons.shield_outlined,
              title: 'Security',
              subtitle: 'Protect every access',
            ),
          ),
          const Positioned(
            left: 218,
            top: 222,
            child: _GlassCard(
              icon: Icons.bar_chart_rounded,
              title: 'Analytics',
              subtitle: 'Turn data into insights',
            ),
          ),
          Positioned(
            left: 156,
            top: 156,
            child: AnimatedBuilder(
              animation: pulse,
              builder: (context, _) {
                final glow = 0.35 + (pulse.value * 0.35);
                return Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1030),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _kBlue.withOpacity(0.7)),
                    boxShadow: [
                      BoxShadow(
                        color: _kBlue.withOpacity(glow),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    'OC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _GlassCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1533).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withOpacity(0.35)),
        boxShadow: [BoxShadow(color: _kBlue.withOpacity(0.18), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 13, color: _kBlueLight),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 150.0;

    // connecting lines from the centre tile to each card
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.14)
      ..strokeWidth = 1;
    for (final target in const [
      Offset(92, 112),
      Offset(288, 112),
      Offset(92, 268),
      Offset(288, 268),
    ]) {
      canvas.drawLine(center, target, linePaint);
    }

    // outer glow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _kBlue.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    // mid ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _kBlue.withOpacity(0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    // crisp inner line
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _kBlueLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
