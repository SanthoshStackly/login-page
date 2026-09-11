import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../routes/app_routes.dart';
import '../models/service_data.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/platform_services_section.dart';
import '../widgets/service_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          return Row(
            children: [
              // ---------------- SIDEBAR ----------------
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                width: provider.sidebarOpen ? 270 : 0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceGrey,
                  border: Border(
                    right: BorderSide(color: AppColors.borderGrey),
                  ),
                ),
                child: provider.sidebarOpen
                    ? _buildSidebar(context, provider)
                    : const SizedBox.shrink(),
              ),

              // ---------------- MAIN AREA ----------------
              Expanded(
                child: Column(
                  children: [
                    _buildNavbar(context, provider),

                    // Sticky heading - stays fixed while content below scrolls
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.headingTitle,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.headingSubtitle,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Scrollable content only
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                        child: _buildContent(context, provider),
                      ),
                    ),

                    _buildFooter(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============== SIDEBAR ==============
  Widget _buildSidebar(BuildContext context, DashboardProvider provider) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            color: Colors.white,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/onecloud_logo.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _flatItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  selected: provider.selectedService == null,
                  onTap: () => provider.selectDashboard(),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    'SERVICES',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGrey,
                      letterSpacing: 0.6,
                    ),
                  ),
                  childrenPadding: EdgeInsets.zero,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                  children: kPlatformServices.map((s) {
                    final selected = provider.selectedService?.title == s.title;
                    return _flatItem(
                      icon: s.icon,
                      label: s.title,
                      selected: selected,
                      dense: true,
                      onTap: () => provider.selectService(s),
                    );
                  }).toList(),
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: const Text(
                    'SYSTEM',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGrey,
                      letterSpacing: 0.6,
                    ),
                  ),
                  childrenPadding: EdgeInsets.zero,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _flatItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryBlue,
                  child: Text(
                    UserSession.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flatItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
    bool dense = false,
  }) {
    return _HoverNavItem(
      icon: icon,
      label: label,
      selected: selected,
      onTap: onTap,
      dense: dense,
    );
  }

  // ============== NAVBAR ==============
  Widget _buildNavbar(BuildContext context, DashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.darkNavy,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => provider.toggleSidebar(),
          ),
          const SizedBox(width: 6),
          // Compact search bar - fixed small width, not stretched
          Container(
            width: 260,
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) => provider.setSearchQuery(value),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (provider.searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => provider.setSearchQuery(''),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.lightBlue,
                child: Text(
                  UserSession.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                UserSession.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============== FOOTER ==============
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.darkNavy,
      child: Text(
        '© 2026 OneCloud Enterprise Platform. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          color: Colors.white.withOpacity(0.75),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ============== SCROLLABLE CONTENT ==============
  Widget _buildContent(BuildContext context, DashboardProvider provider) {
    // Search overrides everything - shows filtered services
    if (provider.searchQuery.trim().isNotEmpty) {
      return PlatformServicesSection(searchQuery: provider.searchQuery);
    }

    // A specific service was clicked - show its content inline
    if (provider.selectedService != null) {
      return ServiceContent(service: provider.selectedService!);
    }

    // Default: full dashboard view
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final cards = [
              _statCard(
                0,
                'Revenue',
                '₹12.5M',
                '+8.5% this month',
                Icons.trending_up_rounded,
                Colors.green,
              ),
              _statCard(
                1,
                'Profit',
                '₹4.2M',
                '+6.2% this month',
                Icons.account_balance_rounded,
                AppColors.primaryBlue,
              ),
              _statCard(
                2,
                'Employees',
                '2,458',
                'Active employees',
                Icons.groups_rounded,
                AppColors.lightBlue,
              ),
              _statCard(
                3,
                'Customers',
                '1,284',
                '+12.4% growth',
                Icons.apartment_rounded,
                Colors.orange,
              ),
            ];
            return isWide
                ? Row(
                    children: cards
                        .map(
                          (c) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
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
                            padding: const EdgeInsets.only(bottom: 16),
                            child: c,
                          ),
                        )
                        .toList(),
                  );
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final salesPipeline = _buildSalesPipeline();
            final pendingApprovals = _buildPendingApprovals();
            return isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: salesPipeline),
                      const SizedBox(width: 16),
                      Expanded(child: pendingApprovals),
                    ],
                  )
                : Column(
                    children: [
                      salesPipeline,
                      const SizedBox(height: 16),
                      pendingApprovals,
                    ],
                  );
          },
        ),
        const SizedBox(height: 32),
        const PlatformServicesSection(),
      ],
    );
  }

  Widget _statCard(
    int index,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                title,
                style: TextStyle(fontSize: 13.5, color: AppColors.textGrey),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesPipeline() {
    final items = [
      {'label': 'Leads', 'value': 428, 'percent': 1.0},
      {'label': 'Opportunities', 'value': 186, 'percent': 0.55},
      {'label': 'Quotations', 'value': 92, 'percent': 0.35},
      {'label': 'Closed Deals', 'value': 47, 'percent': 0.18},
    ];
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.12), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales Pipeline',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['label'] as String,
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                      Text(
                        '${item['value']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: item['percent'] as double),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: AppColors.borderGrey,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovals() {
    final items = [
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'Purchase Request',
        'subtitle': '₹2,40,000',
      },
      {
        'icon': Icons.person_outline_rounded,
        'title': 'Leave Request',
        'subtitle': '3 Employees',
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'Expense Claim',
        'subtitle': '₹18,500',
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Document Approval',
        'subtitle': '5 Documents',
      },
    ];
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.12), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Approvals',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '8 Pending',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              subtitle: Text(
                item['subtitle'] as String,
                style: TextStyle(color: AppColors.textGrey, fontSize: 12.5),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textGrey,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ============== SIDEBAR NAV ITEM WITH HOVER ==============
class _HoverNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool dense;
  final VoidCallback onTap;
  const _HoverNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.dense = false,
  });

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
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
          margin: EdgeInsets.symmetric(
            horizontal: widget.dense ? 10 : 10,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primaryBlue.withOpacity(
                    widget.selected ? 0.1 : 0.06,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            leading: Icon(
              widget.icon,
              size: 19,
              color: active ? AppColors.primaryBlue : AppColors.textGrey,
            ),
            title: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                color: active ? AppColors.primaryBlue : AppColors.textDark,
                fontWeight: widget.selected
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
