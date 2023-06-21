import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FilterProvider extends ChangeNotifier {
  var period = 0;
  var tempPeriod = 0;
  var avlsScal = 0;
  List<String> filterAdapted = ['시가총액순'];
  List<String> filterList = ['연속 상승/하락','시가총액'];

  FilterProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    period = prefs.getInt('period') ?? 0;
    avlsScal = prefs.getInt('avlsScal') ?? 0;
    notifyListeners();
  }

  deleteFilterAdapted(var filterAdapted){
    this.filterAdapted.remove(filterAdapted);
    notifyListeners();
  }
  setFilterAdapted(var filterAdapted){
    this.filterAdapted.add(filterAdapted);
    notifyListeners();
  }
  setPeriod(var period) {
    this.period = period;
    notifyListeners();
  }

  setTempPeriod(var tempPeriod) {
    this.tempPeriod = tempPeriod;
    notifyListeners();
  }

  setAvlsScal(var avlsScal) {
    this.avlsScal = avlsScal;
    notifyListeners();
  }

}