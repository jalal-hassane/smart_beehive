import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/ui/home/analysis.dart';
import 'package:smart_beehive/ui/home/farm/farm.dart';
import 'package:smart_beehive/ui/home/profile.dart';
import 'package:smart_beehive/utils/extensions.dart';

import '../main.dart';
import 'home/alerts/alerts.dart';
import 'settings/notifications.dart';
import 'settings/settings.dart';

const _tag = 'Home';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  String _selectedPage = farm;
  bool bottomNavigationVisibility = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _selectedPage,
            style: mTS(),
          ),
          centerTitle: true,
        ),
        drawer: _drawer(),
        //bottomNavigationBar: _bnv(),
        body: _screen(_selectedIndex),
      ),
    );
  }

  Widget _bnv() {
    return Visibility(
      visible: bottomNavigationVisibility,
      child: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedLabelStyle: bottomNavigationTextStyle,
        unselectedLabelStyle: bottomNavigationTextStyle,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: colorPrimary,
        iconSize: 30,
        onTap: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: [
          _bottomNavigationBarItem(
            Icons.home,
            farm,
          ),
          _bottomNavigationBarItem(
            Icons.bar_chart,
            analysis,
          ),
          _bottomNavigationBarItem(
            Icons.alarm,
            alerts,
          ),
          _bottomNavigationBarItem(
            Icons.person,
            profile,
          ),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Container(
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
        color: colorPrimary.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: colorBlack,
            ),
            child: Column(
              children: [
                inAppLogo(textColor: colorPrimary),
                Container(
                  margin: top(24),
                  child: Text(
                    'Welcome, ${me?.username}',
                    style: sbTS(color: colorPrimary),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: trbl(20, 0, 0, 12),
            alignment: Alignment.centerLeft,
            child: Text(
              navigation,
              style: ebTS(size: 11),
            ),
          ),
          _divider,
          _drawerItem(Icons.home, farm, () => _navigate(0, farm)),
          _drawerItem(Icons.bar_chart, analysis, () => _navigate(1, analysis)),
          _drawerItem(Icons.alarm, alerts, () => _navigate(2, alerts)),
          _drawerItem(Icons.person, profile, () => _navigate(3, profile)),
          Container(
            margin: trbl(20, 0, 0, 12),
            alignment: Alignment.centerLeft,
            child: Text(
              settings,
              style: ebTS(size: 11),
            ),
          ),
          _divider,
          _drawerItem(
              Icons.notifications, notifications, () => _navigateToSettings(0)),
          _drawerItem(Icons.settings, settings, () => _navigateToSettings(1))
        ],
      ),
    );
  }

  final _divider = const Divider(
    height: 1,
    indent: 12,
  );

  _drawerItem(
    IconData icon,
    String label,
    void Function() onTap,
  ) {
    return ListTile(
      contentPadding: symmetric(0, 20),
      horizontalTitleGap: 2,
      leading: Icon(
        icon,
        size: 24,
        color: colorBlack,
      ),
      title: Text(
        label,
        style: mTS(),
      ),
      onTap: onTap,
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      backgroundColor: colorBlack,
      icon: Icon(
        icon,
        //size: 24,
        color: colorWhite,
      ),
      activeIcon: Icon(
        icon,
        //size: 24,
        color: colorPrimary,
      ),
      label: label,
    );
  }

  Widget _screen(int index) {
    switch (index) {
      case 0:
        return const Farm();
      case 1:
        return Analysis(
          hive: Beehive(uuid()),
          type: AlertType.humidity,
        );
      case 2:
        return  Alerts(
          hive: Beehive(uuid()),
        );
      default:
        return const Profile();
    }
  }

  _showBottomNavigationCallback() {
    setState(() {
      bottomNavigationVisibility = true;
    });
  }

  _navigate(int index, String page) {
    // close drawer
    Navigator.pop(context);
    setState(() {
      _selectedIndex = index;
      _selectedPage = page;
    });
  }

  _navigateToSettings(int index) {
    Navigator.pop(context);
    Widget _screen;
    if (index == 0) {
      _screen = const Notifications();
    } else {
      _screen = const Settings();
    }
    Navigator.of(context).push(
      enterFromBottom(_screen),
    );
  }
}
