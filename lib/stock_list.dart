import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/filter_provider.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/stock_detail.dart';
import 'const/stock_list_provider.dart';
import 'filter_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StockList extends StatefulWidget {
  StockList({Key? key}) : super(key: key);

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'ko_KR');

  Future<void> printAllPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use the .getKeys() method to get all keys
    Set<String> keys = prefs.getKeys();

    // Iterate over all keys and print them with their values
    for (String key in keys) {
      print('key: $key, value: ${prefs.get(key)}');
    }
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() async {
    final filterProvider = context.read<FilterProvider>();
    filterProvider.getDomesticData(0, 0);
    filterProvider.getOverseaData(0, 0);
    print("stock_list loadData 실행");
    printAllPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MyColors.white,
        appBar: AppBar(
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            labelColor: MyColors.grey900,
            unselectedLabelColor: MyColors.grey600,
            tabs: const [Tab(text: "국내"), Tab(text: "해외")],
            indicatorColor: MyColors.grey900,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey),
          elevation: 0.0,
          title: Text(
            "STOCK63",
            style: MyTextStyle.CgS20W700,
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            _domestic(
                filterProvider.domesticData, filterProvider.filterAdapted),
            _overSea(filterProvider.overseaData, filterProvider.filterAdapted)
          ],
        ),
      ),
    );
  }

  Widget _domestic(var domesticData, var filterAdapted) {
    final filterProvider = context.read<FilterProvider>();
    if (domesticData.isNotEmpty) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _filter(filterAdapted),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          StockDetail(
                              division: 0,
                              htsKorIsnm: domesticData[i]['htsKorIsnm'],
                              mkscShrnIscd: domesticData[i]['mkscShrnIscd'],
                              prdyCtrt: domesticData[i]['prdyCtrt']),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, bottom: 28),
                  child: Row(
                    children: [
                      Container(
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            (i + 1).toString(),
                            style: MyTextStyle.CbS18W600,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        child: CircleAvatar(
                            backgroundColor: MyColors.grey300 // 배경색
                            ),
                      ),
                      Container(
                        width: 250,
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                domesticData[i]['htsKorIsnm'].toString(),
                                style: MyTextStyle.CbS18W600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    formatCurrency
                                        .format((domesticData[i]['stckClpr'])),
                                    style: MyTextStyle.CgS14W400,
                                  ),
                                  Text(
                                    ' ',
                                    style: MyTextStyle.CgS14W400,
                                  ),
                                  Text(
                                    filterProvider.getPeriod() > 0
                                        ? filterProvider.getPeriod().toString() + '일 전보다'
                                        : filterProvider.getPeriod() < 0
                                            ? (filterProvider.getPeriod() *
                                                    (-1)).toString() + '일 전보다'
                                            : '',
                                    style: MyTextStyle.CgS14W400,
                                  ),
                                  Text(
                                    ' ${domesticData[i]['totalCtrt'].toString()}%',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        color: domesticData[i]['totalCtrt'] == 0
                                            ? Colors.grey
                                            : domesticData[i]['totalCtrt'] > 0
                                                ? Colors.red
                                                : Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: domesticData.length),
          ),
        ],
      );
    } else {
      return _shimmer();
    }
  }

  Widget _overSea(var overseaData, var filterAdapted) {
    if (overseaData.isNotEmpty) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _filter(filterAdapted),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  printAllPreferences();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>

                          Scaffold(appBar: AppBar(
                            iconTheme: IconThemeData(color: Colors.grey),
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                          ),body: Container(child: Center(child :Text("차트오픈예정"),))),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, bottom: 28),
                  child: Row(
                    children: [
                      Container(
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            (i + 1).toString(),
                            style: MyTextStyle.CbS18W600,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        child: CircleAvatar(
                            backgroundColor: MyColors.grey300 // 배경색
                            ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 250,
                              margin: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                overseaData[i]['htsKorIsnm'].toString(),
                                style: MyTextStyle.CbS18W600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    '${overseaData[i]['stckClpr'].toString()}달러',
                                    style: MyTextStyle.CgS14W400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    ' ${overseaData[i]['totalCtrt'].toString()}%',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        color: overseaData[i]['totalCtrt'] == 0
                                            ? Colors.grey
                                            : overseaData[i]['totalCtrt'] > 0
                                                ? Colors.red
                                                : Colors.blue),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: overseaData.length),
          ),
        ],
      );
    } else {
      return _shimmer();
    }
  }

  Widget _filter(var filterAdapted) {
    var filterProvider = context.read<FilterProvider>();
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: 60.0, // 리스트뷰의 높이를 지정합니다.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          FilterScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/icon_filter_mono.png',
                ),
              ),
              SizedBox(
                width: 10, // 아이콘과 리스트 사이에 간격을 주기 위해 사용합니다.
              ),
              Expanded(
                // Expanded를 이곳으로 옮겨주었습니다.
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterAdapted.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(12.0), // 세트 간 간격을 위해 마진을 추가합니다.
                      padding: EdgeInsets.only(
                        left: 12,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.grey150, // 배경색을 설정합니다.
                        borderRadius:
                            BorderRadius.circular(5.0), // 선택적으로 모서리를 둥글게 만듭니다.
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            filterAdapted[index],
                            style: MyTextStyle.Cg800S16W600,
                          ),
                          if (filterAdapted[index] != '시가총액순')
                            IconButton(
                              color: MyColors.grey500,
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                if (filterAdapted[index] == '연속 상승/하락') {
                                  print("연속 상승/하락 분기");
                                  filterProvider.setPeriod(0);
                                  filterProvider.setTempPeriod(0);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setInt("period", 0);
                                  prefs.setInt("tempPeriod", 0);
                                  filterProvider.resetDomesticData();
                                  filterProvider.resetOverSeaData();

                                  filterProvider.getDomesticData(
                                      filterProvider.getPeriod(),
                                      filterProvider.getAvlsScal());

                                  filterProvider.getOverseaData(
                                      filterProvider.getPeriod(),
                                      filterProvider.getAvlsScal());
                                }
                                if (filterAdapted[index] == '시가총액') {
                                  print("시가총액 분기");

                                  filterProvider.setAvlsScal(0);
                                  filterProvider.setTempAvlsScal(0);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setInt("avlsScal", 0);
                                  prefs.setInt("tempAvlsScal", 0);
                                  print(
                                      'filterProvider.getPeriod() = $filterProvider.getPeriod()');
                                  print(
                                      'filterProvider.getPeriod() = $filterProvider.getPeriod()');
                                  filterProvider.getDomesticData(
                                      filterProvider.getPeriod(),
                                      filterProvider.getAvlsScal());

                                  filterProvider.getOverseaData(
                                      filterProvider.getPeriod(),
                                      filterProvider.getAvlsScal());
                                }

                                filterProvider
                                    .deleteFilterAdapted(filterAdapted[index]);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 36,
        )
      ],
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 20, // 표시할 shimmer item의 개수를 지정
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 44,
            margin: EdgeInsets.only(left: 20, bottom: 28),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 28,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20, // 텍스트 컨테이너 높이
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 20, // 텍스트 컨테이너 높이
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
