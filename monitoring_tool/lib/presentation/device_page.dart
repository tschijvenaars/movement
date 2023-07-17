import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infrastructure/repositories/network/auth_api.dart';
import '../providers.dart';
import 'locked_page.dart';
import 'widgets/device_summary_widget.dart';

class DeviceOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: ((context, ref, child) {
        final authProvider = ref.watch(authApi);
        if (authProvider.isAuthenticated == Authenticated.AUTHENTICATED) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DevicesWidget(),
                  // const SizedBox(
                  //   height: 12.0,
                  // ),
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
