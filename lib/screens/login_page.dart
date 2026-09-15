import 'package:flutter/material.dart';
import '../app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  late final AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final otp = _otpController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }
    if (otp.isEmpty || otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the 4-digit OTP')));
      return;
    }

    UserSession.email = email;
    UserSession.name = email.contains('@') ? email.split('@').first : email;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _handleForgotPassword() {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reset Password'),
          content: TextField(
            controller: resetEmailController,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              filled: true,
              fillColor: AppColors.surfaceGrey,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent to your email')));
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signing in with Google...')));
    UserSession.name = 'Google User';
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _handleAppleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signing in with Apple...')));
    UserSession.name = 'Apple User';
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 5, child: _buildLeftPanel()),
                Expanded(flex: 4, child: _buildRightPanel()),
              ],
            );
          }
          // Narrow screens (mobile): show only the login form
          return _buildRightPanel();
        },
      ),
    );
  }

  // ============== LEFT PANEL: Branding + Features + Preview ==============
  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDCEBFB), Color(0xFFEFF6FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Drifting cloud shapes for subtle animation
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final t = _cloudController.value;
              return Positioned(top: 60 + (t * 10), right: 40 - (t * 20), child: _cloudShape(70));
            },
          ),
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final t = _cloudController.value;
              return Positioned(top: 300 - (t * 15), right: 140 + (t * 15), child: _cloudShape(45));
            },
          ),
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              final t = _cloudController.value;
              return Positioned(bottom: 260 + (t * 12), right: 260 - (t * 10), child: _cloudShape(35));
            },
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(48, 40, 40, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/onecloud_logo.png', height: 34, fit: BoxFit.contain),
                const SizedBox(height: 48),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.darkNavy, height: 1.25),
                    children: [
                      TextSpan(text: 'Smart '),
                      TextSpan(text: 'Enterprise.\n', style: TextStyle(color: AppColors.primaryBlue)),
                      TextSpan(text: 'Stronger Operations.\n'),
                      TextSpan(text: 'Better Growth.'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Manage HRMS, CRM, ERP, Finance and your entire\nenterprise in one unified platform.',
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5),
                ),
                const SizedBox(height: 36),

                // 2x2 feature grid
                Row(
                  children: [
                    Expanded(child: _featureItem(Icons.groups_rounded, 'Manage Services', 'Organize all business modules.')),
                    const SizedBox(width: 24),
                    Expanded(child: _featureItem(Icons.trending_up_rounded, 'Track Projects', 'Plan and deliver on time.')),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: _featureItem(Icons.bolt_rounded, 'Automate Workflows', 'Improve productivity.')),
                    const SizedBox(width: 24),
                    Expanded(child: _featureItem(Icons.bar_chart_rounded, 'Powerful Reports', 'Real-time data insights.')),
                  ],
                ),
                const SizedBox(height: 40),

                _buildDashboardPreview(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cloudShape(double size) {
    return Icon(Icons.cloud_rounded, size: size, color: Colors.white.withOpacity(0.7));
  }

  Widget _featureItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
          child: Icon(icon, color: AppColors.primaryBlue, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.darkNavy)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11.5, color: AppColors.textGrey, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  // Mini dashboard preview mockup (decorative, built from scratch)
  Widget _buildDashboardPreview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.25))),
                )),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _previewStat('Revenue', '₹12.5M', Colors.green),
                    const SizedBox(width: 10),
                    _previewStat('Employees', '2,458', AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    _previewStat('Customers', '1,284', Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: 0.7, minHeight: 6, backgroundColor: AppColors.borderGrey, valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue)),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: 0.45, minHeight: 6, backgroundColor: AppColors.borderGrey, valueColor: const AlwaysStoppedAnimation(AppColors.lightBlue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)),
            Text(label, style: TextStyle(fontSize: 8.5, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  // ============== RIGHT PANEL: Login Form ==============
  Widget _buildRightPanel() {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _FadeSlideIn(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Welcome Back!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
                  const SizedBox(height: 8),
                  Text('Login to your OneCloud Enterprise account', textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: AppColors.textGrey)),
                  const SizedBox(height: 32),

                  const Text('Email', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration(hint: 'Enter your email', icon: Icons.person_outline),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      GestureDetector(
                        onTap: _handleForgotPassword,
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 12.5, color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _fieldDecoration(
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textGrey, size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('OTP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: _fieldDecoration(hint: 'Enter 4-digit OTP', icon: Icons.pin_outlined).copyWith(counterText: ''),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Remember me', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 22),

                  _HoverScale(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.borderGrey)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: AppColors.textGrey, fontSize: 12))),
                      Expanded(child: Divider(color: AppColors.borderGrey)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleGoogleSignIn,
                          icon: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
                          label: const Text('Google', style: TextStyle(color: AppColors.textDark)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: const BorderSide(color: AppColors.borderGrey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleAppleSignIn,
                          icon: const Icon(Icons.apple, size: 20, color: AppColors.textDark),
                          label: const Text('Apple', style: TextStyle(color: AppColors.textDark)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: const BorderSide(color: AppColors.borderGrey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New here? ", style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
                        child: const Text('Create Account', style: TextStyle(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text('© 2026 OneCloud Enterprise Platform. ', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      Text('Privacy Policy', style: TextStyle(fontSize: 11, color: AppColors.textGrey, decoration: TextDecoration.underline)),
                      Text('  |  ', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      Text('Terms of Service', style: TextStyle(fontSize: 11, color: AppColors.textGrey, decoration: TextDecoration.underline)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textGrey.withOpacity(0.7), fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceGrey,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderGrey)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}

class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  const _FadeSlideIn({required this.child});

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 450),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}