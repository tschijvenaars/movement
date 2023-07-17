import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/log_dto.dart';

import '../../infrastructure/notifiers/generic_statenotifier.dart';
import '../../providers.dart';
import 'elements/log_row.dart';

class LogWidget extends ConsumerWidget {
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
              const Text('User Logs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12.0),
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final state = ref.watch(logsNotifierProvider);
                      final notifier = ref.watch(logsNotifierProvider.notifier);
                      if (state is Initial) {
                        return Container();
                      } else if (state is Loaded<Map<String, List<dynamic>>>) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getLogList(state.loadedObject['UserLogs']!),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> getLogList(List<dynamic> list) {
    List<LogRow> logList = [];
    for (var i in (list as List<LogDTO>)) {
      logList.add(LogRow(DateTime.fromMillisecondsSinceEpoch(i.datetime).toString(), 'User_id: ' + i.deviceDTO.device! + ' , Message: ' + i.message!));
    }
    return logList;
  }
}
