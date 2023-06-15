import 'dart:convert';
import 'package:flutter/material.dart';
import 'multi_switch_screen.dart';
import 'stock_list.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    //theme: style.theme,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StockList(period: 3, avlsScal: 0);
  }
}
