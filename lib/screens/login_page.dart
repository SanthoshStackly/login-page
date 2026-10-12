// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../app_theme.dart';
// import '../widgets/auth_shell.dart';
// import '../widgets/auth_widgets.dart';

// // ------------------------------------------------------------
// // Sign-in screen (single page, no separate OTP page).
// //   signIn     : email + password, then "Send OTP" reveals the OTP boxes
// //                inline on the SAME page, then "Verify and sign in"
// //   forgot     : password recovery
// //   checkEmail : reset link sent
// //   locked     : too many wrong attempts (15 min countdown)
// //   success    : "You're in" -> redirects to the dashboard
// //
// // DEMO RULES (no backend yet):
// //   * password with 6+ characters = correct, shorter = wrong attempt
// //   * 3 wrong attempts -> account locked
// //   * any 6 digits = valid OTP
// // ------------------------------------------------------------

// enum _View { signIn, forgot, checkEmail, locked, success }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   static const int _maxAttempts = 3;

//   _View _view = _View.signIn;

//   final TextEditingController _emailC = TextEditingController();
//   final TextEditingController _passC = TextEditingController();
//   final TextEditingController _resetEmailC = TextEditingController();
//   final List<TextEditingController> _otpC = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> _otpF = List.generate(6, (_) => FocusNode());

//   bool _obscure = true;
//   bool _remember = false;
//   bool _otpSent = false;
//   bool _locked = false;
//   int _failedAttempts = 0;

//   Timer? _otpTimer;
//   int _otpSeconds = 300;
//   Timer? _lockTimer;
//   int _lockSeconds = 900;
//   Timer? _redirectTimer;

//   @override
//   void dispose() {
//     _emailC.dispose();
//     _passC.dispose();
//     _resetEmailC.dispose();
//     for (final c in _otpC) {
//       c.dispose();
//     }
//     for (final f in _otpF) {
//       f.dispose();
//     }
//     _otpTimer?.cancel();
//     _lockTimer?.cancel();
//     _redirectTimer?.cancel();
//     super.dispose();
//   }

//   // ---------------- helpers ----------------
//   String _fmt(int seconds) {
//     final m = (seconds ~/ 60).toString().padLeft(2, '0');
//     final s = (seconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   void _snack(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void _go(_View view) => setState(() => _view = view);

//   void _startOtpTimer() {
//     _otpTimer?.cancel();
//     _otpSeconds = 300;
//     _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) return;
//       setState(() {
//         if (_otpSeconds > 0) _otpSeconds--;
//       });
//     });
//   }

//   void _startLockTimer() {
//     _lockTimer?.cancel();
//     _lockSeconds = 900;
//     _lockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) return;
//       if (_lockSeconds <= 1) {
//         t.cancel();
//         setState(() {
//           _locked = false;
//           _failedAttempts = 0;
//           _view = _View.signIn;
//         });
//         _snack('Your account is unlocked. You can sign in again.');
//         return;
//       }
//       setState(() => _lockSeconds--);
//     });
//   }

//   void _redirectToDashboard(String name, String email) {
//     UserSession.name = name;
//     UserSession.email = email;
//     setState(() => _view = _View.success);
//     _redirectTimer?.cancel();
//     _redirectTimer = Timer(const Duration(milliseconds: 1600), () {
//       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//     });
//   }

//   // ---------------- actions ----------------
//   void _handleSendOtp() {
//     final email = _emailC.text.trim();
//     final password = _passC.text;

//     if (_locked) {
//       _go(_View.locked);
//       return;
//     }
//     if (email.isEmpty || !email.contains('@')) {
//       _snack('Please enter a valid work email');
//       return;
//     }
//     if (password.isEmpty) {
//       _snack('Please enter your password');
//       return;
//     }

