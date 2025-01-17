library my_prj.globals;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:SpicyBabyChan/home.dart' as homes;
//import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:convert' show utf8;

List<String> namedataG = [];
//名前
bool backflag = false;//バックグラウンド動作
bool musicflag = false;//音楽再生
bool notificationflag = false;//通知
bool bltflag = false;//通知
bool callflag = false;
bool firstflag = true;
bool firstMusicflag = true;
//test_route用
@override
String inputText = "";
String inputText2 = "";
@override
bool isListening = false;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginG = homes.flutterLocalNotificationsPlugin;
NotificationDetails platformChannelSpecifics;
/*
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_DEVICE_NAME = "ESP32 FLUTTER";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";
  int timeout = 5;

  startScan() {
    connectionText = "Start Scanning";
    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if (TARGET_DEVICE_NAME == scanResult.device.name) {
        print('DEVICE found');
        stopScan();
        connectionText = "Found Target Device";
        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    connectionText = "Device Connecting";

    await targetDevice.connect();

    print('DEVICE CONNECTED');
    connectionText = "Device Connected";

    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    targetCharacteristic = null;

    connectionText = "Device Disconnected";
  }

  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData("Hi there, ESP32!!");
            connectionText = "All Ready with ${targetDevice.name}";
          }
        });
      }
    });
  }

  writeData(String data) {
    if (targetCharacteristic == null) return;
    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
  }
  
*/

void onBluetoothStart(){
  //startScan();
}   

void onBluetoothStop(){
  //disconnectFromDevice();
  //flutterBlue.stopScan();
}   


void callFunc(){

  if(bltflag){
    //writeData("LEDon");
  }
  if(musicflag){
    homes.audio.pause();
  }
  if(notificationflag) {
    _onNotification();
  }
}

Future _onNotification() async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.Max, 
        priority: Priority.High,
        );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPluginG.show(
        0, 
        '通知', 
        '名前を呼ばれています。', 
        platformChannelSpecifics
        );  
  } 
