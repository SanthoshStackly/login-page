// import 'package:flutter/material.dart';

// import '../app_theme.dart';
// import '../widgets/auth_shell.dart';
// import '../widgets/auth_widgets.dart';

// // ------------------------------------------------------------
// // Registration flow (3 steps) + welcome screen.
// //   Step 1 : Organization details
// //   Step 2 : Super admin account
// //   Step 3 : Review and confirm (terms)
// //   Done   : "Welcome to OneCloud"
// // ------------------------------------------------------------

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   int _step = 0; // 0,1,2 = steps, 3 = welcome

//   // step 1
//   final TextEditingController _orgNameC = TextEditingController();
//   final TextEditingController _orgCodeC = TextEditingController();
//   final TextEditingController _cityC = TextEditingController();
//   bool _codeManual = false;
//   String? _orgType = 'Enterprise';
//   String? _industry = 'Information Technology';
//   String? _size = '501-1000';
//   String? _country = 'India';
//   String? _state = 'Telangana';
//   String? _timeZone = 'Asia/Kolkata (UTC +05:30)';

//   // step 2
//   final TextEditingController _firstC = TextEditingController();
//   final TextEditingController _lastC = TextEditingController();
//   final TextEditingController _emailC = TextEditingController();
//   final TextEditingController _mobileC = TextEditingController();
//   final TextEditingController _userC = TextEditingController();
//   final TextEditingController _passC = TextEditingController();
//   final TextEditingController _confirmC = TextEditingController();
//   bool _obscure1 = true;
//   bool _obscure2 = true;

//   // step 3
//   bool _agreeTerms = false;
//   bool _agreeAuth = false;
//   bool _agreeDpa = false;
//   bool _agreeMarketing = true;

//   @override
//   void dispose() {
//     for (final c in [
//       _orgNameC,
//       _orgCodeC,
//       _cityC,
//       _firstC,
//       _lastC,
//       _emailC,
//       _mobileC,
//       _userC,
//       _passC,
//       _confirmC,
//     ]) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   // ---------------- helpers ----------------
//   void _snack(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   String _generateCode(String name) {
//     final words = name
//         .trim()
//         .toUpperCase()
//         .split(RegExp(r'[^A-Z0-9]+'))
//         .where((w) => w.isNotEmpty)
//         .toList();
//     if (words.isEmpty) return '';
//     if (words.length == 1)
//       return words[0].length > 8 ? words[0].substring(0, 8) : words[0];
//     final second = words[1].length > 4 ? words[1].substring(0, 4) : words[1];
//     return '${words[0]}-$second';
//   }

//   void _backToSignIn() {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }

//   // ---------------- step actions ----------------
//   void _nextFromOrg() {
//     if (_orgNameC.text.trim().isEmpty ||
//         _orgCodeC.text.trim().isEmpty ||
//         _cityC.text.trim().isEmpty) {
//       _snack('Please fill all required fields');
//       return;
//     }
//     setState(() => _step = 1);
//   }

//   void _nextFromAdmin() {
//     final email = _emailC.text.trim();
//     final password = _passC.text;
//     if (_firstC.text.trim().isEmpty ||
//         _lastC.text.trim().isEmpty ||
//         email.isEmpty ||
//         _mobileC.text.trim().isEmpty ||
//         _userC.text.trim().isEmpty) {
//       _snack('Please fill all required fields');
//       return;
//     }
//     if (!email.contains('@')) {
//       _snack('Please enter a valid official email');
//       return;
//     }
//     final strong =
//         password.length >= 8 &&
//         RegExp(r'\d').hasMatch(password) &&
//         RegExp(r'[^A-Za-z0-9]').hasMatch(password);
//     if (!strong) {
//       _snack('Password needs 8+ characters, one number and one symbol');
//       return;
//     }
//     if (password != _confirmC.text) {
//       _snack('Passwords do not match');
//       return;
//     }
//     setState(() => _step = 2);
//   }

//   void _createAccount() {
//     if (!(_agreeTerms && _agreeAuth && _agreeDpa)) {
//       _snack('Please accept all required agreements');
//       return;
//     }
//     UserSession.name = '${_firstC.text.trim()} ${_lastC.text.trim()}';
//     UserSession.email = _emailC.text.trim();
//     UserSession.workspace = _orgCodeC.text.trim();
//     setState(() => _step = 3);
//   }

