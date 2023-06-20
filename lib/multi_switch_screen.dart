import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/stock_list.dart';

class MultiSwitch extends StatefulWidget {
  MultiSwitch({Key? key}) : super(key: key);

  @override
  State<MultiSwitch> createState() => _MultiSwitchState();
}

class _MultiSwitchState extends State<MultiSwitch> {
  bool val1 = false;
  bool val2 = false;
  bool searchButtonEnabled = false;

  var period = '';

  var avlsScal = '';


  final List<bool> _selectedUpdown = <bool>[true, false];
  final List<bool> _selectedMarketValue = <bool>[true, false];

  void _onToggleUpdown(int index) {
    setState(() {
      // The button that is tapped is set to true, and the others to false.
      for (int i = 0; i < _selectedUpdown.length; i++) {
        _selectedUpdown[i] = i == index;
      }
      int _period = int.parse(period);
      if ((index == 1 && _period >0) || (index == 0 && _period < 0 )){
        _period *= -1;
      }
      period = _period.toString();
      print(period);
    });
  }

  void _onToggleMarketValue(int index) {
    setState(() {
      // The button that is tapped is set to true, and the others to false.
      for (int i = 0; i < _selectedMarketValue.length; i++) {
        _selectedMarketValue[i] = i == index;
      }
      int _avlsScal = int.parse(avlsScal);
      if ((index == 1 && _avlsScal >0) || (index == 0 && _avlsScal < 0 )){
        _avlsScal *= -1;
      }
      avlsScal = _avlsScal.toString();
      print(avlsScal);
    });
  }

  onChangeFunction1(bool newValue1) {
    setState(() {
      val1 = newValue1;
      updateSearchButtonState();
      print(val1);
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      val2 = newValue2;
      updateSearchButtonState();
    });
  }

  void updateSearchButtonState() {
    setState(() {
      searchButtonEnabled = val1 || val2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customSwitch('연속 하락/상승', val1, onChangeFunction1),
          option1(),
          customSwitch('시가총액', val2, onChangeFunction2),
          option2(),
          _searchButton()
        ]);
  }

  Widget customSwitch(String text, bool val, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: MyTextStyle.CbS20W600),
          const Spacer(),
          CupertinoSwitch(
              trackColor: Colors.grey,
              activeColor: Colors.blue,
              value: val,
              onChanged: (newValue) {
                onChangeMethod(newValue);
              }),
        ],
      ),
    );
  }

  Widget option1() {
    return Visibility(
      visible: val1,
      child: Padding(
        padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70.0,
              child: TextField(
                style:
                    TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
                onChanged: (text) {
                  print(text);
                  setState(() {
                    period = text;
                  });
                },
              ),
            ),
            Text("일 연속"),
            Spacer(),
            ToggleButtons(
              onPressed: _onToggleUpdown,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.white,
              textStyle: TextStyle(),
              fillColor: Colors.blue[200],
              color: Colors.blue[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedUpdown,
              children: const [Text('상승'), Text('하락')],
            ),
          ],
        ),
      ),
    );
  }

  Widget option2(){
    return Visibility(
      visible: val2,
      child: Padding(
        padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("시가총액"),
            SizedBox(width: 20,),
            SizedBox(
              width: 150.0,
              child: TextField(
                style:
                TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
                onChanged: (text) {
                  print(text);
                  setState(() {
                    avlsScal = text;
                  });
                },
              ),
            ),
            Text("억"),
            Spacer(),
            ToggleButtons(
              onPressed: _onToggleMarketValue,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.white,
              textStyle: TextStyle(),
              fillColor: Colors.blue[200],
              color: Colors.blue[400],
              isSelected: _selectedMarketValue,
              children: [Text('이상'), Text('이하')],
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchButton() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: searchButtonEnabled ? () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => StockList()));
        } : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).primaryColor.withOpacity(0.5);
            } else {
              return Theme.of(context).primaryColor;
            }
          }),
        ),
        child: Text("조회"),
      ),
    );
  }
}
