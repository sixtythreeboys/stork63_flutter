import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FilterProvider extends ChangeNotifier {
  var period=0;
  var tempPeriod = 0;

  var avlsScal=0;
  var tempAvlsScal = 0;
  List<String> filterAdapted = ['시가총액순'];
  List<String> filterList = ['연속 상승/하락','시가총액'];

  var domesticData = [];
  var overseaData = [];

  void getDomesticData(var period, var avlsScal) async {
    print("getDomesticData 호출");
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/list?period=$period&avlsScal=$avlsScal'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    print('avlsScal: $avlsScal');
    print('period: $period');
    domesticData = List<dynamic>.from(result2);
    notifyListeners();
  }

  void getOverseaData(var period, var avlsScal) async {

    print("getOverseaData 호출");
    var resultOversea = await http.get(Uri.parse(
        'http://15.164.171.244:8000/oversea/list?period=${period}&avlsScal=${avlsScal}'));
    var resultOversea2 = jsonDecode(utf8.decode(resultOversea.bodyBytes));
    print('avlsScal: $avlsScal');
    print('period: $period');
    overseaData = List<dynamic>.from(resultOversea2);
    notifyListeners();
  }




  deleteFilterAdapted(var filterAdapted){
    this.filterAdapted.remove(filterAdapted);
    notifyListeners();
  }
  setFilterAdapted(var filterAdapted){
    this.filterAdapted.insert(0,filterAdapted);
    notifyListeners();
  }
  getFilterAdapted(){
    return filterAdapted;
  }
  setPeriod(var period) {
    this.period = period;
    notifyListeners();
  }
  getPeriod(){
    return period;
  }

  setTempPeriod(var tempPeriod) {
    this.tempPeriod = tempPeriod;
    notifyListeners();
  }

  setAvlsScal(var avlsScal) {
    this.avlsScal = avlsScal;
    notifyListeners();
  }
  getAvlsScal() {
    return avlsScal;
  }
  setTempAvlsScal(var tempAvlsScal) {
    this.tempAvlsScal = tempAvlsScal;
    notifyListeners();
  }

  resetOverSeaData() {
    overseaData = [];
    notifyListeners();
  }
  resetDomesticData() {
    domesticData = [];
    notifyListeners();
  }

}