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
      body: MultSwitch(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: '샵')
        ],

      ),
    );
  }
}


class MultSwitch extends StatefulWidget {
  const MultSwitch({Key? key}) : super(key: key);

  @override
  State<MultSwitch> createState() => _MultSwitchState();
}

class _MultSwitchState extends State<MultSwitch> {
  bool val1 = true;
  bool val2 = false;

  onChangeFunction1(bool newValue1){
    setState(() {
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
        customSwitch('조건 2', val2, onChangeFunction2)

      ],
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
          Spacer(),
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

