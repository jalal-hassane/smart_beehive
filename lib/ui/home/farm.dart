import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/hive/logs.dart';
import 'package:smart_beehive/ui/hive/overview.dart';
import 'package:smart_beehive/ui/hive/properties.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

const _tag = 'My Farm';
int _selectedTabIndex = 0;

class Farm extends StatefulWidget {
  const Farm({Key? key}) : super(key: key);

  @override
  _Farm createState() => _Farm();
}

class _Farm extends State<Farm> with TickerProviderStateMixin {
  final _pageController = PageController();
  Widget _createdWidget = Container();
  Widget _qrWidget = Container();
  Widget _properties = Container();
  bool _propertyTitleVisibility = false;
  int _selectedHiveIndex = -1;
  late final _tabController = TabController(length: 3, vsync: this);
  final _tabsPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addHive,
        child: const Icon(
          Icons.add,
          color: colorBlack,
        ),
        backgroundColor: colorPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _checkHivesList(),
          ),
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 15,
            child: Column(
              children: [
                Visibility(
                  visible: _propertyTitleVisibility,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Flexible(
                        child: Divider(
                          height: 1,
                          indent: 35,
                          endIndent: 2,
                          color: colorBlack,
                        ),
                      ),
                      Center(
                        child: Text(
                          textDetails,
                          style: rTS(color: colorBlack),
                        ),
                      ),
                      const Flexible(
                        child: Divider(
                          height: 1,
                          indent: 2,
                          endIndent: 35,
                          color: colorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _properties,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _checkHivesList() {
    if (beehives.isNotEmpty) {
      return Container(
        margin: left(10),
        child: ListView.builder(
          padding: all(6),
          itemCount: beehives.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return _listItemWidget(index);
          },
        ),
      );
    } else {
      return Center(
          child: Text(
        textAddHiveHint,
        style: mTS(color: colorBlack),
      ));
    }
  }

  _listItemWidget(int hiveIndex) {
    return GestureDetector(
      onTap: () => _openHiveProperties(hiveIndex),
      child: Container(
        width: screenWidth * 0.3,
        margin: right(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(backgroundHive),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2.0, 2.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Visibility(
                  visible: _selectedHiveIndex == hiveIndex ? true : false,
                  child: Lottie.asset(
                    lottieBee,
                    width: 24,
                    height: 24,
                    repeat: true,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: Text(
                'hive #$hiveIndex',
                style: sbTS(color: colorBlack),
              )),
            ),
          ],
        ),
      ),
    );
  }

  _openHiveProperties(int index) {
    if (index == _selectedHiveIndex) return;
    _selectedHiveIndex = index;
    final hive = beehives[index];
    if (index == 1) {
      hive.qrScanned = true;
    }

    if (index == 2) {
      hive.qrScanned = true;
      hive.overview.name = 'hive2';
    }
    setState(() {
      logInfo('Hive ${hive.qrScanned}');
      _propertyTitleVisibility = true;
      _properties = Details(beehive: hive);
    });
  }

  _addHive() {
    context.showCustomBottomSheet((_) {
      return StatefulBuilder(
        builder: (_, setState) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: _page(
                      textStepOne,
                      textStepOneHint,
                      textCreate,
                      setState,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: _createdWidget,
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: _page(
                      textStepTwo,
                      textStepTwoHint,
                      textGenerateQr,
                      setState,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: _qrWidget,
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  _page(String title, String description, String action,
      void Function(void Function()) state) {
    return SizedBox(
      height: screenHeight * 0.7 * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: bTS(size: 30),
          ),
          Center(
            child: Padding(
              padding: symmetric(0, 10),
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: rTS(),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              state(() => _handleAction(action));
              logInfo("$action was pressed!!");
            },
            child: Container(
              width: screenWidth * 0.4,
              height: screenHeight * 0.7 * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red[200],
              ),
              child: Center(
                  child: Text(
                action,
                style: mTS(color: colorWhite),
              )),
            ),
          ),
        ],
      ),
    );
  }

  _handleAction(String action) {
    if (action == textCreate) {
      // create hive
      final _uuid = uuid();
      final _hive = Beehive(_uuid);
      logInfo('UUID IS $_uuid');
      _createdWidget = Column(
        children: [
          Lottie.asset(lottieBelieve,
              repeat: true,
              width: screenWidth * 0.5,
              height: screenWidth * 0.5),
          Text(
            'Hive created successfully',
            style: mTS(color: colorWhite),
          ),
        ],
      );
      Future.delayed(const Duration(milliseconds: 2000), () {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      });
    } else {
      // generate qr code based on created hive uuid
      _qrWidget = Column(
        children: [
          QrImage(
            data: uuid(),
            backgroundColor: colorWhite,
            version: QrVersions.auto,
            size: 200.0,
          ),
          Container(
            margin: top(8),
            child: Text(
              'Qr Code generated successfully',
              style: mTS(color: colorWhite),
            ),
          ),
        ],
      );

      // todo add only one hive
      beehives.add(Beehive(uuid())..name = 'hive #1');
      beehives.add(Beehive(uuid())..name = 'hive #2');
      beehives.add(Beehive(uuid())..name = 'hive #3');
      beehives.add(Beehive(uuid())..name = 'hive #4');
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
        setState(() {
          _createdWidget = Container();
          _qrWidget = Container();
        });
      });
    }
  }
}

// todo finish details page
class Details extends StatefulWidget {
  final Beehive beehive;

  const Details({Key? key, required this.beehive}) : super(key: key);

  @override
  _Details createState() => _Details();
}

class _Details extends State<Details> with TickerProviderStateMixin {
  late Beehive _hive;
  TabController? _tabController;
  PageController? _tabsPageController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    return _hive.qrScanned != null && _hive.qrScanned!
        ? _detailsWidget()
        : _scanQrWidget();
  }

  _detailsWidget() {
    _tabController ??= TabController(
          initialIndex: _selectedTabIndex, length: 3, vsync: this);

    _tabsPageController ??= PageController(initialPage: _selectedTabIndex);
    return Column(
      children: [
        TabBar(
          tabs: [
            _tabWidget(Icons.remove_red_eye, textOverview),
            _tabWidget(Icons.paste_rounded, textProperties),
            _tabWidget(Icons.library_books, textLogs),
          ],
          indicatorColor: colorBlack,
          indicatorPadding: symmetric(0, 8),
          controller: _tabController,
          onTap: (value) {
            //_selectedTabIndex = value;
            _tabsPageController!.animateToPage(value,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
        ),
        Expanded(
          child: PageView(
            controller: _tabsPageController,
            children: [
              Overview(beehive: _hive),
              Properties(beehive: _hive),
              Logs(beehive: _hive),
            ],
            onPageChanged: (value) {
              logInfo('onPageChanged $value');
              _tabController!.animateTo(value);
              _selectedTabIndex = value;
            },
          ),
        ),
      ],
    );
  }

  _tabWidget(IconData iconData, String text) {
    return Tab(
      icon: Icon(
        iconData,
        size: 20,
      ),
      child: Text(
        text,
        style: bTS(size: 10, color: colorPrimaryDark!),
      ),
    );
  }

  _scanQrWidget() {
    _tabsPageController = null;
    _tabController = null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: bottom(30),
          child: Text(
            textHiveNotAdded,
            style: rTS(color: colorBlack),
          ),
        ),
        QrImage(
          data: uuid(),
          backgroundColor: colorWhite,
          version: QrVersions.auto,
          size: 200.0,
        ),
        Container(
          margin: top(30),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              textScan,
              style: rTS(color: colorBlack),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            textShare,
            style: rTS(color: colorBlack),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    logInfo('dispose from details page');
    _tabController?.dispose();
    _tabsPageController?.dispose();
    super.dispose();
  }
}
