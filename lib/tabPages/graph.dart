import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphTab extends StatefulWidget {
  const GraphTab({Key? key}) : super(key: key);

  @override
  _GraphTabState createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 350,
        child: Text('Hi')
      ),
    );
  }
}
