import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Location extends ChangeNotifier {
  var lat;
  var lon;
  var adrs;
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled. hlo');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final geopos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    lat = geopos.latitude;
    lon = geopos.longitude;
    notifyListeners();
    return geopos;
    //print('${geopos.latitude}, ${geopos.longitude}');
  }

  String placeaddress='';
  String apiKey = "AIzaSyDN2f-K_FFbXH-DrAOxwlRvNy3L9z9asyg";
  Future getAddress(lat, lon) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}&key=${apiKey}");
    var res = await http.get(
      url,
    );
    try {
      if (res.statusCode == 200) {
        String data = res.body;
        var decodedData = jsonDecode(data);
        placeaddress=decodedData["results"][0]["formatted_address"];
        notifyListeners();
        return decodedData;
      }
      return "404 ERROR";
    } on Exception catch (e) {
      print(e);
    }
  }
}

// I/flutter ( 7835): {plus_code: {compound_code: FGHH+GP4 Bongaigaon, Assam, India, global_code: 7MRGFGHH+GP4}, results: [{address_components: [{long_name: FGHJ+83H, short_name: FGHJ+83H, types: [plus_code]}, {long_name: Natunpara, short_name: Natunpara, types: [political, sublocality, sublocality_level_1]}, {long_name: New Bongaigaon Rly. Colony, short_name: New Bongaigaon Rly. Colony, types: [locality, political]}, {long_name: Chirang, short_name: Chirang, types: [administrative_area_level_2, political]}, {long_name: Assam, short_name: AS, types: [administrative_area_level_1, political]}, {long_name: India, short_name: IN, types: [country, political]}, {long_name: 783381, short_name: 783381, types: [postal_code]}], formatted_address: FGHJ+83H, Natunpara, New Bongaigaon Rly. Colony, Assam 783381, India, geometry: {bounds: {northeast: {lat: 26.4783134, lng: 90.5302658}, southwest: {lat: 26.4782572, lng: 90.5302213}}, location: {lat: 26.4782832, lng: 90.53024099999999}, location_type: ROOFTOP, viewport: {northeast: {lat: 26.47963;