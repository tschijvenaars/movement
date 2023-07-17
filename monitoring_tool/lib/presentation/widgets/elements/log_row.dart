import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogRow extends ConsumerWidget {
  final String timeStamp;
  final String logMessage;

  const LogRow(this.timeStamp, this.logMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          timeStamp,
          style: TextStyle(color: Colors.white, fontFamily: 'Consolas', fontSize: 12.0),
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          logMessage,
          style: TextStyle(color: Colors.white, fontFamily: 'Consolas', fontSize: 12.0),
        ),
      ],
    );
  }
}
