import 'package:movement_algo/src/service/mock_foreground_service.dart';

import '../data/mock_database.dart';
import '../data/sensor_data_repository.dart';
import '../notifiers/classification_notifier.dart';

// Mocked depedencies
final mockDatabase = MockDatabase();
final mockForegroundService = MockForegroundService();

// Normal dependencies
final sensorDataRepository = SensorDataRepository(mockDatabase);
final classificationNotifier = ClassificationNotifier(sensorDataRepository);
