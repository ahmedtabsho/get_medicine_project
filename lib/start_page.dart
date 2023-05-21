import 'package:flutter/material.dart';
import 'login_page.dart';

class StartWidget extends StatelessWidget {
  final String text =
      "ACİL İLAÇ, afet durumlarında ilaç ihtiyaçlarının hızlı ve etkili bir şekilde karşılanması için geliştirildi. Kullanıcılarımız, ilk olarak bırakmak istedikleri ilaçları bırakabileceklerdir siteme diğer kullanıcılarımız da ihtiyaç duydukları ilaçları kolayca talep edebileceklerdir. Sonra bir kargo firması aracılığıyla ilçalar ihtiyaç sahiplerine teslim edilecektir.";
  final String imagePath = 'assets/images/logo.png';

  const StartWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.blue,
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginWidget()),
              );
            },
            child: const Text("BAŞLA"),
          ),
        ],
      ),
    );
  }
}
