import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/presentation/locked_page.dart';
import 'package:monitoring_tool/providers.dart';

import '../infrastructure/repositories/network/auth_api.dart';
import 'widgets/multiple_user_signup_widget.dart';
import 'widgets/single_user_signup_widget.dart';

class SignUpOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: ((context, ref, child) {
      final provider = ref.watch(authApi);
      if (provider.isAuthenticated == Authenticated.AUTHENTICATED) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleUserSignup(),
                const SizedBox(
                  height: 12.0,
                ),
                MultiUserSignup(),
              ],
            ),
          ),
        );
      } else {
        return LockedPage();
      }
    }));
  }
}
