import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/presentation/widgets/user_kpi_widget.dart';

import '../infrastructure/repositories/network/auth_api.dart';
import '../providers.dart';
import 'locked_page.dart';
import 'widgets/device_kpi_widget.dart';

class GeneralOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: ((context, ref, child) {
        final provider = ref.watch(authApi);
        if (provider.isAuthenticated == Authenticated.AUTHENTICATED) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserKpiWidget(),
                  const SizedBox(
                    height: 12.0,
                  ),
                  DeviceKpiWidget(),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          );
        } else {
          return LockedPage();
        }
      }),
    );
  }
}
