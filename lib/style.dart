import 'package:flutter/material.dart';

var theme = ThemeData(
  textTheme: TextTheme(bodyText2: TextStyle(fontSize: 15.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      color: Colors.black)
  ),
  iconTheme: IconThemeData(color: Colors.amber),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      actionsIconTheme: IconThemeData(color: Colors.black)
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: IconThemeData(color: Colors.black)
  )
);

