import 'package:flutter/material.dart';
import 'dart:isolate';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int heavyLoad(int iteration) {
    int value = 0;
    for (int i = 0; i < iteration; i++) {
      value++;
    }
    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 50),
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                heavyLoad(40000000000);
              },
              child: Text('Test UI without isolate')),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                IsolateFunc();
              },
              child: Text('Test UI with isolate'))
        ],
      )),
    );
  }
}

void runTask(List<dynamic> args) {
  SendPort resultPort = args[0];
  int value = 0;
  for (int i = 0; i < args[1]; i++) {
    value++;
  }
  Isolate.exit(resultPort, value);
}

IsolateFunc() async {
  final ReceivePort receivePort = ReceivePort();
  try {
    await Isolate.spawn(runTask, [receivePort.sendPort, 40000000000]);
  } on Object {
    print("Isolate Failed");
    receivePort.close();
  }
  final response = await receivePort.first;
  print("data processed: ${response}");
}
