import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'const/text_style.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  StockData({required this.date, required this.open, required this.high, required this.low, required this.close, required this.volume});
}

class StockDetail extends StatefulWidget {
  StockDetail({Key? key,this.htsKorIsnm,this.mkscShrnIscd,this.prdyCtrt}) : super(key: key);

  var mkscShrnIscd;
  var htsKorIsnm;
  var prdyCtrt;
  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {

  String? _stckPrpr;

  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://15.164.171.244:8000/domestic/kospi/realtime'),
  );
  String _message = 'Waiting for data...';

  @override
  void initState() {
    super.initState();
    String messageToSend = widget.mkscShrnIscd;
    channel.sink.add(messageToSend);
    channel.stream.listen((data) {
      try {
        setState(() {
          _message = data;
          Map<String, dynamic> stockDataJson = jsonDecode(_message);
          _stckPrpr = stockDataJson['stckPrpr'].toString();
          print(_stckPrpr);
        });
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  final List<StockData> stockData = [
    StockData(date: DateTime(2023, 1, 1), open: 100, high: 105, low: 95, close: 102, volume: 10000),
    StockData(date: DateTime(2023, 1, 2), open: 102, high: 110, low: 100, close: 108, volume: 12000),
    StockData(date: DateTime(2023, 1, 3), open: 108, high: 112, low: 105, close: 110, volume: 13000),
    StockData(date: DateTime(2023, 1, 4), open: 110, high: 120, low: 108, close: 115, volume: 14000),
    StockData(date: DateTime(2023, 1, 5), open: 115, high: 118, low: 112, close: 116, volume: 15000),
    StockData(date: DateTime(2023, 1, 6), open: 100, high: 105, low: 95, close: 102, volume: 10000),
    StockData(date: DateTime(2023, 1, 7), open: 102, high: 110, low: 100, close: 108, volume: 12000),
    StockData(date: DateTime(2023, 1, 8), open: 108, high: 112, low: 105, close: 110, volume: 13000),
    StockData(date: DateTime(2023, 1, 9), open: 110, high: 120, low: 108, close: 115, volume: 14000),
    StockData(date: DateTime(2023, 1, 10), open: 115, high: 118, low: 112, close: 116, volume: 15000),
    StockData(date: DateTime(2023, 1, 11), open: 102, high: 110, low: 100, close: 108, volume: 12000),
    StockData(date: DateTime(2023, 1, 12), open: 108, high: 112, low: 105, close: 110, volume: 13000),
    StockData(date: DateTime(2023, 1, 13), open: 110, high: 120, low: 108, close: 115, volume: 14000),
    StockData(date: DateTime(2023, 1, 14), open: 115, high: 118, low: 112, close: 116, volume: 15000),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.grey),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stockName(),
            _graph(),
            _websocket()
          ],
        ),
      )
    );
  }

  Widget _stockName(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.htsKorIsnm,style: MyTextStyle.CbS20W700,),
        Text(_stckPrpr == null ? 'wating..' : '${_stckPrpr}원',style: MyTextStyle.CbS30W700,),
        SizedBox(height: 7,),
        Text(
          "어제보다 -3333원 ${widget.prdyCtrt}",
          style: TextStyle(
            color: widget.prdyCtrt > 0
                ? Colors.red
                : (widget.prdyCtrt < 0 ? Colors.blue : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _graph(){
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        zoomMode: ZoomMode.x,
      ),
      series: <ChartSeries>[
        CandleSeries<StockData, DateTime>(
          dataSource: stockData,
          xValueMapper: (StockData stock, _) => stock.date,
          lowValueMapper: (StockData stock, _) => stock.low,
          highValueMapper: (StockData stock, _) => stock.high,
          openValueMapper: (StockData stock, _) => stock.open,
          closeValueMapper: (StockData stock, _) => stock.close,
        )
      ],
    );
  }

  Widget _websocket(){
    return Center(child: Text(_message));
  }

}
