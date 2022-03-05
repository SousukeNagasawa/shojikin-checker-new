import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../tabPages/graph.dart';
import '../tabPages/history.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double _height = 260;
  int? sum;
  final collection_month = DateFormat('yyyy-MM').format(DateTime.now());

  Future<void> fixedcost() async {
    final fixedcost = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('fixedcost')
        .where('paymentDate', isLessThan: collection_month)
        .get();
    final fixsum = fixedcost.docs
        .map((e) => e['paymentMoney'] as int)
        .reduce((value, element) => value + element);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fixedcost();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('payment${collection_month}')
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const SizedBox();
          }
          final variablesum = data.docs
              .map((e) => e['paymentMoney'] as int)
              .reduce((value, element) => value + element);
          sum = variablesum;
          return Scaffold(
            backgroundColor: Colors.orangeAccent[100],
            body: SizedBox(
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 280),
                      child: Column(
                        children: [
                          Text(
                            '履歴',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(height: 330, child: HistoryTab())
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _height = 600;
                      });
                    },
                    onDoubleTap: () {
                      setState(() {
                        _height = 260;
                      });
                    },
                    child: AnimatedContainer(
                      clipBehavior: Clip.antiAlias,
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.fastOutSlowIn,
                      width: double.infinity,
                      height: _height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 52,
                          ),
                          const Text(
                            '今月の出費',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '合計',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: sum.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 円',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '内訳',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final payment = data.docs[index];
                                return Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black12,
                                        ),
                                      ),
                                      color: Colors.white),
                                  child: ListTile(
                                    trailing: IconButton(
                                      onPressed: () {
                                        payment.reference.delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 25,
                                      ),
                                    ),
                                    title: Text(
                                      '${payment['paymentName']}：　${payment['paymentMoney']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
