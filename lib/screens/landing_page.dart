import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

// ------------------------------------------------------------
// LandingPage - first screen shown before Sign In.
// Fully responsive (mobile / tablet / desktop breakpoints).
// Desktop layout is wrapped in a scroll view with fixed spacing
// (instead of Spacer) so it never overflows on short windows.
// ------------------------------------------------------------

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // GO TO LOGIN
  // ============================================================

  void _openLogin() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // MOBILE
            if (width < 600) {
              return _buildMobile();
            }

            // TABLET
            if (width < 1000) {
              return _buildTablet();
            }

            // DESKTOP
            return _buildDesktop();
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOGO (icon + wordmark) - shown at the top on every breakpoint
  // ============================================================

  Widget _buildLogo({double iconSize = 30, double fontSize = 16}) {
    // Logo height is driven off fontSize so it scales the same way
    // across mobile / tablet / desktop as the old text-based version did.
    final logoHeight = fontSize * 1.7;
    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/stackly_logo.png',
        height: logoHeight,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobile() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color(0xFF020202)),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(iconSize: 26, fontSize: 14),

                  const SizedBox(height: 22),

                  _buildCategoryText(),

                  const SizedBox(height: 38),

                  _buildHeading(),

                  const SizedBox(height: 35),

                  Center(child: _buildAnimatedDiagram(size: 250)),

                  const SizedBox(height: 35),

                  _buildSignInButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _buildTablet() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFF020202)),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(iconSize: 30, fontSize: 16),

                  const SizedBox(height: 26),

                  _buildCategoryText(),

                  const SizedBox(height: 45),

                  _buildHeading(),

                  const SizedBox(height: 45),

                  Center(child: _buildAnimatedDiagram(size: 320)),

                  const SizedBox(height: 50),

                  _buildSignInButton(),
                ],
              ),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // Wrapped in a scroll view with a min-height constraint instead
  // of Spacer(), so it can never overflow on short windows - it
  // simply scrolls if the viewport is too short, same as mobile/tablet.
  // ============================================================

  Widget _buildDesktop() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020202), Color(0xFF050505), Color(0xFF0B0B0B)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 45),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 90, // minus vertical padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo(iconSize: 34, fontSize: 18),
                      const SizedBox(height: 28),
                      _buildCategoryText(),
                      const SizedBox(height: 40),
                      _buildHeading(),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: _buildAnimatedDiagram(size: 430)),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSignInButton(),
                      const SizedBox(height: 30),
                      _buildFooter(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // CATEGORY TEXT
  // ============================================================

  Widget _buildCategoryText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'CLOUD PLATFORM  ·  HRMS  ·  CRM  ·  ERP  ·  FINANCE  ·  AI',
        style: TextStyle(
          color: Color(0xFF747474),
          fontSize: 8,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // ============================================================
  // HEADING
  // ============================================================

  Widget _buildHeading() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'One identity.\nInfinite Potential.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATED DIAGRAM
  // ============================================================

  Widget _buildAnimatedDiagram({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final pulse =
              0.5 + (math.sin(_animationController.value * math.pi * 2) * 0.5);

          return Stack(
            alignment: Alignment.center,
            children: [
              // OUTER RING
              Container(
                width: size * 0.66,
                height: size * 0.66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromRGBO(38, 105, 255, 0.65 + (pulse * 0.25)),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(
                        30,
                        100,
                        255,
                        0.12 + (pulse * 0.18),
                      ),
                      blurRadius: 20 + (pulse * 12),
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // ROTATING RING
              Transform.rotate(
                angle: _animationController.value * math.pi * 2,
                child: Container(
                  width: size * 0.75,
                  height: size * 0.75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF125EFF).withOpacity(0.18),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // TOP LEFT
              Positioned(
                left: 0,
                top: size * 0.14,
                child: _buildInfoCard(
                  icon: Icons.people_outline,
                  title: 'People',
                  subtitle: 'Manage users & teams',
                  size: size,
                ),
              ),

              // TOP RIGHT
              Positioned(
                right: 0,
                top: size * 0.14,
                child: _buildInfoCard(
                  icon: Icons.apps_outlined,
                  title: 'Applications',
                  subtitle: 'Integrate & manage',
                  size: size,
                ),
              ),

              // BOTTOM LEFT
              Positioned(
                left: 0,
                bottom: size * 0.14,
                child: _buildInfoCard(
                  icon: Icons.shield_outlined,
                  title: 'Security',
                  subtitle: 'Protect every access',
                  size: size,
                ),
              ),

              // BOTTOM RIGHT
              Positioned(
                right: 0,
                bottom: size * 0.14,
                child: _buildInfoCard(
                  icon: Icons.bar_chart_outlined,
                  title: 'Analytics',
                  subtitle: 'Turn data into insights',
                  size: size,
                ),
              ),

              // CENTER
              Container(
                width: size * 0.19,
                height: size * 0.19,
                decoration: BoxDecoration(
                  color: const Color(0xFF101F55),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF276CFF), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1666FF).withOpacity(0.45),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'OC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.052,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double size,
  }) {
    final cardWidth = size * 0.31;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(size * 0.025),
      decoration: BoxDecoration(
        color: const Color(0xFF080F27),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFF172E6D), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C3BFF).withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size * 0.075,
            height: size * 0.075,
            decoration: BoxDecoration(
              color: const Color(0xFF102C67),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5791FF),
              size: size * 0.045,
            ),
          ),

          SizedBox(height: size * 0.018),

          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF777F96),
              fontSize: size * 0.021,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIGN IN BUTTON
  // ============================================================

  Widget _buildSignInButton() {
    return Column(
      children: [
        const Text(
          'One connected platform for your enterprise.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8A8F9C),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: SizedBox(
            width: 150,
            height: 42,
            child: ElevatedButton(
              onPressed: _openLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2437D8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 14, top: 8),
      child: Row(
        children: [
          Text(
            'Secure',
            style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
          ),

          SizedBox(width: 18),

          Text(
            'Scalable',
            style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
          ),

          SizedBox(width: 18),

          Text(
            'Future-Ready',
            style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
          ),
        ],
      ),
    );
  }
}
