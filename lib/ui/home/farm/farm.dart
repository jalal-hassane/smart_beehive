import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/hive/logs/logs.dart';
import 'package:smart_beehive/ui/hive/overview/overview.dart';
import 'package:smart_beehive/ui/hive/properties.dart';
import 'package:smart_beehive/ui/home/farm/farm_viewmodel.dart';
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
  Widget _properties = Container();
  bool _propertyTitleVisibility = false;
  int _selectedHiveIndex = -1;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  void Function(void Function())? _bottomState;
  BuildContext? _bottomContext;
  Beehive? insertedHive;
  Barcode? result;
  QRViewController? controller;

  int get _hiveCounter => beehives.length + 1;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  int get _nextItem => beehives.length;

  final audioPlayer = AudioPlayer();

  late FarmViewModel _farmViewModel;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) async {
    _bottomState!(() => this.controller = controller);
    controller.scannedDataStream.take(1).listen((data) {
      if (!mounted) return;
      result = data;
      logInfo('' + result!.code.toString());
      if (result == null) return;
      final uuid = result!.code;
      logInfo(uuid);
      if (!validateUUID(uuid)) {
        showDialog<void>(
          context: _bottomContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Scan Error',
                style: mTS(size: 18),
              ),
              content: Text(
                'Qr code info is not valid.',
                style: rTS(),
              ),
            );
          },
        );
        return;
      }
      insertedHive = Beehive(uuid)
        ..overview = HiveOverview(name: 'hive #$_hiveCounter');
      //me!.beehives?.add(insertedHive!);
      _farmViewModel.updateHives(insertedHive!);
    });
  }

  bool validateUUID(String uuid) {
    try {
      assert(uuid.length == 37);
      assert(uuid[8] == '-');
      assert(uuid[13] == '-');
      assert(uuid[18] == '-');
      assert(uuid[23] == '-');
      logInfo('true');
      return true;
    } catch (ex) {
      logError(ex.toString());
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    controller?.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  _initViewModel() {
    _farmViewModel = Provider.of<FarmViewModel>(context);
    _farmViewModel.helper = FarmHelper(
      success: _success,
      failure: _failure,
    );
  }

  _success() {
    _bottomState!(() {
      logInfo('Result ${result!.code}');
      Navigator.popUntil(context, (route) => route.isFirst);
      setState(() {
        logInfo('next item $_nextItem');
        final index = _nextItem;
        beehives.insert(index, insertedHive!);
        logInfo('next item $_nextItem');
        _listKey.currentState?.insertItem(index);
        audioPlayer.seek(const Duration(milliseconds: 0));
        audioPlayer.play();
      });
    });
  }

  _failure(String error) {
    logError(error);
  }

  _initPlayer() async {
    await audioPlayer.setAsset(soundSuccess);
    await audioPlayer.setLoopMode(LoopMode.off);
    await audioPlayer.setVolume(0.05);
    await audioPlayer.load();
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addHive,
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: colorBlack,
        ),
        backgroundColor: colorPrimary,
      ),
      body: beehives.isNotEmpty ? _hiveListWidget() : _emptyListWidget(),
    );
  }

  _emptyListWidget() {
    return GestureDetector(
      onTap: _addHive,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              size: screenWidth * 0.5,
            ),
            Text(
              textAddHiveHint,
              style: mTS(),
            ),
          ],
        ),
      ),
    );
  }

  _hiveListWidget() {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            margin: left(10),
            child: AnimatedList(
              key: _listKey,
              padding: all(6),
              initialItemCount: beehives.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: _listItemWidget,
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 25,
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
                        style: rTS(),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listItemWidget(
      BuildContext context, int hiveIndex, Animation<double> animation) {
    logInfo('beehive ${beehives[hiveIndex].toMap()}');
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: GestureDetector(
        onTap: () => _openHiveProperties(hiveIndex),
        child: Container(
          width: screenWidth * 0.3,
          margin: right(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
            border: Border.all(
                color: Colors.green,
                width: _selectedHiveIndex == hiveIndex ? 2 : 0),
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
                child: Padding(
                  padding: all(8),
                  child: Center(
                      child: Text(
                    beehives[hiveIndex].overview.name!,
                    style: sbTS(),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listStater() => _listKey.currentState?.setState(() {});

  _openHiveProperties(int index) {
    if (index == _selectedHiveIndex) return;
    _selectedHiveIndex = index;
    final hive = beehives[index];
    setState(() {
      _propertyTitleVisibility = true;
      _properties = Details(
        beehive: hive,
        farmState: listStater,
      );
    });
  }

  _addHive() {
    context.showCustomBottomSheet(
      (mContext) {
        return StatefulBuilder(
          builder: (con, state) {
            _bottomState = state;
            _bottomContext = con;
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      textScanQr,
                      style: bTS(size: 24, color: colorPrimary),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: colorPrimary,
                      borderWidth: 5,
                      borderRadius: 5,
                      cutOutSize: screenWidth * 0.75,
                    ),
                    formatsAllowed: const [BarcodeFormat.qrcode],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// todo finish details page
class Details extends StatefulWidget {
  final Beehive beehive;
  final void Function() farmState;

  const Details({
    Key? key,
    required this.beehive,
    required this.farmState,
  }) : super(key: key);

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
    return _detailsWidget();
  }

  _detailsWidget() {
    _tabController ??=
        TabController(initialIndex: _selectedTabIndex, length: 4, vsync: this);

    _tabsPageController ??= PageController(initialPage: _selectedTabIndex);
    return Column(
      children: [
        TabBar(
          tabs: [
            _tabWidget(Icons.remove_red_eye, textOverview),
            _tabWidget(Icons.paste_rounded, textProperties),
            _tabWidget(Icons.bubble_chart, analysis),
            _tabWidget(Icons.library_books, textLogs),
          ],
          indicatorColor: colorBlack,
          indicatorPadding: symmetric(0, 8),
          controller: _tabController,
          onTap: (value) {
            //_selectedTabIndex = value;
            _tabsPageController!.animateToPage(
              value,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
        ),
        Expanded(
          child: PageView(
            controller: _tabsPageController,
            children: [
              Overview(
                beehive: _hive,
                farmState: stater,
              ),
              Properties(
                beehive: _hive,
                showOnlyAnalysis: false,
              ),
              Properties(
                beehive: _hive,
                showOnlyAnalysis: true,
              ),
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

  stater() => widget.farmState.call(); //PASSING SET STATE

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

  @override
  void dispose() {
    logInfo('dispose from details page');
    _tabController?.dispose();
    _tabsPageController?.dispose();
    super.dispose();
  }
}
