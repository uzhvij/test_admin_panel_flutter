import 'dart:async';
import 'package:flutter/material.dart';
import '../Data/account.dart';
import '../Data/text_fields_controllers.dart';
import '../Logic/firebase_worker.dart';
import '../Data/master_data.dart';
import '../Data/master_item.dart';
import '../Logic/authenticator.dart';

class Master extends StatelessWidget {
  final ValueChanged<MasterItem> itemSelectedCallback;
  final bool isMobileLayout;
  final Authenticator authenticator = Authenticator();
  final TextFieldsControllers controllers = TextFieldsControllers();
  final FBWorker fbWorker;

  final StreamController<String> getCodeStream = StreamController.broadcast();
  BuildContext context;

  Master({@required this.itemSelectedCallback, @required this.isMobileLayout})
      : this.fbWorker = FBWorker();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    fbWorker.masterWidget = this;
    return Scaffold(
      appBar: AppBar(
        title: Text(isMobileLayout ? 'Master view' : 'Master-detail view'),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/master_logo.png',
            fit: BoxFit.fitWidth,
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: items.map((item) {
                return ListTile(
                  title: Text(item.title),
                  onTap: () => itemSelectedCallback(item),
                );
              }).toList(),
            ),
          ),
          StreamBuilder<MasterData>(
              initialData: MasterData(),
              stream: authenticator.getMasterDataStream,
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(snapshot.data.phone),
                );
              }),
          StreamBuilder<MasterData>(
              initialData: MasterData(),
              stream: authenticator.getMasterDataStream,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(snapshot.data.icon),
                  color: Colors.purpleAccent,
                  tooltip: snapshot.data.tooltip,
                  iconSize: 35.0,
                  padding: EdgeInsets.only(left: 10),
                  onPressed: () => Account.isSigned
                      ? authenticator.fbWorker.accountExit()
                      : buildPhoneEnteringWidget(context),
                );
              }),
        ],
      ),
    );
  }

  buildPhoneEnteringWidget(BuildContext context) {
    controllers.phoneController.text = '+555555555555';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Enter a phone number \n (below working test number)'),
          content: Container(
            height: 50,
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a phone number'),
              controller: controllers.phoneController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Send'),
              textColor: Colors.green,
              onPressed: () => Navigator.of(context).pop('send'),
            ),
            FlatButton(
              child: Text('Cancel'),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((button) => button == 'send'
        ? authenticator.signInWithSms(controllers.phoneController.text)
        : null);
  }

  buildSmsCodeEnteringWidget(BuildContext context) {
    controllers.smsController.text = '123456';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Enter a code \n (below working test number)'),
          content: Container(
            height: 50,
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a code'),
              controller: controllers.smsController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Send'),
                textColor: Colors.green,
                onPressed: () => Navigator.of(context).pop('send')),
            FlatButton(
              child: Text('Cancel'),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((button) => button == 'send'
        ? getCodeStream.add(controllers.smsController.text)
        : null);
  }

  getCode() async {
    buildSmsCodeEnteringWidget(this.context);
  }

  void dispose() {
    getCodeStream.close();
  }
}
