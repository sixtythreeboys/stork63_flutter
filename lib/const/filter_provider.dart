import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


class FilterProvider extends ChangeNotifier {
  var period = 3;
  var avlsScal = 0;
  List<String> filterAdapted = ['항목1', '항목2', '항목3', '항목4', '항목5'];
  List<String> filterList = ['연속 상승/하락','시가총액'];

  setPeriod(var period) {
    this.period = period;
    notifyListeners();
  }

  setAvlsScal(var avlsScal) {
    this.avlsScal = avlsScal;
    notifyListeners();
  }
}