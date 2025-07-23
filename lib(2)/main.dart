import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

const taskName = "Simple Task";

void callBackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background Task:$task");
    return Future.value(true);
  });
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callBackDispatcher,
    isInDebugMode: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _startBgTask() {
    Workmanager().registerOneOffTask("uniqueName", taskName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BG Processing')),
      body: Center(
        child: ElevatedButton(onPressed: _startBgTask, child: Text('Run Task')),
      ),
    );
  }
}
