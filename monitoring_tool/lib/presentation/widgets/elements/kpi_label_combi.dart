import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KpiLabel extends ConsumerWidget {
  final String kpiName;
  final String kpiValue;

  const KpiLabel(this.kpiName, this.kpiValue, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          kpiName + ':',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          kpiValue,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
