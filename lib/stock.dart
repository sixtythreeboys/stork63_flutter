import 'package:flutter/material.dart';
import 'style.dart' as style;


class StockList extends StatefulWidget {
  StockList({Key? key, this.data}) : super(key: key);
  var data;

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  var scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (c,i){
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(widget.data[i]['htsKorIsnm'],style: textStyle1,),
                      ),
                      Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(widget.data[i]['avlsScalClsCode'],style: textStyle1,)),

                      Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(widget.data[i]['krxBankYn'],style: textStyle1,))
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
  }
}




var textStyle1 = TextStyle(
    fontSize: 20.0,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    color: Colors.black
);