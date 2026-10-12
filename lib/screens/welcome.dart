// import 'dart:math' as math;

// import 'package:flutter/material.dart';

// import '../routes/app_routes.dart';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   State<WelcomePage> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // SIGN IN
//   // ============================================================

//   void _openLogin() {
//     Navigator.pushNamed(context, AppRoutes.login);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF020202),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final width = constraints.maxWidth;

//             if (width < 600) {
//               return _buildMobile();
//             }

//             if (width < 1000) {
//               return _buildTablet();
//             }

//             return _buildDesktop();
//           },
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // MOBILE
//   // ============================================================

//   Widget _buildMobile() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       color: const Color(0xFF020202),
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(22, 25, 22, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // LOGO ONLY
//                   _buildLogo(),

//                   const SizedBox(height: 45),

//                   _buildCategoryText(),

//                   const SizedBox(height: 40),

//                   _buildHeading(),

//                   const SizedBox(height: 35),

//                   Center(child: _buildAnimatedDiagram(size: 250)),

//                   const SizedBox(height: 35),

//                   _buildSignInButton(),

//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//           ),

//           _buildFooter(),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // TABLET
//   // ============================================================

//   Widget _buildTablet() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       color: const Color(0xFF020202),
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildLogo(),

//                   const SizedBox(height: 55),

//                   _buildCategoryText(),

//                   const SizedBox(height: 45),

//                   _buildHeading(),

//                   const SizedBox(height: 45),

//                   Center(child: _buildAnimatedDiagram(size: 320)),

//                   const SizedBox(height: 50),

//                   _buildSignInButton(),
//                 ],
//               ),
//             ),
//           ),

//           _buildFooter(),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // DESKTOP
//   // ============================================================

//   Widget _buildDesktop() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       color: const Color(0xFF020202),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 38),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLogo(),

//             const SizedBox(height: 35),

//             _buildCategoryText(),

//             const SizedBox(height: 30),

//             _buildHeading(),

//             const Spacer(),

//             Center(child: _buildAnimatedDiagram(size: 430)),

//             const Spacer(),

//             _buildSignInButton(),

//             const SizedBox(height: 30),

//             _buildFooter(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // LOGO - ONLY LOGO, NO STACKLY TEXT
//   // ============================================================

//   Widget _buildLogo() {
//     return Container(
//       width: 42,
//       height: 42,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF35C8FF), Color(0xFF2563EB)],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1677FF).withOpacity(0.25),
//             blurRadius: 18,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: const Icon(Icons.cloud_rounded, color: Colors.white, size: 25),
//     );
//   }

//   // ============================================================
//   // CATEGORY
//   // ============================================================

//   Widget _buildCategoryText() {
//     return const Text(
//       'CLOUD PLATFORM  ·  HRMS  ·  CRM  ·  ERP  ·  FINANCE  ·  AI',
//       style: TextStyle(
//         color: Color(0xFF747474),
//         fontSize: 8,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 1.1,
//       ),
//     );
//   }

//   // ============================================================
//   // HEADING
//   // ============================================================

//   Widget _buildHeading() {
//     return const Text(
//       'One identity.\nInfinite Potential.',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 28,
//         height: 1.15,
//         fontWeight: FontWeight.w600,
//         letterSpacing: -0.5,
//       ),
//     );
//   }

//   // ============================================================
//   // ANIMATED DIAGRAM
//   // ============================================================

//   Widget _buildAnimatedDiagram({required double size}) {
//     return SizedBox(
//       width: size,
//       height: size,
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           final pulse =
//               0.5 + math.sin(_animationController.value * math.pi * 2) * 0.5;

//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               // OUTER GLOW RING
//               Container(
//                 width: size * 0.66,
//                 height: size * 0.66,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Color.fromRGBO(38, 105, 255, 0.55 + (pulse * 0.25)),
//                     width: 1.2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color.fromRGBO(
//                         30,
//                         100,
//                         255,
//                         0.12 + (pulse * 0.18),
//                       ),
//                       blurRadius: 20 + (pulse * 12),
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//               ),

//               // ROTATING RING
//               Transform.rotate(
//                 angle: _animationController.value * math.pi * 2,
//                 child: Container(
//                   width: size * 0.75,
//                   height: size * 0.75,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: const Color(0xFF125EFF).withOpacity(0.18),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//               ),

//               // PEOPLE
//               Positioned(
//                 left: 0,
//                 top: size * 0.14,
//                 child: _buildInfoCard(
//                   icon: Icons.people_outline,
//                   title: 'People',
//                   subtitle: 'Manage users & teams',
//                   size: size,
//                 ),
//               ),

//               // APPLICATIONS
//               Positioned(
//                 right: 0,
//                 top: size * 0.14,
//                 child: _buildInfoCard(
//                   icon: Icons.apps_outlined,
//                   title: 'Applications',
//                   subtitle: 'Integrate & manage',
//                   size: size,
//                 ),
//               ),

//               // SECURITY
//               Positioned(
//                 left: 0,
//                 bottom: size * 0.14,
//                 child: _buildInfoCard(
//                   icon: Icons.shield_outlined,
//                   title: 'Security',
//                   subtitle: 'Protect every access',
//                   size: size,
//                 ),
//               ),

//               // ANALYTICS
//               Positioned(
//                 right: 0,
//                 bottom: size * 0.14,
//                 child: _buildInfoCard(
//                   icon: Icons.bar_chart_outlined,
//                   title: 'Analytics',
//                   subtitle: 'Turn data into insights',
//                   size: size,
//                 ),
//               ),

//               // CENTER OC
//               Container(
//                 width: size * 0.19,
//                 height: size * 0.19,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF101F55),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xFF276CFF), width: 1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF1666FF).withOpacity(0.45),
//                       blurRadius: 20,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     'OC',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: size * 0.052,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // ============================================================
//   // INFO CARD
//   // ============================================================

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required double size,
//   }) {
//     final cardWidth = size * 0.31;

//     return Container(
//       width: cardWidth,
//       padding: EdgeInsets.all(size * 0.025),
//       decoration: BoxDecoration(
//         color: const Color(0xFF080F27),
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(color: const Color(0xFF172E6D), width: 0.8),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF0C3BFF).withOpacity(0.08),
//             blurRadius: 12,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: size * 0.075,
//             height: size * 0.075,
//             decoration: BoxDecoration(
//               color: const Color(0xFF102C67),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF5791FF),
//               size: size * 0.045,
//             ),
//           ),

