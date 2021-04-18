import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:table/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void func() async {
    print('yeah yeah');
    var response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins=37.164041578841314, -121.64605305117325&destinations=37.323552557419376, -122.01020882418642&key=AIzaSyBbGbjJla8JroUeVuCtbw9Hw7sd4suTkHQ'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var duration = jsonResponse['rows'][0]['elements'][0]['duration']['text'];
      print('farness: ${duration.toString()}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  GoogleMapController mapController;
  Set<Marker> markers = {};
  void initState() {
    super.initState();
    print('linus is watching');
    func();
    print('linus is not watching');
    markers.add(Marker(position: LatLng(37.164041578841314, -121.64605305117325), markerId: new MarkerId("thomas")));
    markers.add(Marker(position: LatLng(37.274160, -121.749710), markerId: new MarkerId("kashyap")));
    markers.add(Marker(position: LatLng(37.318490, -121.766480), markerId: new MarkerId("rohan")));
  }


  final LatLng _center = const LatLng(37.323552557419376, -122.01020882418642);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: currDividerColor, //change your color here
          ),
          title: Text("Group Map", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
          backgroundColor: currBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: currBackgroundColor,
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 9.0,
          ),
          markers: markers,
        ),
      ),
    );
  }
}