import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:http/http.dart' as http;

class AllRestaurent extends ChangeNotifier { 
  var restaurents;
  var cusineTypes;
  var searchResult;

  String firsturl = 'http://192.168.0.103:5000';

  Future getRestrobyId(id)async{
 try {
      var url = Uri.parse("$firsturl/registerRestro/$id");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      print('not');
    } on Exception catch (e) {
      print('ishh $e');
    }
  }
  Future getAllrestaurent(BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/registerRestro");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        restaurents = jsonDecode(res.body);
        notifyListeners();
        return restaurents;
      }
      print('not');
    } on Exception catch (e) {
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
