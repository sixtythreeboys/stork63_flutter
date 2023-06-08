import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'const/text_style.dart';

import 'package:http/http.dart' as http;
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

  String? _comparePreDay;
  String? _comparePreDayRatio;

  var lastData = [];

  List<StockData> stockData = [];
  Map<String, dynamic> socketDataJson = {};

  void getLastData() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/pirce-by-period?종목코드=${widget.mkscShrnIscd}&기간분류코드=D'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));
    setState(() {
      lastData = List<dynamic>.from(result2);
      print(lastData);
      for (int i = lastData.length-1; i>-1; i--){
        String originalString = lastData[i]['stckBsopDate'];
        String formattedString = originalString.substring(0,4) + "-" + originalString.substring(4,6) + "-" + originalString.substring(6,8);
        DateTime dateTime = DateTime.parse(formattedString);
        stockData.add(StockData(date: dateTime, open: double.parse(lastData[i]['stckOprc']), high: double.parse(lastData[i]['stckHgpr']), low: double.parse(lastData[i]['stckLwpr']), close: double.parse(lastData[i]['stckClpr']), volume: int.parse(lastData[i]['acmlVol'])));
      }

      stockData.insert(0,StockData(date: DateTime.now(), open: double.parse(lastData[0]['stckOprc']), high: double.parse(lastData[0]['stckHgpr']), low: double.parse(lastData[0]['stckLwpr']), close: double.parse(lastData[0]['stckClpr']), volume: int.parse(lastData[0]['acmlVol'])));
    });
  }

  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://15.164.171.244:8000/domestic/kospi/realtime'),
  );
  String _message = 'Waiting for data...';

  @override
  void initState() {
    getLastData();
    super.initState();
    String messageToSend = widget.mkscShrnIscd;
    channel.sink.add(messageToSend);
    channel.stream.listen((data) {
      try {
        setState(() {
          _message = data;
          Map<String, dynamic> socketDataJson = jsonDecode(_message);
          _stckPrpr = socketDataJson['현재가'].toString();
          _comparePreDay = socketDataJson['전일대비'].toString();

          _comparePreDayRatio = socketDataJson['전일대비율'].toString();
          print(socketDataJson);
          stockData[0] = StockData(date: DateTime.now(), open: double.parse(socketDataJson['시가'].toString()), high: double.parse(socketDataJson['고가'].toString()), low: double.parse(socketDataJson['저가'].toString()), close: double.parse(socketDataJson['현재가'].toString()), volume: int.parse(lastData[0]['acmlVol']));
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
          ],
        ),
      )
    );
  }

  Widget _stockName() {
    if (_comparePreDay == null) {
      return Center(
          child: CircularProgressIndicator()); // or any other widget you want to show while loading
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.htsKorIsnm, style: MyTextStyle.CbS20W700,),
          Text(_stckPrpr == null ? 'wating..' : '$_stckPrpr원',
            style: MyTextStyle.CbS30W700,),
          SizedBox(height: 7,),
          Text(
            "어제보다 $_comparePreDay원 $_comparePreDayRatio%",
            style: TextStyle(
              color: int.parse(_comparePreDay!) > 0
                  ? Colors.red
                  : (int.parse(_comparePreDay!) < 0 ? Colors.blue : Colors
                  .grey),
            ),
          ),
        ],
      );
    }
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
          bearColor: Colors.blue, // 하락하는 날의 색상을 파란색으로 설정
          bullColor: Colors.red
        )
      ],
    );
  }


}
