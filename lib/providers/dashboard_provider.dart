import 'package:flutter/material.dart';

import '../models/service_data.dart';

class DashboardProvider extends ChangeNotifier {
  bool sidebarOpen = false;
  ServiceData? selectedService;
  String searchQuery = '';

  void toggleSidebar() {
    sidebarOpen = !sidebarOpen;
    notifyListeners();
  }

  void selectDashboard() {
    selectedService = null;
    notifyListeners();
  }

  void selectService(ServiceData service) {
    selectedService = service;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  String get headingTitle => selectedService?.title ?? 'Dashboard';

  String get headingSubtitle => selectedService != null
      ? 'Domain Microservice — ${selectedService!.db}'
      : 'Welcome to OneCloud Enterprise Platform';
}
