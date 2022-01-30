import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:http/http.dart' as http;

class AllRestaurent extends ChangeNotifier { 
  var restaurents;
  var cusineTypes;
  var searchResult;

  String firsturl = 'https://mealtime7399.herokuapp.com';

  Future getRestrobyId(id)async{
 try {
      var url = Uri.parse("$firsturl/registerRestro/$id");
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
       await EasyLoading.dismiss();
        return jsonDecode(res.body);
      }
      print('not');
     await EasyLoading.dismiss();
      return null;
    } on Exception catch (e) {
    EasyLoading.dismiss();
      print('ishh $e');
        return e;
    }
  }
  Future getAllrestaurent(BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/registerRestro");
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
       await EasyLoading.dismiss();
        restaurents = jsonDecode(res.body);
        notifyListeners();
        return restaurents;
      }
      await EasyLoading.dismiss();
      print('not');
    } on Exception catch (e) {
      await EasyLoading.dismiss();
       snackBar(e.toString(), context);
    }
  }

  Future getCusinetypes(BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/cusineTypes");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        cusineTypes = jsonDecode(res.body);
        //print(cusineTypes);
        notifyListeners();
        return cusineTypes;
      }
      return res.statusCode;
    } on Exception catch (e) {
       snackBar(e.toString(), context);
    }
  }

  Future rateRestro(token,rate,orderid,restroId)async{
    try{
   var url = Uri.parse("$firsturl/registerRestro/rate/$restroId/$rate/$orderid");
   var res = await http.post(url, headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },
      );
      if(res.statusCode==200){
        return res.body;
      }
      //snackBar('${res.body}', context);
      return res.body;
    }catch(e){
//snackBar('$e', context);
return null;
    }

  }

  Future serchProduct(String search,BuildContext context)async{
     try {
      var url = Uri.parse("$firsturl/product/$search");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        searchResult = jsonDecode(res.body);
        //print(cusineTypes);
        notifyListeners();
        return searchResult;
      }
      return jsonDecode(res.body);
    } on Exception catch (e) {
      print(e.toString());
       snackBar(e.toString(), context);
    }

  }
}
