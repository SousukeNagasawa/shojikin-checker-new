import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class FixedCost extends StatefulWidget {
  const FixedCost({Key? key}) : super(key: key);

  @override
  _FixedCostState createState() => _FixedCostState();
}

class _FixedCostState extends State<FixedCost> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('fixedcost')
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const SizedBox();
          }
          final sumCost = data.docs
              .map((e) => e['paymentMoney'] as int)
              .reduce((value, element) => value + element);
          return Scaffold(
            backgroundColor: Colors.orangeAccent[100],
            body: Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 320,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 52,
                        ),
                        const Text(
                          '現在のサブスク一覧',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          '全部で',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: data.docs.length.toString(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' 個',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          '合計',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: sumCost.toString(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' 円',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final payment = data.docs[index];
                        return CostCard(
                            costTitle: payment['paymentName'],
                            costMoney: payment['paymentMoney'],
                            costDate:
                                (payment['paymentDate'] as Timestamp).toDate());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CostCard extends StatefulWidget {
  const CostCard({
    Key? key,
    required this.costTitle,
    required this.costMoney,
    required this.costDate,
  }) : super(key: key);
  final String costTitle;
  final int costMoney;
  final DateTime costDate;

  @override
  State<CostCard> createState() => _CostCardState();
}

class _CostCardState extends State<CostCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 52,
              ),
              Text(
                widget.costTitle,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.costMoney.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' 円',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                '今まで払った金額',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.costMoney.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' 円',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '利用開始月',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (DateFormat('yyyy/MM')).format(widget.costDate),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
