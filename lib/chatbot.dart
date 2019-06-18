import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:santika_chatbot_v2/ChatLog.dart';
import 'package:santika_chatbot_v2/aboutapp.dart';
import 'dart:async';
import 'dart:convert';

import 'package:santika_chatbot_v2/database.dart';
import 'package:santika_chatbot_v2/main.dart';

void main() => runApp(new ChatBot());

class ChatBot extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //'/' : (context) => SplashScreenPage(),
        '/homepage' : (context) => MyApp(),
        '/chat' : (context) => ChatBot(),
        '/about' : (context) => AboutApp(),
      },
      title: 'My Santika Helper',
      theme: ThemeData(
        buttonColor: Color.fromARGB(127, 211, 211, 211), //lightgray
        backgroundColor: Color.fromARGB(255, 184, 50, 39), //
        accentColor: Color.fromARGB(255, 0, 0, 0),
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  @override
  State createState() => new ChatScreenState();
}

Future<List<ChatLog>> fetchChatLogFromDB() async{
  var dbHelper = DBHelper();
  List<ChatLog> chatLogs = await dbHelper.getMessage();
  return chatLogs;
}

class ChatScreenState extends State<ChatScreen>{
  final TextEditingController _textController = new TextEditingController();

  final List<ChatMessage> _message = <ChatMessage>[];

  bool initialized = false;

  void _botStartChat() async {
    String url = "https://aiml-server-heroku.herokuapp.com/hai";
    var res = await http.get(Uri.encodeFull(url), headers: {"Authentication": "Bearer329e2f262b9e03c89379284ca9735332fb151575"});
    setState(() {
      var resBody = json.decode(res.body);
      int ul = resBody['ul'];
      ChatMessage messageResponse;
      List<int> li, footer;
      List<String> message = new List<String>();
      List<dynamic> messageChild = new List<dynamic>();
      List<String> messageFooter = new List<String>();
      li = new List<int>();
      footer = new List<int>();
      String mResponse = "";

      for(int i=0; i<=ul; i++){
        li.add(resBody['li'][i][i.toString()]);
        footer.add(resBody['footer'][i][i.toString()]);
      }

      for(int i=0; i<=li[ul]; i++){
        message.add(resBody["message"][ul][ul.toString()][i][i.toString()]);
        mResponse += (i>0 && i<=li[ul]? "  - " : "") + message[i] + (i != li[ul] ? "\n" : "");
      }

      messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
      if(messageFooter[0] != ""){
        mResponse += "\n\n" + messageFooter[0];
      }

      messageResponse = new ChatMessage(text: mResponse, who: 1,);
      _saveToDB(1, mResponse);
      _message.insert(0, messageResponse);
    });
  }

  void _getInitData() async{
    _botStartChat();
    List<ChatLog> chatLog = await fetchChatLogFromDB();
    print("Print in State: " + chatLog.length.toString());
    int length = chatLog.length;
    print(chatLog);
    if(length > 0){
      for(int i=0; i<length; i++){
        ChatMessage message = new ChatMessage(text: chatLog[i].message, who: chatLog[i].who,);
        setState(() {
          _message.insert(0, message);
        });
      }
    }
  }

  Future<bool> _backButtonPressed(){
    print(initialized ? "Initialized" : "Not initialized");
    initialized = false;
    //Navigator.pop(context, true);
  }