//     // demo rule: password shorter than 6 characters = wrong password
//     if (password.length < 6) {
//       setState(() => _failedAttempts++);
//       if (_failedAttempts >= _maxAttempts) {
//         setState(() {
//           _locked = true;
//           _view = _View.locked;
//         });
//         _startLockTimer();
//       }
//       return;
//     }

//     setState(() {
//       _failedAttempts = 0;
//       _otpSent = true;
//     });
//     _startOtpTimer();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _otpF[0].requestFocus();
//     });
//   }

//   void _handleVerify() {
//     final code = _otpC.map((c) => c.text).join();
//     if (code.length < 6) {
//       _snack('Please enter the full 6-digit code');
//       return;
//     }
//     final email = _emailC.text.trim();
//     _redirectToDashboard(
//       email.contains('@') ? email.split('@').first : email,
//       email,
//     );
//   }

//   void _resendOtp() {
//     for (final c in _otpC) {
//       c.clear();
//     }
//     _startOtpTimer();
//     _otpF[0].requestFocus();
//     _snack('A new code has been sent');
//   }

//   void _sendResetLink() {
//     final email = _resetEmailC.text.trim();
//     if (email.isEmpty || !email.contains('@')) {
//       _snack('Please enter a valid work email');
//       return;
//     }
//     // resetting the password gives immediate access back
//     _lockTimer?.cancel();
//     setState(() {
//       _locked = false;
//       _failedAttempts = 0;
//       _view = _View.checkEmail;
//     });
//   }

//   void _ssoSignIn(String provider) {
//     _redirectToDashboard(
//       '$provider User',
//       '${provider.toLowerCase()}-user@onecloud.io',
//     );
//   }

//   // ---------------- build ----------------
//   @override
//   Widget build(BuildContext context) {
//     return AuthShell(child: _buildView());
//   }

//   Widget _buildView() {
//     switch (_view) {
//       case _View.signIn:
//         return _signInView();
//       case _View.forgot:
//         return _forgotView();
//       case _View.checkEmail:
//         return _checkEmailView();
//       case _View.locked:
//         return _lockedView();
//       case _View.success:
//         return _successView();
//     }
//   }

//   // ---------------- Sign in (email + password + inline OTP) ----------------
//   Widget _signInView() {
//     final remaining = _maxAttempts - _failedAttempts;
//     return Column(
//       key: const ValueKey('signIn'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const AuthStepLabel('SECURE ACCESS'),
//         const SizedBox(height: 8),
//         const AuthTitle('Sign in'),
//         const SizedBox(height: 6),
//         const AuthSubtitle(
//           'Enter your work email and password, then verify with a one-time code.',
//         ),
//         const SizedBox(height: 24),

//         if (_failedAttempts > 0) ...[
//           AuthBanner(
//             icon: Icons.error_outline_rounded,
//             title: 'Incorrect email or password',
//             message:
//                 'You have $remaining ${remaining == 1 ? 'attempt' : 'attempts'} remaining before this account is temporarily locked.',
//             color: AppColors.danger,
//           ),
//           const SizedBox(height: 16),
//         ],

//         AuthField(
//           label: 'Work email',
//           controller: _emailC,
//           hint: 'you@company.com',
//           keyboardType: TextInputType.emailAddress,
//           error: _failedAttempts > 0,
//           readOnly: _otpSent,
//         ),
//         const SizedBox(height: 16),
//         AuthField(
//           label: 'Password',
//           controller: _passC,
//           hint: 'Enter your password',
//           obscure: _obscure,
//           error: _failedAttempts > 0,
//           readOnly: _otpSent,
//           trailingLabel: AuthLinkText(
//             'Forgot password?',
//             onTap: () => _go(_View.forgot),
//           ),
//           suffix: IconButton(
//             icon: Icon(
//               _obscure
//                   ? Icons.visibility_off_outlined
//                   : Icons.visibility_outlined,
//               size: 18,
//               color: AppColors.textMuted,
//             ),
//             onPressed: () => setState(() => _obscure = !_obscure),
//           ),
//           onSubmitted: (_) => _otpSent ? _handleVerify() : _handleSendOtp(),
//         ),
//         const SizedBox(height: 14),

