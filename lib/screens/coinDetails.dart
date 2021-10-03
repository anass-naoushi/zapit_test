import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zapit_test/models/coinData.dart';

class CoinDetails extends StatefulWidget {
  final CoinData coinData;
  const CoinDetails({ Key key, @required this.coinData }) : super(key: key);

  @override
  _CoinDetailsState createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  static Random _random = new Random();
  static int next(int min, int max) => min + _random.nextInt(max - min);
  static List<Map> priceData;
  @override
  void initState() {
    super.initState();
    priceData=List.generate(50, (index) =>{
    'price':next(60, 90)*widget.coinData.quote.uSD.price/100,
    'time':DateTime.now().add(Duration(seconds: index*2))
  });
  priceData.last={
    'price':widget.coinData.quote.uSD.price,
    'time':DateTime.now().add(Duration(seconds: 49*2))
  };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.coinData.name),
        ),
        body: ListView(
          children: [
            ListTile(title:Text('Value: \$${widget.coinData.quote.uSD.price}')),
            ListTile(title: Text('Circulating supply:${widget.coinData.circulatingSupply}')),
            SfCartesianChart(
                backgroundColor: Colors.white,
                title: ChartTitle(
                  text: DateTime.now().toString()
                ),
                primaryXAxis:
              DateTimeAxis(majorGridLines: const MajorGridLines(width: 1)),
                  primaryYAxis: NumericAxis(
                        //desiredIntervals: 2,
                        labelFormat: r'{value}',
                        title: AxisTitle(text: 'Price is USD'),
                        axisLine: const AxisLine(width: 1),
                        majorTickLines: const MajorTickLines(size: 1),
                  ),
                  series: <LineSeries>[LineSeries<Map,DateTime>(
                    dataSource: priceData,
                   xValueMapper: (Map point, _) => point['time'] ,
                        yValueMapper: (Map point, _){
                          return point['price'];
              
                        },)],
  ),
          ],
        ),
    );
  }
}