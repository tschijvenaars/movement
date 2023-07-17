import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/providers.dart';

class DeviceKpiWidget extends ConsumerWidget {
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
              const Text('Device KPI\'s', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12.0),
              Consumer(
                builder: (context, ref, child) {
                  final notifier = ref.watch(userDeviceKpiNotifier);
                  var kpiLabels = notifier.kpiLabels;
                  if (kpiLabels.isNotEmpty) {
                    return Column(
                      children: kpiLabels,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ));
  }
}
