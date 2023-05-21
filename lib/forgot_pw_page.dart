// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final  _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      await showDialog(context: context, builder: (context) {
        return const AlertDialog(
          content: Text(
            "Şifre yenileme linkini gönderdik mail kutunuza bakabilirsiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        );
      },
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e){
      
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          content: Text(
              "Girdiğiniz mail veritabanımıza kayıtlı değildir.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                "Şifrenizi yeniden oluşturmak e-postanıza bir link içeren mail göndereceğiz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            obscureText: false,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.vpn_key,
                color: Colors.white,
              ),
              contentPadding:
              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "mail",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          const SizedBox(height: 10.0),
          MaterialButton(
            onPressed: passwordReset,
            color: Colors.blue,
            child: const Text('Şifremi Yenile'),
          ),
        ],
      ),
    );
  }
}
