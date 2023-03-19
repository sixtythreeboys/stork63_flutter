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
                tabs: [
                  Tab(text: "국내",),
                  Tab(text: "해외",)],
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
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 22.0, left: 16.0, right: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          data[i]['htsKorIsnm'],
                                          style: textStyle1,
                                        ),
                                      ),
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width * 0.3,
                                          child: Text(
                                            data[i]['avlsScalClsCode'],
                                            style: textStyle1,
                                          )),
                                      Container(
                                          width:
                                          MediaQuery.of(context).size.width * 0.1,
                                          child: Text(
                                            data[i]['krxBankYn'],
                                            style: textStyle1,
                                          ))
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Icon(Icons.call),
              ],
            )
          ));
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
      padding: const EdgeInsets.only(
          top: 22.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("거래량 Top100", style:TextStyle(fontSize: 30.0, fontFamily: 'Roboto',fontWeight: FontWeight.w700,color: Colors.black),),
          ),
          Container(
            child: Text("많이 사고 많이 팔고 있어요",style:TextStyle(fontSize: 16.0, fontFamily: 'Roboto',fontWeight: FontWeight.w500,color: Colors.black)),
          ),
          Container(
            child: Text("오늘 12:37 기준",style:TextStyle(fontSize: 15.0, fontFamily: 'Roboto',fontWeight: FontWeight.w400,color: Colors.grey)),
          ),
          Container(
            child: Text("거래소 지정 위험 주식 차트에서 제외되었어요",style:TextStyle(fontSize: 15.0, fontFamily: 'Roboto',fontWeight: FontWeight.w400,color: Colors.grey)),
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
