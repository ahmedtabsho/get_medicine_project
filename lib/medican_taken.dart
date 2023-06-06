import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore veritabanıyla etkileşime izin verir.
import 'package:flutter/material.dart'; // Flutter'ın materyal tasarım widget'larını sağlar.
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart'; //Firebase kimlik doğrulamasını etkinleştirir.

// ignore: use_key_in_widget_constructors
class MedicianTaken extends StatefulWidget {
  //kullanacağımız ekranda widgetlarda değişiklik olacağından bunu Stateful widget sınıfıyla oluşturduk
  @override
  // ignore: library_private_types_in_public_api
  _MedicianTakenState createState() => _MedicianTakenState();
}

class _MedicianTakenState extends State<MedicianTaken> {
  //BU KISIMIDA VERİTABANINDAKİ
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Requestes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //sayfanın iskeleti için scaffold açtık build fonk. içinde. bu sayfa appbar ve body içeriyor.Scaffold ile ekranımızı oluştururuz.
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/ilaçlar.png'),
            ),
            SizedBox(width: 10),
            Text('Alınan İlaçlar'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //streambuilder firebase den anlık şekilde veri çekmesini sağlar.
        stream:
            _usersStream, // veritabanındaki ilaçlar koleksiyonunda herhangi bir değişiklik olduğunda güncel verileri alabilirsiniz.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //asnekron şekilde snapshot veri çekiyor. ve hata olup olmadığını builder ile kontrol ediyoruz.
          if (snapshot.hasError) {
            return const Text(
                'Bir Hata Oluştu'); //Eğer bir hata varsa, veri çekilemezse bir hata mesajı ( Text) döner.
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //Eğer bağlantı bekleniyorsa, dairesel bir yükleme animasyonu ( CircularProgressIndicator) döndürülür
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                if (FirebaseAuth.instance.currentUser!.uid ==
                    data['Wanter']['UserID']) {
                  //uygulamada kullandığımız hesabın uid alıyor gönderilen ilacın user id ile kontrol ediyor eğer bizsek aşağıdaki işlemler.
                  return Container(
                    //çerçeve kısmı burası
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                          title: Text(data['Wanter']['UserName']),
                          subtitle: Text(
                            data['Wanter']['UserTC'],
                          ),
                        ),
                        Text('Alınan ilaç: ${data['Sender']['medName']}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('İlaç Bilgi: ${data['Sender']['MedInfo']}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Şehir: ${data['Sender']['City']}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Adres: ${data['Sender']['Adress']}'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              });
        },
      ),
    );
  }
}
