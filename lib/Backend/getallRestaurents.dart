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

  Future getRestrobyId(id) async {
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
      await EasyLoading.dismiss();
      return null;
    } on Exception catch (e) {
      EasyLoading.dismiss();
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
        notifyListeners();
        return cusineTypes;
      }
      return res.statusCode;
    } on Exception catch (e) {
      snackBar(e.toString(), context);
    }
  }

  Future rateRestro(token, rate, orderid, restroId, context) async {
    print('Rating');
    try {
      var url =
          Uri.parse("$firsturl/registerRestro/rate/$restroId/$rate/$orderid");
      await EasyLoading.show(
        status: 'loading...',
        //maskType: EasyLoadingMaskType.black,
      );
      var res = await http.post(
        url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': token
        },
      );
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        snackBar('${res.body}', context);
        return res.body;
      }
      EasyLoading.dismiss();
      //snackBar('${res.body}', context);
      return res.body;
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
//snackBar('$e', context);
      return null;
    }
  }

  Future serchProduct(String search, BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/product/$search");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        searchResult = jsonDecode(res.body);
        notifyListeners();
        return searchResult;
      }
      return jsonDecode(res.body);
    } on Exception catch (e) {
      snackBar(e.toString(), context);
    }
  }

  Future addbanner(BuildContext context) async {
    try {
      print('tryng');
      var url = Uri.parse("$firsturl/ads");
      EasyLoading.show(
        status: 'loading...',
      );
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (res.statusCode == 200) {
        // print('lol');
        // print(res.body);
        EasyLoading.dismiss();
        restaurents = jsonDecode(res.body);
        notifyListeners();
        return restaurents;
      }
      print('kol');
      EasyLoading.dismiss();
      return;
      //print('not');
    } on Exception catch (e) {
      await EasyLoading.dismiss();
      snackBar(e.toString(), context);
      return;
    }
  }
}
