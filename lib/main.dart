
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final recorder=FlutterSoundRecorder();
  bool isRecordReady=false;


  Future record()async
  {
    if(! isRecordReady)return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop()async
  {
    if(! isRecordReady)return;
    final String? path=await recorder.stopRecorder();
  }

  Future initRecorder()async
  {
    final status=await Permission.microphone.request();

    if(status != PermissionStatus.granted)
      {
        throw 'Microphone permission not granted';
      }

    await recorder.openRecorder();
    isRecordReady=true;
  }

  @override
  void initState() {
    super.initState();
     initRecorder();
  }

  @override
  void dispose() {
     recorder.closeRecorder();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Recorder'),
      ),
      body: Center(
        child:ElevatedButton(
          onPressed:()async
          {
            if(recorder.isRecording)
              {
                await stop();
              }
            else
              {
                await record();
              }

          },
          child: Icon(recorder.isRecording?Icons.stop:Icons.mic),
        ),
      ),
    );
  }
}
