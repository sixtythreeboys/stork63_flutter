import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/text_style.dart';

import 'const/button_style.dart';
import 'const/filter_provider.dart';

class PeriodScreen extends StatefulWidget {
  PeriodScreen({Key? key, this.index}) : super(key: key);
  var index;

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  List<bool> _isSelected = [false, false];

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
          _selectButton()
        ],
      ),
    );
  }

  Widget _detail(List<String> filterList, var index) {
    var periodTemp = 0;
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
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    print(text);
                    setState(() {
                      periodTemp = int.parse(text);
                    });
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
          padding: EdgeInsets.only(left: 20,top: 35,right: 20),
          alignment: Alignment.centerLeft,width: double.infinity,
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
                  onPressed: (int index) {
                    setState(
                      () {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      },
                    );
                    print(_isSelected);
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

  Widget _selectButton(){
    return Container(
      width: double.infinity,
    margin: EdgeInsets.all(20),
      height: 54,
      child: TextButton(
        onPressed: () {
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
