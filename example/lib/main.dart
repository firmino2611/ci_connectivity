import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ci_connectivity/ci_connectivity.dart';
import 'package:ci_connectivity/helpers/ci_connectivity_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ciConnectivity = CiConnectivity();
  String textt = "";

  @override
  void initState() {
    super.initState();

    // ciConnectivity.loopVerifyStatus();
    // ciConnectivity.onListenerStatusNetwork.listen((event) {
    //   print(event);
    //   setState(() {
    //     textt = event.toString();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text("CON: " + textt),
            const CiConnectivityBuilder(
              withStream: true,
              childOnConnected: Text('conectado'),
              childOnDisconnected: Text('desconectado'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ciConnectivity.dispose();
    super.dispose();
  }
}
