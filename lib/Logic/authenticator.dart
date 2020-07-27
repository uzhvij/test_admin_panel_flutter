import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '../Data/account.dart';
import '../Data/master_data.dart';
import '../Logic/firebase_worker.dart';

class Authenticator {
  final MasterData masterData = MasterData();
  final masterDataStream = BehaviorSubject<MasterData>();
  final StreamController<String> authButtonActionController =
      StreamController();
  final FBWorker fbWorker = FBWorker();

  Authenticator() {
    fbWorker.interfaceUpdateCallback = (message) => updateMasterData();
    authButtonActionController.stream.listen(signInWithSms);
    fbWorker.listenAccountStateAndUpdateInterface();
  }

  Stream get getMasterDataStream => masterDataStream.stream;

  Sink get changeMasterData => masterDataStream.sink;

  StreamSink get authOrExit => authButtonActionController.sink;

  updateMasterData() {
    masterData.tooltip = Account.isSigned ? 'Sign Out' : 'Sign In';
    masterData.icon = Account.isSigned ? Icons.keyboard_return : Icons.input;
    masterData.phone = Account.isSigned ? Account.phone : Account.message;
    changeMasterData.add(masterData);
  }

  Future<void> signInWithSms(String phone) async {
    return fbWorker.authWithSms(phone).catchError((e) {
      Account.message = 'Will be realized soon';
      updateMasterData();
    });
  }

  void dispose() {
    masterDataStream.close();
    authButtonActionController.close();
  }
}
