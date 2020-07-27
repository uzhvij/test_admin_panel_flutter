import 'package:flutter/material.dart';
import '../Data/user_record.dart';

class TextFieldsControllers {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final smsController = TextEditingController();

  void clearTextFieldsControllers() {
    ageController.clear();
    cityController.clear();
    nameController.clear();
  }

  void setUserInfo(UserRecord record) {
    nameController.text = record.userName;
    ageController.text = record.age.toString();
    cityController.text = record.city;
  }
}
