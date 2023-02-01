// ignore_for_file: unused_import, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:sayit/card.dart';
import 'package:flutter/material.dart';
import 'package:sayit/main.dart';
import 'package:sayit/pages/createcard.dart';
import 'package:sayit/pages/main.dart';
import 'package:sayit/sayit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 206, 145, 145),
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('${app!.user?.email}',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: Text('Kartlarım'),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: app!.user!.cardIds!.length,
                  (BuildContext context, int index) {
                if (app!.user!.cardIds!.contains(index)) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                app!.cardList![index].color, BlendMode.color),
                            image: Image.asset("assets/desen.png").image)),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                app!.cardList![index].details(context),
                          ),
                        );
                      },
                      child: Ink(
                        height: 130,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                      "KART #${app!.cardList![index].index}",
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
                                      app!.cardList![index].content
                                                  .split(' ')
                                                  .length >=
                                              10
                                          ? app!.cardList![index].content
                                              .split(' ')
                                              .getRange(0, 9)
                                              .join(' ')
                                          : app!.cardList![index].content,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black)),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      db!
                                          .collection('cards')
                                          .doc(await db!
                                              .collection("cards")
                                              .where('id',
                                                  isEqualTo: app!
                                                      .cardList![index].index)
                                              .get()
                                              .then((value) =>
                                                  value.docs.single.id))
                                          .delete();
                                      app!.user!.cardIds!.removeWhere(
                                          (element) =>
                                              element ==
                                              app!.cardList![index].index);
                                      app!.cardList!.removeWhere((element) =>
                                          element.index ==
                                          app!.cardList![index].index);
                                      db!
                                          .collection('users')
                                          .where('email',
                                              isEqualTo: app!.user!.email)
                                          .get()
                                          .then((value) => value.docs)
                                          .then((value) =>
                                              value.single.reference.update({
                                                'cards': app!.user!.cardIds
                                              }));

                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () => {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateCardPage(),
                                            ),
                                          )
                                        },
                                    icon: Icon(Icons.update)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return null;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
