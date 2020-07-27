import 'package:flutter/material.dart';
import '../Data/text_fields_controllers.dart';
import '../Data/master_item.dart';
import 'detail.dart';
import 'master.dart';

class MasterDetailContainer extends StatefulWidget {
  @override
  MasterDetailContainerState createState() => MasterDetailContainerState();
}

class MasterDetailContainerState extends State<MasterDetailContainer> {
  MasterItem selectedItem;
  var isMobileLayout;

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    isMobileLayout = shortestSide < 600;

    if (isMobileLayout) {
      return buildMobileLayout();
    }
    return buildWebLayout();
  }

  Widget buildMobileLayout() {
    return Master(
      itemSelectedCallback: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Detail(
                    item: item,
                    isMobileLayout: isMobileLayout,
                    controllers:
                        item.withCreateButton ? TextFieldsControllers() : null,
                  )),
        );
      },
      isMobileLayout: isMobileLayout,
    );
  }

  Widget buildWebLayout() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Master(
            itemSelectedCallback: (item) {
              setState(() {
                selectedItem = item;
              });
            },
            isMobileLayout: isMobileLayout,
          ),
        ),
        Flexible(
          flex: 5,
          child: Detail(
            item: selectedItem,
            isMobileLayout: isMobileLayout,
            controllers: (selectedItem?.withCreateButton ?? false)
                ? TextFieldsControllers()
                : null,
          ),
        ),
      ],
    );
  }
}
