import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/filter_provider.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/stock_detail.dart';
import 'filter_screen.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StockList extends StatefulWidget {
  StockList({Key? key}) : super(key: key);

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();
  var domesticData = [];
  var data2 = [];
  bool isLoading = true;

  void startLoading() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      isLoading = false;
    });
  }

  void getDomesticData(var period, var avlsScal) async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/list?period=${period}&avlsScal=${avlsScal}'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      domesticData = List<dynamic>.from(result2);
    });
  }

  void getOverseaData(var period, var avlsScal) async {
    var resultOversea = await http.get(Uri.parse(
        'http://15.164.171.244:8000/oversea/list?period=${period}&avlsScal=${avlsScal}'));
    var resultOversea2 = jsonDecode(utf8.decode(resultOversea.bodyBytes));
    setState(() {
      data2 = List<dynamic>.from(resultOversea2);
      print(data2);
    });
  }

  @override
  void initState() {
    super.initState();
    startLoading();
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
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
            ),
            body: TabBarView(
              children: [
                _domestic(filterProvider.period, filterProvider.avlsScal,
                    filterProvider.filterAdapted),
                _overSea()
              ],
            )));
  }

  Widget _domestic(var period, var avlsScal, var filterAdapted) {
    getDomesticData(period, avlsScal);
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
                              htsKorIsnm: domesticData[i]['htsKorIsnm'],
                              mkscShrnIscd: domesticData[i]['mkscShrnIscd'],
                              prdyCtrt: domesticData[i]['prdyCtrt']),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Container(
                  height: 44,
                  margin: EdgeInsets.only(left: 20, bottom: 28),
                  child: Row(
                    children: [
                      Container(
                          width: 40,
                          height: 28,
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
                              width: 268,
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
                                      '${domesticData[i]['stckClpr'].toString()}원',
                                      style: MyTextStyle.CgS14W400),
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
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 200.0,
          height: 200.0,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _overSea() {
    if (data2.isNotEmpty) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.red,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(builder: (BuildContext context) {
                      return StockDetail(
                          htsKorIsnm: data2[i]['htsKorIsnm'],
                          mkscShrnIscd: data2[i]['mkscShrnIscd'],
                          prdyCtrt: data2[i]['prdyCtrt']);
                    }),
                  );
                },
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 21,
                            alignment: Alignment.center,
                            child: Text((i + 1).toString(),
                                style: MyTextStyle.CblS20W700)),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 20, // 반지름 크기
                            backgroundColor: Colors.grey, // 배경색
                            child: Icon(Icons.person,
                                size: 30, color: Colors.white), // 프로필 아이콘
                          ),
                        ),
                        Container(
                          width: 240,
                          margin: EdgeInsets.only(left: 7),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data2[i]['htsKorIsnm'].toString(),
                                  style: MyTextStyle.CbS20W700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      '${data2[i]['stckClpr'].toString()}달러',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      ' ${data2[i]['totalCtrt'].toStringAsFixed(2)}%',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          color: data2[i]['totalCtrt'] == 0
                                              ? Colors.grey
                                              : data2[i]['totalCtrt'] > 0
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
                  ],
                ),
              );
            }, childCount: data2.length),
          ),
        ],
      );
    } else {
      if (isLoading) {
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          child: Text("데이터가 없거나 인터넷이 불안정합니다."),
        );
      }
    }
  }

  Widget _filter(var filterAdapted) {
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
                      padding: EdgeInsets.only(left: 12,),
                      decoration: BoxDecoration(
                        color: MyColors.grey150, // 배경색을 설정합니다.
                        borderRadius: BorderRadius.circular(5.0), // 선택적으로 모서리를 둥글게 만듭니다.
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            filterAdapted[index],
                            style: MyTextStyle.Cg800S16W600,
                          ),
                          IconButton(
                            color: MyColors.grey500,
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                filterAdapted.removeAt(index);
                              });
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
}
