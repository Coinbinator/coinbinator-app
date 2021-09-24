import 'package:flutter/material.dart';

class SplashModel extends ChangeNotifier {
  String initializetionMessage = "";

  setInitializetionMessage(String value) {
    initializetionMessage = value;
    notifyListeners();
  }
}
