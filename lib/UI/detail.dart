import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../Logic/firebase_worker.dart';
import '../Data/text_fields_controllers.dart';
import '../UI/detail_widget_builder.dart';
import '../Data/master_item.dart';

class Detail extends StatelessWidget {
  Detail(
      {@required this.item,
      @required this.isMobileLayout,
      @required this.controllers});

  final MasterItem item;
  final bool isMobileLayout;
  final TextFieldsControllers controllers;
  final FBWorker fbWorker = FBWorker();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

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
                child:
                    DetailWidgetBuilder.buildWidget(context, item, controllers),
              ),
              item != null && item.withCreateButton
                  ? IconButton(
                      icon: Icon(Icons.create),
                      color: Colors.purpleAccent,
                      tooltip: 'Create',
                      iconSize: 35.0,
                      onPressed: () =>
                          createButtonOnPressed(item, controllers, context),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  void createButtonOnPressed(MasterItem item, TextFieldsControllers controllers,
      BuildContext context) async {
    switch (item.title) {
      case 'Create User':
        try {
          await fbWorker.createUser(controllers);
          controllers.clearTextFieldsControllers();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('user created'),
              );
            },
          );
        } catch (e) {
          print(e.toString());
          controllers.ageController.text = 'enter a number';
        }
        break;
      case 'Create Event':
        break;
    }
  }
}
