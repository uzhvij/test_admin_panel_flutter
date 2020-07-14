import '../Data/item.dart';
import 'package:flutter/material.dart';

class Master extends StatelessWidget {
  Master({ @required this.itemSelectedCallback, @required this.isMobileLayout });
  final ValueChanged<Item> itemSelectedCallback;
  final bool isMobileLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMobileLayout?'Master view':'Master-detail view'),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/master_logo.png',
            fit: BoxFit.fitWidth,),
          Expanded(
            flex: 1,
            child:
              ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.title),
                    onTap: () => itemSelectedCallback(item),
                  );
              }).toList(),
            ),
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.purpleAccent,
              tooltip: 'Logout',
              iconSize: 35.0,
              onPressed: () => null
          ),
        ],
      )
    );
  }
}
