import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_medicine_project/medican_taken.dart';
import 'package:get_medicine_project/medician_list.dart';
import 'package:get_medicine_project/profile.dart';
import 'login_page.dart';
import 'medicine_info_page.dart';
import 'search_medicine_page.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';

class ChoiceOperation extends StatefulWidget {
  const ChoiceOperation({Key? key}) : super(key: key);

  @override
  State<ChoiceOperation> createState() => _ChoiceOperationState();
}

class _ChoiceOperationState extends State<ChoiceOperation> {
  late User? auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String name = '';

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance.currentUser;
    getUserName();
  }

  Future<void> getUserName() async {
    DocumentSnapshot snapshot =
        await _firestore.collection("Persons").doc(auth!.uid).get();
    if (snapshot.exists) {
      String? userName = snapshot.get("Name");
      setState(() {
        name = userName ?? '';
      });
    } else {
      setState(() {
        name = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          //appbarda actions ekledik, action en sağdan başlarç
          PopupMenuButton(
            //3 parçacığı gösteren kısım.
            icon: const Icon(
                Icons.menu), //don't specify icon if you want 3 dot menu
            color: Colors.white,
            itemBuilder: (context) => [
              // açılır menüde görüntülenecek öğeleri tanımlar.
              const PopupMenuItem<int>(
                //açılır menüde bir seçeneği temsil eder.
                value: 0,
                child: Text(
                  //her bir özelliğin içeriğini tanımladık child ile. text ilgili metni textstyle rengi belirler.
                  "Gönderilen İlaçlar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text(
                  "Profil",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text(
                  "Alınan İlaçlar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text(
                  "Çıkış Yap",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            onSelected: (item) => {
              //bir kullanıcı açılır menüden bir öğe seçtiğinde olması gerekenler bunlar.
              if (item ==
                  0) //item 0 olduğunda olması gereken gönderilen ilaç listesi. item değeri value değerine göre artar.
                {
                  Navigator.push(
                      context, //Seçilen öğenin değeri 0 ise Navigator.push'ı kullanarak MedicianList sayfasına gider
                      MaterialPageRoute(builder: (context) => MedicianList()))
                },
              // ignore: avoid_print
              if (item == 1)
                {
                  Navigator.push(
                      context, //Seçilen öğenin değeri 0 ise Navigator.push'ı kullanarak MedicianList sayfasına gider
                      MaterialPageRoute(
                          builder: (context) => MedicianProfile()))
                },
              if (item == 2)
                {
                  Navigator.push(
                      context, //Seçilen öğenin değeri 0 ise Navigator.push'ı kullanarak MedicianList sayfasına gider
                      MaterialPageRoute(builder: (context) => MedicianTaken()))
                },
              if (item == 3)
                {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Uyarı'),
                        content: const Text(
                            'Çıkış Yapmak İstediğinizi Emin Misiniz!'),
                        actions: [
                          ButtonBar(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hayır')),
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance
                                        .signOut()
                                        .then((value) async {
                                      await GoogleSignIn().signOut();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginWidget()),
                                          (route) => false);
                                    });
                                  },
                                  child: const Text('Evet'))
                            ],
                          )
                        ],
                      );
                    },
                  )
                }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200, // desired width
              height: 75, // desired height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MedicineInfoWidget()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'İlaç Gönder',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 200, // desired width
              height: 75, // desired height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchMedicine()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'İlaç Al',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
