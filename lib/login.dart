import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text(
            'ログイン',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                    onPressed: () async {

            // signIn メソッドを呼ぶだけでGoogle SignInのポップアップが出る。
            GoogleSignInAccount? googleUser;
            try {
              googleUser = await GoogleSignIn().signIn();
            } catch (e) {
              print(e);
              return;
            }

            // もしユーザーがログインせずにキャンセルしたら、ここで関数を終了する。
            if (googleUser == null) {
              return;
            }

            // credentialを取得するために必要なaccessTokenとidTokenがほしい。その情報は .authentication で取り出せる。
            final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

            // 上で手に入れたgoogleAuthをつかってcredentialをつくる。
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );
            // 最終的にcredentialでFirebaseAuthとGoogleAuthを連携させる。
            await FirebaseAuth.instance.signInWithCredential(credential);

            // ログインに成功したらNavPageに遷移する
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NavPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
