import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


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
                    => const Result()
                    )
                );
              },
              child: Text("조회"))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: '샵')
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

  bool val1 = true;
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
            customSwitch('연속 하락/상승', val1, onChangeFunction1),
            Option1(val1: val1),
            customSwitch('조건 2', val2, onChangeFunction2)
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


class Result extends StatelessWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("ws"),
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
    Text('하락'),
    Text('상승')
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
            Text("일 연속"),
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
