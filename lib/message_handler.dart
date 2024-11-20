import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

// GIVE ME MY POINTERS
class MessageHandler{
  // Stream? _channel;
  static final MessageHandler _instance = MessageHandler._messageHandler();
  final Map<String,QueueUpdate> _pollInfo = {};
  // Queue<String> debug = Queue();
  final debug = QueueUpdate();

  bool _connected = false;
  get connected => _connected;
  Socket? _socket;
  Stream? _channel;


  factory MessageHandler(){
    return _instance;
  }

  MessageHandler._messageHandler(){
    int port = 25565;
    // // debugPrint("port: $port");
    final temp = Socket.connect("localHost", port);
    temp.then((Socket s){
        s.write('<usr>dww</usr>\r\n');
        _socket = s;
        _channel = _socket?.asBroadcastStream();
        _channel?.listen(poll);
        _connected = true;
    });
  }

  void poll(dynamic binMsg){
    String msg = String.fromCharCodes(binMsg);
    List<String> packets = msg.split('\r\n');
    for(String packet in packets) {
      if(packet.isEmpty){
        continue;
      }
      int start = packet.indexOf('<') + 1;
      int stop = packet.indexOf('>');
      if (_pollInfo.containsKey(packet.substring(start, stop))) {
        _pollInfo[packet.substring(start, stop)]?.add(packet);
        _pollInfo[packet.substring(start, stop)]?.send();
      } else {
        debug.add(packet);
      }
    }
    debug.send();
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
  get length => _queue.length;
  get isNotEmpty => _queue.isNotEmpty;

  void add(String ele){
    _queue.add(ele);
  }

  String pop(){
    return _queue.removeFirst();
  }

  void send(){
    notifyListeners();
  }
}