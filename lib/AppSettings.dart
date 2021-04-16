import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier
{
  String webURL;

  void updateWebURL(String url)
  {
    webURL = url;
    notifyListeners();
  }
}