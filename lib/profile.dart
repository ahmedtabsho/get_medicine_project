import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

// ignore: use_key_in_widget_constructors
class MedicianProfile extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MedicianProfileState createState() => _MedicianProfileState();
}

class _MedicianProfileState extends State<MedicianProfile> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Persons').snapshots();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void updateUserProfile(String newName) async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('Persons')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          await userDoc.reference.update({'Name': newName});

          // Güncelleme işlemi tamamlandıktan sonra kullanıcıya geri bildirim vermek için bir snackbar veya dialog gösterdik

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil güncellendi')),
          );
        }
      }
    } catch (e) {
      // Güncelleme işlemi sırasında bir hata oluşursa kullanıcıya geri bildirim vermek için bir snackbar veya dialog gösterdik.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme hatası: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_image.png'),
            ),
            SizedBox(width: 10),
            Text('Profile'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //streambuilder firebase den anlık şekilde veri çekmesini sağlar.
        stream:
            _usersStream, // veritabanındaki ilaçlar koleksiyonunda herhangi bir değişiklik olduğunda güncel verileri alabilirsiniz.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(
                'Bir Hata Oluştu'); //Eğer bir hata varsa, veri çekilemezse bir hata mesajı ( Text) döner.
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), //Eğer bağlantı bekleniyorsa, dairesel bir yükleme animasyonu ( CircularProgressIndicator) döndürülür
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (FirebaseAuth.instance.currentUser!.email == data['email']) {
                //uygulamada kullandığımız hesabın email alıyor persondaki email ile kontrol ediyor eğer bizsek aşağıdaki işlemler.
                return Container(
                  //çerçeve kısmı burası
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                    border: Border.all(
                        color: const Color.fromARGB(255, 54, 181, 244)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Ad-Soyad: ${data['Name']}'),
                        subtitle: Text('E-mail: ${data['email']}'),
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Yeni Ad',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String newName = nameController.text;

                          updateUserProfile(newName);
                        },
                        child: const Text('Güncelle'),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox(); //bu, listede görüntülenmeyecektir
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
