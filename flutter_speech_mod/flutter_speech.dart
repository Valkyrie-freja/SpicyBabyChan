import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

int ErrorCode = -1;

typedef void AvailabilityHandler(bool result);
typedef void StringResultHandler(String text);

/// the channel to control the speech recognition
class SpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('com.flutter.speech_recognition');

  static final SpeechRecognition _speech = new SpeechRecognition._internal();

  factory SpeechRecognition() => _speech;

  SpeechRecognition._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  AvailabilityHandler availabilityHandler;

  StringResultHandler recognitionResultHandler;

  VoidCallback recognitionStartedHandler;

  StringResultHandler recognitionCompleteHandler;

  VoidCallback errorHandler;

  /// ask for speech  recognizer permission
  Future activate(String locale) =>
      _channel.invokeMethod("speech.activate", locale);

  /// start listening
  Future listen() => _channel.invokeMethod("speech.listen");

  /// cancel speech
  Future cancel() => _channel.invokeMethod("speech.cancel");

  /// stop listening
  Future stop() => _channel.invokeMethod("speech.stop");

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "speech.onSpeechAvailability":
        availabilityHandler(call.arguments);
        break;
      case "speech.onSpeech":
        //音声認識終了時以外に呼ばれる,途中経過を送ってくれるっぽい？
        recognitionResultHandler(call.arguments);
        break;
      case "speech.onRecognitionStarted":
        //transcriptionの初期化
        recognitionStartedHandler();
        break;
      case "speech.onRecognitionComplete":
        //音声認識終了時に呼ばれる
        recognitionCompleteHandler(call.arguments);
        //speech.destroy;
        break;
      case "speech.onError":
        errorHandler();
        ErrorCode = call.arguments;
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  // define a method to handle availability / permission result
  void setAvailabilityHandler(AvailabilityHandler handler) =>
      availabilityHandler = handler;

  // define a method to handle recognition result
  void setRecognitionResultHandler(StringResultHandler handler) =>
      recognitionResultHandler = handler;

  // define a method to handle native call
  void setRecognitionStartedHandler(VoidCallback handler) =>
      recognitionStartedHandler = handler;

  // define a method to handle native call
  void setRecognitionCompleteHandler(StringResultHandler handler) =>
      recognitionCompleteHandler = handler;

  void setErrorHandler(VoidCallback handler) => errorHandler = handler;
}
