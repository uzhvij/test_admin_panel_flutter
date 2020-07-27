import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Data/user_record.dart';
import '../Data/master_item.dart';
import '../Logic/firebase_worker.dart';
import '../Data/text_fields_controllers.dart';

class DetailWidgetBuilder {
  static dynamic buildWidget(BuildContext context, MasterItem item,
      TextFieldsControllers controllers) {
    switch (item?.title) {
      case 'Create User':
        return buildAddUserWidget(context, controllers);
        break;
      case 'Create Event':
        return Container();
        break;
      case 'Events':
        return Container();
        break;
      case 'Users':
        return buildUsersListWidget(context);
        break;
      case 'Orders':
        return Container();
        break;
      default:
        return Container();
    }
  }
}

StreamBuilder buildUsersListWidget(BuildContext context) {
  CollectionReference users = Firestore.instance.collection('users');
  return StreamBuilder<QuerySnapshot>(
    stream: users.orderBy('Registration date', descending: true).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData)
        return CircularProgressIndicator(
          strokeWidth: 50,
        );
      return ListView(
        padding: EdgeInsets.all(10.0),
        children: snapshot.data.documents
            .map((data) => buildUsersListItem(context, data))
            .toList(),
      );
    },
  );
}

Widget buildUsersListItem(BuildContext context, DocumentSnapshot data) {
  final record = UserRecord.fromSnapshot(data);
  final TextFieldsControllers controllers = TextFieldsControllers();
  var date = new DateFormat.yMMMMd().add_Hm().format(record.registrationDate);
  var textStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 18,
      backgroundColor: Colors.tealAccent);
  //var vd = VisualDensity(horizontal: 20, vertical: 20)

  return Padding(
      padding: EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 40.0,
        // gap between adjacent chips
        runSpacing: 4.0,
        // gap between lines
        key: ValueKey(record.id),
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.end,
        children: [
          Wrap(
            spacing: 16.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.start,
            children: [
              Text(
                record.id,
                //style: textStyle,
              ),
              Text(record.userName),
              Text(date),
              Text(record.lastEvent),
              Text(record.city),
              Text(record.age.toString()),
            ],
          ),
          Wrap(
            spacing: 20.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between
            alignment: WrapAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.edit),
                    iconSize: 20,
                    visualDensity: VisualDensity(horizontal: 4, vertical: 4),
                    color: Colors.purpleAccent,
                    tooltip: 'Edit',
                    onPressed: () =>
                        buildEditUserWidget(context, controllers, record)),
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.delete),
                    iconSize: 20,
                    visualDensity: VisualDensity(horizontal: 4, vertical: 4),
                    color: Colors.purpleAccent,
                    tooltip: 'Delete',
                    onPressed: () => record.reference.delete().then((value) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('user deleted'),
                              );
                            },
                          ).catchError((e) => print(e));
                        })),
              ),
            ],
          ),
        ],
      ));
}

ListView buildAddUserWidget(
    BuildContext context, TextFieldsControllers controllers) {
  return ListView(
    children: [
      Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a name'),
            controller: controllers.nameController,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a city'),
            controller: controllers.cityController,
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter an age'),
            controller: controllers.ageController,
          )
        ],
      )
    ],
  );
}

Future<dynamic> buildEditUserWidget(BuildContext context,
    TextFieldsControllers controllers, UserRecord record) {
  controllers.setUserInfo(record);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text('Edit user'),
        content: Container(
          height: 300,
          width: 300,
          child: buildAddUserWidget(context, controllers),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            textColor: Colors.green,
            onPressed: () {
              try {
                FBWorker.editUserInfo(controllers, record)
                    .then((value) => Navigator.of(context).pop())
                    .then((value) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('user edited'),
                      );
                    },
                  );
                });
              } catch (e) {
                print(e.toString());
                controllers.ageController.text = 'enter a number';
              }
            },
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
  );
}
