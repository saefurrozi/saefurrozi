import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restoran_app/common/navigation.dart';
import 'package:restoran_app/model/list_model.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ListModel restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "restaurant channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Restaurant Information</b>";
    int selectedIndex = Random().nextInt(restaurant.restaurants.length);
    var titleResto = restaurant.restaurants[selectedIndex].name;
    var idResto = restaurant.restaurants[selectedIndex].id;
    String? dJson = '{"id":"$idResto"}';

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleResto, platformChannelSpecifics,
        payload: dJson);
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var restaurantId = json.decode(payload);
        await Navigation.intentWithData(route, restaurantId["id"]);
      },
    );
  }
}