//   // ---------------- build ----------------
//   @override
//   Widget build(BuildContext context) {
//     return AuthShell(maxFormWidth: 440, child: _buildStep());
//   }

//   Widget _buildStep() {
//     switch (_step) {
//       case 0:
//         return _orgStep();
//       case 1:
//         return _adminStep();
//       case 2:
//         return _reviewStep();
//       default:
//         return _welcomeStep();
//     }
//   }

//   Widget _progress() {
//     return Row(
//       children: List.generate(3, (i) {
//         final Color color = i < _step
//             ? AppColors.info
//             : (i == _step ? AppColors.ink : AppColors.border);
//         return Expanded(
//           child: Container(
//             height: 3,
//             margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _signInFooter() {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         const Divider(color: AppColors.border),
//         const SizedBox(height: 14),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               const Text(
//                 'Already have an organization? ',
//                 style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//               ),
//               AuthLinkText('Sign in', onTap: _backToSignIn),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- Step 1: Organization ----------------
//   Widget _orgStep() {
//     return Column(
//       key: const ValueKey('org'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _progress(),
//         const SizedBox(height: 22),
//         const AuthStepLabel('STEP 1 OF 3  ·  ORGANIZATION DETAILS'),
//         const SizedBox(height: 8),
//         const AuthTitle('Tell us about your organization'),
//         const SizedBox(height: 6),
//         const AuthSubtitle(
//           "This creates your organization's workspace on OneCloud.",
//         ),
//         const SizedBox(height: 22),

