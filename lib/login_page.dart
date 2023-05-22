// ignore: depend_on_referenced_packages
import 'package:get_medicine_project/choice_operation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe, depend_on_referenced_packages
import 'auth_service.dart';
import 'register_page.dart';
import 'forgot_pw_page.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool isFirebaseInitialized = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
  }

  void sendToChoiceOperation() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChoiceOperation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/ilac.png"),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Color.fromRGBO(33, 150, 243, 1),
                      ),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController,
                    obscureText:
                        true, //parolanın gözükmemesini istediğim için true yaptım.
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.vpn_key,
                          color: Color.fromRGBO(33, 150, 243, 1),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Parola",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                  const SizedBox(height: 15.0),
                  Material(
                    //chart şeklinde yapıcam bunu materialı
                    elevation: 5.0, //yazının görünüşünü ayarlıyorum.
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blueAccent,
                    child: MaterialButton(
                      //minWidth: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        _authService
                            .signIn(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChoiceOperation()));
                        });
                      },
                      child: const Text(
                        "Giriş Yap",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Material(
                    //chart şeklinde yapıcam bunu materialı
                    elevation: 5.0, //yazının görünüşünü ayarlıyorum.
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color.fromRGBO(68, 138, 255, 1),
                    child: MaterialButton(
                      //minWidth: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        //TIKLAMA ÖZELLİĞİ SAYFA GEÇİŞİ YAPINCA YAZI YAZMASI İÇİN ALTTAKİ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Kayıt Ol",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Şifremi unuttum!",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.1, left: size.width * 0.02),
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  await _authService.signInWithGoogleByAut();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChoiceOperation()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 26,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Google ile giriş",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //burayaaa
        ],
      ),
    );
  }
}
