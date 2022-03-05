import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../class/payment.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldsFormBloc(),
      child: Builder(builder: (context) {
        final formBloc = BlocProvider.of<FieldsFormBloc>(context);
        return Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.orangeAccent[100],
            body: FormBlocListener<FieldsFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
              },
              child: Container(
                width: double.infinity,
                height: 640,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
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
                      '追加だよ',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: RadioButtonGroupFieldBlocBuilder<String>(
                        selectFieldBloc: formBloc.form_type,
                        decoration: const InputDecoration(
                          labelText: '出費のしゅるい',
                        ),
                        itemBuilder: (context, item) => FieldItem(
                          child: Text(item),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFieldBlocBuilder(
                        textFieldBloc: formBloc.form_name,
                        decoration: const InputDecoration(
                          labelText: 'なまえ',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFieldBlocBuilder(
                        textFieldBloc: formBloc.form_money,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'きんがく',
                          prefixIcon: Icon(Icons.local_atm),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.form_date,
                        locale: const Locale("ja"),
                        format: DateFormat('yyyy/MM/dd'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        decoration: const InputDecoration(
                          labelText: '日付',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: formBloc.submit,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 52, vertical: 12)),
                      ),
                      child: const Text(
                        '追加',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class FieldsFormBloc extends FormBloc<String, String> {
  final form_name = TextFieldBloc();
  final form_type = SelectFieldBloc(
    items: ['固定費/月', '固定費以外のやつ'],
    initialValue: '固定費/月',
  );
  final form_money = TextFieldBloc();
  final form_date =
      InputFieldBloc<DateTime?, Object>(initialValue: DateTime.now());

  FieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      form_name,
      form_type,
      form_money,
      form_date,
    ]);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final payment = Payment(
        paymentType: form_type.value ?? '固定費/月',
        paymentName: form_name.value,
        paymentMoney: int.tryParse(form_money.value) ?? 0,
        paymentDate: form_date.value ?? DateTime.now(),
      );

      // firestoreに追加
      // uid を特定する
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection((form_type.value == '固定費/月')
              ? 'fixedcost'
              : 'payment${DateFormat('yyyy-MM').format(form_date.value as DateTime)}')
          .add(payment.toMap());

      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        color: Colors.transparent,
        padding: const EdgeInsets.all(12.0),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.orange),
        ),
      ),
    );
  }
}
