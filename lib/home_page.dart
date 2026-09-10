import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'routes/app_routes.dart';
import 'platform_services_section.dart';
import 'service_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _sidebarOpen = false; // starts CLOSED - opens on menu click
  String _searchQuery = '';

  void _openService(ServiceData service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServiceDetailPage(service: service)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            width: _sidebarOpen ? 260 : 0,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppColors.borderGrey)),
            ),
            child: _sidebarOpen
                ? _buildSidebar(context)
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Column(
              children: [
                _buildNavbar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: _buildDashboardContent(),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============== SIDEBAR ==============
  Widget _buildSidebar(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.lightBlue, AppColors.primaryBlue],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cloud_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OneCloud',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      Text(
                        'Enterprise Platform',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _navItem(
                  Icons.dashboard_rounded,
                  'Dashboard',
                  selected: true,
                  onTap: () {
                    setState(() => _sidebarOpen = false);
                  },
                ),
                _sectionLabel('SERVICES'),
                ...kPlatformServices.map(
                  (s) =>
                      _navItem(s.icon, s.title, onTap: () => _openService(s)),
                ),
                _sectionLabel('SYSTEM'),
                _navItem(Icons.settings_outlined, 'Settings', onTap: () {}),
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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label, {
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return _HoverNavItem(
      icon: icon,
      label: label,
      selected: selected,
      onTap: onTap,
    );
  }

  // ============== NAVBAR ==============
  Widget _buildNavbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.darkNavy),
            onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textGrey, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search employees, customers, documents...',
                        hintStyle: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13.5,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() => _searchQuery = ''),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textGrey,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.darkNavy,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryBlue,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryBlue,
                child: Text(
                  UserSession.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                UserSession.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textGrey,
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(color: AppColors.darkNavy),
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

  // ============== DASHBOARD CONTENT ==============
  Widget _buildDashboardContent() {
    // If the user is searching, show only the filtered services list -
    // this makes the search bar feel functional and focused.
    if (_searchQuery.trim().isNotEmpty) {
      return PlatformServicesSection(searchQuery: _searchQuery);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome to OneCloud Enterprise Platform',
          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(height: 24),

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
            final salesPipeline = _FadeSlideInLocal(
              delayMs: 400,
              child: _buildSalesPipeline(),
            );
            final pendingApprovals = _FadeSlideInLocal(
              delayMs: 500,
              child: _buildPendingApprovals(),
            );
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
    return _FadeSlideInLocal(
      delayMs: index * 100,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
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
        border: Border.all(color: AppColors.borderGrey),
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
                  _AnimatedProgressBarLocal(percent: item['percent'] as double),
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
        border: Border.all(color: AppColors.borderGrey),
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
  final VoidCallback onTap;
  const _HoverNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
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
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
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
              size: 20,
              color: active ? AppColors.primaryBlue : AppColors.textGrey,
            ),
            title: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13.5,
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

// ============== LOCAL ANIMATION HELPERS ==============
class _FadeSlideInLocal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _FadeSlideInLocal({required this.child, this.delayMs = 0});

  @override
  State<_FadeSlideInLocal> createState() => _FadeSlideInLocalState();
}

class _FadeSlideInLocalState extends State<_FadeSlideInLocal> {
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
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _AnimatedProgressBarLocal extends StatelessWidget {
  final double percent;
  const _AnimatedProgressBarLocal({required this.percent});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percent),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.borderGrey,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        );
      },
    );
  }
}
