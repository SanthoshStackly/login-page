import 'package:flutter/material.dart';

import '../app_theme.dart';

class AdminSectionContent extends StatelessWidget {
  final String title;
  const AdminSectionContent({super.key, required this.title});

  // Small icon + description lookup per admin item, purely presentational.
  static const Map<String, IconData> _icons = {
    'Platform Administration': Icons.apartment_rounded,
    'Super Admin Management': Icons.shield_moon_outlined,
    'Global Dashboard': Icons.public_rounded,
    'Platform Configuration': Icons.settings_suggest_outlined,
    'Global Settings': Icons.tune_rounded,
    'Platform Branding': Icons.palette_outlined,
    'Feature Management': Icons.toggle_on_outlined,
    'License Management': Icons.verified_outlined,
    'Platform Health Overview': Icons.monitor_heart_outlined,
    'Settings': Icons.settings_outlined,

    'Tenant Management': Icons.domain_rounded,
    'Create Tenant': Icons.add_business_outlined,
    'Tenant Configuration': Icons.tune_rounded,
    'Tenant Branding': Icons.palette_outlined,
    'Tenant Database': Icons.storage_rounded,
    'Tenant Isolation': Icons.privacy_tip_outlined,
    'Tenant Backup': Icons.backup_outlined,

    'Organization Management': Icons.corporate_fare_rounded,
    'Company Setup': Icons.business_center_outlined,
    'Business Units': Icons.account_tree_outlined,
    'Departments': Icons.groups_2_outlined,
    'Branches': Icons.device_hub_outlined,
    'Cost Centers': Icons.attach_money_rounded,
    'Locations': Icons.location_on_outlined,

    'User Management': Icons.people_outline_rounded,
    'User Registration': Icons.person_add_alt_outlined,
    'User Import': Icons.upload_file_outlined,
    'User Profile': Icons.badge_outlined,
    'User Activation': Icons.check_circle_outline_rounded,
    'User Deactivation': Icons.block_outlined,
    'Bulk User Upload': Icons.cloud_upload_outlined,

    'Role & Permission Management': Icons.admin_panel_settings_outlined,
    'Roles': Icons.workspace_premium_outlined,
    'Permissions': Icons.key_outlined,
    'RBAC': Icons.rule_folder_outlined,
    'Data Permissions': Icons.folder_shared_outlined,
    'Department Permissions': Icons.apartment_outlined,

    'Authentication & Security': Icons.security_rounded,
    'Login': Icons.login_rounded,
    'Login History': Icons.history_rounded,
    'SSO (Single Sign-On)': Icons.sync_lock_outlined,
    'OAuth': Icons.vpn_key_outlined,
    'MFA': Icons.pin_outlined,
    'Password Policy': Icons.password_outlined,
    'Account Lockout': Icons.lock_clock_outlined,
    'Security Alerts': Icons.notification_important_outlined,
    'Device Management': Icons.devices_other_outlined,
    'Session Management': Icons.timer_outlined,

    'System Configuration': Icons.settings_suggest_outlined,
    'General Settings': Icons.tune_rounded,
    'Localization': Icons.language_rounded,
    'Currency': Icons.currency_exchange_rounded,
    'Time Zone': Icons.schedule_outlined,
    'Email Configuration': Icons.email_outlined,
    'SMS Configuration': Icons.sms_outlined,

    'Audit & Compliance': Icons.fact_check_outlined,
    'Audit Logs': Icons.receipt_long_outlined,
    'Compliance Reports': Icons.assignment_turned_in_outlined,
    'Data Retention Policy': Icons.folder_delete_outlined,
  };

