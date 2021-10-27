import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/ui/hive/overview/overview_viewmodel.dart';
import 'package:smart_beehive/ui/home/farm/farm_viewmodel.dart';
import 'package:smart_beehive/ui/registration/registration_viewmodel.dart';
import 'package:smart_beehive/ui/splash/splash.dart';
import 'package:smart_beehive/ui/splash/splash_viewmodel.dart';

import 'data/local/models/beehive.dart';
import 'ui/hive/logs/logs_viewmodel.dart';
import 'ui/home/alerts/alerts_viewmodel.dart';
import 'utils/extensions.dart';
import 'utils/log_utils.dart';

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

late FirebaseFirestore fireStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Smart Beehive',
    options:const FirebaseOptions(
      apiKey: 'AIzaSyBsdcX6OYVkB_Ty5ZkSJYLBgQP7R8OA7-Y',
      appId: '1:33277488295:android:eb5054d23e50d14816ff82',
      messagingSenderId: '33277488295',
      projectId: 'talabak3enna-cadee',
    ),
  );
  FirebaseApp secondaryApp = Firebase.app('Smart Beehive');
  fireStore = FirebaseFirestore.instanceFor(app: secondaryApp);
  runApp(const MyApp());
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        initialRoute: '/',
        home: const Splash(),
      ),
    );
  }
}
// todo fix marker in queen logs section ( only change its color instead of changing the png)
