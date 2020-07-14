import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_klaizar_android/Data/UserRecord.dart';
import 'package:test_klaizar_android/Data/item.dart';

class DetailWidgetBuilder {
  static dynamic buildWidget(BuildContext context, Item item) {
    switch (item?.title) {
      case 'Create User':
        return buildAddUserWidget(context);
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
        return buildUsersListWidget(context);
    }
  }
}

StreamBuilder buildUsersListWidget(BuildContext context) {
  CollectionReference users = Firestore.instance.collection('users');
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData)
        return CircularProgressIndicator(
          strokeWidth: 50,
        );
      return ListView(
        children: snapshot.data.documents
            .map((data) => buildUsersListItem(context, data))
            .toList(),
      );
    },
  );
}

Widget buildUsersListItem(BuildContext context, DocumentSnapshot data) {
  final record = UserRecord.fromSnapshot(data);
  var textStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 18,
      backgroundColor: Colors.tealAccent);

  return Wrap(
    spacing: 8.0,
    // gap between adjacent chips
    runSpacing: 4.0,
    // gap between lines
    key: ValueKey(record.id),
    alignment: WrapAlignment.spaceBetween,
    direction: Axis.horizontal,
    runAlignment: WrapAlignment.end,
    children: [
      Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.spaceAround,
        children: [
          Text(
            record.id,
            style: textStyle,
          ),
          Text(record.userName),
          Text(record.registrationDate.toIso8601String()),
          Text(record.lastEvent),
          Text(record.city),
          Text(record.age.toString()),
        ],
      ),
      Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between
        alignment: WrapAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.create),
              color: Colors.purpleAccent,
              tooltip: 'Create',
              onPressed: () => null),
          IconButton(
              icon: Icon(Icons.delete),
              color: Colors.purpleAccent,
              visualDensity: VisualDensity.standard,
              tooltip: 'Create',
              onPressed: () => null),
        ],
      ),
    ],
  );
}

ListView buildAddUserWidget(BuildContext context) {
  return ListView(
    children: [
      Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a name'),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a city'),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter an age'),
          )
        ],
      )
    ],
  );
}
