import 'package:flutter/material.dart';

import 'colors.dart';


class MyButtonStyle {

  static ButtonStyle nextButtonStyleDisabled = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    backgroundColor: MaterialStatePropertyAll(MyColors.blue100),
  );

  static ButtonStyle roleSelectButtonEnabled = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.blue500),
      ),
    ),
  );

  static ButtonStyle roleSelectButtonDisabled = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.gray300),
      ),
    ),
  );

  static ButtonStyle categoryUnselectedButton = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.white),
      ),
    ),
  );

  static ButtonStyle categorySelectedButton = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.white),
      ),
    ),
    backgroundColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.2)),
  );

  static ButtonStyle whiteBorder12 = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(width: 1, color: MyColors.white),
      ),
    ),
  );

  static ButtonStyle jobUnSelectButtonEnabled = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.gray300),
      ),
    ),
  );

  static ButtonStyle jobSelectButtonEnabled = ButtonStyle(
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(width: 1, color: MyColors.blue500),
      ),
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return MyColors.blue50.withOpacity(0.5);
      } else {
        return MyColors.blue50;
      }
    }),
  );
}