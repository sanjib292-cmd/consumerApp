import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class Cart extends ChangeNotifier {
  var cart;
  var noItm;
  var sucessFullyaded;
  var notAdded;
  var deletsucess, delfail;
  String firsturl = 'https://mealtime7399.herokuapp.com';
  getCart(token) async {
    var url = Uri.parse("$firsturl/cart");
    var res = await http.get(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-auth-token': token
    });
    if (res.statusCode == 200) {
      cart = jsonDecode(res.body);
      notifyListeners();
      return cart;
    }
    noItm = jsonDecode(res.body);
    notifyListeners();
    return noItm;
  }

  Future addToCart(
      {id, item, quantity, price, token, restroId, itmid, lat, lon}) async {
    var url = Uri.parse("$firsturl/cart/$itmid/$price");
    try {
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },
          body: json.encode({
            'total': price,
            'restroId': restroId,
            'userId': id,
            'products': [
              {'item': item, 'quantity': quantity, 'price': quantity * price}
            ],
            'cord': {'lat': lat, 'lon': lon},
            //'item': item
            //'item':item
          }));
      await EasyLoading.show(
        status: 'loading...',
      );
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        sucessFullyaded = res.body;
        notifyListeners();
        return sucessFullyaded;
      } else {
        EasyLoading.dismiss();
        notAdded = res.body;
        notifyListeners();
        return notAdded;
      }
    } catch (e) {
      EasyLoading.dismiss();
      notAdded = e;
      notifyListeners();
      return e;
    }
  }

  Future removequentity(
      itmid, price, token, restroId, id, item, quantity, prodId) async {
    var url = Uri.parse("$firsturl/cart/removeQuentity/$itmid/$price/$prodId");
    var res = await http.post(url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': token
        },
        body: json.encode({
          'restroId': restroId,
          'total': price,
          'userId': id,
          'products': [
            {'item': item, 'quantity': quantity, 'price': quantity * price}
          ],
          //'item': item
          //'item':item
        }));
        await EasyLoading.show(
        status: 'loading...',
      );
    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      sucessFullyaded = res.body;
      notifyListeners();
      return res.body;
    } else {
      EasyLoading.dismiss();
      notAdded = res.body;
      notifyListeners();
      return res.body;
    }
  }

  Future removeItem(itmid, prodId, price, token, quentity) async {
    var url =
        Uri.parse("$firsturl/cart/removeitm/$itmid/$prodId/$price/$quentity");
        await EasyLoading.show(
        status: 'loading...',
      );
    var res = await http.post(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-auth-token': token
    });

    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      sucessFullyaded = res.body;
      notifyListeners();
      return res.body;
    } else {
      EasyLoading.dismiss();
      notAdded = res.body;
      notifyListeners();
      return res.body;
    }
  }

  Future deletCart(token) async {
    var url = Uri.parse("$firsturl/cart");
    try {
      await EasyLoading.show(
        status: 'loading...',
      );
      var res = await http.delete(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      });
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        deletsucess = res.body;
        notifyListeners();
        return res.body;
      }
      EasyLoading.dismiss();
      delfail = res.body;
      notifyListeners();
      return res.body;
    } catch (e) {}
  }
}
