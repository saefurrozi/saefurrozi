import 'dart:isolate';
import 'dart:ui';
import 'package:restoran_app/data/api/api_service.dart';
import 'package:restoran_app/helper/notification_helper.dart';
import 'package:restoran_app/main.dart';
import 'package:http/http.dart' show Client;

final ReceivePort port = ReceivePort();
final Client client = Client();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }
    return _service!;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiService(client).getListRestaurant();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
