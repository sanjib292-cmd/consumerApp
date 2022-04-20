import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:http/http.dart' as http;

class RegisterUser extends ChangeNotifier {
  String firsturl = 'https://mealtime7399.herokuapp.com';
  var msg;
  var errorMsg;
  bool verifynumMsg = false;
  bool verifynumerrorMsg = false;
  bool otpVeryfied = false;
  var userDetails;
  var sendOtperror;

  String get emsg => errorMsg;

  Future getUser(token, BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/login");
      var res = await http.get(url, headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      });
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return null;
    } on Exception catch (e) {
      return snackBar(e.toString(), context);
    }
  }

  Future registerUser(email, String name, number, BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/registeruser");
      await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({
            'phoneNumber': number,
            'name': name,
            'email': email,
          }));
          if(res.statusCode == 200){
            EasyLoading.dismiss();
            msg = res.body.toUpperCase();
            notifyListeners();
          }
          EasyLoading.dismiss();
       errorMsg = res.body;
      notifyListeners();


    } catch (ex) {
      return snackBar(ex.toString(), context);
    }
  }

  Future veriFyregister(
      number, otpcode, email, name, fcmToken, BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/verifyOtp?code=$otpcode");
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader:'application/json',
          },
          body: json.encode({
            'phoneNumber': number,
            'name': name,
            'email': email,
            'fcmToken': fcmToken
          }));

      // if (res.statusCode == 404) {
      //   otpVeryfied = false;
      //   notifyListeners();
      //   print('from sucess:${res.body}');
      //   return null;
      // }
      if (res.statusCode == 200) {
       await EasyLoading.dismiss();
        userDetails = res.headers['x-auth-token'];
        otpVeryfied = true;
        notifyListeners();
        return userDetails;
      } else {
       await EasyLoading.dismiss();
        otpVeryfied = false;
        notifyListeners();
        return null;
      }
    } catch (ex) {
      await EasyLoading.dismiss();
      return snackBar(ex.toString(), context);
    }
  }

  Future verifyNumber(number, BuildContext context) async {
    try {
      var url = Uri.parse("$firsturl/verifynum");
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({
            'phoneNumber': number,
          }));
         
      if (res.statusCode == 200) {
        await EasyLoading.dismiss();
        verifynumMsg = true;
        verifynumerrorMsg = false;
        notifyListeners();
        return verifynumMsg;
      }
      if (res.statusCode == 400) {
       await EasyLoading.dismiss();
        verifynumerrorMsg = true;
        verifynumMsg = false;
        notifyListeners();
        return verifynumMsg;
      }
    await  EasyLoading.dismiss();
      return snackBar('there is some problem..', context);
    }on SocketException catch (e){
     await EasyLoading.dismiss();
      Navigator.of(context).pop();
      //AlertDialog(title: Text(e.toString()),);
      return snackBar('No internet connection', context);
      
    }
     catch (e) {
    return snackBar(e.toString(), context);
    }
  }

  sendLoginoTp(number) async {
    try {
      var url = Uri.parse("$firsturl/login");
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({
            'phoneNumber': number,
          }));
      // errorMsg = res.body.toUpperCase();
      // notifyListeners();
      // print('$errorMsg fucking error');

    } catch (ex) {
      sendOtperror = ex;
      notifyListeners();
    }
  }

  veriFylogin(number, otpcode, fcmToken, BuildContext context) async {
    try {
       await EasyLoading.show(
                        status: 'loading...',
                        //maskType: EasyLoadingMaskType.black,
                      );
      var url = Uri.parse("$firsturl/verifylogin?code=$otpcode");
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({'phoneNumber': number, 'fcmToken': fcmToken}));

      // if (res.statusCode == 404) {
      //   otpVeryfied = false;
      //   notifyListeners();
      //   print('from sucess:${res.body}');
      //   return null;
      // }
      if (res.statusCode == 200) {
        await EasyLoading.dismiss();
        userDetails = res.body;
        otpVeryfied = true;
        notifyListeners();
        return res.body;
      } else {
      await  EasyLoading.dismiss();
        otpVeryfied = false;
        notifyListeners();
        return null;
      }
    } catch (ex) {
     await EasyLoading.dismiss();
      return snackBar(ex.toString(), context);
    }
  }

  updateUserLoc(lat,lon,token)async{
    print('ran');
    var url = Uri.parse("$firsturl/verifylogin/updateLoc/$lat/$lon");
    try {
      var res =await http.post(url, headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },);
          if(res.statusCode==200){
            print(res.body);
            return;
          }
          print('er'+res.body);
          return;
    } on Exception catch (e) {
      print(e);
      return;
    }

  }
}
