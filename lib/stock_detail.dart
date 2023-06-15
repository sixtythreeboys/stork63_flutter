import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stock63/const/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'const/text_style.dart';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class StockData {
  DateTime date;
  double open;
  double high;
  double low;
  double close;
  int volume;

  StockData(
      {required this.date,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume});
}

class StockDetail extends StatefulWidget {
  StockDetail({Key? key, this.htsKorIsnm, this.mkscShrnIscd, this.prdyCtrt})
      : super(key: key);

  var mkscShrnIscd; //종목코드
  var htsKorIsnm; //
  var prdyCtrt;

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  String? _stckPrpr;

  String? _comparePreDay;
  String? _comparePreDayRatio;

  String? todayFinalPrice;

  String? todayFinalUpdown;

  var lastData = [];

  List<StockData> stockData = [];
  List<StockData> stockDataDay = [];

  List<StockData> stockDataWeek = [];

  List<StockData> stockDataMonth = [];

  List<StockData> stockDataYear = [];
  Map<String, dynamic> socketDataJson = {};

  void getLastDataDay() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/pirce-by-period?종목코드=${widget.mkscShrnIscd}&기간분류코드=D'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));

    setState(() {
      lastData = List<dynamic>.from(result2);

      todayFinalPrice = NumberFormat("#,###").format(int.parse(lastData[0]['stckClpr'])).toString();
      todayFinalUpdown = lastData[0]['prdyVrss'];
      print(lastData);
      for (int i = lastData.length - 1; i > -1; i--) {
        String originalString = lastData[i]['stckBsopDate'];
        String formattedString = originalString.substring(0, 4) +
            "-" +
            originalString.substring(4, 6) +
            "-" +
            originalString.substring(6, 8);
        DateTime dateTime = DateTime.parse(formattedString);
        stockDataDay.add(StockData(
            date: dateTime.add(Duration(hours: 12)),
            open: double.parse(lastData[i]['stckOprc']),
            high: double.parse(lastData[i]['stckHgpr']),
            low: double.parse(lastData[i]['stckLwpr']),
            close: double.parse(lastData[i]['stckClpr']),
            volume: int.parse(lastData[i]['acmlVol'])));
      }
    });
  }

  void getLastDataWeek() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/pirce-by-period?종목코드=${widget.mkscShrnIscd}&기간분류코드=W'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));

    setState(() {
      lastData = List<dynamic>.from(result2);
      print(lastData);
      for (int i = lastData.length - 1; i > -1; i--) {
        String originalString = lastData[i]['stckBsopDate'];
        String formattedString = originalString.substring(0, 4) +
            "-" +
            originalString.substring(4, 6) +
            "-" +
            originalString.substring(6, 8);
        DateTime dateTime = DateTime.parse(formattedString);
        stockDataWeek.add(StockData(
            date: dateTime.add(Duration(hours: 12)),
            open: double.parse(lastData[i]['stckOprc']),
            high: double.parse(lastData[i]['stckHgpr']),
            low: double.parse(lastData[i]['stckLwpr']),
            close: double.parse(lastData[i]['stckClpr']),
            volume: int.parse(lastData[i]['acmlVol'])));
      }

      DateTime now = DateTime.now();
      DateTime dateWithNoTime = DateTime(now.year, now.month, now.day);

      stockDataWeek.insert(
          0,
          StockData(
              date: dateWithNoTime,
              open: double.parse(lastData[0]['stckOprc']),
              high: double.parse(lastData[0]['stckHgpr']),
              low: double.parse(lastData[0]['stckLwpr']),
              close: double.parse(lastData[0]['stckClpr']),
              volume: int.parse(lastData[0]['acmlVol'])));
      print(stockDataWeek);
    });
  }

  void getLastDataMonth() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/pirce-by-period?종목코드=${widget.mkscShrnIscd}&기간분류코드=M'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));

    setState(() {
      lastData = List<dynamic>.from(result2);
      print(lastData);
      for (int i = lastData.length - 1; i > -1; i--) {
        String originalString = lastData[i]['stckBsopDate'];
        String formattedString = originalString.substring(0, 4) +
            "-" +
            originalString.substring(4, 6) +
            "-" +
            originalString.substring(6, 8);
        DateTime dateTime = DateTime.parse(formattedString);
        stockDataMonth.add(StockData(
            date: dateTime.add(Duration(hours: 12)),
            open: double.parse(lastData[i]['stckOprc']),
            high: double.parse(lastData[i]['stckHgpr']),
            low: double.parse(lastData[i]['stckLwpr']),
            close: double.parse(lastData[i]['stckClpr']),
            volume: int.parse(lastData[i]['acmlVol'])));
      }

      DateTime now = DateTime.now();
      DateTime dateWithNoTime = DateTime(now.year, now.month, now.day);

      stockDataMonth.insert(
          0,
          StockData(
              date: dateWithNoTime,
              open: double.parse(lastData[0]['stckOprc']),
              high: double.parse(lastData[0]['stckHgpr']),
              low: double.parse(lastData[0]['stckLwpr']),
              close: double.parse(lastData[0]['stckClpr']),
              volume: int.parse(lastData[0]['acmlVol'])));
      print(stockDataMonth);
    });
  }

  void getLastDataYear() async {
    var result = await http.get(Uri.parse(
        'http://15.164.171.244:8000/domestic/kospi/pirce-by-period?종목코드=${widget.mkscShrnIscd}&기간분류코드=Y'));
    var result2 = jsonDecode(utf8.decode(result.bodyBytes));

    setState(() {
      lastData = List<dynamic>.from(result2);
      print(lastData);
      for (int i = lastData.length - 1; i > -1; i--) {
        String originalString = lastData[i]['stckBsopDate'];
        String formattedString = originalString.substring(0, 4) +
            "-" +
            originalString.substring(4, 6) +
            "-" +
            originalString.substring(6, 8);
        DateTime dateTime = DateTime.parse(formattedString);
        stockDataYear.add(StockData(
            date: dateTime.add(Duration(hours: 12)),
            open: double.parse(lastData[i]['stckOprc']),
            high: double.parse(lastData[i]['stckHgpr']),
            low: double.parse(lastData[i]['stckLwpr']),
            close: double.parse(lastData[i]['stckClpr']),
            volume: int.parse(lastData[i]['acmlVol'])));
      }

      DateTime now = DateTime.now();
      DateTime dateWithNoTime = DateTime(now.year, now.month, now.day);

      stockDataYear.insert(
          0,
          StockData(
              date: dateWithNoTime,
              open: double.parse(lastData[0]['stckOprc']),
              high: double.parse(lastData[0]['stckHgpr']),
              low: double.parse(lastData[0]['stckLwpr']),
              close: double.parse(lastData[0]['stckClpr']),
              volume: int.parse(lastData[0]['acmlVol'])));
      print(stockDataYear);
    });
  }

  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://15.164.171.244:8000/domestic/kospi/realtime'),
  );
  String _message = 'Waiting for data...';

  @override
  void initState() {
    super.initState();
    getLastDataDay();
    getLastDataWeek();
    getLastDataMonth();
    getLastDataYear();
    String messageToSend = widget.mkscShrnIscd;
    channel.sink.add(messageToSend);
    channel.stream.listen((data) {
      try {
        setState(() {
          _message = data;
          Map<String, dynamic> socketDataJson = jsonDecode(_message);
          _stckPrpr = NumberFormat("#,###").format(int.parse(socketDataJson['현재가'])).toString();
          _comparePreDay = socketDataJson['전일대비'].toString();

          _comparePreDayRatio = socketDataJson['전일대비율'].toString();

          stockDataDay[stockDataDay.length - 1].close =
              double.parse(socketDataJson['현재가']!);

          stockDataWeek[stockDataWeek.length - 1].close =
              double.parse(socketDataJson['현재가']!);

          stockDataMonth[stockDataMonth.length - 1].close =
              double.parse(socketDataJson['현재가']!);

          stockDataYear[stockDataYear.length - 1].close =
              double.parse(socketDataJson['현재가']!);

          print(_stckPrpr);
        });
      } catch (e) {
        print('Error: $e');
      }
    });

    stockData = stockDataDay;
  }

  @override
  void dispose() {
    channel.sink.close();
    print("소켓종료");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (todayFinalPrice == null ) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 10.0,
          height: 10.0,
          color: Colors.white,
        ),
      );
    } else {
      return Scaffold(

          backgroundColor: MyColors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.grey),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stockName(),
              SizedBox(
                height: 30,
              ),
              _dateButton(),
              _graph(),
            ],
          ));
    }
  }

  Widget _stockName() {
    return Container(
      padding: EdgeInsets.only(left : 20, top : 22,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.htsKorIsnm,
            style: MyTextStyle.CbS20W700,
          ),
          SizedBox(height: 4,),
          Text(
            _stckPrpr == null ? '$todayFinalPrice원' : '$_stckPrpr원',
            style: MyTextStyle.CbS32W700,
          ),
          SizedBox(
            height: 7,
          ),
          _comparePreDay == null && _comparePreDayRatio == null
              ? Text("어제보다 $todayFinalUpdown원 00%",
                  style: TextStyle(
                    color: int.parse(todayFinalUpdown!) > 0
                        ? Colors.red
                        : (int.parse(todayFinalUpdown!) < 0
                            ? Colors.blue
                            : Colors.grey),
                  ))
              : Text(
                  "어제보다 $_comparePreDay원 $_comparePreDayRatio%",
                  style: TextStyle(
                    color: int.parse(_comparePreDay!) > 0
                        ? Colors.red
                        : (int.parse(_comparePreDay!) < 0
                            ? Colors.blue
                            : Colors.grey),
                  ),
                )
        ],
      ),
    );
  }

  List<bool> _selections = [true, false, false, false]; // '일'이 기본 선택됨
  Widget _dateButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ToggleButtons(
        selectedBorderColor: MyColors.grey150,
        borderColor: Colors.transparent,
        selectedColor: MyColors.black,
        fillColor: MyColors.grey150,
        color: MyColors.grey600,
        constraints: const BoxConstraints(
          minHeight: 35.0,
          minWidth: 58.0,
        ),
        children: const <Widget>[
          Text('일'),
          Text('주'),
          Text('월'),
          Text('년'),
        ],
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selections.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _selections[buttonIndex] = true;
              } else {
                _selections[buttonIndex] = false;
              }
            }
            if (_selections[0]) {
              setState(() {
                stockData = stockDataDay;
              });
            } else if (_selections[1]) {
              setState(() {
                stockData = stockDataWeek;
              });
            } else if (_selections[2]) {
              setState(() {
                stockData = stockDataMonth;
              });
            } else if (_selections[3]) {
              setState(() {
                stockData = stockDataYear;
              });
            }
          });
        },
        isSelected: _selections,
      ),
    );
  }

  Widget _graph() {
    return SfCartesianChart(
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat.yMd(),
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
      ),
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
            bearColor: Colors.blue,
            // 하락하는 날의 색상을 파란색으로 설정
            bullColor: Colors.red)
      ],
      trackballBehavior: TrackballBehavior(
        enable: true, // 트랙볼 기능 활성화
        tooltipSettings: InteractiveTooltip(

            enable: true,
            format:
                '종가 : point.close\n시가 : point.open\n최고가 : point.high\n최저가 : point.low\n날짜 : point.date'),
      ),
    );
  }
}
