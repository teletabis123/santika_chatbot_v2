import 'package:flutter/material.dart';
import 'package:santika_chatbot_v2/chatbot.dart';
import 'package:santika_chatbot_v2/main.dart';

void main() => runApp(HowToUse());

class HowToUse extends StatefulWidget {
  final String title;
  HowToUse({this.title = 'How To Use App'});
  @override
  _HowToUsePageState createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
//          Container(
//            padding: new EdgeInsets.all(10.0),
//            margin: new EdgeInsets.all(10.0),
//            child: Image(image: AssetImage('assets/logo_umn.png')),
//          ),
          Container(
            padding: new EdgeInsets.only(top: 30.0),
            //Padding(padding: EdgeInsets.only(top: 10.0),
            margin: new EdgeInsets.all(20.0),
            child: Text(
              'Pada menu utama terdapat 3 button yang dapat ditekan.\n'
                  '\n'
                  '1. Chat Bot:\n'
                  '- Fitur utama dari aplikasi yang menyediakan Artificial Intelligence untuk melakukan automasi pelayanan customer service Aplikasi Mysantika.\n\n'
                  '- Dalam Halaman ini, user dapat melakukan chatting dengan Berscha Bot untuk bertanya mengenai Hotel Santika Premier Slipi.\n\n'
                  '2. How To Use App:\n'
                  '- Pada halaman ini, terdapat informasi mengenai cara penggunaan aplikasi dari Berscha Bot.\n\n'
                  '3. About App:\n'
                  '- Halaman ini berisi penjelasan singkat mengenai Berscha Bot.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}