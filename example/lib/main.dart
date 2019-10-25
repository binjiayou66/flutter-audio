import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_audio/flutter_audio.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterAudio _flutterAudio = FlutterAudio();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          leading: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              if (_flutterAudio.isPlaying() == true) {
                _flutterAudio.stopPlay();
              } else {
                _flutterAudio.startPlay(
                    (await getApplicationDocumentsDirectory()).path +
                        '/ccheer.wav');
              }
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.accessible),
              onPressed: () async {
                //print((await _flutterAudio.canRecord()));
                if (_flutterAudio.isRecording() == true) {
                  _flutterAudio.stopRecord();
                } else {
                  _flutterAudio.startRecord(
                      (await getApplicationDocumentsDirectory()).path +
                          '/aaa.wav');
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Running!!!'),
        ),
      ),
    );
  }
}
