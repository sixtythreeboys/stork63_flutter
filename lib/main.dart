import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock63/const/filter_provider.dart';
import 'multi_switch_screen.dart';
import 'stock_list.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FilterProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        //theme: style.theme,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StockList();
  }
}
