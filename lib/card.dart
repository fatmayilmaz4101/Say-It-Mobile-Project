// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, duplicate_ignore, unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sayit/main.dart';
import 'package:sayit/pages/main.dart';
import 'package:sayit/sayit.dart';
import 'package:share/share.dart';

class SayItCard {
  SayItCard(int index, this.content, this.color, BuildContext? context,
      this.viewCount) {
    this.index = index;
    index += 1;
  }
  late int viewCount;
  late int index;
  late Color color;
  late String content;
  Scaffold details(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Row(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // ignore: prefer_const_constructors
                  child: Text("KART #$index",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )),
            Align(
              child: Container(
                padding: EdgeInsets.only(left: 150),
                child: Text(
                  "Görüntülenme: $viewCount",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            )
          ]),
          backgroundColor: Colors.grey,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      //Paylaş butonu
                      Share.share("'$content' from Say it!");
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(21.5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 4, color: Colors.black)),
                      child: RichText(
                        text: const TextSpan(
                            text: "Paylaş",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      //Anasayfaya gider
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ),
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(21.5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 4, color: Colors.black)),
                      child: RichText(
                        text: const TextSpan(
                            text: "Anasayfa",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      int nextCardId = Random().nextInt(app!.cardList!
                          .length); //cardlistten random kart getir nextcardıd'ye at.
                      while (nextCardId + 1 ==
                              index && //nextcardıd +1(+1 olmasının nedeni cardlarımın 1den başlaması lazım) indexe eşitse cardlist uzunluğu 1den büyükse yeniden random üret ve nextcarıd ye at
                          app!.cardList!.length > 1) {
                        nextCardId = Random().nextInt(app!.cardList!.length);
                      }
                      if (app!.cardList!.length > 1) {
                        //Birden fazla card varsa if'e gir
                        app!.cardList![nextCardId].viewCount +=
                            1; //Random gelen card'ın görüntülenmesini 1 arttır
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                app!.cardList![nextCardId].details(context),
                          ),
                        );
                      }
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 4, color: Colors.black)),
                      child: RichText(
                        text: const TextSpan(
                            text: "Rastgele Kart",
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
        //backgroundColor: color,
        body: Center(
          child: ListView(
            itemExtent: MediaQuery.of(context).size.height,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(color, BlendMode.color),
                        image: Image.asset("assets/desen.png").image)),
                padding: const EdgeInsets.all(50),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
