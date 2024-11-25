
import 'package:chat_room/message_handler.dart';
import 'package:chat_room/room_display.dart';
import 'package:chat_room/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_room.dart';
import 'doors_95.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ColorScheme CSS = ColorScheme(
      brightness: Brightness.light,
        primary: Colors.blue[900]!,
        onPrimary: Colors.white,
        secondary: Colors.green,
        onSecondary: Colors.black,
        // surfaceContainer: Colors.blue[900],
        // onPrimaryContainer: Colors.blue[900]!,
        // onSecondaryContainer: Colors.blue[900]!,
        error: Colors.red,
        onError: Colors.black,
        surface: Colors.grey,
        onSurface: Colors.black,
    );//.fromSeed(seedColor: Colors.blue[100]!);//.fromARGB(255, 0, 0, 255)),
    // CSS.surface = Colors.grey;
    return MaterialApp(
      title: 'Doors 95',
      theme: ThemeData(
        fontFamily: GoogleFonts.vt323().fontFamily,
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: CSS,
        appBarTheme: AppBarTheme(
            color: Colors.blue[900],
            foregroundColor: Colors.white,
            shape: Border.all(color: Colors.black,width: 2.5)
        ),
        // buttonTheme: ButtonThemeData(
        //     shape: Border.all(color: Colors.black,width: 2.5),
        //     colorScheme: ColorScheme(
        //         brightness: Brightness.dark,
        //         primary: Colors.grey[800]!,
        //         onPrimary: Colors.black,
        //         secondary: Colors.grey[800]!,
        //         onSecondary: Colors.black,
        //         error: Colors.red,
        //         onError: Colors.black,
        //         surface: Colors.green,
        //         onSurface: Colors.white
        //     ),
        //   textTheme: ButtonTextTheme.primary,
        // ),

        textButtonTheme: TextButtonThemeData(style: ButtonStyle(
          // shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          backgroundColor: WidgetStateProperty.all(Colors.grey),
          overlayColor: WidgetStateProperty.all(Colors.grey),
          shadowColor: WidgetStateProperty.all(const Color.fromARGB(0, 0, 0, 0)),

          // elevation: WidgetStateProperty.all(10)
        )),
        // textButtonTheme: const TextButtonThemeData(style: ButtonStyle(shape: Outlined)),
      ),
      home: const MyHomePage(title: 'Doors 95'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final MessageHandler _MH = MessageHandler();
  final QueueUpdate _rmsgq = QueueUpdate();
  final List<Widget> _rooms = [];
  final Map<String,RoomDisplay> _openRooms = {};
  final List<TextButton95> _openRoomsButtons = [];

  @override
  void initState() {
    super.initState();
    // _MH.user = 'dww';
    _MH.addPoll('rooms', _rmsgq);
    _MH.debug.addListener(printUnhandled);
    _MH.connectedListener = (){
      debugPrint("Updating connection");
      setState(() {
        if(!_MH.connected) {
          _openRoomsButtons.clear();
          _openRooms.clear();
        }
      });
    }; // this is funny
    _rmsgq.addListener(parseMSG);
  }

  void printUnhandled(){
    while(_MH.debug.isNotEmpty){
      debugPrint('UnHandled Message: ${_MH.debug.pop()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    debugPrint("Building");

    if(!_MH.hasUsers){
      return getUser();
    }

    if(!_MH.connected){
      return const CircularProgressIndicator();
    }
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Center(child: Text(widget.title))),
            Container95(child: const Icon(Icons.minimize,color: Colors.black,)),
          ],
        ),
        leading: Builder(
          builder: (context) {
            return Container95(
              height: 10,
              width: 10,
              child: TextButton(
                  onPressed: () {Scaffold.of(context).openDrawer();},
                  child: const Center(
                      child: Icon(Icons.remove,size: 30,)
                  )
              ),
            );
          }
        ), //this is dumb why
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListView.builder(
              controller: ScrollController(),
              // padding: const EdgeInsets.symmetric(vertical: 4),
              shrinkWrap: true,
              itemCount: _rooms.length,
              itemBuilder: (context, idx) => _rooms[idx],
              // children: _rooms,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton95(onPressed: (){_MH.send('<rooms><refresh></rooms>');}, child: const Text('Refresh')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton95(onPressed: _createRoom, child: const Text('Create Room')),
                  ) //TODO make this create different rooms
              ],),
            ),
            // TextField95(
            //   controller: _controller,
            //   hintText: 'Type debug message',
            // ),
          ],
        ),
      ),
      drawer: NavigationDrawer(
          children: _openRoomsButtons
          // children: List.from(_openRooms.values)
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'send',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void parseMSG(){
    setState(() {
      while (_rmsgq.isNotEmpty) {
        String msg = _rmsgq.pop();
        msg = unpack(msg);
        List<String> openRooms = msg.split(';');
        debugPrint('openRooms: $openRooms');
        _rooms.clear();
        for (var room in openRooms) {
          _rooms.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5,horizontal: 1),
            child: TextButton95(
              onPressed: () => _enterRoom(room),
              child: Center(child: Text(room),),
            ),
          ));
          // _rooms.add(const Padding(padding: P));
        }
      }
      debugPrint('Rooms: $_rooms');
    });
  }

  void _enterRoom(String room) {
    if (!_openRooms.containsKey(room)) {
      debugPrint("Adding entering room $_openRooms");
      _openRooms[room] = RoomDisplay(name: room);
      _openRoomsButtons.add(TextButton95(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return _openRooms[room]!;
                }));
          },
          child: Text(room)
      ));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return _openRooms[room]!;
          }));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return _openRooms[room]!;
          }));
    }
  }
  
  void _createRoom(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CreateRoom()
    ));
  }

  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     // debugPrint('text: ${_controller.text}');
  //     _MH.send(_controller.text);
  //     _controller.clear();
  //     // _socket?.write('\r\n');
  //     // _channel.sink.add(_controller.text);
  //   }
  // }

  @override
  void dispose() {
    // _channel.sink.close();
    // _socket?.close();
    _MH.dispose();
    _rmsgq.removeListener(parseMSG);
    _rmsgq.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget getUser() {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Center(child: Text(widget.title))),
              // Container95(child: const Icon(Icons.minimize,color: Colors.black,)),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField95(
                controller: _controller,
                hintText: 'username',
              ),
              TextButton95(onPressed: _setUser, child: const Text('Connect'))
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
