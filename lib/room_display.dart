import 'package:chat_room/message_handler.dart';
import 'package:chat_room/utils.dart';
import 'package:flutter/material.dart';

class RoomDisplay extends StatefulWidget {
  final String name;
  final QueueUpdate _queue = QueueUpdate();
  final MessageHandler _MH = MessageHandler();

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
  final List<Widget> _log = [];
  _RoomDisplayState();

  @override
  void initState() {
    super.initState();
    widget._queue.addListener(logListener);
  }

  void logListener(){
    setState(() {
      while(widget._queue.isNotEmpty) {
        String msg = widget._queue.pop();
        msg = unpack(msg);

        // debugPrint('msg: $msg');
        _log.add(SizedBox(width: double.infinity, child: Text(msg)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('logLen: ${_log.length}');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.remove),
            Expanded(child: Center(child: Text(widget.name))),
            // Expanded(child: Center(child: Text(name))),
            const Icon(Icons.minimize),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            // shrinkWrap: true,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _log,
          ),
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String wrapper(String msg){
    return '<${widget.name}>$msg</${widget.name}>';
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      widget._MH.send(wrapper(_controller.text));
      // _socket?.write('\r\n');
      // _channel.sink.add(_controller.text);
    }
  }
}