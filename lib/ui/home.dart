import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/ui/home/analysis/analysis.dart';
import 'package:smart_beehive/ui/home/farm/farm.dart';
import 'package:smart_beehive/ui/home/profile.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../main.dart';
import 'home/alerts/alerts.dart';

const _tag = 'Home';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with WidgetsBindingObserver {
  final int _selectedIndex = 0;
  final String _selectedPage = farm;
  bool bottomNavigationVisibility = true;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    if (!kIsWeb) {
      if (Platform.isIOS) {
        messaging.requestPermission(
          sound: true,
          badge: true,
          alert: true,
        );
      }
    }

    _handleFcmMessage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      logInfo("Data link ${data?.link}", tag: _tag);

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        logInfo("DataLink $deepLink", tag: _tag);
      }, onError: (OnLinkErrorException e) async {
        logError('onLinkError ${e.message}', tag: _tag);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _selectedPage,
            style: mTS(),
          ),
          centerTitle: true,
        ),
        //drawer: _drawer(),
        //bottomNavigationBar: _bnv(),
        body: _screen(_selectedIndex),
      ),
    );
  }

  Widget _screen(int index) {
    switch (index) {
      case 0:
        return _farmInstance;
      case 1:
        return Analysis(
          hive: Beehive(uuid(), '', ''),
          type: AlertType.humidity,
        );
      case 2:
        return Alerts(
          hive: Beehive(uuid(), '', ''),
        );
      default:
        return const Profile();
    }
  }

  final _farmInstance = Farm();

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                logInfo("notification pressed", tag: _tag);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      logInfo("select $payload", tag: _tag);
    });
    selectNotificationHiveId.stream.listen((String? id) async {
      for (var element in beehives) {
        if (element.id == id) {
          setState(() {
            element.hasNotifications = true;
          });
        }
      }
      logInfo("select $id", tag: _tag);
    });
    selectNotificationAnalysis.stream.listen((String? analysis) async {
      logInfo("select $analysis", tag: _tag);
    });
  }

  _handleFcmMessage() async {
    //await initializeFirebaseApp();
    //await messaging.getToken();

    /**
     * todo If the application has been opened from a terminated state via a [RemoteMessage]
     * (containing a [Notification]), it will be returned, otherwise it will be `null`.
     */
    messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        logInfo('getInitialMessage', tag: _tag);
        logInfo("Remote " + message.data.toString(), tag: _tag);
        logInfo("Remote " + message.notification.toString(), tag: _tag);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logInfo('onMessageOpenedApp ${message.data}', tag: _tag);
      final beehive = beehives
          .firstWhere((element) => element.id == message.data['hive_id']);
      beehive.hasNotifications = true;
      _farmInstance.changeState();
    });
  }
}
