import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/sync_dto.dart';
import 'package:monitoring_tool/providers.dart';

import '../../infrastructure/notifiers/generic_statenotifier.dart';
import '../../infrastructure/repositories/dtos/device_monitoring_dto.dart';

class DevicesWidget extends ConsumerWidget {
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
              const Text('Devices', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('Status Color:'),
                  Text(
                    '10 minutes',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '1 hour',
                    style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '1 day',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '> 1 day',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Never',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Consumer(
                builder: ((context, ref, child) {
                  DateFormat dateFormat = DateFormat("dd HH:mm");
                  final state = ref.watch(devicesNotifierProvider);
                  final notifier = ref.watch(devicesNotifierProvider.notifier);
                  if (state is Initial) {
                    return Container(
                      height: 200,
                    );
                  } else if (state is Loaded<List<SyncDTO>>) {
                    final loadedObject = state.loadedObject;
                    List<TableRow> devicesList = [];
                    devicesList.add(makeTableHeaders(
                        ['Status', 'Device', 'Last Sync', 'BatteryLevel', 'Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7', 'Options']));
                    final nowTime = DateTime.now();
                    for (var infoElement in loadedObject) {
                      var newRow = TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Container(
                              width: 30,
                              height: 30,
                            ),
                            decoration: BoxDecoration(
                                color: notifier.drawStatusColor(DateTime.fromMillisecondsSinceEpoch(infoElement.lastSync), nowTime), shape: BoxShape.circle),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.device),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(children: [
                            Text("Sync 1 - " +
                                (infoElement.lastSyncs.length > 0 ? dateFormat.format(DateTime.fromMillisecondsSinceEpoch(infoElement.lastSyncs[0])) : "")),
                            Text("Sync 2 - " +
                                (infoElement.lastSyncs.length > 1 ? dateFormat.format(DateTime.fromMillisecondsSinceEpoch(infoElement.lastSyncs[1])) : "")),
                            Text("Sync 3 - " +
                                (infoElement.lastSyncs.length > 2 ? dateFormat.format(DateTime.fromMillisecondsSinceEpoch(infoElement.lastSyncs[2])) : ""))
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.batteryLevel.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[0].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[1].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[2].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[3].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[4].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[5].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(infoElement.days[6].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onTap: () {
                                notifier.deleteTrackedDays(infoElement.userId);
                              }),
                        ),
                      ]);
                      devicesList.add(newRow);
                    }
                    return Table(
                      //border: TableBorder.all(width: 2.0),
                      children: devicesList,
                    );
                  } else {
                    return Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ));
  }

  TableRow makeTableHeaders(List<String> titles) {
    List<Widget> titleList = [];
    for (var title in titles) {
      titleList.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: Color.fromARGB(255, 234, 234, 234),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
        ),
      ));
    }
    return TableRow(children: titleList);
  }
}
