import 'package:flutter/material.dart';

import 'doors_95.dart';
import 'message_handler.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _controller = TextEditingController();
  final MessageHandler _MH = MessageHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(child: Center(child: Text("Create Room"))),
              Container95(child: const Icon(Icons.minimize,color: Colors.black,)),
            ],
          ),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField95(
              controller: _controller,
              hintText: "Type room name",
            ),
            TextButton95(onPressed: _create, child: const Text('Create')),

          ],
        )
        )
    );
  }

  void _create() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      _MH.send('<rooms><create>${_controller.text}</create></rooms>');
      _controller.clear();
      Navigator.of(context).pop();
      // _socket?.write('\r\n');
      // _channel.sink.add(_controller.text);
    }
  }

}
