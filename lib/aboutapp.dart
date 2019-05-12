import 'package:flutter/material.dart';
import 'package:santika_chatbot_v2/chatbot.dart';
import 'package:santika_chatbot_v2/main.dart';

void main() => runApp(AboutApp());

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //'/' : (context) => SplashScreenPage(),
        '/homepage' : (context) => MyApp(),
        '/chat' : (context) => ChatBot(),
        '/about' : (context) => AboutApp(),
      },
      title: 'My Santika',

      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Cara Memulai Chatbot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Image(image: AssetImage('assets/logo_umn.png'), width: 64.0, height: 64.0,)
            ),
            Text(
              'Aplikasi Chatbot ini dibuat bekerja sama dengan UMN.',
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
