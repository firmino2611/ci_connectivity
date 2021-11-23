# ci_connectivity

OBS: For now we don't have IOS support

## Getting Started

Flutter plugin for checking network connection. It is not just checking if you are connected to Wifi or Mobile network, this plugin provides a validation with connection to the google server to determine if there is or is not the possibility of making a connection.

## Usage

The simplest way to use the plugin is with the checkConnection method, which returns a boolean value to identify whether a connection exists.

```dart
import 'package:ci_connectivity/ci_connectivity.dart';

if (CiConnectivity().checkConnection) {
    // is connected
} else {
    // is not connected
}

```

We also offer a listener to listen for change in connection status.

```dart
import 'package:ci_connectivity/ci_connectivity.dart';

final ciConnectivity = CiConnectivity();

ciConnectivity.loopVerifyStatus();
ciConnectivity.onListenerStatusNetwork.listen((event) {
    print(event);
});

```
It is still possible to use an interface helper, if you want a simple visual implementation of the resource. Can be used as Future or Stream.

```dart
import 'package:ci_connectivity/helpers/ci_connectivity_builder.dart';

CiConnectivityBuilder(
    withStream: true, // indicates whether it will be rendered with a StreamBuilder
    childOnConnected: Text('connected'),
    childOnDisconnected: Text('diconnected'),
)
```
