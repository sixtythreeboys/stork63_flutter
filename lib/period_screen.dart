import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const/button_style.dart';
import 'const/filter_provider.dart';

class PeriodScreen extends StatefulWidget {
  PeriodScreen({Key? key, this.index}) : super(key: key);
  var index;

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}


class _PeriodScreenState extends State<PeriodScreen> {

  final myController = TextEditingController();
  List<bool> _isSelected = [false, false];
  var tempPeriod;
  Future<void> printAllPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use the .getKeys() method to get all keys
    Set<String> keys = prefs.getKeys();

    // Iterate over all keys and print them with their values
    for (String key in keys) {
      print('key: $key, value: ${prefs.get(key)}');
    }
  }

  // In the initState method, set the initial value
  @override
  void initState() {
    super.initState();
    _setInitialValue();
  }

  Future<void> _setInitialValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int storedValue = prefs.getInt('tempPeriod') ?? 0;
    myController.text = storedValue.toString();
    _isSelected[0] = prefs.getBool('isSelectedFirst')?? false;
    _isSelected[1] = prefs.getBool('isSelectedSecond')?? false;
  }


  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          _detail(filterProvider.filterList, widget.index),
          _selectButton(),
        ],
      ),
    );
  }

  Widget _detail(List<String> filterList, var index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(21),
          alignment: Alignment.centerLeft,
          width: 390,
          height: 63,
          child: Text(
            filterList[index],
            style: MyTextStyle.CbS20W700,
          ),
        ),
        Container(
          padding: EdgeInsets.all(21),
          alignment: Alignment.centerLeft,
          width: 390,
          height: 63,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '조건 1',
                style: MyTextStyle.CbS18W600,
              ),
              SizedBox(width: 50.0), // 추가적인 간격
              Expanded(
                child: TextField(
                  controller: myController,
                  keyboardType: TextInputType.number,
                  onChanged: (text) async {
                    setState(() {
                      tempPeriod = int.parse(text);
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('tempPeriod', tempPeriod);
                    printAllPreferences();
                  },
                ),
              ),
              SizedBox(width: 14.0), // 추가적인 간격
              Text(
                '일 연속',
                style: MyTextStyle.CbS18W600,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 35, right: 20),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Text(
                '조건 2',
                style: MyTextStyle.CbS18W600,
              ),
              SizedBox(width: 50.0),
              Container(
                color: MyColors.grey200,
                child: ToggleButtons(
                  onPressed: (int index) async {
                    setState(
                      () {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      },
                    );
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isSelectedFirst', _isSelected[0]);
                    await prefs.setBool('isSelectedSecond', _isSelected[1]);
                    printAllPreferences();
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedColor: MyColors.grey900,
                  fillColor: MyColors.white,
                  color: MyColors.grey600,
                  isSelected: _isSelected,
                  children: <Widget>[
                    Container(
                      child: Text('상승'),
                      alignment: Alignment.center,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text('하락'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _selectButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      height: 54,
      child: TextButton(
        onPressed: () async{

          SharedPreferences prefs = await SharedPreferences.getInstance();
          // Use the read method of context to get the FilterProvider
          var filterProvider = context.read<FilterProvider>();
          if (prefs.getBool('isSelectedSecond') ?? false) {
            // If yes, make tempPeriod negative
            filterProvider.setTempPeriod((prefs.getInt('tempPeriod') ?? 0) * -1);
          } else {
            // If not, use tempPeriod as is
            filterProvider.setTempPeriod(prefs.getInt('tempPeriod') ?? 0);
          }
          Navigator.pop(context);
        },
        style: MyButtonStyle.searchButtonStyle,
        child: Text(
          '확인',
          style: MyTextStyle.CwS18W600,
        ),
      ),
    );
  }
}