//         // OTP appears right here, on the same page
//         AnimatedSize(
//           duration: const Duration(milliseconds: 260),
//           curve: Curves.easeOut,
//           alignment: Alignment.topCenter,
//           child: SizedBox(
//             width: double.infinity,
//             child: _otpSent ? _otpSection() : const SizedBox(height: 0),
//           ),
//         ),

//         AuthCheckRow(
//           value: _remember,
//           onChanged: (v) => setState(() => _remember = v ?? false),
//           label: const Text(
//             'Remember this device for 30 days',
//             style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
//           ),
//         ),
//         const SizedBox(height: 18),

//         AuthPrimaryButton(
//           label: _otpSent ? 'Verify and sign in' : 'Send OTP',
//           onPressed: _otpSent ? _handleVerify : _handleSendOtp,
//         ),
//         const SizedBox(height: 18),
//         const Center(
//           child: Text(
//             'Protected by enterprise password policy · 3 attempts before lockout',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
//           ),
//         ),

//         const SizedBox(height: 22),
//         const AuthDividerLabel('or continue with'),
//         const SizedBox(height: 16),
//         AuthSsoButton(
//           leading: const Text(
//             'G',
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               fontSize: 15,
//               color: Color(0xFFDB4437),
//             ),
//           ),
//           label: 'Google',
//           onTap: () => _ssoSignIn('Google'),
//         ),
//         const SizedBox(height: 10),
//         AuthSsoButton(
//           leading: const Icon(
//             Icons.grid_view_rounded,
//             size: 16,
//             color: AppColors.info,
//           ),
//           label: 'Microsoft',
//           onTap: () => _ssoSignIn('Microsoft'),
//         ),
//         const SizedBox(height: 10),
//         AuthSsoButton(
//           leading: const Icon(
//             Icons.groups_outlined,
//             size: 17,
//             color: AppColors.textMuted,
//           ),
//           label: 'Company SSO (SAML)',
//           onTap: () => _ssoSignIn('Company'),
//         ),
//         const SizedBox(height: 22),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               const Text(
//                 'New to OneCloud? ',
//                 style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//               ),
//               AuthLinkText(
//                 'Create an account',
//                 onTap: () => Navigator.pushNamed(context, '/signup'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _otpSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AuthLabel('One-time code', required: true),
//         const SizedBox(height: 8),
//         Row(
//           children: List.generate(11, (i) {
//             if (i.isOdd) return const SizedBox(width: 8);
//             return Expanded(child: _otpBox(i ~/ 2));
//           }),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             Text(
//               'Code expires in ${_fmt(_otpSeconds)}',
//               style: const TextStyle(
//                 fontSize: 11.5,
//                 color: AppColors.textMuted,
//               ),
//             ),
//             const Text(
//               '  ·  ',
//               style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
//             ),
//             AuthLinkText('Resend code', size: 11.5, onTap: _resendOtp),
//           ],
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget _otpBox(int index) {
//     return SizedBox(
//       height: 48,
//       child: TextField(
//         controller: _otpC[index],
//         focusNode: _otpF[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w700,
//           color: AppColors.textInk,
//         ),
//         decoration: InputDecoration(
//           counterText: '',
//           contentPadding: EdgeInsets.zero,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: AppColors.border),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: AppColors.info, width: 2),
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) _otpF[index + 1].requestFocus();
//           if (value.isEmpty && index > 0) _otpF[index - 1].requestFocus();
//         },
//       ),
//     );
//   }

