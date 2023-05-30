import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore veritabanıyla etkileşime izin verir.
import 'package:flutter/material.dart'; // Flutter'ın materyal tasarım widget'larını sağlar.
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart'; //Firebase kimlik doğrulamasını etkinleştirir.

// ignore: use_key_in_widget_constructors
class MedicianList extends StatefulWidget {
  @override //kullanacağımız ekranda widgetlarda değişiklik olacağından bunu Stateful widget sınıfıyla oluşturduk
  // ignore: library_private_types_in_public_api
  _MedicianListState createState() => _MedicianListState();
}

class _MedicianListState extends State<MedicianList> {
  //BU KISIMIDA VERİTABANINDAKİ
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Medicines').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //sayfanın iskeleti için scaffold açtık build fonk. içinde. bu sayfa appbar ve body içeriyor.Scaffold ile ekranımızı oluştururuz.
      appBar: AppBar(
        //AppBar widgetı da, Scaffold ile oluşturduğumuz ekranın içinde, üst kısımda oluşturduğumuz bir yapıdır. Burada uygulamanın adını yazdık
        title: const Text('Gönderilen İlaçlar'),
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
              if (FirebaseAuth.instance.currentUser!.uid == data['UserID']) {
                //uygulamada kullandığımız hesabın uid alıyor gönderilen ilacın user id ile kontrol ediyor eğer bizsek aşağıdaki işlemler.
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
                        title: Text(data['UserName']),
                        subtitle: Text(
                          data['UserTC'],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // İlaç silme işlemi burada yapılacak
                            FirebaseFirestore.instance
                                .collection('Medicines')
                                .doc(document
                                    .id) // Silinecek ilacın belirleyici alanı (document ID)
                                .delete()
                                .then((value) {})
                                .catchError((error) {});
                          },
                        ),
                      ),
                      Text('Gönderilen İlaç: ${data['medName']}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('İlaç Bilgi: ${data['MedInfo']}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Şehir: ${data['City']}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Adres: ${data['Adress']}'),
                      const SizedBox(
                        height: 10,
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
