import 'package:flutter/foundation.dart';

import 'dart:io';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class Paymentrzrpay extends ChangeNotifier {
  String firsturl = 'https://mealtime7399.herokuapp.com';
  var msg;
  var errorMsg;
  Future createPayment(payment) async {
    var url = Uri.parse("$firsturl/order/$payment");
     await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
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
         await EasyLoading.dismiss();
          return jsonDecode(res.body) ;
        }
        await EasyLoading.dismiss();
        return null;
    // res.statusCode == 200 ? msg = res.body.toUpperCase() : errorMsg = res.body;
    // notifyListeners();
    // return 
  }
}
