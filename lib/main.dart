import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/ui/hive/overview/overview_viewmodel.dart';
import 'package:smart_beehive/ui/home/analysis/analysis_viewmodel.dart';
import 'package:smart_beehive/ui/home/farm/farm_viewmodel.dart';
import 'package:smart_beehive/ui/registration/registration_viewmodel.dart';
import 'package:smart_beehive/ui/splash/splash.dart';
import 'package:smart_beehive/ui/splash/splash_viewmodel.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'data/local/models/beehive.dart';
import 'ui/hive/logs/logs_viewmodel.dart';
import 'ui/home/alerts/alerts_viewmodel.dart';
import 'utils/constants.dart';
import 'utils/log_utils.dart';
import 'utils/pref_utils.dart';

const _tag = 'main';
// top-level variables
double screenHeight = 0;
double screenWidth = 0;
double screenBottomPadding = 0;
BuildContext? mContext;
Beekeeper? me; // this is the current user of the app
List<Beehive> get beehives {
  if (me != null) {
    if (me!.beehives == null) me!.beehives = [];
    return me!.beehives!;
  }
  return <Beehive>[];
}

int get hiveCounter => beehives.length + 1;

String currentHiveId = '';
DateTime? swarmingTime = DateTime.now();

double get childAspectRatio => screenHeight / screenWidth;

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

final BehaviorSubject<String?> selectNotificationHiveId =
    BehaviorSubject<String?>();

final BehaviorSubject<String?> selectNotificationAnalysis =
    BehaviorSubject<String?>();

const MethodChannel platform = MethodChannel('smart_beehive');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

late FirebaseFirestore fireStore;
late AndroidNotificationChannel channel;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApp();
  fireStore = FirebaseFirestore.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'Alerts', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await handleRefreshFirebaseToken();
  handleNotifications();

  runApp(const MyApp());
}

initializeFirebaseApp() async {
  await Firebase.initializeApp();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await initializeFirebaseApp();

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'Alerts', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    ledColor: colorPrimary,
  );
  //handleRemoteMessage(message);
}

handleRemoteMessage(RemoteMessage message) {
  logInfo("Remote " + message.data.toString(), tag: _tag);
  logInfo("Remote " + message.notification.toString(), tag: _tag);
  final title = message.data['title'];
  final body = message.data['body'];
  final openPage = message.data['open_page'];
  final hiveId = message.data['hive_id'];
  final analysis = message.data['analysis'];

  logInfo("OpenPage $openPage", tag: _tag);

  selectedNotificationPayload = openPage;
  selectNotificationSubject.add(openPage);
  selectNotificationHiveId.add(hiveId);
  selectNotificationAnalysis.add(analysis);

  flutterLocalNotificationsPlugin.show(
    1,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
        channelShowBadge: true,
        priority: Priority.high,
        setAsGroupSummary: true,
        ledColor: colorPrimary,
        ledOnMs: 1500,
        ledOffMs: 500,
      ),
    ),
  );

  /*// cant open inbox because of remote message not containing notification
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            groupAlertBehavior: GroupAlertBehavior.summary,
            channelShowBadge: true,
          ),
        ));
  }*/
}

handleRefreshFirebaseToken() async {
  final authToken = await PrefUtils.authToken;
  if (authToken.isEmpty) return;
  final oldToken = await PrefUtils.deviceToken;
  try {
    messaging.getToken().then((token) {
      if (token.isNullOrEmpty || oldToken == token) return;
      logInfo("Token is $token", tag: _tag);
      PrefUtils.setDeviceToken(token!);
      fireStore
          .collection(collectionBeekeeper)
          .doc(authToken)
          .update({fieldDeviceToken: token});
    });
  } catch (ex) {
    logError("Exception with error $ex");
  }
}

void handleNotifications() async {
  await _configureLocalTimeZone();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SplashViewModel()),
        ChangeNotifierProvider.value(value: RegistrationViewModel()),
        ChangeNotifierProvider.value(value: FarmViewModel()),
        ChangeNotifierProvider.value(value: OverviewViewModel()),
        ChangeNotifierProvider.value(value: AlertsViewModel()),
        ChangeNotifierProvider.value(value: LogsViewModel()),
        ChangeNotifierProvider.value(value: AnalysisViewModel()),
      ],
      child: MaterialApp(
        title: 'Smart Beehive',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: colorPrimary
        ),
        initialRoute: '/',
        home: const Splash(),
      ),
    );
  }
}
