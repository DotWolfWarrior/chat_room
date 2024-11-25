import 'dart:ui';

import 'package:chat_room/message_handler.dart';
import 'package:chat_room/utils.dart';
import 'package:flutter/material.dart';

import 'doors_95.dart';

class RoomDisplay extends StatefulWidget {
  final String name;
  final QueueUpdate _queue = QueueUpdate();
  final MessageHandler _MH = MessageHandler();
  // final List<Widget> _log = [];

  RoomDisplay({super.key, required this.name}){
    _MH.addPoll(name, _queue);
    _MH.send('<rooms><join>$name</join></rooms>');
  }

  @override
  State<RoomDisplay> createState() => _RoomDisplayState();
}

class _RoomDisplayState extends State<RoomDisplay> {
// class RoomDisplay extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  static final ValueNotifier<bool> _connected = ValueNotifier(false);
  final List<Widget> _log = [];
  _RoomDisplayState();

  @override
  void initState() {
    super.initState();
    widget._queue.addListener(logListener);
    _connected.addListener(() => setState(() {}));
  }

  void logListener(){
    debugPrint("LogListener");
    setState(() {
      while(widget._queue.isNotEmpty) {
        String msg = widget._queue.pop();
        msg = unpack(msg);
        int start = msg.indexOf('<');
        int stop = msg.indexOf('>');
        if((start != -1 || stop != -1) && msg.substring(start+1,stop) == 'status'){
          int status = int.parse(unpack(msg));
          debugPrint('${widget.name} status: $status');
          if(status == 200){
            _connected.value = true;
          } else if (status == 258){
            _log.add(const SizedBox(width: double.infinity, child: Text("[Server]: You are now the owner of this room.")));
          } else if (status == 800){
            _log.add(const SizedBox(width: double.infinity, child: Text("Entering Failed try again")));
          }
        } else {
          _log.insert(0,SizedBox(width: double.infinity, child: Text(msg,softWrap: true,)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('logLen: ${_log.length}');
    if(!_connected.value){
      // Future.delayed(const Duration(seconds: 10)).whenComplete(retry);
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const Icon(Icons.remove),
              Expanded(child: Center(child: Text(widget.name))),
              // Expanded(child: Center(child: Text(name))),
              // const Icon(Icons.minimize),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: CircularProgressIndicator()),
            ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              itemCount: _log.length,
              itemBuilder: (context, idx) => _log[idx],
              // children: widget._log,
            ),
            TextButton95(onPressed: () {}, child: const Text("Close"))
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const Icon(Icons.remove),
            Expanded(child: Center(child: Text(widget.name))),
            // Expanded(child: Center(child: Text(name))),
            // const Icon(Icons.minimize),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height-110,
            child: ListView.builder(
              reverse: true,
              controller: ScrollController(),
              // shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              itemCount: _log.length,
              itemBuilder: (context, idx) => _log[idx],
              // children: widget._log,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              children: <Widget>[
                // https://stackoverflow.com/questions/49553402/how-to-determine-screen-height-and-width
                TextField95(
                  controller: _controller,
                  hintText: 'Send a message',
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width-100),
                  selectionWidthStyle: BoxWidthStyle.max,
                ),
                TextButton95(onPressed: _sendMessage, child: const Text('Send')),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'send',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String _wrapper(String msg){
    return '<${widget.name}>$msg</${widget.name}>';
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      setState(() {
        _log.insert(0,SizedBox(width: double.infinity,child: Text('[${widget._MH.user}]: ${_controller.text}')));
      });
      widget._MH.send(_wrapper(_controller.text));
      _controller.clear();
      // _socket?.write('\r\n');
      // _channel.sink.add(_controller.text);
    }
  }
}