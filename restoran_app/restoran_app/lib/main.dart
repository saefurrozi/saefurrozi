import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restoran_app/ui/detail_screen.dart';
import 'package:restoran_app/ui/home_screen.dart';
import 'package:restoran_app/provider/post_data_provider.dart';
import 'package:restoran_app/provider/list_data_provider.dart';
import 'package:restoran_app/provider/db_provider.dart';
import 'package:restoran_app/provider/scheduling_provider.dart';
import 'package:restoran_app/utils/background_service.dart';
import 'package:restoran_app/utils/const.dart';

import 'common/navigation.dart';
import 'helper/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ListDataProvider>(
          create: (_) => ListDataProvider(),
        ),
        ChangeNotifierProvider<PostDataProvider>(
          create: (_) => PostDataProvider(),
        ),
        ChangeNotifierProvider<DbProvider>(
          create: (_) => DbProvider(),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      themeMode: ThemeMode.system,
      navigatorKey: navigatorKey,
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) => MyHomePage(),
        HomeScreen.routeName: (context) => HomeScreen(),
        DetailScreen.routeName: (context) => DetailScreen(
          restoId:  ModalRoute.of(context)?.settings.arguments as String,
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/resto_homepage';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigation.intentRoute(HomeScreen.routeName)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wine_bar,
              size: MediaQuery.of(context).size.height / 4,
              color: Colors.blueAccent[100],
            ),
            Text(
              'Restaurant Apps',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GreatVibes',
                  color: Colors.blue.shade50),
            ),
          ],
        ));
  }
}
