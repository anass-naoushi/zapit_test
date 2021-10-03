import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zapit_test/screens/coinsList.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  print('sss');
  WidgetsFlutterBinding.ensureInitialized(); 
  Directory appDocDir = await getApplicationDocumentsDirectory();
  print('sss');
  print(appDocDir.path);
  Hive.init(appDocDir.path);
  await Hive.openBox('coinData',crashRecovery: true,);
  runApp(MyApp());
}

///Start of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zapit Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:CoinsList(),
    );
  }
}