  ScrollController _hideSuggestion;
  var _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _hideSuggestion = new ScrollController();
    _hideSuggestion.addListener((){
      if(_hideSuggestion.position.userScrollDirection == ScrollDirection.reverse){
        setState((){
          _isVisible = true;
          print("**** ${_isVisible} up");
        });
      }
      if(_hideSuggestion.position.userScrollDirection == ScrollDirection.forward){
        setState((){
          _isVisible = false;
          print("**** ${_isVisible} down");

        });
      }
    });
  }

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {

    if(!initialized){
      _getInitData();
      initialized = true;
    }

    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      //onWillPop: _baqckButtonPressed,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("My Santika Chatroom"),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                reverse: true,
                itemBuilder: (_, int index) => _message[index],
                itemCount: _message.length,
              ),
            ),
            //new Divider(height: 1.0,),
            new Container(
              width: width,
              margin: new EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SingleChildScrollView(
                //controller: _hideSuggestion,
                scrollDirection: Axis.horizontal,
                child: new Center(
                  child: new Row(
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: (){
                          _textController.text = "Saya ingin bertanya tentang Santika Premiere Slipi";
                          setState(() {
                            _isComposing = true;
                          });
                        },
                        child: new Container(
                          //width: width/3,
                          padding: new EdgeInsets.all(8.0),
                          margin: new EdgeInsets.only(right: 8.0, left: 8.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(50.0),
                            border: new Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 1.0,
                              style: BorderStyle.solid
                            )
                          ),
                          child: new Text(
                            "Tentang Santika Premiere Slipi",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          _textController.text = "Saya ingin bertanya tentang Kamar hotel";
                          setState(() {
                            _isComposing = true;
                          });
                        },
                        child: new Container(
                          //width: width/3,
                          padding: new EdgeInsets.all(8.0),
                          margin: new EdgeInsets.only(right: 8.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(50.0),
                            border: new Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 1.0,
                                style: BorderStyle.solid
                            )
                          ),
                          child: new Text(
                            "Kamar Hotel",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        onTap: () {
                          _textController.text = "Saya ingin bertanya tentang Ruang rapat";
                          setState(() {
                            _isComposing = true;
                          });
                        },
                        child: new Container(
                          //width: width/3,
                          padding: new EdgeInsets.all(8.0),
                          margin: new EdgeInsets.only(right: 8.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(50.0),
                            border: new Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 1.0,
                                style: BorderStyle.solid
                            )
                          ),
                          child: new Text(
                            "Ruang Rapat",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        onTap: (){
                          _textController.text = "Saya ingin melakukan Cek kamar";
                          setState(() {
                            _isComposing = true;
                          });
                        },
                        child: new Container(
                          //width: width/3,
                          padding: new EdgeInsets.all(8.0),
                          margin: new EdgeInsets.only(right: 8.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(50.0),
                            border: new Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 1.0,
                                style: BorderStyle.solid
                            )
                          ),
                          child: new Text(
                            "Cek Kamar",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(){
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text){
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message",
                  hintStyle: new TextStyle(
                    color: Colors.black,
                  )
                ),
              ),
            ),
            new Container(
              //margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                color: Colors.black,
                disabledColor: Colors.black,
                icon: new Icon(Icons.send),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
                // What to do after send icon is pressed
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleSubmitted(String text){
    _textController.clear();

    ChatMessage message = new ChatMessage(text: text, who: 0,);
    _saveToDB(0, text);

    ChatMessage messageResponse;

    String url = "https://aiml-server-heroku.herokuapp.com/";

    String mResponse = "";
    String mResFooter = "";
    Future getAndParse(String param) async {
      List<dynamic> response = new List();
      url += param;
      print("Text        : " + text);
      print("Url         : " + url);
      print("Encoded Url : " + Uri.encodeFull(url));
      var res = await http.get(Uri.encodeFull(url), headers: {"Authentication": "Bearer329e2f262b9e03c89379284ca9735332fb151575"});

      print("Done waiting!");

      setState(() {
        var resBody = json.decode(res.body);
        print(resBody);

        print("Reformatting json result");


        int ul = resBody['ul'];
        print("ul = " + ul.toString());

        List<int> li, footer;
        List<String> message = new List<String>();
        List<dynamic> messageChild = new List<dynamic>();
        List<String> messageFooter = new List<String>();
        li = new List<int>();
        footer = new List<int>();

        print("getting ul value: " + ul.toString());

        for(int i=0; i<=ul; i++){
          li.add(resBody['li'][i][i.toString()]);
          footer.add(resBody['footer'][i][i.toString()]);
        }

        if(ul == 0){
          print(resBody["message"]);
          message.add(resBody["message"][ul][ul.toString()]);
          messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
          print("Message: " + message[ul]);

          mResponse += message[ul];

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);

          if(messageFooter[ul] != ""){
            mResFooter += "\n" + messageFooter[ul];
          }
        }
        else if(ul == 1){
          print("ul = 1");
          print("li[0] = " + li[0].toString());
          for(int i=0; i<=li[ul]; i++){
            message.add(resBody["message"][ul][ul.toString()][i][i.toString()]);
            mResponse += (i>0 && i<=li[ul]? "  - " : "") + message[i] + (i != li[ul] ? "\n" : "");
          }

          messageFooter.add(resBody["m_footer"][ul][ul.toString()]);
          if(messageFooter[0] != ""){
            mResponse += "\n\n" + messageFooter[0];
          }

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);
        }
        else if(ul > 1){
          print(li[0]);
          int idx = 0;
          for(int i=0; i<=ul; i++){
            if(li[i] == 1) mResponse += resBody["message"][i][i.toString()] + "\n\n";
            else{
              //Main
              print(idx);
              messageChild.add(message);
              for(int j=0; j<=li[i]; j++){
                messageChild[idx].add(resBody["message"][i][i.toString()][j][j.toString()]);
                print("resBody[\"message\"][$i][\"$i\"][$j][\"$j\"]: " + resBody["message"][i][i.toString()][j][j.toString()]);
                mResponse += (j>0 && j<=li[i]? "  - " : "") + resBody["message"][i][i.toString()][j][j.toString()] + (i==ul && j==li[i]? "" : "\n") + (i!=ul && j==li[i]? "" : "");
              }

              //Footer
              messageFooter.add(resBody["m_footer"][i][i.toString()]);
              if(messageFooter[idx] != "") mResponse += (i!=ul? "" : "\n") + "\n" + messageFooter[idx] + (i!=ul? "\n\n" : "");
              else{
                mResponse += (i==ul ? "" : "\n");
              }
              idx++;
            }

          }

          messageResponse = new ChatMessage(text: mResponse, who: 1,);
          _saveToDB(1, mResponse);
          _message.insert(0, messageResponse);
        }

        //print(mResponse);
      });
    }

    setState(() {
      _message.insert(0, message);
      getAndParse(text);
    });
  }
}

const String _name = "User"; //harusnya nama kita disini
const String _botName = "Chatbot"; //nama bot nya

class ChatMessage extends StatelessWidget{

  ChatMessage({this.text, this.who});
  final String text;
  final int who;

  @override
  Widget build(BuildContext context) {
    final c_width = MediaQuery.of(context).size.width * (who == 0 ? 0.6 : 0.9);

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      //width: MediaQuery.of(context).size.width*0.5,
      child: new Row(
        textDirection: who == 0 ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: c_width,
            padding: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: who == 1 ? Theme.of(context).buttonColor : Theme.of(context).backgroundColor,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //new Text(who == 1 ? _botName : _name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    text,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: who == 0? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

void _saveToDB(int who, String message){
  var dbHelper = new DBHelper();

  dbHelper.saveChatLog(who, message, _makeTimestamp());

}

String _makeTimestamp(){
  String day = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  String hour = DateTime.now().hour.toString();
  String minute = DateTime.now().minute.toString();
  String second = DateTime.now().second.toString();

  print("Timestamp to be inserted to db: " + year.toString() + "-" + month.toString() + "-" + day.toString()
      + " " + hour.toString() + ":" + minute.toString() + ":" + second.toString());

  String timestamp = year + "-" + month + "-" + day + " " +
      hour + ":" + minute + ":" + second;

  return timestamp;
}