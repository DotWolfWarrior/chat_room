
import 'package:chat_room/message_handler.dart';
import 'package:chat_room/room_display.dart';
import 'package:chat_room/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: 'Chat Room Demo',
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
        buttonTheme: ButtonThemeData(
            shape: Border.all(color: Colors.black,width: 2.5),
            colorScheme: ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.grey[800]!,
                onPrimary: Colors.black,
                secondary: Colors.grey[800]!,
                onSecondary: Colors.black,
                error: Colors.red,
                onError: Colors.black,
                surface: Colors.green,
                onSurface: Colors.white
            ),
          textTheme: ButtonTextTheme.primary,
        ),
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(
         side: WidgetStateProperty.all(const BorderSide(color: Colors.black, width: 1.5)),
         //  side: WidgetStateProperty.all(BorderSide(color: Colors.grey[300]!,width: 1.5)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          backgroundColor: WidgetStateProperty.all(Colors.grey[600]),
          overlayColor: WidgetStateProperty.all(Colors.grey[600]),
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
  final List<TextButton> _openRooms = [];

  @override
  void initState() {
    super.initState();
    _MH.addPoll('rooms', _rmsgq);
    _MH.debug.addListener(printUnhandled);
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
            const Icon(Icons.remove),
            Expanded(child: Center(child: Text(widget.title))),
            const Icon(Icons.minimize),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: _rooms,
            ),
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
          ],
        ),
      ),
      drawer: NavigationDrawer(
          children: _openRooms
          // children: List.from(_openRooms.values)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void parseMSG(){
    setState(() {
      while (_rmsgq.isNotEmpty) {
        String msg = _rmsgq.pop();
        msg = unpack(msg);
        List<String> openRooms = msg.split(';');
        for (var room in openRooms) {
          _rooms.add(TextButton(onPressed: () {
            // if (!_openRooms.any((ele) => ele.)) {
              debugPrint("Adding entering room");
              _openRooms.add(TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RoomDisplay(name: room)
                    ));
                  },
                  child: Text(room)
              ));
            // }
          }, child: Center(child: Text(room),)));
        }
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      _MH.send(_controller.text);
      // _socket?.write('\r\n');
      // _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _channel.sink.close();
    // _socket?.close();
    _MH.dispose();
    _controller.dispose();
    super.dispose();
  }
}

