import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GIVE ME MY POINTERS
class MessageHandler{
  // Stream? _channel;
  static final MessageHandler _instance = MessageHandler._messageHandler();
  final Map<String,QueueUpdate> _pollInfo = {};
  final SharedPreferencesAsync sp = SharedPreferencesAsync();
  String? _user;
  String get user => _user!;
  // returns true if user is Not null
  bool get hasUsers => _user != null;
  set user(String user) {
    setUser(user);
  }

  void setUser(String usr) async {
    if(_user != null){
      await sp.setString('username',usr);
      _user = usr;
      _socket?.close();
      return;
    }
    _connected.value = true;
    await sp.setString('username',usr);
    _user = usr;
    _socket?.write('<usr>$_user</usr>\r\n');
  }
  // Queue<String> debug = Queue();
  final debug = QueueUpdate();


  final ValueNotifier<bool> _connected = ValueNotifier(false);
  // bool _connected = false;
  get connected => _connected.value;
  set connectedListener(void Function() f){
    debugPrint("Added listener to connected");
    _connected.addListener(f);
  }
  Socket? _socket;
  Stream? _channel;


  factory MessageHandler(){
    return _instance;
  }

  // https://stackoverflow.com/questions/55503083/flutter-websockets-autoreconnect-how-to-implement
  MessageHandler._messageHandler() {
    int port = 25565;
    // // debugPrint("port: $port");
    // final temp = Socket.connect("localHost", port);
    initConnection(port);
  }

  void initConnection(int port) async {
    _user = await sp.getString("username");
    _socket = await connect(port);
    _channel = _socket?.asBroadcastStream();
    _channel?.listen(poll,
        onError: (e) async{
          _connected.value = false;
          initConnection(port);
        },
      onDone: () async{
        _connected.value = false;
        initConnection(port);
      }
    );
    if(_user != null) {
      _socket?.write('<usr>$_user</usr>\r\n');
      _connected.value = true;
    }
  }

  Future<Socket> connect(int port) async {
    try {
      return await Socket.connect('localhost', port);
      // return await Socket.connect('192.168.1.141', port);
    } catch(e){
      debugPrint('connection Failed: $e');
      await Future.delayed(const Duration(milliseconds: 1000));
      return connect(port);
    }

  }

  void poll(dynamic binMsg){
    String msg = String.fromCharCodes(binMsg);
    List<String> packets = msg.split('\r\n');
    for(String packet in packets) {
      if(packet.isEmpty){
        continue;
      }
      int start = packet.indexOf('<');
      int stop = packet.indexOf('>');
      if(start == -1 || stop == -1){
        continue;
      }
      debugPrint('[MESSAGEHANDLER]: ${msg.trim()} as ${packet.substring(start + 1, stop)}');
      if (_pollInfo.containsKey(packet.substring(start + 1, stop))) {
        _pollInfo[packet.substring(start+1, stop)]?.add(packet);
        // _pollInfo[packet.substring(start, stop)]?.send();
      } else {
        debug.add(packet);
        debugPrint(packet);
      }
    }
    // debug.send();
  }

  void addPoll(String name, QueueUpdate messageQueue){
    if(!_pollInfo.containsKey(name)){
      _pollInfo[name] = messageQueue;
    }
  }

  void removePoll(String name){
    if(_pollInfo.containsKey(name)){
      _pollInfo.remove(name);
    }
  }

  void send(String text) {
    text += '\r\n';
    _socket?.write(text);
  }

  void dispose(){
    _socket?.close();
  }
}

class QueueUpdate extends ChangeNotifier{
  final Queue<String> _queue = Queue();
  int get length => _queue.length;
  bool get isNotEmpty => _queue.isNotEmpty;
  bool get listener => hasListeners;

  void add(String ele){
    _queue.add(ele);
    // debugPrint('has Listeners: $hasListeners');
    notifyListeners();
  }

  String pop(){
    return _queue.removeFirst();
  }

  void send(){
    notifyListeners();
  }
}