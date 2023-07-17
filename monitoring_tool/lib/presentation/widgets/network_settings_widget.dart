import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/providers.dart';

class NetworkSettingsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer(builder: (context, ref, child) {
            final notifier = ref.watch(settingsNotifier);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Network Settings',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    const Text('IP Address: '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlue, width: 2.0),
                            ),
                          ),
                          controller: notifier.ipTextControl,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        notifier.setServerIP();
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        notifier.setDefaultIP();
                      },
                      child: const Text('Restore Default'),
                    ),
                  ],
                ),
              ],
            );
          }),
        ));
  }
}