//         AuthField(
//           label: 'Organization Name',
//           required: true,
//           controller: _orgNameC,
//           hint: 'ABC Technologies Pvt Ltd',
//           onChanged: (value) {
//             if (!_codeManual) {
//               setState(() => _orgCodeC.text = _generateCode(value));
//             }
//           },
//         ),
//         const SizedBox(height: 16),
//         AuthField(
//           label: 'Organization Code',
//           required: true,
//           controller: _orgCodeC,
//           hint: 'ABC-TECH',
//           readOnly: !_codeManual,
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           children: [
//             const Text(
//               'Auto-generated from your organization name — ',
//               style: TextStyle(fontSize: 11, color: AppColors.textMuted),
//             ),
//             AuthLinkText(
//               'edit manually',
//               size: 11,
//               onTap: () => setState(() => _codeManual = true),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         AuthDropdown(
//           label: 'Organization Type',
//           required: true,
//           value: _orgType,
//           items: const [
//             'Enterprise',
//             'SMB',
//             'Startup',
//             'Non-profit',
//             'Government',
//           ],
//           onChanged: (v) => setState(() => _orgType = v),
//         ),
//         const SizedBox(height: 16),
//         AuthDropdown(
//           label: 'Industry',
//           required: true,
//           value: _industry,
//           items: const [
//             'Information Technology',
//             'Finance',
//             'Healthcare',
//             'Manufacturing',
//             'Retail',
//             'Education',
//           ],
//           onChanged: (v) => setState(() => _industry = v),
//         ),
//         const SizedBox(height: 16),
//         AuthDropdown(
//           label: 'Company Size',
//           required: true,
//           value: _size,
//           items: const ['1-50', '51-200', '201-500', '501-1000', '1000+'],
//           onChanged: (v) => setState(() => _size = v),
//         ),
//         const SizedBox(height: 16),

//         AuthPair(
//           first: AuthDropdown(
//             label: 'Country',
//             required: true,
//             value: _country,
//             items: const [
//               'India',
//               'United States',
//               'United Kingdom',
//               'Singapore',
//               'UAE',
//             ],
//             onChanged: (v) => setState(() => _country = v),
//           ),
//           second: AuthDropdown(
//             label: 'State / Province',
//             required: true,
//             value: _state,
//             items: const [
//               'Telangana',
//               'Tamil Nadu',
//               'Karnataka',
//               'Maharashtra',
//               'Delhi',
//             ],
//             onChanged: (v) => setState(() => _state = v),
//           ),
//         ),
//         const SizedBox(height: 16),
//         AuthPair(
//           first: AuthField(
//             label: 'City',
//             required: true,
//             controller: _cityC,
//             hint: 'Hyderabad',
//           ),
//           second: AuthDropdown(
//             label: 'Time Zone',
//             required: true,
//             value: _timeZone,
//             items: const [
//               'Asia/Kolkata (UTC +05:30)',
//               'UTC',
//               'America/New_York (UTC -05:00)',
//               'Europe/London (UTC +00:00)',
//             ],
//             onChanged: (v) => setState(() => _timeZone = v),
//           ),
//         ),
//         const SizedBox(height: 16),

//         Row(
//           children: const [
//             AuthLabel('Organization Logo'),
//             SizedBox(width: 6),
//             Text(
//               'OPTIONAL',
//               style: TextStyle(
//                 fontSize: 9,
//                 color: AppColors.textMuted,
//                 letterSpacing: 0.6,
//                 fontFamily: 'monospace',
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         MouseRegion(
//           cursor: SystemMouseCursors.click,
//           child: GestureDetector(
//             onTap: () => _snack(
//               'Logo upload will be enabled once the backend is connected',
//             ),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//               decoration: BoxDecoration(
//                 color: AppColors.paperDim,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   const Icon(
//                     Icons.file_upload_outlined,
//                     size: 20,
//                     color: AppColors.textMuted,
//                   ),
//                   const SizedBox(height: 6),
//                   Text.rich(
//                     const TextSpan(
//                       style: TextStyle(
//                         fontSize: 11.5,
//                         color: AppColors.textMuted,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Upload logo',
//                           style: TextStyle(
//                             color: AppColors.info,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' or drag and drop — PNG, JPG up to 5MB',
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 22),
//         AuthPrimaryButton(label: 'Continue', onPressed: _nextFromOrg),
//         _signInFooter(),
//       ],
//     );
//   }

//   // ---------------- Step 2: Super admin ----------------
//   Widget _adminStep() {
//     return Column(
//       key: const ValueKey('admin'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         AuthBackLink(onTap: () => setState(() => _step = 0)),
//         const SizedBox(height: 12),
//         _progress(),
//         const SizedBox(height: 22),
//         const AuthStepLabel('STEP 2 OF 3  ·  SUPER ADMIN ACCOUNT'),
//         const SizedBox(height: 8),
//         const AuthTitle('Create your admin account'),
//         const SizedBox(height: 6),
//         Text.rich(
//           TextSpan(
//             style: const TextStyle(
//               fontSize: 13,
//               color: AppColors.textMuted,
//               height: 1.45,
//             ),
//             children: [
//               const TextSpan(text: "This is the account you'll use to manage "),
//               TextSpan(
//                 text: _orgNameC.text.trim().isEmpty
//                     ? 'your organization'
//                     : _orgNameC.text.trim(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textInk,
//                 ),
//               ),
//               const TextSpan(text: '.'),
//             ],
//           ),
//         ),
//         const SizedBox(height: 18),
//         const AuthBanner(
//           icon: Icons.shield_outlined,
//           title: 'SUPER_ADMIN role',
//           message: "This account will automatically be assigned the SUPER_ADMIN role, with full access to your organization's workspace.",
//           color: AppColors.info,
//         ),
//         const SizedBox(height: 18),

//         AuthPair(
//           first: AuthField(
//             label: 'First Name',
//             required: true,
//             controller: _firstC,
//             hint: 'Ananya',
//           ),
//           second: AuthField(
//             label: 'Last Name',
//             required: true,
//             controller: _lastC,
//             hint: 'Rao',
//           ),
//         ),
//         const SizedBox(height: 16),
//         AuthField(
//           label: 'Official Email',
//           required: true,
//           controller: _emailC,
//           hint: 'ananya.rao@abctech.com',
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 16),
//         AuthField(
//           label: 'Mobile Number',
//           required: true,
//           controller: _mobileC,
//           hint: '+91 98765 43210',
//           keyboardType: TextInputType.phone,
//         ),
//         const SizedBox(height: 16),
//         AuthField(
//           label: 'Username',
//           required: true,
//           controller: _userC,
//           hint: 'ananya.rao',
//         ),
//         const SizedBox(height: 16),
//         AuthPair(
//           first: AuthField(
//             label: 'Password',
//             required: true,
//             controller: _passC,
//             hint: 'Create a password',
//             obscure: _obscure1,
//             suffix: IconButton(
//               icon: Icon(
//                 _obscure1
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 size: 18,
//                 color: AppColors.textMuted,
//               ),
//               onPressed: () => setState(() => _obscure1 = !_obscure1),
//             ),
//           ),
//           second: AuthField(
//             label: 'Confirm Password',
//             required: true,
//             controller: _confirmC,
//             hint: 'Re-enter password',
//             obscure: _obscure2,
//             suffix: IconButton(
//               icon: Icon(
//                 _obscure2
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 size: 18,
//                 color: AppColors.textMuted,
//               ),
//               onPressed: () => setState(() => _obscure2 = !_obscure2),
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         const Text(
//           'Minimum 8 characters, with at least one number and one symbol.',
//           style: TextStyle(fontSize: 11, color: AppColors.textMuted),
//         ),
//         const SizedBox(height: 22),
//         AuthPrimaryButton(label: 'Continue', onPressed: _nextFromAdmin),
//         _signInFooter(),
//       ],
//     );
//   }

//   // ---------------- Step 3: Review and confirm ----------------
//   Widget _reviewStep() {
//     final org = _orgNameC.text.trim().isEmpty
//         ? 'your organization'
//         : _orgNameC.text.trim();
//     const linkStyle = TextStyle(
//       color: AppColors.info,
//       fontWeight: FontWeight.w600,
//     );
//     const textStyle = TextStyle(
//       fontSize: 12,
//       color: AppColors.textInk,
//       height: 1.4,
//     );

//     return Column(
//       key: const ValueKey('review'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         AuthBackLink(onTap: () => setState(() => _step = 1)),
//         const SizedBox(height: 12),
//         _progress(),
//         const SizedBox(height: 22),
//         const AuthStepLabel('STEP 3 OF 3  ·  TERMS & AUTHORIZATION'),
//         const SizedBox(height: 8),
//         const AuthTitle('Review and confirm'),
//         const SizedBox(height: 6),
//         Text.rich(
//           TextSpan(
//             style: const TextStyle(
//               fontSize: 13,
//               color: AppColors.textMuted,
//               height: 1.45,
//             ),
//             children: [
//               const TextSpan(text: 'One last step before we create '),
//               TextSpan(
//                 text: "$org's",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textInk,
//                 ),
//               ),
//               const TextSpan(text: ' workspace.'),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.paperDim,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: AppColors.border),
//           ),
//           child: Column(
//             children: [
//               AuthCheckRow(
//                 value: _agreeTerms,
//                 onChanged: (v) => setState(() => _agreeTerms = v ?? false),
//                 label: const Text.rich(
//                   TextSpan(
//                     style: textStyle,
//                     children: [
//                       TextSpan(text: 'I have read and agree to the '),
//                       TextSpan(text: 'Terms of Service', style: linkStyle),
//                       TextSpan(text: ' and '),
//                       TextSpan(text: 'Privacy Policy', style: linkStyle),
//                       TextSpan(text: '.'),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               AuthCheckRow(
//                 value: _agreeAuth,
//                 onChanged: (v) => setState(() => _agreeAuth = v ?? false),
//                 label: Text.rich(
//                   TextSpan(
//                     style: textStyle,
//                     children: [
//                       const TextSpan(
//                         text: 'I confirm that I am authorized to register ',
//                       ),
//                       TextSpan(
//                         text: org,
//                         style: const TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                       const TextSpan(
//                         text: ' on OneCloud, and I accept responsibility as its Super Administrator.',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               AuthCheckRow(
//                 value: _agreeDpa,
//                 onChanged: (v) => setState(() => _agreeDpa = v ?? false),
//                 label: const Text.rich(
//                   TextSpan(
//                     style: textStyle,
//                     children: [
//                       TextSpan(text: 'I agree to the '),
//                       TextSpan(
//                         text: 'Data Processing Agreement',
//                         style: linkStyle,
//                       ),
//                       TextSpan(
//                         text: ' governing how organization data is stored and processed.',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               AuthCheckRow(
//                 value: _agreeMarketing,
//                 onChanged: (v) => setState(() => _agreeMarketing = v ?? false),
//                 label: const Text.rich(
//                   TextSpan(
//                     style: textStyle,
//                     children: [
//                       TextSpan(
//                         text: 'Send me product updates and security notices by email ',
//                       ),
//                       TextSpan(
//                         text: 'OPTIONAL',
//                         style: TextStyle(
//                           fontSize: 9,
//                           color: AppColors.textMuted,
//                           letterSpacing: 0.6,
//                           fontFamily: 'monospace',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 18),
//         AuthPrimaryButton(label: 'Create account', onPressed: _createAccount),
//         _signInFooter(),
//       ],
//     );
//   }

//   // ---------------- Welcome ----------------
//   Widget _welcomeStep() {
//     final org = _orgNameC.text.trim().isEmpty
//         ? 'Your organization'
//         : _orgNameC.text.trim();
//     final code = _orgCodeC.text.trim().toLowerCase();
//     return Column(
//       key: const ValueKey('welcome'),
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const AuthCircleIcon(
//           icon: Icons.check_rounded,
//           color: AppColors.success,
//         ),
//         const SizedBox(height: 18),
//         const Center(child: AuthTitle('Welcome to OneCloud')),
//         const SizedBox(height: 8),
//         Text.rich(
//           TextSpan(
//             style: const TextStyle(
//               fontSize: 12.5,
//               color: AppColors.textMuted,
//               height: 1.5,
//             ),
//             children: [
//               TextSpan(
//                 text: org,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textInk,
//                 ),
//               ),
//               const TextSpan(
//                 text: ' is ready. Your Super Admin account has been created — verify your email to activate full access.',
//               ),
//             ],
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: AppColors.info.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Icon(
//                 Icons.mail_outline_rounded,
//                 size: 16,
//                 color: AppColors.info,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text.rich(
//                   TextSpan(
//                     style: const TextStyle(
//                       fontSize: 11.5,
//                       color: AppColors.textInk,
//                       height: 1.45,
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: "We've sent a verification link to your official email. Your workspace: ",
//                       ),
//                       TextSpan(
//                         text: '$code.onecloud.io',
//                         style: const TextStyle(
//                           fontFamily: 'monospace',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         AuthPrimaryButton(
//           label: 'Go to sign in',
//           onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
//         ),
//         const SizedBox(height: 18),
//         const Divider(color: AppColors.border),
//         const SizedBox(height: 12),
//         Center(
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               const Text(
//                 "Didn't get the email? ",
//                 style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
//               ),
//               AuthLinkText(
//                 'Resend verification',
//                 size: 11.5,
//                 onTap: () => _snack('Verification email sent again'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets/auth_shell.dart';
import '../widgets/auth_widgets.dart';

// ------------------------------------------------------------
// Registration flow (3 steps) + welcome screen.
//   Step 1 : Organization details
//   Step 2 : Super admin account
//   Step 3 : Review and confirm (terms)
//   Done   : "Welcome to OneCloud"
// ------------------------------------------------------------

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _step = 0; // 0,1,2 = steps, 3 = welcome

  // step 1
  final TextEditingController _orgNameC = TextEditingController();
  final TextEditingController _orgCodeC = TextEditingController();
  final TextEditingController _cityC = TextEditingController();
  bool _codeManual = false;
  String? _orgType = 'Enterprise';
  String? _industry = 'Information Technology';
  String? _size = '501-1000';
  String? _country = 'India';
  String? _state = 'Telangana';
  String? _timeZone = 'Asia/Kolkata (UTC +05:30)';

  // step 2
  final TextEditingController _firstC = TextEditingController();
  final TextEditingController _lastC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _mobileC = TextEditingController();
  final TextEditingController _userC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final TextEditingController _confirmC = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  // step 3
  bool _agreeTerms = false;
  bool _agreeAuth = false;
  bool _agreeDpa = false;
  bool _agreeMarketing = true;

  @override
  void dispose() {
    for (final c in [
      _orgNameC,
      _orgCodeC,
      _cityC,
      _firstC,
      _lastC,
      _emailC,
      _mobileC,
      _userC,
      _passC,
      _confirmC,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------------- helpers ----------------
  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _generateCode(String name) {
    final words = name
        .trim()
        .toUpperCase()
        .split(RegExp(r'[^A-Z0-9]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    if (words.length == 1)
      return words[0].length > 8 ? words[0].substring(0, 8) : words[0];
    final second = words[1].length > 4 ? words[1].substring(0, 4) : words[1];
    return '${words[0]}-$second';
  }

  void _backToSignIn() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // ---------------- step actions ----------------
  void _nextFromOrg() {
    if (_orgNameC.text.trim().isEmpty ||
        _orgCodeC.text.trim().isEmpty ||
        _cityC.text.trim().isEmpty) {
      _snack('Please fill all required fields');
      return;
    }
    setState(() => _step = 1);
  }

  void _nextFromAdmin() {
    final email = _emailC.text.trim();
    final password = _passC.text;
    if (_firstC.text.trim().isEmpty ||
        _lastC.text.trim().isEmpty ||
        email.isEmpty ||
        _mobileC.text.trim().isEmpty ||
        _userC.text.trim().isEmpty) {
      _snack('Please fill all required fields');
      return;
    }
    if (!email.contains('@')) {
      _snack('Please enter a valid official email');
      return;
    }
    final strong =
        password.length >= 8 &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(password);
    if (!strong) {
      _snack('Password needs 8+ characters, one number and one symbol');
      return;
    }
    if (password != _confirmC.text) {
      _snack('Passwords do not match');
      return;
    }
    setState(() => _step = 2);
  }

  void _createAccount() {
    if (!(_agreeTerms && _agreeAuth && _agreeDpa)) {
      _snack('Please accept all required agreements');
      return;
    }
    UserSession.name = '${_firstC.text.trim()} ${_lastC.text.trim()}';
    UserSession.email = _emailC.text.trim();
    UserSession.workspace = _orgCodeC.text.trim();
    setState(() => _step = 3);
  }

  // ---------------- build ----------------
  @override
  Widget build(BuildContext context) {
    return AuthShell(maxFormWidth: 440, child: _buildStep());
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _orgStep();
      case 1:
        return _adminStep();
      case 2:
        return _reviewStep();
      default:
        return _welcomeStep();
    }
  }

  Widget _progress() {
    return Row(
      children: List.generate(3, (i) {
        final Color color = i < _step
            ? AppColors.info
            : (i == _step ? AppColors.ink : AppColors.border);
        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _signInFooter() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(color: AppColors.border),
        const SizedBox(height: 14),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an organization? ',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              AuthLinkText('Sign in', onTap: _backToSignIn),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Step 1: Organization ----------------
  Widget _orgStep() {
    return Column(
      key: const ValueKey('org'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _progress(),
        const SizedBox(height: 22),
        const AuthStepLabel('STEP 1 OF 3  ·  ORGANIZATION DETAILS'),
        const SizedBox(height: 8),
        const AuthTitle('Tell us about your organization'),
        const SizedBox(height: 6),
        const AuthSubtitle(
          "This creates your organization's workspace on OneCloud.",
        ),
        const SizedBox(height: 22),

        AuthField(
          label: 'Organization Name',
          required: true,
          controller: _orgNameC,
          hint: 'ABC Technologies Pvt Ltd',
          onChanged: (value) {
            if (!_codeManual) {
              setState(() => _orgCodeC.text = _generateCode(value));
            }
          },
        ),
        const SizedBox(height: 16),
        AuthField(
          label: 'Organization Code',
          required: true,
          controller: _orgCodeC,
          hint: 'ABC-TECH',
          readOnly: !_codeManual,
        ),
        const SizedBox(height: 6),
        Wrap(
          children: [
            const Text(
              'Auto-generated from your organization name — ',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            AuthLinkText(
              'edit manually',
              size: 11,
              onTap: () => setState(() => _codeManual = true),
            ),
          ],
        ),
        const SizedBox(height: 16),

        AuthDropdown(
          label: 'Organization Type',
          required: true,
          value: _orgType,
          items: const [
            'Enterprise',
            'SMB',
            'Startup',
            'Non-profit',
            'Government',
          ],
          onChanged: (v) => setState(() => _orgType = v),
        ),
        const SizedBox(height: 16),
        AuthDropdown(
          label: 'Industry',
          required: true,
          value: _industry,
          items: const [
            'Information Technology',
            'Finance',
            'Healthcare',
            'Manufacturing',
            'Retail',
            'Education',
          ],
          onChanged: (v) => setState(() => _industry = v),
        ),
        const SizedBox(height: 16),
        AuthDropdown(
          label: 'Company Size',
          required: true,
          value: _size,
          items: const ['1-50', '51-200', '201-500', '501-1000', '1000+'],
          onChanged: (v) => setState(() => _size = v),
        ),
        const SizedBox(height: 16),

        AuthPair(
          first: AuthDropdown(
            label: 'Country',
            required: true,
            value: _country,
            items: const [
              'India',
              'United States',
              'United Kingdom',
              'Singapore',
              'UAE',
            ],
            onChanged: (v) => setState(() => _country = v),
          ),
          second: AuthDropdown(
            label: 'State / Province',
            required: true,
            value: _state,
            items: const [
              'Telangana',
              'Tamil Nadu',
              'Karnataka',
              'Maharashtra',
              'Delhi',
            ],
            onChanged: (v) => setState(() => _state = v),
          ),
        ),
        const SizedBox(height: 16),
        AuthPair(
          first: AuthField(
            label: 'City',
            required: true,
            controller: _cityC,
            hint: 'Hyderabad',
          ),
          second: AuthDropdown(
            label: 'Time Zone',
            required: true,
            value: _timeZone,
            items: const [
              'Asia/Kolkata (UTC +05:30)',
              'UTC',
              'America/New_York (UTC -05:00)',
              'Europe/London (UTC +00:00)',
            ],
            onChanged: (v) => setState(() => _timeZone = v),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: const [
            AuthLabel('Organization Logo'),
            SizedBox(width: 6),
            Text(
              'OPTIONAL',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textMuted,
                letterSpacing: 0.6,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _snack(
              'Logo upload will be enabled once the backend is connected',
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.file_upload_outlined,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    const TextSpan(
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(
                          text: 'Upload logo',
                          style: TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' or drag and drop — PNG, JPG up to 5MB',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(label: 'Continue', onPressed: _nextFromOrg),
        _signInFooter(),
      ],
    );
  }

  // ---------------- Step 2: Super admin ----------------
  Widget _adminStep() {
    return Column(
      key: const ValueKey('admin'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthBackLink(onTap: () => setState(() => _step = 0)),
        const SizedBox(height: 12),
        _progress(),
        const SizedBox(height: 22),
        const AuthStepLabel('STEP 2 OF 3  ·  SUPER ADMIN ACCOUNT'),
        const SizedBox(height: 8),
        const AuthTitle('Create your admin account'),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.45,
            ),
            children: [
              const TextSpan(text: "This is the account you'll use to manage "),
              TextSpan(
                text: _orgNameC.text.trim().isEmpty
                    ? 'your organization'
                    : _orgNameC.text.trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textInk,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const AuthBanner(
          icon: Icons.shield_outlined,
          title: 'SUPER_ADMIN role',
          message: "This account will automatically be assigned the SUPER_ADMIN role, with full access to your organization's workspace.",
          color: AppColors.info,
        ),
        const SizedBox(height: 18),

        AuthPair(
          first: AuthField(
            label: 'First Name',
            required: true,
            controller: _firstC,
            hint: 'Ananya',
          ),
          second: AuthField(
            label: 'Last Name',
            required: true,
            controller: _lastC,
            hint: 'Rao',
          ),
        ),
        const SizedBox(height: 16),
        AuthField(
          label: 'Official Email',
          required: true,
          controller: _emailC,
          hint: 'ananya.rao@abctech.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthField(
          label: 'Mobile Number',
          required: true,
          controller: _mobileC,
          hint: '+91 98765 43210',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AuthField(
          label: 'Username',
          required: true,
          controller: _userC,
          hint: 'ananya.rao',
        ),
        const SizedBox(height: 16),
        AuthPair(
          first: AuthField(
            label: 'Password',
            required: true,
            controller: _passC,
            hint: 'Create a password',
            obscure: _obscure1,
            suffix: IconButton(
              icon: Icon(
                _obscure1
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscure1 = !_obscure1),
            ),
          ),
          second: AuthField(
            label: 'Confirm Password',
            required: true,
            controller: _confirmC,
            hint: 'Re-enter password',
            obscure: _obscure2,
            suffix: IconButton(
              icon: Icon(
                _obscure2
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscure2 = !_obscure2),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Minimum 8 characters, with at least one number and one symbol.',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(label: 'Continue', onPressed: _nextFromAdmin),
        _signInFooter(),
      ],
    );
  }

  // ---------------- Step 3: Review and confirm ----------------
  Widget _reviewStep() {
    final org = _orgNameC.text.trim().isEmpty
        ? 'your organization'
        : _orgNameC.text.trim();
    const linkStyle = TextStyle(
      color: AppColors.info,
      fontWeight: FontWeight.w600,
    );
    const textStyle = TextStyle(
      fontSize: 12,
      color: AppColors.textInk,
      height: 1.4,
    );

    return Column(
      key: const ValueKey('review'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthBackLink(onTap: () => setState(() => _step = 1)),
        const SizedBox(height: 12),
        _progress(),
        const SizedBox(height: 22),
        const AuthStepLabel('STEP 3 OF 3  ·  TERMS & AUTHORIZATION'),
        const SizedBox(height: 8),
        const AuthTitle('Review and confirm'),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.45,
            ),
            children: [
              const TextSpan(text: 'One last step before we create '),
              TextSpan(
                text: "$org's",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textInk,
                ),
              ),
              const TextSpan(text: ' workspace.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.paperDim,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              AuthCheckRow(
                value: _agreeTerms,
                onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                label: const Text.rich(
                  TextSpan(
                    style: textStyle,
                    children: [
                      TextSpan(text: 'I have read and agree to the '),
                      TextSpan(text: 'Terms of Service', style: linkStyle),
                      TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy', style: linkStyle),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AuthCheckRow(
                value: _agreeAuth,
                onChanged: (v) => setState(() => _agreeAuth = v ?? false),
                label: Text.rich(
                  TextSpan(
                    style: textStyle,
                    children: [
                      const TextSpan(
                        text: 'I confirm that I am authorized to register ',
                      ),
                      TextSpan(
                        text: org,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(
                        text: ' on OneCloud, and I accept responsibility as its Super Administrator.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AuthCheckRow(
                value: _agreeDpa,
                onChanged: (v) => setState(() => _agreeDpa = v ?? false),
                label: const Text.rich(
                  TextSpan(
                    style: textStyle,
                    children: [
                      TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Data Processing Agreement',
                        style: linkStyle,
                      ),
                      TextSpan(
                        text: ' governing how organization data is stored and processed.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AuthCheckRow(
                value: _agreeMarketing,
                onChanged: (v) => setState(() => _agreeMarketing = v ?? false),
                label: const Text.rich(
                  TextSpan(
                    style: textStyle,
                    children: [
                      TextSpan(
                        text: 'Send me product updates and security notices by email ',
                      ),
                      TextSpan(
                        text: 'OPTIONAL',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textMuted,
                          letterSpacing: 0.6,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(label: 'Create account', onPressed: _createAccount),
        _signInFooter(),
      ],
    );
  }

  // ---------------- Welcome ----------------
  Widget _welcomeStep() {
    final org = _orgNameC.text.trim().isEmpty
        ? 'Your organization'
        : _orgNameC.text.trim();
    final code = _orgCodeC.text.trim().toLowerCase();
    return Column(
      key: const ValueKey('welcome'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthCircleIcon(
          icon: Icons.check_rounded,
          color: AppColors.success,
        ),
        const SizedBox(height: 18),
        const Center(child: AuthTitle('Welcome to OneCloud')),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: org,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textInk,
                ),
              ),
              const TextSpan(
                text: ' is ready. Your Super Admin account has been created — verify your email to activate full access.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.mail_outline_rounded,
                size: 16,
                color: AppColors.info,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textInk,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(
                        text: "We've sent a verification link to your official email. Your workspace: ",
                      ),
                      TextSpan(
                        text: '$code.onecloud.io',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AuthPrimaryButton(
          label: 'Go to sign in',
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
        const SizedBox(height: 18),
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                "Didn't get the email? ",
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
              ),
              AuthLinkText(
                'Resend verification',
                size: 11.5,
                onTap: () => _snack('Verification email sent again'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
