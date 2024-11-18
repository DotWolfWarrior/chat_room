import 'dart:io';

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
    ColorScheme CSS = ColorScheme(brightness: Brightness.light,
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
        appBarTheme: AppBarTheme(color: Colors.blue[900],foregroundColor: Colors.white),

        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ChatRoom Demo'),
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
  Socket? _socket;
  Stream? _channel;
  // final test = WebSocket.connect('ws://192.168.1.102:25564');
  // final _channel = WebSocketChannel.connect(Uri(scheme: 'ws', host: '127.0.0.1',port: 25565));
  // final _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.102:25565'));
  void connect() async{
    int port = 25564;
    debugPrint("port: $port");
    final temp = await Socket.connect("localHost", port);
    setState(() {
      _socket = temp;
      _channel = _socket?.asBroadcastStream();
    });
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    if(_socket == null){
      return const CircularProgressIndicator();
    }

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        shape: Border.all(color: Colors.black,width: 2.5),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: Colors.blue[900],
        // titleTextStyle: TextStyle(color: Colors.white,fontFamily: GoogleFonts.vt323().fontFamily,fontSize: 36),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _channel,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  String msg = String.fromCharCodes(snapshot.data);
                  return Text(msg);
                }
                return const CircularProgressIndicator();
              },
            ),
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            /*const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // debugPrint('text: ${_controller.text}');
      _socket?.write('${_controller.text}\r\n');
      // _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _channel.sink.close();
    _socket?.close();
    _controller.dispose();
    super.dispose();
  }
}
