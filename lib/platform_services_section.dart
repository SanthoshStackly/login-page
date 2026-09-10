import 'package:flutter/material.dart';

import 'app_theme.dart';

class ServiceData {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> features;
  final String db;

  const ServiceData({
    required this.title,
    required this.icon,
    required this.color,
    required this.features,
    required this.db,
  });
}

final List<ServiceData> kPlatformServices = [
  ServiceData(
    title: 'Platform Administration',
    icon: Icons.admin_panel_settings_outlined,
    color: const Color(0xFF1565C0),
    features: [
      'Global Settings',
      'Platform Config',
      'License Mgmt.',
      'Feature Mgmt.',
      'Resource Mgmt.',
      'System Health',
      'Tenant Templates',
    ],
    db: 'Platform DB',
  ),
  ServiceData(
    title: 'HRMS Service',
    icon: Icons.badge_outlined,
    color: const Color(0xFF2E7D32),
    features: [
      'Employee Mgmt.',
      'Attendance',
      'Leave',
      'Payroll',
      'Recruitment',
      'Performance',
      'Learning',
      'ESS / MSS',
      'Asset Mgmt.',
    ],
    db: 'HRMS DB',
  ),
  ServiceData(
    title: 'CRM Service',
    icon: Icons.handshake_outlined,
    color: const Color(0xFFC2185B),
    features: [
      'Leads',
      'Opportunities',
      'Contacts',
      'Activities',
      'Pipeline',
      'Quotations',
      'Campaigns',
      'Customer Support',
    ],
    db: 'CRM DB',
  ),
  ServiceData(
    title: 'ERP Service',
    icon: Icons.factory_outlined,
    color: const Color(0xFF00838F),
    features: [
      'Inventory',
      'Procurement',
      'Production',
      'Sales Orders',
      'Dispatch',
      'Asset Mgmt.',
      'Maintenance',
      'Vendors',
    ],
    db: 'ERP DB',
  ),
  ServiceData(
    title: 'Finance & Accounting',
    icon: Icons.account_balance_outlined,
    color: const Color(0xFF00695C),
    features: [
      'General Ledger',
      'Accounts Payable',
      'Accounts Receivable',
      'Tax Management',
      'Budgeting',
      'Costing',
      'Financial Reports',
      'Reconciliation',
      'Multi-Currency',
    ],
    db: 'Finance DB',
  ),
  ServiceData(
    title: 'Workflow & Automation',
    icon: Icons.account_tree_outlined,
    color: const Color(0xFF6A1B9A),
    features: [
      'Workflow Builder',
      'Approvals',
      'Business Rules',
      'Process Automation',
      'Task Management',
      'Triggers',
      'SLAs & Escalations',
      'Process Monitoring',
      'Workflow Templates',
    ],
    db: 'Workflow DB',
  ),
  ServiceData(
    title: 'Document Management',
    icon: Icons.folder_copy_outlined,
    color: const Color(0xFF5E35B1),
    features: [
      'Document Repository',
      'Versioning',
      'File Upload/Download',
      'Access Control',
      'Document Templates',
      'Tagging & Search',
      'Retention Policies',
      'Audit Trails',
      'OCR Integration',
    ],
    db: 'DMS DB',
  ),
  ServiceData(
    title: 'Subscription Service',
    icon: Icons.card_membership_outlined,
    color: const Color(0xFFAD1457),
    features: [
      'Plans & Features',
      'Tenant Subscriptions',
      'Usage & Quotas',
      'Payment Terms',
      'License Allocation',
      'License Keys',
      'Renewals',
      'Trial Management',
      'Billing Integration',
    ],
    db: 'Subscription DB',
  ),
  ServiceData(
    title: 'Revenue Service',
    icon: Icons.trending_up_rounded,
    color: const Color(0xFF1976D2),
    features: [
      'Revenue Tracking',
      'Usage Analytics',
      'Forecasting',
      'Revenue Reports',
      'Revenue Recognition',
      'Commission Mgmt.',
      'Financial Analytics',
      'Invoicing',
      'Integration',
    ],
    db: 'Revenue DB',
  ),
  ServiceData(
    title: 'Reporting & BI',
    icon: Icons.insert_chart_outlined_rounded,
    color: const Color(0xFF00838F),
    features: [
      'Standard Reports',
      'Ad-hoc Reports',
      'Data Exploration',
      'BI Management',
      'Data Export',
      'Scheduled Reports',
      'Data Visualization',
      'Self-Service Analytics',
    ],
    db: 'Reporting DB',
  ),
  ServiceData(
    title: 'Enterprise AI',
    icon: Icons.auto_awesome_outlined,
    color: const Color(0xFF283593),
    features: [
      'AI Models',
      'AI Chat / Copilot',
      'Document AI / OCR',
      'Predictive Analytics',
      'Recommendations',
      'AI Workflows',
      'Model Management',
      'Prompt Engineering',
      'AI Usage Logs',
    ],
    db: 'AI DB',
  ),
  ServiceData(
    title: 'Notification Service',
    icon: Icons.notifications_active_outlined,
    color: const Color(0xFFEF6C00),
    features: [
      'In-App Notifications',
      'Email Notifications',
      'SMS Notifications',
      'Push Notifications',
      'Templates',
      'Preferences',
      'Integrations (Google, Outlook)',
      'Availability',
      'Event Notifications',
    ],
    db: 'Notification DB',
  ),
  ServiceData(
    title: 'Calendar Service',
    icon: Icons.calendar_month_outlined,
    color: const Color(0xFF00838F),
    features: [
      'User Calendars',
      'Team Calendars',
      'Meeting Scheduler',
      'Resource Booking',
      'Reminders',
      'Schedules',
      'Delivery Tracking',
      'Shared Calendars',
    ],
    db: 'Calendar DB',
  ),
  ServiceData(
    title: 'Integration Service',
    icon: Icons.hub_outlined,
    color: const Color(0xFF7B1FA2),
    features: [
      'API Management',
      'Third-Party Integration',
      'Webhooks',
      'Event Streaming',
      'Data Transformation',
      'ETL / Data Sync',
      'Connectors (ERP, Bank, Payment, etc.)',
      'Integration Logs',
    ],
    db: 'Integration DB',
  ),
  ServiceData(
    title: 'Search Service',
    icon: Icons.travel_explore_outlined,
    color: const Color(0xFF1565C0),
    features: [
      'Global Search',
      'Index Management',
      'Search Analytics',
      'Autocomplete',
      'Relevance Ranking',
      'Saved Searches',
      'Multi-Tenant Index',
      'Synonyms',
      'Suggestion Engine',
    ],
    db: 'Search DB',
  ),
  ServiceData(
    title: 'Security & Compliance',
    icon: Icons.shield_outlined,
    color: const Color(0xFFC62828),
    features: [
      'Audit Logs',
      'Activity Tracking',
      'Compliance Reports',
      'Data Retention',
      'Policy Management',
      'Threat Detection',
      'Vulnerability Mgmt.',
      'Encryption & Key Mgmt.',
      'Security Alerts',
    ],
    db: 'Security DB',
  ),
];

