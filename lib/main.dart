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
    theme: style.theme,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: MultiSwitch(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}
