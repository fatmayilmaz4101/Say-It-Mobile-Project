import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sayit/card.dart';
import 'package:sayit/user.dart';

class SayIt {
  List<SayItCard>? cardList;
  User? user;

  static Queue<Color> cardColorQueue = Queue.from([
    const Color.fromARGB(255, 206, 145, 145),
    const Color.fromARGB(255, 129, 141, 184),
    const Color.fromARGB(255, 75, 90, 145),
    const Color.fromARGB(255, 193, 197, 129)
  ]);
}