class PlatformServicesSection extends StatelessWidget {
  final String searchQuery;
  const PlatformServicesSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? kPlatformServices
        : kPlatformServices.where((s) {
            final inTitle = s.title.toLowerCase().contains(query);
            final inFeatures = s.features.any(
              (f) => f.toLowerCase().contains(query),
            );
            return inTitle || inFeatures;
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Domain Microservices Layer — each domain runs as one independent microservice',
          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
        ),
        const SizedBox(height: 18),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No services match "$searchQuery"',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 1;
              if (constraints.maxWidth > 1300) {
                columns = 4;
              } else if (constraints.maxWidth > 950) {
                columns = 3;
              } else if (constraints.maxWidth > 600) {
                columns = 2;
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 280,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return _ServiceCardAnimated(
                    index: index,
                    service: filtered[index],
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

class _ServiceCardAnimated extends StatefulWidget {
  final int index;
  final ServiceData service;
  const _ServiceCardAnimated({required this.index, required this.service});

  @override
  State<_ServiceCardAnimated> createState() => _ServiceCardAnimatedState();
}

class _ServiceCardAnimatedState extends State<_ServiceCardAnimated> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(16),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: s.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(s.icon, color: s.color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: s.features.take(6).map((f) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: s.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: s.color.withOpacity(0.25)),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: s.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.storage_rounded, size: 14, color: s.color),
                  const SizedBox(width: 6),
                  Text(
                    s.db,
                    style: TextStyle(
                      fontSize: 11,
                      color: s.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
