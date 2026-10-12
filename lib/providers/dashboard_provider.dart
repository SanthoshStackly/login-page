import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_data.dart';

class DashboardState {
  final bool sidebarOpen;
  final ServiceData? selectedService;
  final String? focusedFeature;
  final String? selectedAdminItem;
  final String searchQuery;

  const DashboardState({
    this.sidebarOpen = false,
    this.selectedService,
    this.focusedFeature,
    this.selectedAdminItem,
    this.searchQuery = '',
  });

  DashboardState copyWith({
    bool? sidebarOpen,
    ServiceData? selectedService,
    bool clearSelectedService = false,
    String? focusedFeature,
    bool clearFocusedFeature = false,
    String? selectedAdminItem,
    bool clearSelectedAdminItem = false,
    String? searchQuery,
  }) {
    return DashboardState(
      sidebarOpen: sidebarOpen ?? this.sidebarOpen,
      selectedService: clearSelectedService
          ? null
          : (selectedService ?? this.selectedService),
      focusedFeature: clearFocusedFeature
          ? null
          : (focusedFeature ?? this.focusedFeature),
      selectedAdminItem: clearSelectedAdminItem
          ? null
          : (selectedAdminItem ?? this.selectedAdminItem),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  String get headingTitle =>
      selectedAdminItem ?? selectedService?.title ?? 'Dashboard';

  String get headingSubtitle {
    if (selectedAdminItem != null) return 'Platform Administration module';
    if (selectedService != null) {
      return focusedFeature != null
          ? '${selectedService!.title} — $focusedFeature'
          : 'Domain Microservice — ${selectedService!.db}';
    }
    return 'Welcome to OneCloud Enterprise Platform';
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState());

  void toggleSidebar() {
    state = state.copyWith(sidebarOpen: !state.sidebarOpen);
  }

  void closeSidebar() {
    state = state.copyWith(sidebarOpen: false);
  }

  void selectDashboard() {
    state = state.copyWith(
      clearSelectedService: true,
      clearFocusedFeature: true,
      clearSelectedAdminItem: true,
    );
  }

  /// Selecting a service alone (e.g. clicking "HRMS" itself, or its
  /// "Dashboard" sub-item) shows the full overview - no single feature focused.
  void selectService(ServiceData service, {String? feature}) {
    state = state.copyWith(
      selectedService: service,
      focusedFeature: feature,
      clearFocusedFeature: feature == null,
      clearSelectedAdminItem: true,
    );
  }

  void selectAdminItem(String label) {
    state = state.copyWith(
      selectedAdminItem: label,
      clearSelectedService: true,
      clearFocusedFeature: true,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      return DashboardNotifier();
    });
