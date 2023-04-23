import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  StockDetail({Key? key,this.i}) : super(key: key);

  var i;
  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _stockName(),
            _graph()
          ],
        ),
      )
    );
  }

  Widget _stockName(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("마이크로 소프트"),
        Text("123456 원"),
        Text("어제보다 -3333원 (0.85)")
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
}
