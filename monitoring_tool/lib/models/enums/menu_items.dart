import 'package:flutter/material.dart';

enum NavigationItems {
  Home,
  Logs,
  Devices,
  Utilities,
  Settings,
}

extension NavigationItemsExtensions on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.Home:
        return Icons.home;
      case NavigationItems.Logs:
        return Icons.dvr;
      case NavigationItems.Devices:
        return Icons.smartphone;
      case NavigationItems.Utilities:
        return Icons.build;
      case NavigationItems.Settings:
        return Icons.settings;
      default:
        return Icons.warning;
    }
  }
}
