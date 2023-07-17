import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/providers.dart';

class SingleUserSignup extends ConsumerWidget {
  const SingleUserSignup({Key? key}) : super(key: key);

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
              const Text('Single User Credentials',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12.0),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text('Username: '),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Consumer(
                        builder: ((context, ref, child) {
                          final notifier = ref.watch(signupNotifier);
                          return TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            controller: notifier.usernameTextControl,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text('Password: '),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Consumer(builder: ((context, ref, child) {
                        final notifier = ref.watch(signupNotifier);
                        return TextField(
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
                  ElevatedButton(
                    onPressed: () async {
                      final notifier = ref.watch(signupNotifier);
                      await notifier.signUpUser();
                    },
                    child: const Text('Sign Up'),
                  ),
                  Container(width: 12.0),
                  Consumer(
                    builder: ((context, ref, child) {
                      final notifier = ref.watch(signupNotifier);
                      if (notifier.shouldDisplaySingleUserWarning) {
                        return const Text(
                          'Credentials contain unwanted syntax.',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic),
                        );
                      } else if (notifier.succesfullyAdded) {
                        return const Text(
                          'User Succesfully Created.',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
