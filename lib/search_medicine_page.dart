// ignore_for_file: duplicate_ignore

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wanter_info_page.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:geocoding/geocoding.dart';
import 'distance_service.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_map/flutter_map.dart';

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
  List<QueryDocumentSnapshot>? tmpmatchingDocuments;
  bool hasSearched = false;
  // ignore: unused_field
  bool _locationPermissionGranted = false;
  // ignore: prefer_final_fields, unused_field
  String _userCity = '';
  late FirebaseAuth _auth;
  String userID = " ";
  List<String> cities = [];
  List<LatLng> coordinates = [];

  @override
  void initState() {
    super.initState();
    searchedMedName = "";
    _firestore = FirebaseFirestore.instance;
    matchingDocuments = [];
    tmpmatchingDocuments = [];
    _checkLocationPermission();
    _auth = FirebaseAuth.instance;
    userID = _auth.currentUser!.uid;
  }

  Future<void> getCityCoordinates() async {
    cities.clear();
    coordinates.clear();
    for (int i = 0; i < matchingDocuments!.length; i++) {
      final data = matchingDocuments?[i].data() as Map<String, dynamic>;
      cities.add(data["City"]);
    }

    for (var city in cities) {
      List<double>? result = await getCoordinates(city);
      if (result != null) {
        setState(() {
          coordinates.add(LatLng(result[0], result[1]));
        });
      }
    }
  }

// ignore: unused_element
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Kullanıcı kalıcı olarak konum izinlerini reddetti
      setState(() {
        _locationPermissionGranted = false;
      });
    } else {
      // Kullanıcı konum izinlerini kabul etti veya geçici olarak kabul edildi
      setState(() {
        _locationPermissionGranted = true;
      });

      if (_locationPermissionGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          String userCity = placemarks[0].administrativeArea!;
          // ignore: avoid_print
          print(userCity);
          setState(() {
            _userCity = userCity;
          });
        }
      }
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>?> sortMed(
      List<QueryDocumentSnapshot>? matchingDocuments) async {
    List<int> distances = [];
    for (int i = 0; i < matchingDocuments!.length; i++) {
      final data = matchingDocuments[i].data() as Map<String, dynamic>;
      distances.add(await getDistance(_userCity, data["City"]));
    }
    int n = distances.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;

      for (int j = i + 1; j < n; j++) {
        if (distances[j] < distances[minIndex]) {
          minIndex = j;
        }
      }

      int temp = distances[minIndex];
      distances[minIndex] = distances[i];
      distances[i] = temp;

      QueryDocumentSnapshot? tmp = matchingDocuments[minIndex];
      matchingDocuments[minIndex] = matchingDocuments[i];
      matchingDocuments[i] = tmp;
    }
    return matchingDocuments;
  }

  Future<void> searchMedicine() async {
    if (searchedMedName.isEmpty) {
      return;
    }

    final QuerySnapshot querySnapshot = await _firestore
        .collection("Medicines")
        .where(
          "medName",
          isEqualTo: searchedMedName.toLowerCase(),
        )
        .get();

    setState(() {
      tmpmatchingDocuments = querySnapshot.docs.toList();
      for (int i = 0; i < tmpmatchingDocuments!.length; i++) {
        final data = tmpmatchingDocuments![i].data() as Map<String, dynamic>;
        if (data["UserID"] == userID) {
          tmpmatchingDocuments!.removeAt(i);
        }
      }
    });
    tmpmatchingDocuments = await sortMed(tmpmatchingDocuments);
    setState(() {
      matchingDocuments = tmpmatchingDocuments;
      hasSearched = true;
    });
    getCityCoordinates();
  }

  void requestMedicine(String medName, String medId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetWanterInfo(medId)),
    );
  }

  // ignore: unused_element, unused_element, unused_element, unused_element
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
            if (hasSearched &&
                (matchingDocuments == null || matchingDocuments!.isEmpty))
              const Text(
                "Aradığınız ilaç şu anda veritabanımızda bulunmamaktadır.",
                style: TextStyle(fontSize: 16),
              ),
            if (!hasSearched ||
                (matchingDocuments != null && matchingDocuments!.isNotEmpty))
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(
            16.0), // Kenar boşluklarını ayarlamak için padding kullanabilirsiniz
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              16.0), // Kenarlara yuvarlatma eklemek için borderRadius kullanabilirsiniz
          child: SizedBox(
            height:
                200, // Haritanın yüksekliğini istediğiniz gibi ayarlayabilirsiniz
            child: Center(
              child: (coordinates.isEmpty)
                  ? const CircularProgressIndicator()
                  : FlutterMap(
                      options: MapOptions(
                        center: LatLng(39.9208, 32.8541),
                        zoom: 5.0,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayerOptions(
                          markers: coordinates.map((LatLng latLng) {
                            return Marker(
                              point: latLng,
                              builder: (ctx) => const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
