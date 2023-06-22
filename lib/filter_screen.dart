import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock63/avlsScalScreen.dart';
import 'package:stock63/const/button_style.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/period_screen.dart';
import 'package:stock63/stock_list.dart';

import 'const/filter_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Future<void> printAllPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use the .getKeys() method to get all keys
    Set<String> keys = prefs.getKeys();

    // Iterate over all keys and print them with their values
    for (String key in keys) {
      print('key: $key, value: ${prefs.get(key)}');
    }
  }
  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();

    return Scaffold(
        backgroundColor: MyColors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "필터",
            style: MyTextStyle.Cg900S20W700,
          ),
        ),
        body: _filterList(filterProvider.filterList),
        bottomSheet: _bottomSheet());
  }

  Widget _filterList(List<String> filterList) {
    return ListView.builder(
      itemCount: filterList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => PeriodScreen(index: index),
                ),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => AvlsScalScreen(index: index),
                ),
              );
            }
          },
          title: Container(
            width: 390,
            height: 64,
            alignment: Alignment.centerLeft,
            child: Text(
              filterList[index],
              style: MyTextStyle.CbS18W600,
            ),
          ),
        );
      },
    );
  }

  Widget _bottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            // 상단에만 선 추가
            color: MyColors.grey400,
            width: 1.0, // 선 두께 설정
          ),
        ),
      ),
      height: 129, // Set this to the desired height
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        // Adjust padding here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: ElevatedButton(
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setInt('tempPeriod', 0);
                  printAllPreferences();
                },
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/images/icon-refresh-mono.png'),
                      color: MyColors.grey700,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '다시 고르기',
                      style: MyTextStyle.Cg900S16W600,
                    ),
                  ],
                ),
                style: MyButtonStyle.researchButtonStyle,
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () async{
                    var filterProvider = context.read<FilterProvider>();
                    filterProvider.setPeriod(filterProvider.tempPeriod);
                    if (filterProvider.tempPeriod != 0 && !filterProvider.getFilterAdapted().contains('연속 상승/하락')) {
                      filterProvider.setFilterAdapted('연속 상승/하락');
                    }
                    filterProvider.setAvlsScal(filterProvider.tempAvlsScal);
                    if (filterProvider.tempAvlsScal != 0 && !filterProvider.getFilterAdapted().contains('시가총액')) {
                      filterProvider.setFilterAdapted('시가총액');
                    }

                    filterProvider.getDomesticData(filterProvider.period,filterProvider.avlsScal);
                    filterProvider.getOverseaData(filterProvider.period,filterProvider.avlsScal);
                    Navigator.pop(context);
                  },
                  child: Text('조회하기', style: MyTextStyle.CwS18W600),
                  style: MyButtonStyle.searchButtonStyle),
            ),
          ],
        ),
      ),
    );
  }
}
