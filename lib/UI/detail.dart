import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_klaizar_android/UI/detail_widget_builder.dart';

import '../Data/item.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Detail extends StatelessWidget {
  Detail({@required this.item, @required this.isMobileLayout});

  final Item item;
  final bool isMobileLayout;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    dynamic list = DetailWidgetBuilder.buildWidget(context, item);

    return Scaffold(
        appBar: AppBar(
          title: Text(isMobileLayout ? 'Detail view' : ''),
        ),
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item?.title ?? "Item isn't selected",
                style: textTheme.headline3,
              ),
              Expanded(
                flex: 1,
                child: list,
              ),
              item != null && item.withButton
                  ? IconButton(
                      icon: Icon(Icons.create),
                      color: Colors.purpleAccent,
                      tooltip: 'Create',
                      iconSize: 35.0,
                      onPressed: () => mainButtonPressed(item, list),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}

Future<void> mainButtonPressed(Item item, ListView list) {
  switch (item.title) {
    case 'Create User':
      CollectionReference users = Firestore.instance.collection('users');
      return users.add({
        'User Name': 'sdfsdfsdfsdf',
        'Registration date': Timestamp.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch),
        'Last event': '-',
        'City': 'sdfkjsl',
        'Age': 44
      });
      break;
  }
}
