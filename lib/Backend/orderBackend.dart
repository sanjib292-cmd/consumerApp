import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;

class OrderBackend extends ChangeNotifier {
  var sucessFullyaded;
  var notAdded;
  var placedOrder;
  String firsturl = 'https://mealtime7399.herokuapp.com';
  Future getorderbyId(orderID) async {
    var url = Uri.parse("$firsturl/orders/$orderID");
    var res = await http.get(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (res.statusCode == 200) {
      placedOrder = jsonDecode(res.body);
      notifyListeners();
      return placedOrder;
    }
  }

  Future postOrder(token, restronam, orderItm, user, isPaid, lat, lon,paymentId,orderTotal,delBoychrge) async {
    var url = Uri.parse("$firsturl/orders");
    try {
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
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
            'paymentId':paymentId,
            'orderTotal':orderTotal,
            'delboyCharge':delBoychrge
          }));
      if (res.statusCode == 200) {
        await EasyLoading.dismiss();
        sucessFullyaded = jsonDecode(res.body);
        notifyListeners();
        return sucessFullyaded;
      } else {
       await EasyLoading.dismiss();
        notAdded = res.body;
        notifyListeners();
        return res.body;
      }
    } on Exception catch (e) {
     await EasyLoading.dismiss();
     return  e;
    }
  }
}
