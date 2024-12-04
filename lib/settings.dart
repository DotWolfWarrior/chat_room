import 'package:chat_room/message_handler.dart';
import 'package:flutter/material.dart';

import 'doors_95.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _controller = TextEditingController();
  final MessageHandler _MH = MessageHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Center(child: Text('Settings'))),
              // Container95(child: const Icon(Icons.minimize,color: Colors.black,)),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  TextField95(
                    controller: _controller,
                    hintText: _MH.user,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width-120
                    ),
                  ),
                  TextButton95(
                      onPressed: _setUser,
                      child: const Text('Change User')
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  void _setUser() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _MH.user = _controller.text;
        _controller.clear();
      }
    });
  }
}
