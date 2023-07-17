import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/login_admin_widget.dart';
import 'widgets/network_settings_widget.dart';
import 'widgets/placeholder_widget.dart';

class SettingsOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkSettingsWidget(),
          const SizedBox(
            height: 12.0,
          ),
          LoginAdminWidget(),
        ],
      ),
    );
  }
}
