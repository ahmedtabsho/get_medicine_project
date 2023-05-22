import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medicine_info_page.dart';
import 'search_medicine_page.dart';

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
                    MaterialPageRoute(builder: (context) => const MedicineInfoWidget()),
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
            const SizedBox(height: 15,),
            SizedBox(
              width: 200, // desired width
              height: 75, // desired height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchMedicine()),
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
