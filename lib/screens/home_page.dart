import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_theme.dart';
import '../routes/app_routes.dart';
import '../models/service_data.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/platform_services_section.dart';
import '../widgets/service_content.dart';
import '../widgets/admin_section_content.dart';

const double kMobileBreakpoint = 700;

// ------------------------------------------------------------
// Full Platform Administration sidebar structure - one entry per
// collapsible group, each with its own list of real sub-items.
// Clicking any sub-item (or the group's own matching overview item)
// opens AdminSectionContent for that label inline in the dashboard.
// ------------------------------------------------------------
class _AdminGroupData {
  final IconData icon;
  final String label;
  final List<String> items; // first item is the group's own overview page
  const _AdminGroupData({
    required this.icon,
    required this.label,
    required this.items,
  });
}

final List<_AdminGroupData> _kAdminGroups = [
  const _AdminGroupData(
    icon: Icons.apartment_rounded,
    label: 'PLATFORM ADMINISTRATION',
    items: [
      'Platform Administration',
      'Super Admin Management',
      'Global Dashboard',
      'Platform Configuration',
      'Global Settings',
      'Platform Branding',
      'License Management',
      'Feature Management',
      'Platform Health Overview',
      'Settings',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.domain_rounded,
    label: 'TENANT MANAGEMENT',
    items: [
      'Tenant Management',
      'Create Tenant',
      'Tenant Configuration',
      'Tenant Branding',
      'Tenant Database',
      'Tenant Isolation',
      'Tenant Backup',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.corporate_fare_rounded,
    label: 'ORGANIZATION MANAGEMENT',
    items: [
      'Organization Management',
      'Company Setup',
      'Business Units',
      'Departments',
      'Branches',
      'Cost Centers',
      'Locations',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.people_outline_rounded,
    label: 'USER MANAGEMENT',
    items: [
      'User Management',
      'User Registration',
      'User Import',
      'User Profile',
      'User Activation',
      'User Deactivation',
      'Bulk User Upload',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.admin_panel_settings_outlined,
    label: 'ROLE & PERMISSION MANAGEMENT',
    items: [
      'Role & Permission Management',
      'Roles',
      'Permissions',
      'RBAC',
      'Data Permissions',
      'Department Permissions',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.security_rounded,
    label: 'AUTHENTICATION & SECURITY',
    items: [
      'Authentication & Security',
      'Login',
      'Login History',
      'SSO (Single Sign-On)',
      'OAuth',
      'MFA',
      'Password Policy',
      'Account Lockout',
      'Security Alerts',
      'Device Management',
      'Session Management',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.settings_suggest_outlined,
    label: 'SYSTEM CONFIGURATION',
    items: [
      'System Configuration',
      'General Settings',
      'Localization',
      'Currency',
      'Time Zone',
      'Email Configuration',
      'SMS Configuration',
    ],
  ),
  const _AdminGroupData(
    icon: Icons.fact_check_outlined,
    label: 'AUDIT & COMPLIANCE',
    items: [
      'Audit & Compliance',
      'Audit Logs',
      'Compliance Reports',
      'Data Retention Policy',
    ],
  ),
];

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paperDim,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < kMobileBreakpoint;

          return Stack(
            children: [
              Row(
                children: [
                  if (!isMobile)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      width: state.sidebarOpen ? 260 : 0,
                      clipBehavior: Clip.hardEdge,
                      color: AppColors.ink,
                      child: state.sidebarOpen
                          ? _buildSidebar(context, state, notifier, isMobile)
                          : const SizedBox.shrink(),
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildNavbar(context, state, notifier, isMobile),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            isMobile ? 16 : 28,
                            16,
                            isMobile ? 16 : 28,
                            14,
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Breadcrumb
                              Text(
                                state.selectedService != null
                                    ? 'Platform Administration  /  ${state.headingTitle}'
                                    : 'Platform Administration  /  Dashboard',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                state.headingTitle,
                                style: TextStyle(
                                  fontSize: isMobile ? 19 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textInk,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Welcome back, ${UserSession.name}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              isMobile ? 16 : 28,
                              18,
                              isMobile ? 16 : 28,
                              24,
                            ),
                            child: _buildContent(
                              context,
                              state,
                              notifier,
                              isMobile,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isMobile && state.sidebarOpen) ...[
                GestureDetector(
                  onTap: () => notifier.toggleSidebar(),
                  child: Container(color: Colors.black.withOpacity(0.45)),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  width: constraints.maxWidth * 0.82 > 280
                      ? 280
                      : constraints.maxWidth * 0.82,
                  child: Material(
                    elevation: 14,
                    child: _buildSidebar(context, state, notifier, isMobile),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // ============== SIDEBAR (dark Ink theme) ==============
  Widget _buildSidebar(
    BuildContext context,
    DashboardState state,
    DashboardNotifier notifier,
    bool isMobile,
  ) {
    // Explicit ink background here (not just on the outer wrapper) so the
    // sidebar always looks correct - including the mobile overlay, where
    // Material's default white background would otherwise show through.
    return Container(
      color: AppColors.ink,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.tealData, AppColors.info],
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (isMobile) ...[
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => notifier.toggleSidebar(),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tealData.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ONE ENTERPRISE CLOUD',
                  style: TextStyle(
                    color: AppColors.tealData,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(8),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  children: [
                    _sideItem(
                      Icons.dashboard_rounded,
                      'Dashboard',
                      selected:
                          state.selectedService == null &&
                          state.selectedAdminItem == null,
                      onTap: () {
                        notifier.selectDashboard();
                        if (isMobile) notifier.toggleSidebar();
                      },
                    ),
                    const SizedBox(height: 6),
                    ..._kAdminGroups.map((group) {
                      return _AdminExpansionGroup(
                        icon: group.icon,
                        label: group.label,
                        items: group.items,
                        activeItem: state.selectedAdminItem,
                        onSelectItem: (item) {
                          notifier.selectAdminItem(item);
                          if (isMobile) notifier.toggleSidebar();
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    _groupLabel('ENTERPRISE SERVICES'),
                    ...kPlatformServices.map((s) {
                      return _ServiceExpansionGroup(
                        service: s,
                        isServiceSelected:
                            state.selectedService?.title == s.title,
                        focusedFeature: state.selectedService?.title == s.title
                            ? state.focusedFeature
                            : null,
                        onSelectDashboard: () {
                          notifier.selectService(s);
                          if (isMobile) notifier.toggleSidebar();
                        },
                        onSelectFeature: (feature) {
                          notifier.selectService(s, feature: feature);
                          if (isMobile) notifier.toggleSidebar();
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    _groupLabel('ORGANIZATION'),
                    _sideItem(
                      Icons.business_center_outlined,
                      'Company Setup',
                      selected: state.selectedAdminItem == 'Company Setup',
                      onTap: () {
                        notifier.selectAdminItem('Company Setup');
                        if (isMobile) notifier.toggleSidebar();
                      },
                    ),
                    _sideItem(
                      Icons.people_outline_rounded,
                      'User Management',
                      selected: state.selectedAdminItem == 'User Management',
                      onTap: () {
                        notifier.selectAdminItem('User Management');
                        if (isMobile) notifier.toggleSidebar();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.white.withOpacity(0.1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 15,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'English',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.tealData,
                    child: Text(
                      UserSession.initials,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserSession.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          'Super Admin',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 16),
              child: InkWell(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: AppColors.danger.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.35),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _sideItem(
    IconData icon,
    String label, {
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return _HoverSideItem(
      icon: icon,
      label: label,
      selected: selected,
      onTap: onTap,
    );
  }

  // ============== NAVBAR ==============
  Widget _buildNavbar(
    BuildContext context,
    DashboardState state,
    DashboardNotifier notifier,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 20,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded, color: AppColors.textInk),
            onPressed: () => notifier.toggleSidebar(),
          ),
          const SizedBox(width: 4),
          if (!isMobile)
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                constraints: const BoxConstraints(maxWidth: 360),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textMuted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => notifier.setSearchQuery(v),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textInk,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Search tenants, users, settings, audit logs...',
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.5,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    if (state.searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => notifier.setSearchQuery(''),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.textMuted,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.search, color: AppColors.textInk),
              onPressed: () => _showMobileSearch(context, notifier),
            ),
          const Spacer(),
          if (!isMobile) ...[
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textInk,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: AppColors.textInk),
              onPressed: () {},
            ),
            const SizedBox(width: 6),
          ],
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.ink,
            child: Text(
              UserSession.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserSession.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInk,
                    fontSize: 12.5,
                  ),
                ),
                Text(
                  'Super Admin',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }

  void _showMobileSearch(BuildContext context, DashboardNotifier notifier) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notifier.setSearchQuery(c.text);
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  // ============== CONTENT ==============
  Widget _buildContent(
    BuildContext context,
    DashboardState state,
    DashboardNotifier notifier,
    bool isMobile,
  ) {
    if (state.searchQuery.trim().isNotEmpty) {
      return PlatformServicesSection(searchQuery: state.searchQuery);
    }
    if (state.selectedAdminItem != null) {
      return AdminSectionContent(title: state.selectedAdminItem!);
    }

    if (state.selectedService != null) {
      return ServiceContent(
        service: state.selectedService!,
        focusedFeature: state.focusedFeature,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stat cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final cards = [
              _statCard(
                'Total Users',
                '96,412',
                '+1.8% this month',
                Icons.people_alt_rounded,
                AppColors.info,
              ),
              _statCard(
                'Active Users',
                '78,930',
                '4,215 online now',
                Icons.wifi_tethering_rounded,
                AppColors.success,
              ),
              _statCard(
                'Organizations',
                '1,842',
                '+4.2% this month',
                Icons.apartment_rounded,
                AppColors.amberAI,
              ),
              _statCard(
                'Licenses Active',
                '2,140',
                '27 expiring in 30 days',
                Icons.verified_rounded,
                AppColors.ink,
                highlight: true,
              ),
            ];
            return isWide
                ? Row(
                    children: cards
                        .map(
                          (c) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: c,
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Column(
                    children: cards
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: c,
                          ),
                        )
                        .toList(),
                  );
          },
        ),
        const SizedBox(height: 26),

        // System Status
        const Text(
          'System Status',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textInk,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final items = [
              _statusPill('Server Status', 'Healthy', AppColors.success),
              _statusPill('Database', 'Connected', AppColors.success),
              _statusPill('API Gateway', 'Running', AppColors.success),
              _statusPill('Storage', '68% used', AppColors.warning),
            ];
            return isWide
                ? Row(
                    children: items
                        .map(
                          (c) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: c,
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: items
                        .map(
                          (c) => SizedBox(
                            width: (constraints.maxWidth - 12) / 2,
                            child: c,
                          ),
                        )
                        .toList(),
                  );
          },
        ),
        const SizedBox(height: 26),

        // Resource Utilization
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resource Utilization',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textInk,
                ),
              ),
              const SizedBox(height: 16),
              _resourceBar('CPU usage', 0.42, AppColors.info),
              const SizedBox(height: 14),
              _resourceBar('Memory usage', 0.57, AppColors.tealData),
              const SizedBox(height: 14),
              _resourceBar('Storage', 0.68, AppColors.amberAI),
            ],
          ),
        ),
        const SizedBox(height: 26),

        // Alerts
        const Text(
          'Alerts & Notifications',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textInk,
          ),
        ),
        const SizedBox(height: 12),
        _alertBox(
          Icons.warning_amber_rounded,
          'License expiring soon',
          '27 licenses expiring within 30 days. Review renewals before Sep 30.',
          AppColors.warning,
        ),
        const SizedBox(height: 10),
        _alertBox(
          Icons.info_outline_rounded,
          'Organizations awaiting approval',
          '3 organizations submitted self-signup, pending review.',
          AppColors.info,
        ),
        const SizedBox(height: 10),
        _alertBox(
          Icons.error_outline_rounded,
          'Unusual login pattern detected',
          'Multiple logins from new locations for one organization.',
          AppColors.danger,
        ),
        const SizedBox(height: 32),

        // Quick Navigation / Platform Services
        const PlatformServicesSection(),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color, {
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlight ? AppColors.ink : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: highlight ? null : Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: highlight
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.textMuted,
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: highlight
                      ? Colors.white.withOpacity(0.15)
                      : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: highlight ? Colors.white : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.white : AppColors.textInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: highlight
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resourceBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textInk),
            ),
            Text(
              '${(percent * 100).round()}%',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textInk,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: AppColors.paperDim,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _alertBox(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverSideItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _HoverSideItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  State<_HoverSideItem> createState() => _HoverSideItemState();
}

class _HoverSideItemState extends State<_HoverSideItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovering;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.tealData.withOpacity(0.15)
                : (_hovering
                      ? Colors.white.withOpacity(0.06)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: active
                    ? AppColors.tealData
                    : Colors.white.withOpacity(0.55),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.65),
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== SERVICE SIDEBAR GROUP (expandable, with real sub-items) ==============
// ============== ADMIN SIDEBAR GROUP (expandable, generic) ==============
// Same visual pattern as _ServiceExpansionGroup below, but driven purely
// by strings (_AdminGroupData) instead of ServiceData - reuses the same
// _ExpansionHeader / _SubItem building blocks.
class _AdminExpansionGroup extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final String? activeItem;
  final ValueChanged<String> onSelectItem;

  const _AdminExpansionGroup({
    required this.icon,
    required this.label,
    required this.items,
    required this.activeItem,
    required this.onSelectItem,
  });

  @override
  State<_AdminExpansionGroup> createState() => _AdminExpansionGroupState();
}

class _AdminExpansionGroupState extends State<_AdminExpansionGroup> {
  bool _expanded = false;

  bool get _isGroupActive => widget.items.contains(widget.activeItem);

  @override
  void didUpdateWidget(covariant _AdminExpansionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isGroupActive && !_expanded) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExpansionHeader(
          icon: widget.icon,
          label: widget.label,
          active: _isGroupActive,
          expanded: _expanded,
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.items.map((item) {
                      // The first item (same name as the group) acts as that
                      // group's own overview page - shown with a grid icon.
                      final isOverview = item == widget.items.first;
                      return _SubItem(
                        icon: isOverview
                            ? Icons.grid_view_rounded
                            : Icons.circle,
                        iconSize: isOverview ? 15 : 6,
                        label: item,
                        active: widget.activeItem == item,
                        onTap: () => widget.onSelectItem(item),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _ServiceExpansionGroup extends StatefulWidget {
  final ServiceData service;
  final bool isServiceSelected;
  final String? focusedFeature;
  final VoidCallback onSelectDashboard;
  final ValueChanged<String> onSelectFeature;

  const _ServiceExpansionGroup({
    required this.service,
    required this.isServiceSelected,
    required this.focusedFeature,
    required this.onSelectDashboard,
    required this.onSelectFeature,
  });

  @override
  State<_ServiceExpansionGroup> createState() => _ServiceExpansionGroupState();
}

class _ServiceExpansionGroupState extends State<_ServiceExpansionGroup> {
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant _ServiceExpansionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-expand the group when one of its items becomes the active selection.
    if (widget.isServiceSelected && !_expanded) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExpansionHeader(
          icon: s.icon,
          label: s.title,
          active: widget.isServiceSelected,
          expanded: _expanded,
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SubItem(
                        icon: Icons.grid_view_rounded,
                        label: '${s.title} Dashboard',
                        active:
                            widget.isServiceSelected &&
                            widget.focusedFeature == null,
                        onTap: widget.onSelectDashboard,
                      ),
                      ...s.features.map(
                        (f) => _SubItem(
                          icon: Icons.circle,
                          iconSize: 6,
                          label: f,
                          active: widget.focusedFeature == f,
                          onTap: () => widget.onSelectFeature(f),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _ExpansionHeader extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool expanded;
  final VoidCallback onTap;
  const _ExpansionHeader({
    required this.icon,
    required this.label,
    required this.active,
    required this.expanded,
    required this.onTap,
  });

  @override
  State<_ExpansionHeader> createState() => _ExpansionHeaderState();
}

class _ExpansionHeaderState extends State<_ExpansionHeader> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.active || _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.tealData.withOpacity(0.12)
                : (_hover
                      ? Colors.white.withOpacity(0.06)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: highlight
                    ? AppColors.tealData
                    : Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: highlight
                        ? Colors.white
                        : Colors.white.withOpacity(0.65),
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AnimatedRotation(
                turns: widget.expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubItem extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SubItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.iconSize = 15,
  });

  @override
  State<_SubItem> createState() => _SubItemState();
}

class _SubItemState extends State<_SubItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.active || _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8, bottom: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: highlight
                ? Colors.white.withOpacity(0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border(
              left: BorderSide(
                color: widget.active
                    ? AppColors.tealData
                    : Colors.white.withOpacity(0.12),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(
                widget.icon,
                size: widget.iconSize,
                color: widget.active
                    ? AppColors.tealData
                    : Colors.white.withOpacity(0.45),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: widget.active
                        ? Colors.white
                        : Colors.white.withOpacity(0.55),
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
