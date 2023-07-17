import 'package:movement_algo/src/core/service_locator.dart';

void main() {
  runSimulation();
}

void runSimulation() async {
  while (true) {
    final sensorData = await mockForegroundService.getNext();
    if (sensorData == null) break;
    classificationNotifier.classify(sensorData);
  }
  mockDatabase.writeResultsToCsv();
}
