// ignore_for_file: avoid_unnecessary_containers, duplicate_ignore, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:sayit/card.dart';
import 'package:sayit/main.dart';
import 'package:sayit/pages/createcard.dart';
import 'package:sayit/pages/login.dart';
import 'package:sayit/pages/profile.dart';
import 'package:sayit/sayit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  static const double heightVar = 130;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    app!.cardList = List<SayItCard>.empty(growable: true);
    updateCardList();
    super.initState();
  }

  void updateCardList() async {
    app!.cardList!.addAll(await db!.collection('cards').get().then((value) =>
        value.docs.map((e) => SayItCard(
            e.get('id'),
            e.get('content'),
            Color.fromRGBO(
                Map.from(e.get('color'))['r'],
                Map.from(e.get('color'))['g'],
                Map.from(e.get('color'))['b'],
                Map.from(e.get('color'))['o']),
            context,
            e.get('view_count')))));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      )
                    },
                icon: Icon(Icons.person)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
          backgroundColor: Colors.grey,
        ),
        bottomNavigationBar: BottomAppBar(
          //bottom nav oluşturmak için
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      if (app!.cardList!.isNotEmpty) {
                        //Kart listesi boş değilse router yap
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => app!.cardList!.first
                                .details(context), //İlk kartı getir
                          ),
                        );
                      }
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          //borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 4, color: Colors.black)),
                      child: RichText(
                        text: const TextSpan(
                            text: "İlk Karta Git",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateCardPage(), //Kart Oluşturma sayfasına git
                        ),
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 4, color: Colors.black)),
                      child: RichText(
                        text: const TextSpan(
                            text: "Kart Oluştur",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      if (app!.cardList!.isNotEmpty) {
                        //Kart listesi boş değilse
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => app!.cardList!.last
                                .details(context), //Son kartı getir
                          ),
                        );
                      }
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 4, color: Colors.black),
                      ),
                      child: RichText(
                        text: const TextSpan(
                            text: "Son Karta Git",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 181, 181),
        body: Center(
          child: ListView(
              //Containerları listview'a koymak scroll sağlar
              reverse: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(left: 20, right: 20, top: 40),
              children: List.from(
                app!.cardList!.map((e) {
                  //cardlist listesine eleman(e) atar
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter:
                                ColorFilter.mode(e.color, BlendMode.color),
                            image: Image.asset("assets/desen.png").image)),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: InkWell(
                      // Karta Tıklandığında detayları göster.

                      onTap: () {
                        setState(() {
                          //Detayları görüntüler
                          e.viewCount +=
                              1; //Görüntülenmeyi tıklandığında 1 arttır
                          db!
                              .collection('cards')
                              .where('id', isEqualTo: e.index)
                              .get()
                              .then((value) => value.docs.single)
                              .then((value) => value.reference
                                  .update({"view_count": e.viewCount}));

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => e.details(context),
                            ),
                          );
                        });
                      }, // Handle your callback
                      child: Ink(
                        height: heightVar,
                        child: Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(left: 5, top: 5),
                                child: Text("KART #${e.index}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black))),
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      right: 25, left: 25, bottom: 10),
                                  child: Text(
                                      e.content.split(' ').length >= 10
                                          ? e.content
                                              .split(' ')
                                              .getRange(0, 9)
                                              .join(' ')
                                          : e.content,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black))))
                        ]),
                      ),
                    ),
                  );
                }),
              )),
        ));
  }
}
