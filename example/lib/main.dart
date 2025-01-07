import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call.dart';

void main() {
  runApp(const MyHomeApp());
}

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NERtc FaceUnity plugin Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _nertcFaceunityPlugin = NertcFaceunityPlugin();

  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPermissions();
    // 生成一个随机的 userid，类型是 int
    _userIdController.text = Random().nextInt(1000000).toString();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _nertcFaceunityPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initPermissions() async {
    var status = await Permission.camera.request();
    print('permission status :${status}');
    status = await Permission.microphone.request();
    print('permission status :${status}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NERtc Faceunity example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: loginWidget,
          ),
        ),
      ),
    );
  }

List<Widget> get loginWidget {
    return [
            TextField(
              controller: _channelNameController,
              onChanged: (value) {
              },
              decoration: const InputDecoration(
                labelText: 'channel name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'user id',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_channelNameController.text.isEmpty || _userIdController.text.isEmpty) {
                  print('channel name or user id is empty, invalid');
                  return;
                }
                
                Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => VideoCall(
                    channelName: _channelNameController.text,
                    uid: int.parse(_userIdController.text),
                  )));
              }, 
              child: const Text('join'),
            ),
          ];
  }
}
