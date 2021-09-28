import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/fonts.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../main.dart';

const _tag = 'Home';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  bool bottomNavigationVisibility = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        drawer: _drawer(),
        bottomNavigationBar: Visibility(
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
                'Farm',
              ),
              _bottomNavigationBarItem(
                Icons.bar_chart,
                'Analysis',
              ),
              _bottomNavigationBarItem(
                Icons.alarm,
                'Alarms',
              ),
              _bottomNavigationBarItem(
                Icons.person,
                'Profile',
              ),
            ],
          ),
        ),
        body: _screen(_selectedIndex),
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
                    'Welcome, Jalal',
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
              style: ebTS(
                size: 11,
                color: colorBlack,
              ),
            ),
          ),
          _divider,
          _drawerItem(Icons.home, farm, () {}),
          _drawerItem(Icons.bar_chart, analysis, () {}),
          _drawerItem(Icons.alarm, alarms, () {}),
          _drawerItem(Icons.person, profile, () {}),
          Container(
            margin: trbl(20, 0, 0, 12),
            alignment: Alignment.centerLeft,
            child: Text(
              settings,
              style: ebTS(
                size: 11,
                color: colorBlack,
              ),
            ),
          ),
          _divider,
          _drawerItem(Icons.notifications, notifications, () {}),
          _drawerItem(Icons.settings, settings, () {})
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
        style: mTS(color: colorBlack),
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
    logInfo("setting screen $index", tag: _tag);
    return const Center(
      child: Text(
        'Home screen',
        style: TextStyle(
          fontFamily: montserratRegular,
          fontSize: 26,
        ),
      ),
    );
    /*switch (index) {
      case 0:
        return HomeScreen(
          remainingMessages: mProfile?.allowedMessages,
          callback: this.callback,
        );
      case 1:
        return MemoriesScreen(
          refreshInbox: this.refreshInbox,
        );
      case 2:
        return ShopScreen();
      default:
        return AccountScreen();
    }*/
  }

  _showBottomNavigationCallback() {
    setState(() {
      bottomNavigationVisibility = true;
    });
  }
}
