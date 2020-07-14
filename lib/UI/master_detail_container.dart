import 'package:flutter/material.dart';
import 'detail.dart';
import '../Data/item.dart';
import 'master.dart';

class MasterDetailContainer extends StatefulWidget {
  @override
  _MasterDetailContainerState createState() => _MasterDetailContainerState();
}

class _MasterDetailContainerState extends State<MasterDetailContainer> {
  Item _selectedItem;
  var isMobileLayout;

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    isMobileLayout = shortestSide < 600;

    if (isMobileLayout) {
      return _buildMobileLayout();
    }
    return _buildWebLayout();
  }

  Widget _buildMobileLayout() {
    return Master(
      itemSelectedCallback: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Detail(
                    item: item,
                    isMobileLayout: isMobileLayout,
                  )),
        );
      },
      isMobileLayout: isMobileLayout,
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Master(
            itemSelectedCallback: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
            isMobileLayout: isMobileLayout,
          ),
        ),
        Flexible(
          flex: 5,
          child: Detail(
            item: _selectedItem,
            isMobileLayout: isMobileLayout,
          ),
        ),
      ],
    );
  }
}
