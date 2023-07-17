import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/infrastructure/repositories/network/auth_api.dart';
import 'package:monitoring_tool/providers.dart';

class LoginAdminWidget extends ConsumerWidget {
  const LoginAdminWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Login Admin',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12.0),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text('Username: '),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Consumer(builder: ((context, ref, child) {
                        final notifier = ref.watch(settingsNotifier);
                        return TextField(
                          enabled: !notifier.loginButtonDisabled,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          controller: notifier.usernameTextControl,
                        );
                      })),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text('Password: '),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Consumer(builder: ((context, ref, child) {
                        final notifier = ref.watch(settingsNotifier);
                        return TextField(
                          obscureText: true,
                          enabled: !notifier.loginButtonDisabled,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          controller: notifier.passwordTextControl,
                        );
                      })),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Consumer(
                    builder: ((context, ref, child) {
                      final notifier = ref.watch(settingsNotifier);

                      if (!notifier.loginButtonDisabled) {
                        return ElevatedButton(
                          onPressed: () {
                            final notifier = ref.watch(settingsNotifier);
                            notifier.loginAdmin(
                                notifier.usernameTextControl.text,
                                notifier.passwordTextControl.text);
                          },
                          child: const Text('Login'),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                          ),
                          onPressed: () {},
                          child: const Text('Login'),
                        );
                      }
                    }),
                  ),
                  Container(
                    width: 12.0,
                  ),
                  Consumer(builder: ((context, ref, child) {
                    final notifier = ref.watch(settingsNotifier);
                    if (notifier.authApi.isAuthenticated ==
                        Authenticated.AUTHENTICATED) {
                      return const Text(
                        'Authentication Succesful!',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 10.0,
                            fontStyle: FontStyle.italic),
                      );
                    } else if (notifier.authApi.isAuthenticated ==
                        Authenticated.UNAUTHENTICATED) {
                      return const Text(
                        'Authentication Failed!',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 10.0,
                            fontStyle: FontStyle.italic),
                      );
                    } else {
                      return Container();
                    }
                  })),
                ],
              ),
            ],
          ),
        ));
  }
}
