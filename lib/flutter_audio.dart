import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAudio {
  static const MethodChannel _channel = const MethodChannel('flutter_audio');

  bool _isRecording = false;
  bool _isPlaying = false;

  FlutterAudio() {
    _channel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case "audioPlayerDidFinishPlaying":
          {
            _isPlaying = false;
            print('audioPlayerDidFinishPlaying');
            break;
          }
        case "updateDbPeakProgress":
          break;
        default:
          throw new ArgumentError('Unknown method ${call.method} ');
      }
      return null;
    });
  }

  Future<bool> canRecord() async {
    return await _channel.invokeMethod('canRecord');
  }

  bool isRecording() {
    return _isRecording;
  }

  Future<bool> startRecord(String path) async {
    if (_isRecording == true) {
      print('已经在录制当中');
      return Future.value(false);
    }
    _isRecording = true;
    return await _channel.invokeMethod('startRecord', [path]);
  }

  Future<int> stopRecord() async {
    if (_isRecording == false) {
      print('当前没有开始录制');
      return Future.value(0);
    }
    _isRecording = false;
    return await _channel.invokeMethod('stopRecord');
  }

  bool isPlaying() {
    return _isPlaying;
  }

  Future<bool> startPlay(String path) async {
    if (_isPlaying == true) {
      print('已经在播放当中');
      return Future.value(false);
    }
    _isPlaying = true;
    return await _channel.invokeMethod('startPlay', [path]);
  }

  Future<bool> stopPlay() async {
    if (_isPlaying == false) {
      print('当前没有开始播放');
      return Future.value(false);
    }
    _isPlaying = false;
    return await _channel.invokeMethod('stopPlay');
  }
}
