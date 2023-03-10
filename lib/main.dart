import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'stock.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
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

  var data;

  getData() async{
    var result = await http.get(Uri.parse('http://15.164.171.244:8000/domestic/kospi/list?period=2&gradient=1'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      data = result2;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MultiSwitch(),
          ElevatedButton(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (c)
                    => StockList(data: data,)
                    )
                );
              },
              child: Text("์กฐํ"))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'ํ'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: '์ต')
        ],

      ),
    );
  }
}


class MultiSwitch extends StatefulWidget {

  const MultiSwitch({Key? key}) : super(key: key);

  @override
  State<MultiSwitch> createState() => _MultiSwitchState();
}

class _MultiSwitchState extends State<MultiSwitch> {

  bool val1 = false;
  bool val2 = false;

  onChangeFunction1(bool newValue1){
    setState(() {
      print(val1);
      val1 = newValue1;

    });
  }

  onChangeFunction2(bool newValue2){
    setState(() {
      val2 = newValue2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            customSwitch('์ฐ์ ํ๋ฝ/์์น', val1, onChangeFunction1),
            Option1(val1: val1),
            customSwitch('์กฐ๊ฑด 2', val2, onChangeFunction2),
      ]

    );
  }

  Widget customSwitch(String text, bool val, Function onChangeMethod){
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            color: Colors.black
          )),
          const Spacer(),
          CupertinoSwitch(
            trackColor: Colors.grey,
            activeColor: Colors.blue,
            value: val,
            onChanged: (newValue) {
              onChangeMethod(newValue);
            }
            )
        ],
      ),
    );
  }
}



class Option1 extends StatefulWidget {
  Option1({Key? key, required this.val1}) : super(key: key);

  bool val1;

  @override
  State<Option1> createState() => _Option1State();
}

class _Option1State extends State<Option1> {
  List<Widget> fruits = <Widget>[
    Text('ํ๋ฝ'),
    Text('์์น')
  ];
  final List<bool> _selectedFruits = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.val1,
      child: Padding(
        padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 70.0,
              child: TextField(
                style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.black),
              ),
            ),
            Text("์ผ ์ฐ์"),
            Spacer(),
            ToggleButtons(

              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedFruits.length; i++) {
                    _selectedFruits[i] = i == index;
                  }
                });
              },
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
}


