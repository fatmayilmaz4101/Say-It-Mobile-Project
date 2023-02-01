// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:sayit/card.dart';
import 'package:sayit/main.dart';
import 'package:sayit/pages/login.dart';
import 'package:sayit/pages/main.dart';
import 'package:sayit/sayit.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({super.key});

  @override
  State<CreateCardPage> createState() => _CreateCardPage();
}

class _CreateCardPage extends State<CreateCardPage> {
  final TextEditingController _contentController = TextEditingController();
  //int colorIndex = SayIt.cardColorList.length;

  SayItCard newCard = SayItCard(-1, "no content", Colors.green, null, 0);

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 90, 87, 87),
      ),
      backgroundColor: const Color.fromARGB(255, 90, 87, 87),
      body: Center(
          child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(children: [
                Flexible(
                    child: TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  minLines: null,
                  maxLines: null,
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Kendinden bahset',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 206, 145, 145))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 206, 145, 145)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                )),
                ElevatedButton(
                  onPressed: () async {
                    //Göndere bastığımda
                    if (_contentController.text.isNotEmpty) {
                      int cardCount = await db!
                          .collection('cards')
                          .get()
                          .then((value) => value.docs.length);
                      //text boş değilse
                      setState(() {
                        Color tempColorVar = SayIt.cardColorQueue
                            .removeFirst(); //color queque listesinin sonunu değişkene at sil
                        SayIt.cardColorQueue.addLast(
                            tempColorVar); //Silinen değeri yakala kuyruğa geri ekle
                        newCard = SayItCard(
                            app!.cardList!.length, //Yeni kart oluştur
                            _contentController.text,
                            tempColorVar,
                            context,
                            cardCount);

                        app!.cardList!.add(newCard);
                        app!.user!.cardIds!.add(newCard.index);
                        db!
                            .collection('users')
                            .doc(app!.user!.docId)
                            .update({"cards": app!.user!.cardIds});

                        db!.collection('cards').add({
                          'view_count': newCard.viewCount,
                          'id': newCard.index,
                          'content': newCard.content,
                          'color': {
                            'r': newCard.color.red,
                            'g': newCard.color.green,
                            'b': newCard.color.blue,
                            'o': newCard.color.opacity
                          }
                        });

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                MainPage(), //Kart Oluşturma sayfasına git
                          ),
                        ); //Anasayfaya dön
                      });
                    }
                  },
                  child: const Text(
                    "Gönder",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 206, 145, 145)),
                  ),
                ),
              ]))),
    );
  }
}
