import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/googlemaps_error_dto.dart';
import 'package:monitoring_tool/presentation/widgets/elements/log_row.dart';
import 'package:monitoring_tool/providers.dart';

import '../../infrastructure/notifiers/generic_statenotifier.dart';

class GoogleErrorLogWidget extends ConsumerWidget {
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
              const Text('Google Error Logs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12.0),
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                              children: getLogList(state.loadedObject['GoogleLogs']!),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> getLogList(List<dynamic> list) {
    List<LogRow> logList = [];
    for (var i in (list as List<GoogleMapsErrorDTO>)) {
      logList.add(LogRow(i.CreatedAt!, 'User_id: ' + i.UserId!.toString() + ' , Message: ' + i.ErrorMsg!));
    }
    return logList;
  }
}
