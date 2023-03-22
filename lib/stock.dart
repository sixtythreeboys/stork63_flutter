import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;

class Stock extends StatelessWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: StockOverView(),
        ),
        StockList()
      ],
    );
  }
}

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();
  var data = [];

  getData() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/list?period=2&gradient=1'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      data = result2;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: "국내",
                    ),
                    Tab(
                      text: "해외",
                    )
                  ],
                  indicatorColor: Colors.black,
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.grey),
                elevation: 0.0,
              ),
              body: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: StockOverView(),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute<Widget>(builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(title: const Text('ListTile Hero')),
                                    body: Center(
                                      child: Hero(
                                        tag: 'ListTile-Hero',
                                        child: Material(
                                          child: ListTile(
                                            title: Text(i.toString()),
                                            subtitle: const Text('Tap here to go back'),
                                            tileColor: Colors.blue[700],
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                );
                              },
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 21,
                                            alignment: Alignment.center,
                                            child: Text(
                                              i.toString(),
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue),
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: CircleAvatar(
                                            radius: 20, // 반지름 크기
                                            backgroundColor: Colors.grey, // 배경색
                                            child: Icon(Icons.person,
                                                size: 30,
                                                color: Colors.white), // 프로필 아이콘
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
                                                  data[i]['htsKorIsnm'],
                                                  style: textStyle1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '1000원',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //     child: Text(
                                        //       data[i]['avlsScalClsCode'],
                                        //       style: textStyle1,
                                        //     )),
                                        Container(
                                            child: Text(
                                          data[i]['krxBankYn'],
                                          style: textStyle1,
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                          },
                          childCount: data.length
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.call),
                ],
              )));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class StockOverView extends StatelessWidget {
  const StockOverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "거래량 Top100",
              style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          Container(
            child: Text("많이 사고 많이 팔고 있어요",
                style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
          Container(
            child: Text("오늘 12:37 기준",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
          ),
          Container(
            child: Text("거래소 지정 위험 주식 차트에서 제외되었어요",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
          )
        ],
      ),
    );
  }
}

var textStyle1 = TextStyle(
    fontSize: 20.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    color: Colors.black);
