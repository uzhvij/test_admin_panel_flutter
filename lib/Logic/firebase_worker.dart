import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Data/account.dart';
import '../Data/text_fields_controllers.dart';
import '../Data/user_record.dart';
import '../UI/master.dart';

class FBWorker {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference users = Firestore.instance.collection('users');
  ValueChanged<String> interfaceUpdateCallback;
  Master masterWidget;

  static final FBWorker singleton = new FBWorker.internal();

  factory FBWorker() {
    return singleton;
  }

  FBWorker.internal();

  Future<void> listenAccountStateAndUpdateInterface() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.onAuthStateChanged.listen((FirebaseUser user) {
      if (user == null) {
        Account.isSigned = false;
        Account.phone = '';
        Account.message = 'Please sign in';
      } else {
        Account.isSigned = true;
        Account.phone = user.phoneNumber;
      }
      interfaceUpdateCallback('firebase user state is changed');
    }).onError((e) => print(e));
  }

  Future<void> authWithSms(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.verifyPhoneNumber(
      // Update the UI - wait for the user to enter the phone number
      //testing phone number
      phoneNumber: phoneNumber,
      verificationCompleted: (AuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (AuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print('error ' + e.message);
      },
      codeSent: (verificationId, [forceResendingToken]) async {
        masterWidget.getCode();
        String smsCode = await masterWidget.getCodeStream.stream.first;
        // Update the UI - wait for the user to enter the SMS code
        print(smsCode);
        // Create a PhoneAuthCredential with the code
        AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
            verificationId: verificationId, smsCode: smsCode);
        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(phoneAuthCredential);
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('codeAutoRetrievalTimeout');
      },
    );
  }

  void accountExit() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
  }

  Future<DocumentReference> createUser(
      TextFieldsControllers controllers) async {
    return await users.add({
      'User Name': controllers.nameController.text,
      'Registration date': FieldValue.serverTimestamp(),
      'Last event': 'some event',
      'City': controllers.cityController.text,
      'Age': int.parse(controllers.ageController.text),
    });
  }

  static Future<void> editUserInfo(
      TextFieldsControllers controllers, UserRecord record) {
    return record.reference.updateData({
      'User Name': controllers.nameController.text,
      'City': controllers.cityController.text,
      'Age': int.parse(controllers.ageController.text),
    });
  }
}
