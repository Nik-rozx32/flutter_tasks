import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

const taskName = "Simple Task";

void callBackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Background Task:$task");
    print("Received Data: ${inputData?['message']}");
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _log = "No task run yet";

  void _startBgTask() {
    Workmanager().registerOneOffTask("uniqueName", taskName,
        inputData: {"message": "Hello from foreground"});
    setState(() {
      _log = "Task registered. Check logs or background output.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BG Processing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _startBgTask, child: Text('Run Task')),
            SizedBox(height: 20),
            Text(_log),
          ],
        ),
      ),
    );
  }
}
