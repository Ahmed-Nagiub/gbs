import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class homeScreen extends StatefulWidget {

  static const String routeName='Home';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  Set<Marker> markers={};
  var defLat= 30.035863;
  var defLong= 31.1965055;
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 89.440717697143555,
      zoom: 20.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    Marker UserMarker = Marker(
      markerId: MarkerId('user_location'),
      position: LatLng(
          locationData?.latitude ?? defLat, locationData?.longitude ?? defLong),
    );
    markers.add(UserMarker);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text('GBS',style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: currentLocationMap==null ? _kLake : currentLocationMap!,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Current Location'),
        icon: const Icon(Icons.gps_fixed),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLocationMap!));
  }

  Location location = Location();

  late PermissionStatus permissionStatus;

  bool? serviceEnable;
  StreamSubscription<LocationData>? streamSubscription;
  LocationData? locationData;
  CameraPosition? currentLocationMap;


  void getCurrentLocation() async{
    var service = await isServiceEnable();
    if(service == false) return;
    var permission = await isPermissionGranted();
    if(permission == false) return;
    locationData = await location.getLocation();
    print('My Current Location ${locationData?.latitude} long: ${locationData?.longitude}');

    currentLocationMap = CameraPosition(
      target: LatLng(locationData?.latitude??29.83, locationData?.longitude??31.38),
      zoom: 19.4746,
    );
    updateUserMarker();

    streamSubscription = location.onLocationChanged.listen((event) {
      locationData=event;
      print('My Current Location ${locationData?.latitude} long: ${locationData?.longitude}');
    });
  }
  void updateUserMarker() async {
    print('route4');
    Marker UserMarker = Marker(
      markerId: MarkerId('user_location'),
      position: LatLng(
          locationData?.latitude ?? defLat, locationData?.longitude ?? defLong),
    );
    markers.add(UserMarker);
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(currentLocationMap!));
    setState(() {

    });
  }

  // AIzaSyCHQsElrB9_JnvraM-Kvf-BDR4HthRham8
  Future<bool> isServiceEnable() async{
    serviceEnable = await location.serviceEnabled();
    if(serviceEnable == false){
      serviceEnable = await location.requestService();
      return serviceEnable!;
    }else{
      return serviceEnable!;
    }
  }

  Future<bool> isPermissionGranted() async{
    permissionStatus = await location.hasPermission();
    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }else{
      return permissionStatus == PermissionStatus.granted;
    }
  }
}
