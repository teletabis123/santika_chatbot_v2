import 'package:flutter/material.dart';
import 'package:santika_chatbot_v2/aboutapp.dart';
import 'dart:async';

import 'package:santika_chatbot_v2/chatbot.dart';
import 'package:santika_chatbot_v2/main.dart';

void main() => runApp(SplashScreenPage());

class SplashScreenPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      routes: {
        //'/' : (context) => SplashScreenPage(),
        '/homepage' : (context) => MyApp(),
        '/chat' : (context) => ChatBot(),
        '/about' : (context) => AboutApp(),
      },
      theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  int _start = 2;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec, (Timer timer) => setState((){
          print("timernya disini"+_start.toString());
          if (_start < 1){
            timer.cancel();

            Navigator.pushReplacementNamed(context, '/homepage');
            //Navigator.popAndPushNamed(context, "/homepage");
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
            //Navigator.of(context).pop(true);
          } else {
            print("Secconds: " + _start.toString());
            _start = _start - 1;
          }
        }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var assetImage = AssetImage('assets/santika_2_2.png');
    var image = new Image(image: assetImage, width: 64.0, height: 64.0,);

    return new Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.brown),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 65, 57, 55),
                          radius: 50.0,
                          child: image,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          "Ashka Bot",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text("MySantika App Chatbot",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            )
          ]
      ),
    );
  }

}