// ignore_for_file: prefer_const_constructors, unnecessary_import, unused_import

import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sayit/main.dart';
import 'package:sayit/pages/main.dart';
import 'package:sayit/pages/signup.dart';
import 'package:sayit/sayit.dart';
import 'package:sayit/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  _LoginPage() {
    app = SayIt();
  }
  final formKey = GlobalKey<FormState>();
  User user = User(null, List<int>.empty(growable: true));
  String? tempPassword;

  @override
  void initState() {
    app!.cardList = null;
    app!.user = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(fit: StackFit.loose, children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 206, 145, 145),
                    border: BorderDirectional(
                        bottom: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 75, 90, 145),
                    )),
                  ),
                  height: MediaQuery.of(context).size.height / 2,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 2),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: const Text(
                      "Say It",
                      style: TextStyle(
                        fontSize: 50,
                        color: Color.fromARGB(255, 75, 90, 145),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Color.fromARGB(255, 75, 90, 145),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: const EdgeInsets.only(
                            right: 30, left: 30, top: 250, bottom: 280),
                        padding: EdgeInsets.all(20),
                        child: Form(
                            key: formKey,
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1)),
                                      labelText: "E-Posta",
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 145, 145)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 206, 145, 145))),
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 145, 145)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'E-Posta boş bırakılamaz';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      user.email = value!;
                                    },
                                  ),
                                ),
                                TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 4)),
                                      labelText: "Şifre",
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 145, 145)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 206, 145, 145))),
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 145, 145)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Şifre boş bırakılamaz';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      tempPassword = value!;
                                    }),
                                TextButton(
                                  onPressed: () => {},
                                  child: Text("Şifremi Unuttum",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 145, 145),
                                      )),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 206, 145, 145)),
                                    minimumSize: MaterialStateProperty.all(
                                        Size.fromHeight(50)),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();

                                      try {
                                        await db!
                                            .collection('users')
                                            .where('email',
                                                isEqualTo: user.email)
                                            .get()
                                            .then((value) => value.docs
                                                .singleWhere((element) =>
                                                    element.get('email') ==
                                                        user.email &&
                                                    element.get('password') ==
                                                        sha1
                                                            .convert(utf8.encode(
                                                                tempPassword
                                                                    as String))
                                                            .toString()))
                                            .then((value) {
                                          user.docId = value.id;
                                          user.email = value.get('email');
                                          for (int id in value.get('cards')) {
                                            user.cardIds!.add(id);
                                          }
                                          return true;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Başarılı giriş')));
                                        app!.user = user;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MainPage(),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Hatalı e-mail veya şifre')));
                                      }
                                    }
                                  },
                                  child: const Text('GİRİŞ YAP'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    )
                                  },
                                  child: Text("Üye değil misin? Üye Ol",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 206, 145, 145),
                                      )),
                                ),
                              ],
                            )))),
              ]))),
    );
  }
}
