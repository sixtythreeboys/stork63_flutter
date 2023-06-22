import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock63/const/filter_provider.dart';
import 'package:stock63/const/stock_list_provider.dart';
import 'stock_list.dart';
import 'package:http/http.dart' as http;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences instance를 가져옵니다.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 'filterAdapted'에 대한 데이터가 있는지 확인합니다.
  // if (!prefs.containsKey('filterAdapted')) {
  //   // 'filterAdapted'에 대한 데이터가 없다면, '시가총액순'을 포함하는 새로운 리스트를 설정합니다.
  //   List<String> defaultList = ['시가총액순'];
  //   prefs.setString('filterAdapted', json.encode(defaultList));
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StockListProvider>(
          create: (context) => StockListProvider(),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
      ],
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