//           SizedBox(height: size * 0.018),

//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: size * 0.035,
//               fontWeight: FontWeight.w600,
//             ),
//           ),

//           const SizedBox(height: 2),

//           Text(
//             subtitle,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: const Color(0xFF777F96),
//               fontSize: size * 0.021,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SIGN IN BUTTON
//   // ============================================================

//   Widget _buildSignInButton() {
//     return Center(
//       child: SizedBox(
//         width: 130,
//         height: 38,
//         child: ElevatedButton(
//           onPressed: _openLogin,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2437D8),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           child: const Text(
//             'SIGN IN',
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.4,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // FOOTER
//   // ============================================================

//   Widget _buildFooter() {
//     return const Padding(
//       padding: EdgeInsets.only(left: 20, right: 20, bottom: 14, top: 8),
//       child: Row(
//         children: [
//           Text(
//             'Secure',
//             style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
//           ),
//           SizedBox(width: 18),
//           Text(
//             'Scalable',
//             style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
//           ),
//           SizedBox(width: 18),
//           Text(
//             'Future-Ready',
//             style: TextStyle(color: Color(0xFF5D6270), fontSize: 7),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color background = Color(0xFF02040A);
  static const Color blue = Color(0xFF087BFF);
  static const Color brightBlue = Color(0xFF00B7FF);
  static const Color cardColor = Color(0xFF07132D);

  void _openLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 950;
            final isMobile = constraints.maxWidth < 600;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 48,
                    vertical: isMobile ? 20 : 24,
                  ),
                  child: Column(
                    children: [
                      // STACKLY LOGO
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/stackly_logo.png',
                          width: isMobile ? 220 : 320,
                          height: isMobile ? 68 : 90,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'STACKLY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // PLATFORM LABELS
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CLOUD PLATFORM   ·   HRMS   ·   CRM   ·   ERP   ·   FINANCE   ·   AI',
                          style: TextStyle(
                            color: Color(0xFF8995AA),
                            fontSize: 11,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: isMobile ? 30 : 24),

                      // MAIN CONTENT
                      if (isDesktop)
                        _desktopContent(context, constraints.maxWidth)
                      else
                        _mobileContent(context, isMobile, constraints.maxWidth),

                      const SizedBox(height: 24),

                      // FOOTER
                      const Text(
                        '© 2026 STACKLY  ·  ONE PLATFORM. INFINITE POSSIBILITIES.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF596579),
                          fontSize: 10,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _desktopContent(BuildContext context, double screenWidth) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT HEADING
            SizedBox(
              width: screenWidth < 1200 ? 300 : 390,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'One identity.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Text(
                    'Infinite Potential.',
                    style: TextStyle(
                      color: brightBlue,
                      fontSize: 38,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'One intelligent platform to connect your people, '
                    'applications, security and business insights.',
                    style: TextStyle(
                      color: Color(0xFF9AA7BD),
                      fontSize: 14,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT ORBIT DIAGRAM
            Expanded(child: Center(child: _orbitDiagram())),
          ],
        ),

        const SizedBox(height: 12),

        // SIGN IN BUTTON
        Center(child: _signInButton(context)),
      ],
    );
  }

  Widget _mobileContent(
    BuildContext context,
    bool isMobile,
    double screenWidth,
  ) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'One identity.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'Infinite Potential.',
                style: TextStyle(
                  color: brightBlue,
                  fontSize: 30,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your people, apps and business insights — '
            'all connected in one place.',
            style: TextStyle(
              color: Color(0xFF9AA7BD),
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Scale diagram to fit mobile/tablet width.
        SizedBox(
          width: screenWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(width: 620, height: 430, child: _orbitDiagram()),
          ),
        ),

        const SizedBox(height: 8),

        _signInButton(context),
      ],
    );
  }

  Widget _orbitDiagram() {
    return SizedBox(
      width: 620,
      height: 430,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative blue glow
          Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: blue.withValues(alpha: 0.14),
                  blurRadius: 90,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),

          // Orbit rings
          Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: blue.withValues(alpha: 0.8),
                width: 1.3,
              ),
            ),
          ),

          Container(
            width: 390,
            height: 390,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: blue.withValues(alpha: 0.3), width: 1),
            ),
          ),

          // Animated orbit dot
          const _OrbitDot(),

          // CENTER STACKLY HUB
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: const Color(0xFF09265A),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: brightBlue, width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: blue.withValues(alpha: 0.45),
                  blurRadius: 35,
                  spreadRadius: 3,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // PEOPLE
          const Positioned(
            left: 25,
            top: 15,
            child: _FeatureCard(
              icon: Icons.people_alt_outlined,
              title: 'People',
              subtitle: 'Manage users & teams',
            ),
          ),

          // APPLICATIONS
          const Positioned(
            right: 25,
            top: 15,
            child: _FeatureCard(
              icon: Icons.grid_view_rounded,
              title: 'Applications',
              subtitle: 'Integrate & manage',
            ),
          ),

          // SECURITY
          const Positioned(
            left: 25,
            bottom: 15,
            child: _FeatureCard(
              icon: Icons.shield_outlined,
              title: 'Security',
              subtitle: 'Protect every access',
            ),
          ),

          // ANALYTICS
          const Positioned(
            right: 25,
            bottom: 15,
            child: _FeatureCard(
              icon: Icons.bar_chart_rounded,
              title: 'Analytics',
              subtitle: 'Turn data into insights',
            ),
          ),
        ],
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return SizedBox(
      width: 195,
      height: 54,
      child: ElevatedButton(
        onPressed: () => _openLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: blue.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF07132D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF0759D7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006EFF).withValues(alpha: 0.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0754C8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: const Color(0xFFBDE7FF), size: 24),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF9AA7BD), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _OrbitDot extends StatefulWidget {
  const _OrbitDot();

  @override
  State<_OrbitDot> createState() => _OrbitDotState();
}

class _OrbitDotState extends State<_OrbitDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * math.pi;

        return Transform.translate(
          offset: Offset(math.cos(angle) * 175, math.sin(angle) * 175),
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: const Color(0xFF00C8FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00A6FF).withValues(alpha: 0.9),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
