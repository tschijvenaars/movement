import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/infrastructure/repositories/network/auth_api.dart';

import '../../../providers.dart';

///Custom floating action button which triggers onPressed function depending on the page.
class CustomFloatingActionButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navNotifier = ref.watch(appNavigationNotifier);
    final authNotifier = ref.watch(authApi);
    var page = navNotifier.currentPage;
    if (page < 3 && authNotifier.isAuthenticated == Authenticated.AUTHENTICATED) {
      return SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
            child: const Icon(
              Icons.refresh,
              size: 69,
            ),
            hoverColor: Colors.lightBlue,
            elevation: 12,
            onPressed: () async {
              switch (page) {
                case 0:
                  final notifier = ref.read(userDeviceKpiNotifier);
                  notifier.getUserKpis();
                  break;
                case 1:
                  final notifier = ref.read(logsNotifierProvider.notifier);
                  notifier.getAllLogs();
                  break;
                case 2:
                  final notifier = ref.watch(devicesNotifierProvider.notifier);
                  await notifier.getDevices();
                  break;
                default:
                  print('pressed the default fab');
                  break;
              }
            }),
      );
    } else {
      return Container();
    }
  }
}
