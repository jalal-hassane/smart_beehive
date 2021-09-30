import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/ui/registration/registration.dart';
import 'package:smart_beehive/ui/registration/registration_viewmodel.dart';
import 'package:smart_beehive/ui/splash/splash.dart';

import 'data/local/models/beehive.dart';
import 'ui/home.dart';

// top-level variables
double screenHeight = 0;
double screenWidth = 0;
double screenBottomPadding = 0;
BuildContext? mContext;
List<Beehive> beehives = [];

void main() {
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
        ChangeNotifierProvider.value(value: RegistrationViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const Splash(),
      ),
    );
  }
}
