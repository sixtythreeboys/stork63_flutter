import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'dart:convert';
import 'package:http/http.dart' as http;


class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);


  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();
  var data= [] ;

  getData() async{
    var result = await http.get(Uri.parse('http://15.164.171.244:8000/domestic/kospi/list?period=2&gradient=1'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      data = result2;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          controller: scroll,
          itemCount: data.length,
          itemBuilder: (c, i) {
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          child: Text(data[i]['htsKorIsnm'],
                            style: textStyle1,),
                        ),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            child: Text(data[i]['avlsScalClsCode'],
                              style: textStyle1,)),

                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.1,
                            child: Text(data[i]['krxBankYn'],
                              style: textStyle1,))
                      ],
                    ),
                    Divider(thickness: 2,)
                  ],
                ),
              ),
            );
          },
        ),
      );
    }else{
      return Center(
          child : CircularProgressIndicator()
      );
    }
  }
}




var textStyle1 = TextStyle(
    fontSize: 20.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    color: Colors.black
);