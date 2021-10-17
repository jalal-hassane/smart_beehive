import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatefulWidget {
  final Position initial;
  final Function getLocationCallback;

  const LocationMap({
    required this.initial,
    required this.getLocationCallback,
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

  late final List<Marker> _markers = <Marker>[
    Marker(
      markerId: markerId,
      position: LatLng(widget.initial.latitude, widget.initial.longitude),
    ),
  ];

  late final markerId = const MarkerId('Current Position');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
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
        ),
      );
    });
  }
}
