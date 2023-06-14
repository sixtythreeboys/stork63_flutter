import 'package:flutter/material.dart';
import 'package:stock63/const/colors.dart';
import 'package:stock63/const/text_style.dart';
import 'package:stock63/stock_detail.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockList extends StatefulWidget {
  StockList({Key? key, this.avlsScal, this.period}) : super(key: key);

  var period;
  var avlsScal;

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();
  var data = [];
  var data2 = [];
  bool isLoading = true;

  void startLoading() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      isLoading = false;
    });
  }

  void getDomesticData() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/list?period=${widget.period}&avlsScal=${widget.avlsScal}'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      print(widget.period);
      print(widget.avlsScal);
      data = List<dynamic>.from(result2);
      print(data);
    });
  }

  void getOverseaData() async {
    var resultOversea = await http.get(Uri.parse(
        'http://15.164.171.244:8000/oversea/list?period=${widget.period}&avlsScal=${widget.avlsScal}'));
    var resultOversea2 = jsonDecode(utf8.decode(resultOversea.bodyBytes));
    setState(() {
      data2 = List<dynamic>.from(resultOversea2);
      print(data2);
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    DateTime todayDateOnly =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    getDomesticData();
    getOverseaData();
    startLoading();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
              children: [_domestic(), _overSea()],
            )));
  }

  Widget _domestic() {
    if (data.isNotEmpty) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _filter(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(builder: (BuildContext context) {
                      return StockDetail(
                          htsKorIsnm: data[i]['htsKorIsnm'],
                          mkscShrnIscd: data[i]['mkscShrnIscd'],
                          prdyCtrt: data[i]['prdyCtrt']);
                    }),
                  );
                },
                child: Container(
                  height: 44,
                  margin: EdgeInsets.only(left: 20, bottom: 28),
                  child: Row(
                    children: [
                      Container(
                          width: 20,
                          height: 28,
                          alignment: Alignment.center,
                          child: Text(
                            (i + 1).toString(),
                            style: MyTextStyle.CbS18W600,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20),
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
                              margin: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                data[i]['htsKorIsnm'].toString(),
                                style: MyTextStyle.CbS18W600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text('${data[i]['stckClpr'].toString()}원',
                                      style: MyTextStyle.CgS14W400),
                                  Text(
                                    ' ${data[i]['totalCtrt'].toString()}%',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        color: data[i]['totalCtrt'] == 0
                                            ? Colors.grey
                                            : data[i]['totalCtrt'] > 0
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
            }, childCount: data.length),
          ),
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
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

  Widget _filter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1"),
        IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt)),
        OutlinedButton(
          onPressed: () {},
          child: Text(
            "시가총액순", style: MyTextStyle.Cg900S16W600,
          ),
        )
      ],
    );
  }
}
