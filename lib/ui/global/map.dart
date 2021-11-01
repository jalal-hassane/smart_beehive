import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/main.dart';

class LocationMap extends StatefulWidget {
  final Position initial;
  final Function getLocationCallback;
  final Function myLocationCallback;

  const LocationMap({
    required this.initial,
    required this.getLocationCallback,
    required this.myLocationCallback,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationMap> createState() => _Map();
}

class _Map extends State<LocationMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final _zoom = 14.4746;
  late final CameraPosition _mPosition = CameraPosition(
    target: LatLng(widget.initial.latitude, widget.initial.longitude),
    zoom: _zoom,
  );

  late final List<Marker> _markers = <Marker>[];

  late final markerId = const MarkerId('Current Position');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _mPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onTap: (argument) => _markLocation(argument),
              markers: _markers.toSet(),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.getLocationCallback.call(_markers.first);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[200],
                      minimumSize: Size.zero,
                    ),
                    child: SizedBox(
                      height: screenHeight * .06,
                      child: Center(
                        child: Text(
                          textGetLocation,
                          style: mTS(color: colorWhite),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.myLocationCallback.call();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[200],
                      minimumSize: Size.zero,
                    ),
                    child: SizedBox(
                      height: screenHeight * .06,
                      child: Center(
                        child: Text(
                          textUseMyLocation,
                          style: mTS(color: colorWhite),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _markLocation(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    final newPosition = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: _zoom,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: markerId,
          position: latLng,
          onTap: () async {
            await controller.showMarkerInfoWindow(markerId);
            Future.delayed(const Duration(milliseconds: 1500), () async {
              await controller.hideMarkerInfoWindow(markerId);
            });
          },
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Lat: ${double.parse((latLng.latitude).toStringAsFixed(2))}, '
                'Long: ${double.parse((latLng.longitude).toStringAsFixed(2))}',
          ),
        ),
      );
    });
  }
}
