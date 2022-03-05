import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  Payment({
    required this.paymentType,
    required this.paymentName,
    required this.paymentMoney,
    required this.paymentDate,
  });
  // 1. プロパティを全部書く
  //    - 型と変数名を決める
  // 2. コンストラクタを作る
  //    - これは機械的にできます
  // 3. toMap, fromMap 関数を作る
  //    - firestoreにデータを追加したり、firestoreからデータを取ってくるとき、いい感じにデータを変換するのに必要

  // final 型名 変数名 この形で列挙する
  final String paymentType;
  final String paymentName;
  final int paymentMoney;
  final DateTime paymentDate;

  // MAP構造
  // <String, dynamic>{};
  // List<String>:
  // final map = {'key' : 'value' };
  // 辞書配列
  // map['key'] こいつから value が取り出せる。
  // firestoreから得られるデータは Map<String, dynamic> 型になっています。
  // {'filed名' : 'filedに入っている値'}
  // ここで field名っていうのは paymentMoney とかそういうやつになります。

  static Payment fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentType: map['paymentType'],
      paymentName: map['paymentName'],
      paymentMoney: map['paymentMoney'],
      paymentDate: (map['paymentDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentType': paymentType,
      'paymentName': paymentName,
      'paymentMoney': paymentMoney,
      'paymentDate': Timestamp.fromDate(paymentDate),
    };
  }
}
