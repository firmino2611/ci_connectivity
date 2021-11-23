import 'package:ci_connectivity/ci_connectivity.dart';
import 'package:flutter/material.dart';

class CiConnectivityBuilder extends StatefulWidget {
  final Widget? childOnConnected;
  final Widget? childOnDisconnected;

  final bool withStream;

  const CiConnectivityBuilder(
      {Key? key,
      this.childOnConnected,
      this.childOnDisconnected,
      this.withStream = false})
      : super(key: key);

  @override
  State<CiConnectivityBuilder> createState() => _CiConnectivityBuilderState();
}

class _CiConnectivityBuilderState extends State<CiConnectivityBuilder> {
  CiConnectivity ciConnectivity = CiConnectivity();

  @override
  void initState() {
    if (widget.withStream) ciConnectivity.loopVerifyStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.withStream
        ? StreamBuilder<bool>(
            stream: ciConnectivity.onListenerStatusNetwork,
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return Container();

              if (snapshot.data) return widget.childOnConnected!;

              return widget.childOnDisconnected!;
            },
          )
        : FutureBuilder<bool>(
            future: ciConnectivity.checkConnection,
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return Container();

              if (snapshot.data) return widget.childOnConnected!;

              return widget.childOnDisconnected!;
            },
          );
  }
}
