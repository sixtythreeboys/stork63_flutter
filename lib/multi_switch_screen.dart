import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var gradient = 0;
  var period = '';

  List<Widget> fruits = <Widget>[Text('하락'), Text('상승')];
  final List<bool> _selectedFruits = <bool>[true, false];

  void _onToggle(int index) {
    setState(() {
      // The button that is tapped is set to true, and the others to false.
      for (int i = 0; i < _selectedFruits.length; i++) {
        _selectedFruits[i] = i == index;
      }
      print(index);
      gradient = index;
      print(gradient);
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
          customSwitch('조건 2', val2, onChangeFunction2),
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
              style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
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
              onPressed: _onToggle,
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
              isSelected: _selectedFruits,
              children: fruits,
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
              context, MaterialPageRoute(builder: (c) => StockList(gradient: gradient, period: period)));
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
