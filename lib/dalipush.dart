import 'dart:async';

import 'package:flutter/services.dart';

class Dalipush {
  factory Dalipush() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('dalipush');
      final EventChannel eventChannel = const EventChannel('dalipush_event');
      _instance = new Dalipush.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  Dalipush.private(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;

  final EventChannel _eventChannel;

  static Dalipush _instance;

  Stream<Message> _listener;

  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> get deviceId async {
    final String id =
    await _methodChannel.invokeMethod('getDeviceId');
    return id;
  }

  Future<String> get deviceToken async {
    final String token =
    await _methodChannel.invokeMethod('getDeviceToken');
    return token;
  }

  Future<bool> clearNotifications() async {
    return _methodChannel.invokeMethod('getDeviceToken');
  }

  Future<bool> closeDoNotDisturbMode() async {
    return _methodChannel.invokeMethod('closeDoNotDisturbMode');
  }

  Future<String> addAlias(String alias) async {
    return _methodChannel.invokeMethod('closeDoNotDisturbMode', <String, String>{
      'alias': alias
    });
  }

  Future<String> removeAlias(String alias) async {
    return _methodChannel.invokeMethod('closeDoNotDisturbMode', <String, String>{
      'alias': alias
    });
  }

  Future<String> bindAccount(String account) async {
    return _methodChannel.invokeMethod('bindAccount', <String, String>{
      'account': account
    });
  }

  Future<String> bindPhoneNumber(String phoneNumber) async {
    return _methodChannel.invokeMethod('bindPhoneNumber', <String, String>{
      'phoneNumber': phoneNumber
    });
  }

  Future<String> bindTag(int target, List<String> tags, String alias) async {
    return _methodChannel.invokeMethod('bindTag', <String, dynamic>{
      'target': target,
      'tags': tags,
      'alias': alias
    });
  }

  Future<String> unbindTag(int target, List<String> tags, String alias) async {
    return _methodChannel.invokeMethod('bindTag', <String, dynamic>{
      'target': target,
      'tags': tags,
      'alias': alias
    });
  }

  Future<String> unbindAccount() async {
    return _methodChannel.invokeMethod('unbindAccount');
  }

  Future<String> unbindPhoneNumber() async {
    return _methodChannel.invokeMethod('unbindPhoneNumber');
  }

  Future<String> checkPushChannelStatus() async {
    return _methodChannel.invokeMethod('checkPushChannelStatus');
  }

  Future<String> turnOffPushChannel() async {
    return _methodChannel.invokeMethod('turnOffPushChannel');
  }

  Future<String> turnOnPushChannel() async {
    return _methodChannel.invokeMethod('turnOnPushChannel');
  }



  Stream<Message> get onMessage {
    if (_listener == null) {
      _listener = _eventChannel
          .receiveBroadcastStream()
          .map((event) => _parseMsg(event));
    }
    return _listener;
  }

  Message _parseMsg(event) {
    return Message.fromJson(event);
  }
}

enum MessageEventType {
  onNotification,
  onMessage,
  onNotificationOpened,
  onNotificationClickedWithNoAction,
  onNotificationReceivedInApp,
  onNotificationRemoved
}

class Message {
  final String event;
  final String title;
  final String summary;
  final Map<String, dynamic> extraMap;

  Message(this.event, this.title, this.summary, this.extraMap);

  MessageEventType get eventType => MessageEventType.values.firstWhere((e) => e.toString() == 'MessageEventType.' + event);

  get uri {
    if (extraMap.containsKey("uri") && extraMap['uri'].trim() != "") {
      return extraMap['uri'];
    }
    return null;
  }
  factory Message.fromJson(json) {
    return Message(json["event"] as String, json["title"] as String, json["summary"] as String, Map.from(json["extraMap"]) );
  }
}
