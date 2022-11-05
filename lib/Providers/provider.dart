import 'package:flutter/material.dart';

class Providers extends ChangeNotifier{
  void onChanged(){
    notifyListeners();
  }
}