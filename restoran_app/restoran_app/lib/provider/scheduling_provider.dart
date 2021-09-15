import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:restoran_app/helper/date_time_helper.dart';
import 'package:restoran_app/utils/background_service.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledInfo(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Info Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Info Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
