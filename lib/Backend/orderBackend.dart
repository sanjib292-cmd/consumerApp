import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class OrderBackend extends ChangeNotifier {
  var sucessFullyaded;
  var notAdded;
  var placedOrder;
  String firsturl = 'http://192.168.0.103:5000';
  Future getorderbyId(orderID) async {
    var url = Uri.parse("$firsturl/orders/$orderID");
    var res = await http.get(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (res.statusCode == 200) {
      print(res.body);
      placedOrder = jsonDecode(res.body);
      notifyListeners();
      return placedOrder;
    }
  }

  Future postOrder(token, restronam, orderItm, user, isPaid, lat, lon,paymentId) async {
    var url = Uri.parse("$firsturl/orders");
    try {
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },
          body: json.encode({
            'restroName': restronam,
            'orderItems': orderItm,
            'user': user,
            'paid': isPaid,
            'lat': lat,
            'lon': lon,
            'paymentId':paymentId
          }));
      if (res.statusCode == 200) {
        sucessFullyaded = jsonDecode(res.body);
        notifyListeners();
        return sucessFullyaded;
      } else {
        notAdded = res.body;
        notifyListeners();
        return res.body;
      }
    } on Exception catch (e) {
      print('wtf excption $e');
    }
  }
}
