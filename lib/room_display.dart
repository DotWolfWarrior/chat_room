import 'dart:ui';

import 'package:chat_room/message_handler.dart';
import 'package:chat_room/utils.dart';
import 'package:flutter/material.dart';

import 'doors_95.dart';

class RoomDisplay extends StatefulWidget {
  final String name;
  final QueueUpdate _queue = QueueUpdate();
  final MessageHandler _MH = MessageHandler();
  final List<Widget> _log = [];

  RoomDisplay({super.key, required this.name}){
    _MH.addPoll(name, _queue);
  }

  void dispose(){
    _MH.removePoll(name);
  }

  @override
  State<RoomDisplay> createState() => _RoomDisplayState();
}

class _RoomDisplayState extends State<RoomDisplay> {
// class RoomDisplay extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  static final ValueNotifier<bool> _connected = ValueNotifier(false); // may not be needed
  // final List<Widget> _log = [];
  _RoomDisplayState();

  @override
  void initState() {
    super.initState();
    if(!widget._queue.listener) {
      widget._queue.addListener(logListener);
      _connected.addListener(() => setState(() {}));
      widget._MH.send('<rooms><join>${widget.name}</join></rooms>');
    }
  }

  void logListener(){
    debugPrint("LogListener");
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
          widget._log.add(const SizedBox(width: double.infinity, child: Text("[Server]: You are now the owner of this room.")));
        } else if (status == 800){
          widget._log.add(const SizedBox(width: double.infinity, child: Text("Entering Failed try again")));
        }
      } else {
        widget._log.insert(0,SizedBox(width: double.infinity, child: Text(msg,softWrap: true,)));
      }
    }

    if(mounted){
      setState(() {});
    }
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
          automaticallyImplyLeading: false,
          leading: Container95(
            height: 10,
            width: 10,
            child: TextButton(
                  onPressed: (){Navigator.pop(context);},
                  child: const Icon(Icons.arrow_back)
              )
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
              itemCount: widget._log.length,
              itemBuilder: (context, idx) => widget._log[idx],
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
              itemCount: widget._log.length,
              itemBuilder: (context, idx) => widget._log[idx],
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
    );
  }

  String _wrapper(String msg){
    return '<${widget.name}>$msg</${widget.name}>';
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      setState(() {
        widget._log.insert(0,SizedBox(width: double.infinity,child: Text('[${widget._MH.user}]: ${_controller.text}')));
      });
      widget._MH.send(_wrapper(_controller.text));
      _controller.clear();
    }
  }
}