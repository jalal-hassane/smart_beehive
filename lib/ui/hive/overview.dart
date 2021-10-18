import 'dart:async';
import 'dart:collection';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/global/map.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

const _tag = 'Overview';

class Overview extends StatefulWidget {
  final Beehive beehive;

  const Overview({Key? key, required this.beehive}) : super(key: key);

  @override
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> with TickerProviderStateMixin {
  late Beehive _hive;
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  late DateTime _dateTime;
  HiveType? _hiveType;
  Species? _species;

  Completer<GoogleMapController> _controller = Completer();

  String _location = '';
  Position? _position;

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    _animationController.forward(from: 0);
    return Padding(
      padding: all(16),
      child: Column(
        children: [
          Column(
            children: [
              _overviewItem(
                textName,
                _hive.overview.name,
                _offsetAnimation(-1.0),
              ),
              //_divider,
              _overviewItem(
                textHiveType,
                _hive.overview.hiveType,
                _offsetAnimation(-2.0),
              ),
              //_divider,
              _overviewItem(
                textInstallationDate,
                _hive.overview.installationDate,
                _offsetAnimation(-3.0),
              ),
              //_divider,
              _overviewItem(
                textColonyAge,
                _hive.overview.colonyAge,
                _offsetAnimation(1.0),
              ),
              //_divider,
              _overviewItem(
                textSpecies,
                _hive.overview.speciesType,
                _offsetAnimation(2.0),
              ),
              //_divider,
              _overviewItem(
                textLocation,
                _hive.overview.location,
                _offsetAnimation(3.0),
              ),
            ],
          ),
          Flexible(
            child: Center(
              child: ElevatedButton(
                onPressed: () => _showEditModal(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                ),
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: colorBlack,
                    ),
                    label: Text(
                      textEditHive,
                      style: rTS(),
                    ),
                    onPressed: () => {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  late Function(void Function()) locationState;

  _showEditModal() async {
    _nameController.text = _hive.overview.name ?? '';
    _hiveType = _hive.overview.type;
    _species = _hive.overview.species;
    _dateController.text =
    _hive.overview.date != null ? _hive.overview.installationDate : '';
    _locationController.text =
    _hive.overview.position != null ? _hive.overview.location : '';
    context.showCustomBottomSheet((_) {
      return StatefulBuilder(builder: (_, state) {
        locationState = state;
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  textEditHive,
                  style: bTS(size: 24, color: colorPrimary),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  overviewSheetItemWidget(
                    _nameController,
                    screenWidth,
                    screenHeight,
                    textName,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: left(16),
                        child: Text(
                          textHiveType,
                          style: boTS(color: colorPrimary),
                        ),
                      ),
                      _hiveTypeDropDownWidget(state),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _datePickerWidget(),
                    child: overviewSheetItemWidget(
                      _dateController,
                      screenWidth,
                      screenHeight,
                      textInstallationDate,
                      enabled: false,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: left(16),
                        child: Text(
                          textSpecies,
                          style: boTS(color: colorPrimary),
                        ),
                      ),
                      _speciesDropDownWidget(state),
                    ],
                  ),
                  overviewSheetItemWidget(
                    _locationController,
                    screenWidth,
                    screenHeight,
                    textLocation,
                    suffix: Container(
                      margin: symmetric(0, 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async => await _getLocationName(state),
                            child: const Icon(
                              Icons.my_location,
                              color: colorWhite,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async => await _showMap(state),
                            child: Container(
                              margin: left(6),
                              child: const Icon(
                                Icons.edit_location_outlined,
                                color: colorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    scrollController: _scrollController,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    state(() => _saveHiveDetails());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[200],
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.056,
                    child: Center(
                      child: Text(
                        textSave,
                        style: mTS(color: colorWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });
    });
  }

  late final _scrollController = ScrollController();

  _saveHiveDetails() {
    final name = _nameController.text.toString();
    final date = _dateController.text.toString();
    final location = _locationController.text.toString();
    setState(() {
      if (name.isNotEmpty) _hive.overview.name = name;
      if (date.isNotEmpty && date != _hive.overview.installationDate) {
        _hive.overview.date = _dateTime;
      }
      if (_hiveType != null) {
        _hive.overview.type = _hiveType;
      }
      if (_species != null) {
        _hive.overview.species = _species;
      }
      if (_position != null) {
        _hive.overview.position = _position;
        _hive.overview.mLocation = location;
      }
      _nameController.clear();
      _dateController.clear();
      _locationController.clear();
      Navigator.pop(context);
    });
  }

  final _divider = const Flexible(
    child: Divider(
      height: 1,
      indent: 3,
      color: colorBlack,
    ),
  );

  _overviewItem(String title, String? value, Animation<Offset> tween) {
    return SlideTransition(
      position: tween,
      child: SizedBox(
        height: screenHeight * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: right(8),
              child: Text(
                title,
                style: mTS(),
              ),
            ),
            Flexible(
              child: Text(
                value!,
                textAlign: TextAlign.end,
                style: rTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Animation<Offset> _offsetAnimation(double start) {
    return Tween<Offset>(
      begin: Offset(0.0, start),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _datePickerWidget() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(1970, 1, 1),
    );

    if (date != null) {
      _dateTime = date;
      String formattedDate = formatDate(_dateTime, [yyyy, ' ', M, ' ', dd]);
      _dateController.text = formattedDate;
    }
  }

  _dropDownButton(Function(void Function()) state,
      Function(String string) onChanged,
      String current,
      Widget hint,
      List<DropdownMenuItem<String>> items,) {
    return DropdownButton<String>(
      iconSize: 0,
      onChanged: (value) => state(() => onChanged.call(value!)),
      dropdownColor: Colors.black87,
      isExpanded: true,
      borderRadius: BorderRadius.circular(8),
      hint: hint,
      value: current.isNotEmpty ? current : null,
      items: items,
    );
  }

  _hiveTypeDropDownWidget(void Function(void Function()) state) {
    return Center(
      child: Container(
        margin: symmetric(4, 16),
        decoration: BoxDecoration(
          color: colorBgRegistrationTextField,
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButtonHideUnderline(
          child: _dropDownButton(
            state,
                (s) => _hiveType = s.hiveTypeFromString,
            _hiveType?.description ?? '',
            _hintWidget(textHiveType),
            _hiveTypesDropDownItems(),
          ),
        ),
      ),
    );
  }

  _hiveTypesDropDownItems() {
    return HiveType.values.map<DropdownMenuItem<String>>((HiveType value) {
      return _dropDownItemWidget(value.description);
    }).toList();
  }

  _dropDownItemWidget(String value) {
    return DropdownMenuItem<String>(
      alignment: Alignment.centerLeft,
      value: value,
      child: Container(
        margin: left(8),
        child: Text(
          value,
          style: rTS(color: colorWhite),
        ),
      ),
    );
  }

  _hintWidget(String text) {
    return Padding(
      padding: left(8),
      child: Text(
        text,
        style: rTS(color: colorHint),
      ),
    );
  }

  _speciesDropDownWidget(void Function(void Function()) state) {
    return Center(
      child: Container(
        margin: symmetric(4, 16),
        decoration: BoxDecoration(
          color: colorBgRegistrationTextField,
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButtonHideUnderline(
          child: _dropDownButton(
            state,
                (s) => _species = s.speciesFromString,
            _species?.description ?? '',
            _hintWidget(textSpecies),
            _speciesDropDownItems(),
          ),
        ),
      ),
    );
  }

  _speciesDropDownItems() {
    return Species.values.map<DropdownMenuItem<String>>((Species value) {
      return _dropDownItemWidget(value.description);
    }).toList();
  }

  _locationHandler() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(LocationErrors.serviceDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(LocationErrors.permissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(LocationErrors.permissionDeniedForever);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getLocationName(Function(void Function()) state, {Marker? marker}) async {
    if (marker != null) {
      // returning from map
      final map = {'latitude': marker.position.latitude,
        'longitude': marker.position.longitude,};
      _position = Position.fromMap(map);
      String location = await _getLocationFromLatLng(
        marker.position.latitude,
        marker.position.longitude,
      );

      state(() {
        _locationController.text = location;
        _animateScroll();
      });
      return;
    }

    _determinePosition().then((position) async {
      _position = position;

      String location = await _getLocationFromLatLng(
        position.latitude,
        position.longitude,
      );

      state(() {
        _locationController.text = location;
        _animateScroll();
      });
    }).catchError((error) => _catchLocationError(error));
  }

  _getLocationFromLatLng(double lat,
      double long,) async {
    List<geo_coding.Placemark> locations =
    await geo_coding.placemarkFromCoordinates(lat, long);
    final mLocation = locations.first;
    return '${mLocation.country}, '
        '${mLocation.administrativeArea} - '
        '${mLocation.subAdministrativeArea} - '
        '${mLocation.name}';
  }

  _showMap(Function(void Function()) state) async {
    _determinePosition().then((position) {
      Navigator.of(context).push(
        enterFromRight(
          LocationMap(
            initial: position,
            getLocationCallback: _getLocationCallback,
            myLocationCallback: _myLocationCallback,
          ),
        ),
      );
    }).catchError((error) => _catchLocationError(error));
  }

  _myLocationCallback() => _getLocationName(locationState);

  _getLocationCallback(Marker marker) => _getLocationName(locationState,marker: marker);

  _catchLocationError(dynamic error) {
    switch (error) {
      case LocationErrors.serviceDisabled:
        showErrorPopup(LocationErrors.serviceDisabled);
        break;
      case LocationErrors.permissionDenied:
        showErrorPopup(LocationErrors.permissionDenied);
        break;
      case LocationErrors.permissionDeniedForever:
        showErrorPopup(LocationErrors.permissionDeniedForever);
        break;
    }
    logError('Exception $error');
  }

  void showErrorPopup(LocationErrors locationErrors) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            locationErrors.description,
            style: mTS(size: 18),
          ),
          content: Text(
            locationErrors.error,
            style: rTS(),
          ),
          actions: [
            if (locationErrors.action != null) locationErrors.action!,
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                textOk,
                style: rTS(),
              ),
            ),
          ],
          actionsPadding: all(8),
        );
      },
    );
  }

  _animateScroll({bool reverse = false}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController
          .animateTo(
        reverse
            ? _scrollController.position.minScrollExtent
            : _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 3),
        curve: Curves.ease,
      )
          .whenComplete(() => _animateScroll(reverse: !reverse));
    });
  }
}

enum LocationErrors {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever
}

extension LocationExtension on LocationErrors {
  String get description {
    switch (this) {
      case LocationErrors.serviceDisabled:
        return serviceDisabled;
      default:
        return permissionDenied;
    }
  }

  String get error {
    switch (this) {
      case LocationErrors.serviceDisabled:
        return errorLocationServiceDisabled;
      case LocationErrors.permissionDenied:
        return errorLocationPermissionDenied;
      case LocationErrors.permissionDeniedForever:
        return errorLocationPermissionDeniedForEver;
    }
  }

  Widget? get action {
    switch (this) {
      case LocationErrors.serviceDisabled:
        return GestureDetector(
          onTap: () async => await Geolocator.openLocationSettings(),
          child: Text(
            textLocationSettings,
            style: rTS(),
          ),
        );
      case LocationErrors.permissionDeniedForever:
        return GestureDetector(
          onTap: () async => await Geolocator.openAppSettings(),
          child: Text(
            textAppSettings,
            style: rTS(),
          ),
        );
      default:
        return null;
    }
  }
}
