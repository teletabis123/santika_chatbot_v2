import 'package:flutter/material.dart';
import 'package:santika_chatbot_v2/aboutapp.dart';
import 'package:santika_chatbot_v2/chatbot.dart';
import 'package:santika_chatbot_v2/splashScreen.dart';

void main() => runApp(SplashScreenPage());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        //primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.grey,
//        buttonColor: Color.fromARGB(255, 127, 255, 212), //aquamarine
        buttonColor: Color.fromARGB(255, 184, 50, 39), //
      ),
      home: MyHomePage(title: 'Some page in My Santika'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var assetImage = AssetImage('assets/santika_2_2.png');
    //var assetImage = AssetImage('assets/logo_umn.png');
    var image = new Image(image: assetImage, width: 64.0, height: 64.0,);

    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
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
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Padding(padding: new EdgeInsets.only(top: 50.0),),
                      ButtonTheme(
                        minWidth: 130.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.all(
                              Radius.circular(50.0)
                            )
                          ),
                          child: new Text(
                            "Chat Bot",
                            style: TextStyle(
                                color: Colors.white
                            )
                          ),
                          color: Theme.of(context).buttonColor,
                          //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBot())),
                          onPressed: () =>
                            Navigator.pushNamed(context, '/chat'),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 130.0,
                        child: RaisedButton(
                          onPressed: () {
                            print("About App button pressed");
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => AboutApp()));
                            Navigator.pushNamed(context, '/about');
                          },
                          color: Theme.of(context).buttonColor,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.all(
                              Radius.circular(50.0)
                            )
                          ),
                          child: new Text(
                            "About This App",
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ]
      ),
    );
  }
}