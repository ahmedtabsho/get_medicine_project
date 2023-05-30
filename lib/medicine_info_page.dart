import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get_medicine_project/choice_operation.dart';
import 'package:fluttertoast/fluttertoast.dart';


const List<String> list = <String>['Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya', 'Ankara', 'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir', 'Bartın', 'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkâri', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul', 'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu', 'Kayseri', 'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kilis', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Şanlıurfa', 'Şırnak', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak'];
String dropdownValue =list.first;
class MedicineInfoWidget extends StatefulWidget {
  const MedicineInfoWidget({Key? key}) : super(key: key);

  @override
  State<MedicineInfoWidget> createState() => _MedicineInfoWidgetState();
}

class _MedicineInfoWidgetState extends State<MedicineInfoWidget> {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _medNameController = TextEditingController();
  // ignore: unused_field
  late final TextEditingController _cityController= TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _medInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    //_nameController.text = _auth.currentUser!.displayName!;
  }

  Future<void> setNewMed() async {
    try {
      final newMed = _firestore.collection("Medicines").doc(); // doc() parametresiz kullanarak yeni bir doküman referansı alın
      if(_medNameController.text == ""  || _nameController.text == "" || _adresController.text == "" || _tcController.text == ""){
        throw Exception("doğru bilgiler girin lürfen.");
      }
      await newMed.set(
        {
          'UserName': _nameController.text,
          'UserID': _auth.currentUser!.uid,
          'UserTC': _tcController.text,
          'medName': _medNameController.text,
          'City':dropdownValue,
          'Adress': _adresController.text,
          'MedInfo': _medInfoController.text,
        },
      );

      Fluttertoast.showToast(
        msg: "İlaç Bilgileri kaydedildi, teşekkürler.",
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

  
   
    //var city;
    
    var children2 = [
                          TextField(
  controller: _tcController,
  style: const TextStyle(
    color: Colors.white,
  ),
  cursorColor: const Color.fromARGB(255, 15, 15, 15),
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ],
  textAlign: TextAlign.left,
  decoration: const InputDecoration(
    hintText: '   TC numarası',
    hintStyle: TextStyle(color: Colors.white),
    focusColor: Colors.white,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  ),
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
                              controller: _medNameController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(

                                hintText: '   İlaç adı',
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
                  
      
     DropdownButton<String>(
         
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color.fromARGB(255, 25, 26, 26)),
      underline: Container(
        height: 2,
        color: const Color.fromARGB(255, 42, 90, 247),
      ),
      onChanged: (String? value) {
     //kullanıcı bir öğe seçtiğinde çağrılır
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
        
        iconSize: 30.0,
        iconEnabledColor: const Color.fromARGB(255, 18, 18, 18),
        isExpanded: true, //genişletmek için
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
                            height: size.height * 0.02,
                          ),
                          TextField(
                            controller: _medInfoController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(

                                hintText: '   İlaç bilgisi',
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
                            onTap: setNewMed,
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
                        ];
    return Scaffold(
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
                        children: children2,
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
                      "İlaç Bırak",
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