  static const Map<String, String> _descriptions = {
    'Platform Administration': 'Central hub for platform-wide KPIs, system health, and recent admin activity across every module.',
    'Super Admin Management': 'Manage super admin accounts and the highest level of platform-wide access.',
    'Global Dashboard': 'Track performance, engagement and growth across every tenant and organization on the platform.',
    'Platform Configuration': 'Manage core platform identity, regional defaults, time zone, language, and security handling.',
    'Global Settings': 'Platform-wide defaults that apply across every tenant unless overridden locally.',
    'Platform Branding': 'Customize logo, brand colors, login background, and the welcome message tenants see.',
    'Feature Management': 'Roll features out by license plan and track adoption/rollout percentage across every tenant.',
    'License Management': 'Manage seat usage, renewal dates, and license status across every organization.',
    'Platform Health Overview': 'Live status per service — auth, API gateway, database, queue, storage, AI engine.',
    'Settings': 'General platform preferences, notification defaults, and account-level configuration.',

    'Tenant Management': 'Create, configure, and manage every tenant workspace on the platform from one place.',
    'Create Tenant': 'Provision a brand-new tenant workspace with its own data and configuration.',
    'Tenant Configuration': 'Per-tenant settings — session limits, upload size, environment defaults.',
    'Tenant Branding': 'Logo, colors, and login background customization scoped to a single tenant.',
    'Tenant Database': 'Each tenant owns its database — view connection health and storage usage here.',
    'Tenant Isolation': 'Security boundaries that keep one tenant\'s data fully separated from another\'s.',
    'Tenant Backup':
        'Schedule and restore point-in-time snapshots for a tenant\'s data.',

    'Organization Management': 'Business units, departments, branches, and legal entity details for the organization.',
    'Company Setup': 'Configure business units, departments, branches, and legal entity details for the organization.',
    'Business Units':
        'Group teams and cost structures under logical business units.',
    'Departments': 'Manage departments and their reporting structure across the organization.',
    'Branches': 'Manage physical or regional branch locations tied to the organization.',
    'Cost Centers':
        'Track budget ownership and spend allocation by cost center.',
    'Locations': 'Manage office and facility locations used across HR and logistics modules.',

    'User Management': 'Invite, deactivate, and manage roles for every user across the organization.',
    'User Registration':
        'Self-service and admin-invited registration flows for new users.',
    'User Import':
        'Bring in users in bulk from an existing HR or directory system.',
    'User Profile':
        'View and edit a user\'s profile details, role, and access.',
    'User Activation': 'Activate pending user accounts so they can sign in.',
    'User Deactivation':
        'Suspend a user\'s access without deleting their account history.',
    'Bulk User Upload':
        'Upload a CSV of users to create or update many accounts at once.',

    'Role & Permission Management': 'Define roles and the exact permissions each one grants across every module.',
    'Roles': 'Create and manage named roles like Admin, Manager, or Viewer.',
    'Permissions': 'The individual actions (read/write/delete) that can be granted to a role.',
    'RBAC': 'Role-Based Access Control — the engine that ties roles to permissions and users.',
    'Data Permissions': 'Control which records a role can see, independent of module-level access.',
    'Department Permissions': 'Scope access so users only see data belonging to their own department.',

    'Authentication & Security': 'Everything related to how users prove who they are, and how that access is protected.',
    'Login': 'Configure login methods and behavior across the platform.',
    'Login History':
        'Audit trail of sign-in attempts, successful and failed, per user.',
    'SSO (Single Sign-On)':
        'Let users sign in once and access every connected enterprise app.',
    'OAuth':
        'Manage OAuth client credentials for third-party app integrations.',
    'MFA': 'Require a second verification factor for sign-in, like an authenticator app.',
    'Password Policy':
        'Set minimum password strength, rotation, and reuse rules.',
    'Account Lockout':
        'Configure how many failed attempts trigger a temporary lockout.',
    'Security Alerts':
        'Real-time alerts for unusual logins or suspicious account activity.',
    'Device Management':
        'See and revoke devices that are currently signed in to an account.',
    'Session Management':
        'View and terminate active sessions across the platform.',

    'System Configuration':
        'Core system-wide technical settings for the platform.',
    'General Settings':
        'Platform name, URL, and other foundational configuration.',
    'Localization':
        'Manage supported languages and regional content formatting.',
    'Currency': 'Set the base currency and supported currencies for billing and reports.',
    'Time Zone':
        'Default time zone used across dashboards, logs, and scheduling.',
    'Email Configuration':
        'SMTP settings used to send platform notification emails.',
    'SMS Configuration':
        'SMS gateway settings used for OTPs and text notifications.',

    'Audit & Compliance': 'Centralized audit trail and compliance reporting for the entire platform.',
    'Audit Logs':
        'Comprehensive logging of administrative actions across every module.',
    'Compliance Reports': 'Generate reports needed for SOC 2, ISO 27001, and other compliance frameworks.',
    'Data Retention Policy': 'Define how long different types of data are kept before automatic deletion.',
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[title] ?? Icons.widgets_outlined;
    final description =
        _descriptions[title] ?? 'Manage this section of the OneCloud platform.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FadeSlideIn(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.ink, AppColors.ink2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withOpacity(0.25),
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
                    color: AppColors.tealData.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.tealData, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _FadeSlideIn(
          delayMs: 100,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This admin module is part of the POC. Full functionality will be connected once the backend service is ready.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textInk.withOpacity(0.75),
                    ),
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
