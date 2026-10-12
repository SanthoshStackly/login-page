import 'package:flutter/material.dart';

import '../app_theme.dart';

InputDecoration authInputDecoration({
  String? hint,
  Widget? suffix,
  bool error = false,
}) {
  final borderColor = error ? AppColors.danger : AppColors.borderGrey;
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
    isDense: true,
    filled: true,
    fillColor: AppColors.paperDim,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    suffixIcon: suffix,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.4),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    ),
  );
}

class AuthStepLabel extends StatelessWidget {
  final String text;
  const AuthStepLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      color: AppColors.textMuted,
      fontFamily: 'monospace',
    ),
  );
}

class AuthTitle extends StatelessWidget {
  final String text;
  const AuthTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.textInk,
      height: 1.2,
    ),
  );
}

class AuthSubtitle extends StatelessWidget {
  final String text;
  const AuthSubtitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      color: AppColors.textMuted,
      height: 1.45,
    ),
  );
}

class AuthLabel extends StatelessWidget {
  final String text;
  final bool required;
  const AuthLabel(this.text, {super.key, this.required = false});
  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textInk,
      ),
      children: [
        if (required)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.danger),
          ),
      ],
    ),
  );
}

class AuthLinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double size;
  const AuthLinkText(this.text, {super.key, this.onTap, this.size = 12});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
    ),
  );
}

class AuthBackLink extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const AuthBackLink({super.key, required this.onTap, this.label = 'Back'});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 11,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}

class AuthField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool required;
  final bool error;
  final String? helper;
  final bool readOnly;
  final Widget? trailingLabel;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AuthField({
    super.key,
    required this.label,
    this.controller,
    this.hint = '',
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.required = false,
    this.error = false,
    this.helper,
    this.readOnly = false,
    this.trailingLabel,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AuthLabel(label, required: required),
            if (trailingLabel != null) trailingLabel!,
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: TextStyle(
            fontSize: 13.5,
            color: readOnly ? AppColors.textMuted : AppColors.textInk,
          ),
          decoration: authInputDecoration(
            hint: hint,
            suffix: suffix,
            error: error,
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(
            helper!,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }
}

class AuthDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final bool required;
  final ValueChanged<String?> onChanged;

  const AuthDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Select',
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthLabel(label, required: required),
        const SizedBox(height: 6),
        InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            filled: true,
            fillColor: AppColors.paperDim,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textMuted,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
              style: const TextStyle(fontSize: 13.5, color: AppColors.textInk),
              items: items
                  .map(
                    (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPair extends StatelessWidget {
  final Widget first;
  final Widget second;
  const AuthPair({super.key, required this.first, required this.second});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 380)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [first, const SizedBox(height: 16), second],
          );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class AuthOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AuthOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textInk,
        ),
      ),
    ),
  );
}

class AuthSsoButton extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  const AuthSsoButton({
    super.key,
    required this.leading,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textInk,
            ),
          ),
        ],
      ),
    ),
  );
}

class AuthBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Color color;
  const AuthBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.message,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.28)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 2),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class AuthDividerLabel extends StatelessWidget {
  final String text;
  const AuthDividerLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(color: AppColors.borderGrey)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ),
      const Expanded(child: Divider(color: AppColors.borderGrey)),
    ],
  );
}

// --- THIS WAS MISSING - ADDED NOW ---
class AuthCircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const AuthCircleIcon({super.key, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.12),
      ),
      child: Icon(icon, color: color, size: 26),
    ),
  );
}

class AuthCheckRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget label;
  const AuthCheckRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 22,
        height: 22,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Padding(padding: const EdgeInsets.only(top: 2), child: label),
      ),
    ],
  );
}
