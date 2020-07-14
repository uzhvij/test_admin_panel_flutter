import 'package:flutter/material.dart';
import 'package:test_klaizar_android/UI/master_detail_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.purpleAccent,
          displayColor: Colors.purpleAccent,
        )
      ),
      home: MasterDetailContainer(),
    );
  }
}
