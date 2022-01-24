import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Cart extends ChangeNotifier {
  var cart;
  var noItm;
  var sucessFullyaded;
  var notAdded;
  String firsturl = 'http://192.168.0.103:5000';
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

  Future addToCart({id, item, quantity, price, token, restroId, itmid, lat, lon}) async {
    var url = Uri.parse("$firsturl/cart/$itmid/$price");
try{
    var res = 
    await http.post(url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': token
        },
        body: json.encode({
          'total':price,
          'restroId': restroId,
          'userId': id,
          'products': [
            {'item': item, 'quantity': quantity, 'price': quantity * price}
          ],
          'cord':{
            'lat':lat,
            'lon':lon
          },
          //'item': item
          //'item':item
        }));
        print('this $lat');
    if (res.statusCode == 200) {
      // print(res.body);
      sucessFullyaded = res.body;
      notifyListeners();
      return sucessFullyaded;
    } else {
      notAdded = res.body;
      notifyListeners();
      //print('notAdded');
      return notAdded;
    }}catch(e){
      print(e);
      notAdded=e;
      notifyListeners();
      return e;
    }
  }

  Future removequentity(
      itmid, price, token, restroId, id, item, quantity,prodId) async {
    var url = Uri.parse("$firsturl/cart/removeQuentity/$itmid/$price/$prodId");
    var res = await http.post(url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': token
        },
        body: json.encode({
          'restroId': restroId,
          'total':price,
          'userId': id,
          'products': [
            {'item': item, 'quantity': quantity, 'price': quantity * price}
          ],
          //'item': item
          //'item':item
        }));
    if (res.statusCode == 200) {
      sucessFullyaded = res.body;
      notifyListeners();
      return res.body;
    } else {
      notAdded = res.body;
      notifyListeners();
      return res.body;
    }
  }
}
