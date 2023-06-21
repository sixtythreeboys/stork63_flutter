import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class StockListProvider extends ChangeNotifier {

  var domesticData = [];


  var overSeaData= [];

  void getDomesticData(var period, var avlsScal) async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/list?period=${period}&avlsScal=${avlsScal}'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    domesticData = List<dynamic>.from(result2);
  }


  setOverSeaData(var overSeaData){
    this.overSeaData  = overSeaData;
    notifyListeners();
  }
}