//   // ---------------- Forgot password ----------------
//   Widget _forgotView() {
//     return Column(
//       key: const ValueKey('forgot'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         AuthBackLink(label: 'Back to sign in', onTap: () => _go(_View.signIn)),
//         const SizedBox(height: 18),
//         const AuthStepLabel('PASSWORD RECOVERY'),
//         const SizedBox(height: 8),
//         const AuthTitle('Forgot your password?'),
//         const SizedBox(height: 6),
//         const AuthSubtitle(
//           "Enter your work email and we'll send you a link to reset it.",
//         ),
//         const SizedBox(height: 24),
//         AuthField(
//           label: 'Work email',
//           controller: _resetEmailC,
//           hint: 'you@company.com',
//           keyboardType: TextInputType.emailAddress,
//           onSubmitted: (_) => _sendResetLink(),
//         ),
//         const SizedBox(height: 18),
//         AuthPrimaryButton(label: 'Send reset link', onPressed: _sendResetLink),
//         const SizedBox(height: 20),
//         const Divider(color: AppColors.border),
//         const SizedBox(height: 14),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               const Text(
//                 'Remembered your password? ',
//                 style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//               ),
//               AuthLinkText('Sign in', onTap: () => _go(_View.signIn)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- Check your email ----------------
//   Widget _checkEmailView() {
//     return Column(
//       key: const ValueKey('checkEmail'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const AuthCircleIcon(
//           icon: Icons.mail_outline_rounded,
//           color: AppColors.success,
//         ),
//         const SizedBox(height: 18),
//         const Center(child: AuthTitle('Check your email')),
//         const SizedBox(height: 8),
//         Text.rich(
//           TextSpan(
//             style: const TextStyle(
//               fontSize: 12.5,
//               color: AppColors.textMuted,
//               height: 1.5,
//             ),
//             children: [
//               const TextSpan(text: "We've sent a password reset link to "),
//               TextSpan(
//                 text: _resetEmailC.text.trim(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textInk,
//                 ),
//               ),
//               const TextSpan(text: '.\nThe link expires in 30 minutes.'),
//             ],
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 24),
//         AuthOutlineButton(
//           label: 'Resend email',
//           onPressed: () => _snack('Reset link sent again'),
//         ),
//         const SizedBox(height: 10),
//         AuthPrimaryButton(
//           label: 'Back to sign in',
//           onPressed: () => _go(_View.signIn),
//         ),
//         const SizedBox(height: 20),
//         const Divider(color: AppColors.border),
//         const SizedBox(height: 12),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               const Text(
//                 "Didn't get it? Check spam, or ",
//                 style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
//               ),
//               AuthLinkText('contact support', size: 11.5),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- Account locked ----------------
//   Widget _lockedView() {
//     final email = _emailC.text.trim();
//     return Column(
//       key: const ValueKey('locked'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const AuthCircleIcon(
//           icon: Icons.lock_outline_rounded,
//           color: AppColors.danger,
//         ),
//         const SizedBox(height: 18),
//         const Center(child: AuthTitle('This account is locked')),
//         const SizedBox(height: 8),
//         Text.rich(
//           TextSpan(
//             style: const TextStyle(
//               fontSize: 12.5,
//               color: AppColors.textMuted,
//               height: 1.5,
//             ),
//             children: [
//               const TextSpan(
//                 text: 'Too many failed sign-in attempts. For your security, ',
//               ),
//               TextSpan(
//                 text: email.isEmpty ? 'this account' : email,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textInk,
//                 ),
//               ),
//               const TextSpan(
//                 text: ' has been temporarily locked for 15 minutes.',
//               ),
//             ],
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         AuthBanner(
//           icon: Icons.timer_outlined,
//           title: 'Try again in ${_fmt(_lockSeconds)}',
//           message: 'Or reset your password now to regain access immediately.',
//           color: AppColors.warning,
//         ),
//         const SizedBox(height: 18),
//         AuthPrimaryButton(
//           label: 'Reset password',
//           onPressed: () => _go(_View.forgot),
//         ),
//         const SizedBox(height: 10),
//         AuthOutlineButton(
//           label: 'Back to sign in',
//           onPressed: () => _go(_View.signIn),
//         ),
//         const SizedBox(height: 18),
//         const Divider(color: AppColors.border),
//         const SizedBox(height: 12),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               const Text(
//                 'This lockout was recorded in the security audit log · ',
//                 style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
//               ),
//               AuthLinkText('Contact support', size: 10.5),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- You're in ----------------
//   Widget _successView() {
//     return Column(
//       key: const ValueKey('success'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: const [
//         AuthCircleIcon(icon: Icons.check_rounded, color: AppColors.success),
//         SizedBox(height: 18),
//         Center(child: AuthTitle("You're in")),
//         SizedBox(height: 8),
//         Center(child: AuthSubtitle('Redirecting to your dashboard...')),
//         SizedBox(height: 22),
//         Center(
//           child: SizedBox(
//             width: 22,
//             height: 22,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.4,
//               color: AppColors.info,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../widgets/auth_shell.dart';
import '../widgets/auth_widgets.dart';

enum _View { signIn, forgot, checkEmail, locked, success }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const int _maxAttempts = 3;
  _View _view = _View.signIn;

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final TextEditingController _resetEmailC = TextEditingController();
  final List<TextEditingController> _otpC = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpF = List.generate(6, (_) => FocusNode());

  bool _obscure = true;
  bool _remember = false;
  bool _otpSent = false;
  bool _locked = false;
  int _failedAttempts = 0;

  Timer? _otpTimer;
  int _otpSeconds = 300;
  Timer? _lockTimer;
  int _lockSeconds = 900;
  Timer? _redirectTimer;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _resetEmailC.dispose();
    for (final c in _otpC) c.dispose();
    for (final f in _otpF) f.dispose();
    _otpTimer?.cancel();
    _lockTimer?.cancel();
    _redirectTimer?.cancel();
    super.dispose();
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _go(_View view) => setState(() => _view = view);

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _otpSeconds = 300;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_otpSeconds > 0) _otpSeconds--;
      });
    });
  }

  void _startLockTimer() {
    _lockTimer?.cancel();
    _lockSeconds = 900;
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_lockSeconds <= 1) {
        t.cancel();
        setState(() {
          _locked = false;
          _failedAttempts = 0;
          _view = _View.signIn;
        });
        _snack('Your account is unlocked. You can sign in again.');
        return;
      }
      setState(() => _lockSeconds--);
    });
  }

  void _redirectToDashboard(String name, String email) {
    UserSession.name = name;
    UserSession.email = email;
    setState(() => _view = _View.success);
    _redirectTimer?.cancel();
    _redirectTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleSendOtp() {
    final email = _emailC.text.trim();
    final password = _passC.text;
    if (_locked) {
      _go(_View.locked);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _snack('Please enter a valid work email');
      return;
    }
    if (password.isEmpty) {
      _snack('Please enter your password');
      return;
    }
    if (password.length < 6) {
      setState(() => _failedAttempts++);
      if (_failedAttempts >= _maxAttempts) {
        setState(() {
          _locked = true;
          _view = _View.locked;
        });
        _startLockTimer();
      }
      return;
    }
    setState(() {
      _failedAttempts = 0;
      _otpSent = true;
    });
    _startOtpTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpF[0].requestFocus();
    });
  }

  void _handleVerify() {
    final code = _otpC.map((c) => c.text).join();
    if (code.length < 6) {
      _snack('Please enter the full 6-digit code');
      return;
    }
    final email = _emailC.text.trim();
    _redirectToDashboard(
      email.contains('@') ? email.split('@').first : email,
      email,
    );
  }

  void _resendOtp() {
    for (final c in _otpC) c.clear();
    _startOtpTimer();
    _otpF[0].requestFocus();
    _snack('A new code has been sent');
  }

  void _sendResetLink() {
    final email = _resetEmailC.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _snack('Please enter a valid work email');
      return;
    }
    _lockTimer?.cancel();
    setState(() {
      _locked = false;
      _failedAttempts = 0;
      _view = _View.checkEmail;
    });
  }

  void _ssoSignIn(String provider) {
    _redirectToDashboard(
      '$provider User',
      '${provider.toLowerCase()}-user@onecloud.io',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(child: _buildView());
  }

  Widget _buildView() {
    switch (_view) {
      case _View.signIn:
        return _signInView();
      case _View.forgot:
        return _forgotView();
      case _View.checkEmail:
        return _checkEmailView();
      case _View.locked:
        return _lockedView();
      case _View.success:
        return _successView();
    }
  }

  Widget _signInView() {
    final remaining = _maxAttempts - _failedAttempts;
    return Column(
      key: const ValueKey('signIn'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthStepLabel('SECURE ACCESS'),
        const SizedBox(height: 8),
        const AuthTitle('Sign in'),
        const SizedBox(height: 6),
        const AuthSubtitle(
          'Enter your work email and password, then verify with a one-time code.',
        ),
        const SizedBox(height: 24),
        if (_failedAttempts > 0) ...[
          AuthBanner(
            icon: Icons.error_outline_rounded,
            title: 'Incorrect email or password',
            message:
                'You have $remaining ${remaining == 1 ? 'attempt' : 'attempts'} remaining before lockout.',
            color: AppColors.danger,
          ),
          const SizedBox(height: 16),
        ],
        AuthField(
          label: 'Work email',
          controller: _emailC,
          hint: 'you@company.com',
          keyboardType: TextInputType.emailAddress,
          error: _failedAttempts > 0,
          readOnly: _otpSent,
        ),
        const SizedBox(height: 16),
        AuthField(
          label: 'Password',
          controller: _passC,
          hint: 'Enter your password',
          obscure: _obscure,
          error: _failedAttempts > 0,
          readOnly: _otpSent,
          trailingLabel: AuthLinkText(
            'Forgot password?',
            onTap: () => _go(_View.forgot),
          ),
          suffix: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.textMuted,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          onSubmitted: (_) => _otpSent ? _handleVerify() : _handleSendOtp(),
        ),
        const SizedBox(height: 14),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: double.infinity,
            child: _otpSent ? _otpSection() : const SizedBox(height: 0),
          ),
        ),
        AuthCheckRow(
          value: _remember,
          onChanged: (v) => setState(() => _remember = v ?? false),
          label: const Text(
            'Remember this device for 30 days',
            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(
          label: _otpSent ? 'Verify and sign in' : 'Send OTP',
          onPressed: _otpSent ? _handleVerify : _handleSendOtp,
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'Protected by enterprise password policy · 3 attempts before lockout',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 22),
        const AuthDividerLabel('or continue with'),
        const SizedBox(height: 16),
        AuthSsoButton(
          leading: const Text(
            'G',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFFDB4437),
            ),
          ),
          label: 'Google',
          onTap: () => _ssoSignIn('Google'),
        ),
        const SizedBox(height: 10),
        AuthSsoButton(
          leading: const Icon(
            Icons.grid_view_rounded,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          label: 'Microsoft',
          onTap: () => _ssoSignIn('Microsoft'),
        ),
        const SizedBox(height: 10),
        AuthSsoButton(
          leading: const Icon(
            Icons.groups_outlined,
            size: 17,
            color: AppColors.textMuted,
          ),
          label: 'Company SSO (SAML)',
          onTap: () => _ssoSignIn('Company'),
        ),
        const SizedBox(height: 22),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'New to OneCloud? ',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              AuthLinkText(
                'Create an account',
                onTap: () => Navigator.pushNamed(context, '/signup'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _otpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel('One-time code', required: true),
        const SizedBox(height: 8),
        Row(
          children: List.generate(11, (i) {
            if (i.isOdd) return const SizedBox(width: 8);
            return Expanded(child: _otpBox(i ~/ 2));
          }),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Code expires in ${_fmt(_otpSeconds)}',
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
              ),
            ),
            const Text(
              '  ·  ',
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
            AuthLinkText('Resend code', size: 11.5, onTap: _resendOtp),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _otpC[index],
        focusNode: _otpF[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textInk,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.paperDim,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) _otpF[index + 1].requestFocus();
          if (value.isEmpty && index > 0) _otpF[index - 1].requestFocus();
        },
      ),
    );
  }

  Widget _forgotView() {
    return Column(
      key: const ValueKey('forgot'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthBackLink(label: 'Back to sign in', onTap: () => _go(_View.signIn)),
        const SizedBox(height: 18),
        const AuthStepLabel('PASSWORD RECOVERY'),
        const SizedBox(height: 8),
        const AuthTitle('Forgot your password?'),
        const SizedBox(height: 6),
        const AuthSubtitle(
          "Enter your work email and we'll send you a link to reset it.",
        ),
        const SizedBox(height: 24),
        AuthField(
          label: 'Work email',
          controller: _resetEmailC,
          hint: 'you@company.com',
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (_) => _sendResetLink(),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(label: 'Send reset link', onPressed: _sendResetLink),
        const SizedBox(height: 20),
        const Divider(color: AppColors.borderGrey),
        const SizedBox(height: 14),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Remembered your password? ',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              AuthLinkText('Sign in', onTap: () => _go(_View.signIn)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _checkEmailView() {
    return Column(
      key: const ValueKey('checkEmail'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthCircleIcon(
          icon: Icons.mail_outline_rounded,
          color: AppColors.success,
        ),
        const SizedBox(height: 18),
        const Center(child: AuthTitle('Check your email')),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: "We've sent a password reset link to "),
              TextSpan(
                text: _resetEmailC.text.trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textInk,
                ),
              ),
              const TextSpan(text: '.\nThe link expires in 30 minutes.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AuthOutlineButton(
          label: 'Resend email',
          onPressed: () => _snack('Reset link sent again'),
        ),
        const SizedBox(height: 10),
        AuthPrimaryButton(
          label: 'Back to sign in',
          onPressed: () => _go(_View.signIn),
        ),
        const SizedBox(height: 20),
        const Divider(color: AppColors.borderGrey),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                "Didn't get it? Check spam, or ",
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
              ),
              AuthLinkText('contact support', size: 11.5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lockedView() {
    final email = _emailC.text.trim();
    return Column(
      key: const ValueKey('locked'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthCircleIcon(
          icon: Icons.lock_outline_rounded,
          color: AppColors.danger,
        ),
        const SizedBox(height: 18),
        const Center(child: AuthTitle('This account is locked')),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: 'Too many failed sign-in attempts. For your security, ',
              ),
              TextSpan(
                text: email.isEmpty ? 'this account' : email,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textInk,
                ),
              ),
              const TextSpan(
                text: ' has been temporarily locked for 15 minutes.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AuthBanner(
          icon: Icons.timer_outlined,
          title: 'Try again in ${_fmt(_lockSeconds)}',
          message: 'Or reset your password now to regain access immediately.',
          color: AppColors.warning,
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(
          label: 'Reset password',
          onPressed: () => _go(_View.forgot),
        ),
        const SizedBox(height: 10),
        AuthOutlineButton(
          label: 'Back to sign in',
          onPressed: () => _go(_View.signIn),
        ),
        const SizedBox(height: 18),
        const Divider(color: AppColors.borderGrey),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'This lockout was recorded in the security audit log · ',
                style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
              ),
              AuthLinkText('Contact support', size: 10.5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _successView() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        AuthCircleIcon(icon: Icons.check_rounded, color: AppColors.success),
        SizedBox(height: 18),
        Center(child: AuthTitle("You're in")),
        SizedBox(height: 8),
        Center(child: AuthSubtitle('Redirecting to your dashboard...')),
        SizedBox(height: 22),
        Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
