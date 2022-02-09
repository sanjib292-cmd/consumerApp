import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CouponBackend extends ChangeNotifier{
  var applied,problem;
   String firsturl = 'https://mealtime7399.herokuapp.com';
  getCoupon() async {
    var url = Uri.parse("$firsturl/coupon");
     await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
    var res = await http.get(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      //'x-auth-token': token
    });
    if (res.statusCode == 200) {
      await EasyLoading.dismiss();
      return jsonDecode(res.body);
    }
   await EasyLoading.dismiss();
  
    return null;
  }

  applyCoupon(couponCode,token)async{
     var url = Uri.parse("$firsturl/coupon/applycoupon/$couponCode");
      await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
    var res = await http.post(url, headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-auth-token': token
    });
    if (res.statusCode == 200) {
      await EasyLoading.dismiss();
      applied=jsonDecode(res.body);
      notifyListeners();
      return jsonDecode(res.body);
    }
    await EasyLoading.dismiss();
    problem=res.body;
    notifyListeners();
  
    return null;

  }


}