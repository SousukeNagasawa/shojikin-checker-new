import 'package:flutter/material.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final items = List<String>.generate(20, (i) => "Item $i");
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
              border: const Border(
                bottom: const BorderSide(
                  color: Colors.black12,
                ),
              ),
              color: Colors.white),
          child: ListTile(
            leading: Text('${items[index]}'),
            title: Text('${items[index]}'),
          ),
        );
      },
    );
  }
}
