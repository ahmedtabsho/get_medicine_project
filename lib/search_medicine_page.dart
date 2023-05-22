import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wanter_info_page.dart';

class SearchMedicine extends StatefulWidget {
  const SearchMedicine({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  late String searchedMedName;
  late FirebaseFirestore _firestore;
  List<QueryDocumentSnapshot>? matchingDocuments;
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    searchedMedName = "";
    _firestore = FirebaseFirestore.instance;
    matchingDocuments = [];
  }

  Future<void> searchMedicine() async {
    if (searchedMedName.isEmpty) {
      return;
    }

    final QuerySnapshot querySnapshot = await _firestore
        .collection("Medicines")
        .where("medName", isEqualTo: searchedMedName)
        .get();

    setState(() {
      matchingDocuments = querySnapshot.docs.toList();
      hasSearched = true;
    });
  }

  void requestMedicine(String medName, String medId) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetWanterInfo(medId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlaç Arama Sayfası"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchedMedName = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "İlaç Ara",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: searchMedicine,
              child: const Text("Ara"),
            ),
            const SizedBox(height: 10),
            if (hasSearched && (matchingDocuments == null || matchingDocuments!.isEmpty))
              const Text(
                "Aradığınız ilaç şu anda veritabanımızda bulunmamaktadır.",
                style: TextStyle(fontSize: 16),
              ),
            if (!hasSearched || (matchingDocuments != null && matchingDocuments!.isNotEmpty))
              Expanded(
                child: ListView.builder(
                  itemCount: matchingDocuments!.length,
                  itemBuilder: (context, index) {
                    final document = matchingDocuments![index];
                    final data = document.data() as Map<String, dynamic>;
                    final medName = data['medName'] as String;
                    final medInfo = data['MedInfo'] as String;
                    final medCity = data['City'] as String;
                    final medId = document.id;

                    return ListTile(
                      title: Text(medName),
                      subtitle: Text("$medCity\n$medInfo"),
                      trailing: ElevatedButton(
                        onPressed: () => requestMedicine(medName, medId),
                        child: const Text("İstek"),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
