import 'package:flutter/foundation.dart';

import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Paymentrzrpay extends ChangeNotifier {
  String firsturl = 'http://192.168.0.103:5000';
  var msg;
  var errorMsg;
  Future createPayment(payment) async {
    var url = Uri.parse("$firsturl/order/$payment");
    var res = await http.post(url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({'amount': payment}));
        if(res.statusCode==200){
         var decoded=jsonDecode(res.body);
         msg=decoded['id'];
         notifyListeners();
         //print(msg);
          return jsonDecode(res.body) ;
        }
        return null;
    // res.statusCode == 200 ? msg = res.body.toUpperCase() : errorMsg = res.body;
    // notifyListeners();
    // return 
  }
}
