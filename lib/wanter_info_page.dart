import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_medicine_project/choice_operation.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GetWanterInfo extends StatefulWidget {
  final String medId;

  GetWanterInfo(this.medId, {Key? key}) : super(key: key);

  @override
  State<GetWanterInfo> createState() => _GetWanterInfoState();
}

class _GetWanterInfoState extends State<GetWanterInfo> {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _nameController.text = _auth.currentUser!.displayName!;
  }

  Future<void> setNewReq() async {
    try {
      final newReq = _firestore.collection("Requestes").doc(); // doc() parametresiz kullanarak yeni bir doküman referansı alın
      var documentSnapshot = await FirebaseFirestore.instance.collection('Medicines').doc(widget.medId).get();
      var sender = documentSnapshot.data();
      final wanter = {
      'UserName': _nameController.text,
      'UserID': _auth.currentUser!.uid,
      'UserTC': _tcController.text,
      'City': _cityController.text,
      'Adress': _adresController.text,
      };
      if( _cityController.text == "" || _nameController.text == "" || _adresController.text == "" || _tcController.text == ""){
        print("buraya girdi-----------------------------------------");
        throw Exception("doğru bilgiler girin lürfen.");
      }

      await newReq.set(
        {
          'Sender': sender,
          'Wanter': wanter,
        },
      );
      await FirebaseFirestore.instance.collection('SendingMedicines').doc().set(sender!);
      await FirebaseFirestore.instance.collection('Medicines').doc(widget.medId).delete();

      Fluttertoast.showToast(
        msg: "Talebinizi oluşturduk en kısa sürede ilaç elinize ulaçaktır.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChoiceOperation()),
      );

    } catch (error) {
      Fluttertoast.showToast(
        msg: "Tüm bilgileri doldurun, lütfen!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Scaffold(
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .7,
                  width: size.width * .85,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(33, 150, 243, 1).withOpacity(.75),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.75),
                            blurRadius: 10,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                              keyboardType: TextInputType.number,
                              controller: _tcController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintText: '   TC numarası',
                                prefixText: ' ',
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              )
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintText: '   Ad Soyad',
                                prefixText: ' ',
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              )),
                          SizedBox(
                            height: size.height * 0.02,
                          ),

                          TextField(
                              controller: _cityController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(

                                hintText: '   Şehir',
                                prefixText: ' ',
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              )),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextField(
                              controller: _adresController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(

                                hintText: '   Açık Adres',
                                prefixText: ' ',
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              )),

                          SizedBox(
                            height: size.height * 0.08,
                          ),
                          InkWell(
                            onTap: setNewReq,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                      "Kaydet",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(top: size.height * .06, left: size.width * .02),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.blue.withOpacity(.75),
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                    ),
                    Text(
                      "İlaç iste",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.withOpacity(.75),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
