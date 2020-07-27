import 'package:flutter/material.dart';

class MasterData {
  IconData icon;
  String tooltip;
  String phone;

  static final MasterData singleton = new MasterData.internal();

  factory MasterData() {
    return singleton;
  }

  MasterData.internal() {
    icon = Icons.autorenew;
    phone = "";
  }
}
