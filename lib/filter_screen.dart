import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock63/const/button_style.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/stock_list.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("필터", style: MyTextStyle.Cg900S20W700,),
      ),
      body: Container(),
      bottomSheet: _bottomSheet()
    );
  }

  Widget _bottomSheet(){
    return Container(
      height: 129, // Set this to the desired height
      color: Colors.white, // Set this to the desired color
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24), // Adjust padding here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 133,
              height: 53,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('다시 고르기',style: MyTextStyle.Cg900S16W600,),
                style: MyButtonStyle.researchButtonStyle,
              ),
            ),
            SizedBox(
              width: 199,
              height: 53,
              child: ElevatedButton(

                onPressed: () {},
                child: Text(
                  '조회하기',
                  style: MyTextStyle.CwS18W600
                ),
                style: MyButtonStyle.searchButtonStyle
              ),
            ),
          ],
        ),
      ),
    );
  }
}
