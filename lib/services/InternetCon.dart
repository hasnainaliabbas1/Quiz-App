import'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
class Internet{
  bool connected =false;
  checkInternet()async{
    connected =await InternetConnectionChecker().hasConnection;
    final msg =connected ? "Connected to Internet": "Not Connected to Internet";
    showSimpleNotification(Text('$msg'));


  }
}